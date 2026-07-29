use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ModuleError {
    #[error("Module not found: {0}")]
    NotFound(String),
    #[error("Dependency not satisfied: {0}")]
    UnsatisfiedDependency(String),
    #[error("Circular dependency detected")]
    CircularDependency,
    #[error("Conflict detected: {0}")]
    Conflict(String),
    #[error("Hook failed: {0}")]
    HookFailed(String),
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Parse error: {0}")]
    Parse(#[from] toml::de::Error),
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum ModuleStatus {
    Available,
    Installed,
    Configured,
    Disabled,
    Broken,
    Updatable,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleManifest {
    pub module: ModuleMeta,
    pub dependencies: Option<ModuleDependencies>,
    pub conflicts: Option<ModuleConflicts>,
    pub config: Option<toml::Value>,
    pub arch: Option<ModuleArch>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleMeta {
    pub id: String,
    pub version: String,
    pub name: String,
    pub description: String,
    pub license: String,
    pub author: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleDependencies {
    pub modules: Option<Vec<String>>,
    pub packages: Option<Vec<String>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleConflicts {
    pub modules: Option<Vec<String>>,
    pub packages: Option<Vec<String>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleArch {
    pub supported: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct Module {
    pub manifest: ModuleManifest,
    pub path: PathBuf,
    pub status: ModuleStatus,
}

pub struct ModuleManager {
    modules_dir: PathBuf,
    modules: HashMap<String, Module>,
    state_dir: PathBuf,
}

impl ModuleManager {
    pub fn new(modules_dir: PathBuf, state_dir: PathBuf) -> Self {
        Self {
            modules_dir,
            modules: HashMap::new(),
            state_dir,
        }
    }

    pub fn scan(&mut self) -> Result<(), ModuleError> {
        let entries = std::fs::read_dir(&self.modules_dir)?;
        for entry in entries {
            let entry = entry?;
            let path = entry.path();
            if path.is_dir() {
                let manifest_path = path.join("module.toml");
                if manifest_path.exists() {
                    let content = std::fs::read_to_string(&manifest_path)?;
                    let manifest: ModuleManifest = toml::from_str(&content)?;
                    let status = self.detect_status(&manifest.module.id);
                    self.modules.insert(
                        manifest.module.id.clone(),
                        Module {
                            manifest,
                            path,
                            status,
                        },
                    );
                }
            }
        }
        Ok(())
    }

    pub fn get_module(&self, id: &str) -> Result<&Module, ModuleError> {
        self.modules
            .get(id)
            .ok_or_else(|| ModuleError::NotFound(id.to_string()))
    }

    pub fn list_modules(&self) -> Vec<&Module> {
        self.modules.values().collect()
    }

    pub fn list_installed(&self) -> Vec<&Module> {
        self.modules
            .values()
            .filter(|m| {
                matches!(
                    m.status,
                    ModuleStatus::Installed | ModuleStatus::Configured | ModuleStatus::Disabled
                )
            })
            .collect()
    }

    fn detect_status(&self, id: &str) -> ModuleStatus {
        let status_file = self.state_dir.join(format!("{}.status", id));
        if !status_file.exists() {
            return ModuleStatus::Available;
        }
        let content = std::fs::read_to_string(&status_file).unwrap_or_default();
        match content.trim() {
            "installed" => ModuleStatus::Installed,
            "configured" => ModuleStatus::Configured,
            "disabled" => ModuleStatus::Disabled,
            "broken" => ModuleStatus::Broken,
            _ => ModuleStatus::Available,
        }
    }

    pub fn resolve_dependencies(&self, ids: &[String]) -> Result<Vec<String>, ModuleError> {
        let mut resolved = Vec::new();
        let mut visited = HashSet::new();

        for id in ids {
            self.resolve_deps_recursive(id, &mut resolved, &mut visited)?;
        }

        Ok(resolved)
    }

    fn resolve_deps_recursive(
        &self,
        id: &str,
        resolved: &mut Vec<String>,
        visited: &mut HashSet<String>,
    ) -> Result<(), ModuleError> {
        if visited.contains(id) {
            return Err(ModuleError::CircularDependency);
        }
        if resolved.contains(&id.to_string()) {
            return Ok(());
        }

        visited.insert(id.to_string());

        if let Some(deps) = self.modules.get(id) {
            if let Some(dep_modules) = &deps.manifest.dependencies {
                if let Some(ref mods) = dep_modules.modules {
                    for dep in mods {
                        let dep_id = dep.trim_start_matches("lnos-");
                        self.resolve_deps_recursive(dep_id, resolved, visited)?;
                    }
                }
            }
        }

        resolved.push(id.to_string());
        Ok(())
    }

    pub fn check_conflicts(&self, ids: &[String]) -> Result<(), ModuleError> {
        for id in ids {
            if let Some(module) = self.modules.get(id.as_str()) {
                if let Some(ref conflicts) = module.manifest.conflicts {
                    if let Some(ref conflict_mods) = conflicts.modules {
                        for conflict in conflict_mods {
                            if self.modules.contains_key(conflict) {
                                return Err(ModuleError::Conflict(format!(
                                    "{} conflicts with {}",
                                    id, conflict
                                )));
                            }
                        }
                    }
                }
            }
        }
        Ok(())
    }

    pub fn install(&mut self, ids: &[String]) -> Result<(), ModuleError> {
        let order = self.resolve_dependencies(ids)?;
        self.check_conflicts(&order)?;

        for id in &order {
            let module = self.get_module(id)?;
            let hook_dir = module.path.join("hooks");

            self.run_hook(&hook_dir, "pre-install")?;

            self.set_status(id, ModuleStatus::Installed)?;

            self.run_hook(&hook_dir, "post-install")?;
        }

        Ok(())
    }

    pub fn remove(&mut self, ids: &[String]) -> Result<(), ModuleError> {
        for id in ids {
            let module = self.get_module(id)?;
            let hook_dir = module.path.join("hooks");

            self.run_hook(&hook_dir, "pre-remove")?;

            self.set_status(id, ModuleStatus::Available)?;

            self.run_hook(&hook_dir, "post-remove")?;
        }
        Ok(())
    }

    pub fn configure(&mut self, ids: &[String]) -> Result<(), ModuleError> {
        for id in ids {
            let module = self.get_module(id)?;
            let hook_dir = module.path.join("hooks");

            self.run_hook(&hook_dir, "configure")?;

            self.set_status(id, ModuleStatus::Configured)?;
        }
        Ok(())
    }

    fn run_hook(&self, hook_dir: &Path, name: &str) -> Result<(), ModuleError> {
        let hook_path = hook_dir.join(name);
        if hook_path.exists() && hook_path.is_file() {
            let status = std::process::Command::new(&hook_path)
                .status()
                .map_err(|e| ModuleError::HookFailed(format!("Cannot execute {}: {}", name, e)))?;

            if !status.success() {
                return Err(ModuleError::HookFailed(format!(
                    "Hook {} exited with code {:?}",
                    name,
                    status.code()
                )));
            }
        }
        Ok(())
    }

    fn set_status(&self, id: &str, status: ModuleStatus) -> Result<(), ModuleError> {
        let status_file = self.state_dir.join(format!("{}.status", id));
        std::fs::write(
            &status_file,
            format!(
                "{}\n",
                match status {
                    ModuleStatus::Installed => "installed",
                    ModuleStatus::Configured => "configured",
                    ModuleStatus::Disabled => "disabled",
                    ModuleStatus::Broken => "broken",
                    _ => "available",
                }
            ),
        )?;
        Ok(())
    }
}
