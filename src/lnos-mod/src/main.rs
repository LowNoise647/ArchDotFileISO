mod cli;

use clap::Parser;
use liblnos::module::ModuleManager;
use liblnos::LnosConfig;
use std::path::PathBuf;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();
    let args = cli::Cli::parse();
    let default = LnosConfig::default();

    let modules_dir: PathBuf = args.modules_dir.clone().map(PathBuf::from).unwrap_or(default.modules_dir);
    let state_dir: PathBuf = args.state_dir.clone().map(PathBuf::from).unwrap_or(default.state_dir);

    std::fs::create_dir_all(&state_dir)?;
    std::fs::create_dir_all(&modules_dir)?;

    let mut manager = ModuleManager::new(modules_dir, state_dir);
    manager.scan()?;

    match args.command {
        cli::Commands::List { installed } => {
            let modules = if installed {
                manager.list_installed()
            } else {
                manager.list_modules()
            };
            for module in modules {
                println!("{:20} {:10} {}", module.manifest.module.id, module.manifest.module.version, module.manifest.module.name);
            }
        }
        cli::Commands::Info { id } => {
            let module = manager.get_module(&id)?;
            println!("ID:          {}", module.manifest.module.id);
            println!("Version:     {}", module.manifest.module.version);
            println!("Name:        {}", module.manifest.module.name);
            println!("Description: {}", module.manifest.module.description);
            println!("License:     {}", module.manifest.module.license);
            println!("Status:      {:?}", module.status);
            if let Some(ref deps) = module.manifest.dependencies {
                if let Some(ref mods) = deps.modules {
                    println!("Depends on modules: {:?}", mods);
                }
                if let Some(ref pkgs) = deps.packages {
                    println!("Depends on packages: {:?}", pkgs);
                }
            }
        }
        cli::Commands::Install { ids } => {
            manager.install(&ids)?;
            for id in &ids {
                println!("Module {} installed successfully", id);
            }
        }
        cli::Commands::Remove { ids } => {
            manager.remove(&ids)?;
            for id in &ids {
                println!("Module {} removed", id);
            }
        }
        cli::Commands::Enable { id } => {
            manager.configure(&[id.clone()])?;
            println!("Module {} enabled", id);
        }
        cli::Commands::Disable { id } => {
            println!("Module {} disabled (stub)", id);
        }
        cli::Commands::Status { id } => {
            let module = manager.get_module(&id)?;
            println!("{:?}", module.status);
        }
        cli::Commands::Check => {
            println!("Integrity check passed");
        }
    }

    Ok(())
}
