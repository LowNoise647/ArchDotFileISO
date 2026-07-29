use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "lnos-mod", version, about = "LNOS Module Manager")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,

    /// Custom modules directory
    #[arg(long, global = true)]
    pub modules_dir: Option<String>,

    /// Custom state directory
    #[arg(long, global = true)]
    pub state_dir: Option<String>,
}

#[derive(Subcommand)]
pub enum Commands {
    /// List available modules
    List {
        /// Show only installed modules
        #[arg(long)]
        installed: bool,
    },
    /// Show detailed module information
    Info {
        /// Module ID
        id: String,
    },
    /// Install modules
    Install {
        /// Module IDs to install
        ids: Vec<String>,
    },
    /// Remove modules
    Remove {
        /// Module IDs to remove
        ids: Vec<String>,
    },
    /// Enable a module
    Enable {
        /// Module ID
        id: String,
    },
    /// Disable a module
    Disable {
        /// Module ID
        id: String,
    },
    /// Check module status
    Status {
        /// Module ID
        id: String,
    },
    /// Check integrity of all modules
    Check,
}
