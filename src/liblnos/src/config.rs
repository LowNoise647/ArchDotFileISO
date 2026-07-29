use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::path::Path;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ConfigError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Parse error: {0}")]
    Parse(#[from] toml::de::Error),
    #[error("Serialize error: {0}")]
    Serialize(#[from] toml::ser::Error),
    #[error("Validation error: {0}")]
    Validation(String),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LnosSystemConfig {
    pub system: SystemConfig,
    pub modules: ModuleConfig,
    pub update: UpdateConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SystemConfig {
    pub hostname: String,
    pub timezone: String,
    pub locale: String,
    pub keymap: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModuleConfig {
    pub auto_resolve_dependencies: bool,
    pub allow_community_modules: bool,
    pub sandbox_hooks: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UpdateConfig {
    pub auto_update: bool,
    pub auto_update_time: String,
    pub snapshot_before_update: bool,
    pub max_snapshots: u32,
}

impl Default for LnosSystemConfig {
    fn default() -> Self {
        Self {
            system: SystemConfig {
                hostname: "lnos".to_string(),
                timezone: "UTC".to_string(),
                locale: "en_US.UTF-8".to_string(),
                keymap: "us".to_string(),
            },
            modules: ModuleConfig {
                auto_resolve_dependencies: true,
                allow_community_modules: false,
                sandbox_hooks: true,
            },
            update: UpdateConfig {
                auto_update: true,
                auto_update_time: "03:00".to_string(),
                snapshot_before_update: true,
                max_snapshots: 20,
            },
        }
    }
}

impl LnosSystemConfig {
    pub fn load(path: &Path) -> Result<Self, ConfigError> {
        let content = std::fs::read_to_string(path)?;
        let config: Self = toml::from_str(&content)?;
        config.validate()?;
        Ok(config)
    }

    pub fn save(&self, path: &Path) -> Result<(), ConfigError> {
        let content = toml::to_string_pretty(self)?;
        std::fs::write(path, content)?;
        Ok(())
    }

    pub fn validate(&self) -> Result<(), ConfigError> {
        if self.system.hostname.is_empty() {
            return Err(ConfigError::Validation("hostname cannot be empty".into()));
        }
        if self.update.max_snapshots == 0 {
            return Err(ConfigError::Validation("max_snapshots must be > 0".into()));
        }
        Ok(())
    }
}

pub type UserConfigOverrides = HashMap<String, toml::Value>;
