//! Shared by the preview app and relay; separate from the official Coucou namespace.
pub const NAME: &str = "Coucou";
pub const IDENTIFIER: &str = "io.github.jose-smg.mochistudio.preview";
pub const DATA_DIRECTORY: &str = "MochiStudioPreview";
pub const APP_BINARY: &str = "Coucou";
pub const HOOK_MARKER: &str = "mochi-studio-preview-hook";
pub const PIPE_PREFIX: &str = "mochi-studio-preview";
pub const AGENT_HOOKS_ENABLED: bool = false;
pub const AUTOMATIC_UPDATES_ENABLED: bool = false;
pub const GLOBAL_SHORTCUTS_ENABLED: bool = false;

pub fn require_agent_hooks() -> Result<(), String> {
    if AGENT_HOOKS_ENABLED { Ok(()) } else {
        Err("Agent hook installation is disabled in this Coucou build. Your Coucou and coding-agent settings are left unchanged.".into())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn preview_cannot_install_or_remove_official_agent_hooks() {
        assert!(require_agent_hooks().is_err());
        assert_ne!(IDENTIFIER, "fr.louisraille.coucou");
        assert_ne!(DATA_DIRECTORY, "Coucou");
        assert_ne!(PIPE_PREFIX, "coucou");
        assert_ne!(HOOK_MARKER, "coucou-hook");
        assert!(!AUTOMATIC_UPDATES_ENABLED);
    }
}
