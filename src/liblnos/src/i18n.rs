use std::collections::HashMap;

pub struct I18n {
    translations: HashMap<String, HashMap<String, String>>,
    current_lang: String,
}

impl I18n {
    pub fn new() -> Self {
        let mut translations = HashMap::new();
        let mut en = HashMap::new();
        en.insert("module.install.success".to_string(), "Module {0} installed successfully".to_string());
        en.insert("module.remove.success".to_string(), "Module {0} removed successfully".to_string());
        en.insert("error.not_found".to_string(), "Module not found: {0}".to_string());

        let mut es = HashMap::new();
        es.insert("module.install.success".to_string(), "Módulo {0} instalado correctamente".to_string());
        es.insert("module.remove.success".to_string(), "Módulo {0} eliminado correctamente".to_string());
        es.insert("error.not_found".to_string(), "Módulo no encontrado: {0}".to_string());

        translations.insert("en".to_string(), en);
        translations.insert("es".to_string(), es);

        Self {
            translations,
            current_lang: "en".to_string(),
        }
    }

    pub fn set_language(&mut self, lang: &str) {
        self.current_lang = lang.to_string();
    }

    pub fn translate(&self, key: &str, args: &[&str]) -> String {
        let lang_map = self.translations.get(&self.current_lang)
            .or_else(|| self.translations.get("en"))
            .unwrap();

        let template = lang_map.get(key)
            .or_else(|| self.translations.get("en").unwrap().get(key))
            .map(|s| s.clone())
            .unwrap_or_else(|| key.to_string());

        let mut result = template;
        for (i, arg) in args.iter().enumerate() {
            result = result.replace(&format!("{{{}}}", i), arg);
        }
        result
    }
}

impl Default for I18n {
    fn default() -> Self {
        Self::new()
    }
}
