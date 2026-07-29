use zbus::interface;

pub struct LnosDbusService;

#[interface(name = "org.lnos.ModuleManager")]
impl LnosDbusService {
    #[zbus(property)]
    async fn version(&self) -> String {
        "0.1.0".to_string()
    }

    async fn ping(&self) -> String {
        "pong".to_string()
    }
}
