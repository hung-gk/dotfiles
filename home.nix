{ config, lib, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # Installed with the Homebrew `code` CLI on every switch. Not done through
  # nix-darwin's `homebrew.vscode` because `brew bundle` (seen on 6.0.1 and
  # 7.0.11) fails to detect VS Code and aborts the whole activation.
  vscodeExtensions = [
    "anthropic.claude-code"
    "atlassian.atlascode"
    "dbtlabsinc.dbt"
    "dracula-theme.theme-dracula"
    "eamodio.gitlens"
    "inferrinizzard.prettier-sql-vscode"
    "redhat.vscode-yaml"
    "trunk.io"
  ];
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    gh        # github cli
    neovim
    uv        # python projects and tools
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept

      # Run one command with Looker API credentials from the macOS Keychain,
      # so the secret never sits in the shell env of every process.
      with-looker() {
        LOOKERSDK_BASE_URL="$(security find-generic-password -s looker-base-url -w)" \
        LOOKERSDK_CLIENT_ID="$(security find-generic-password -s looker-client-id -w)" \
        LOOKERSDK_CLIENT_SECRET="$(security find-generic-password -s looker-client-secret -w)" \
        "$@"
      }
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file."Library/Application Support/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/vscode/settings.json";
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/vscode/keybindings.json";
  home.activation.vscodeExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    code=/opt/homebrew/bin/code
    if [ -x "$code" ]; then
      installed="$("$code" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"
      for ext in ${lib.escapeShellArgs vscodeExtensions}; do
        if ! printf '%s\n' "$installed" | grep -qxF "$ext"; then
          run "$code" --install-extension "$ext"
        fi
      done
    else
      echo "VS Code CLI not found at $code; skipping extensions (rerun ./rebuild.sh after Homebrew installs it)." >&2
    fi
  '';

  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
