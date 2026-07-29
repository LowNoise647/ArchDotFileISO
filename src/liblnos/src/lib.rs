pub mod config;
pub mod dbus;
pub mod i18n;
pub mod module;

use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LnosConfig {
    pub system_config: PathBuf,
    pub user_config: PathBuf,
    pub state_dir: PathBuf,
    pub modules_dir: PathBuf,
}

impl Default for LnosConfig {
    fn default() -> Self {
        Self {
            system_config: PathBuf::from("/etc/lnos"),
            user_config: PathBuf::from("/etc/lnos/user"),
            state_dir: PathBuf::from("/etc/lnos/state"),
            modules_dir: PathBuf::from("/usr/share/lnos/modules"),
        }
    }
}

pub const VERSION: &str = env!("CARGO_PKG_VERSION");
pub const NAME: &str = "LNOS";
