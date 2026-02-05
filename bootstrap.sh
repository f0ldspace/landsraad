#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_USER="f0ld"
TRINITY_REPO="https://github.com/f0ldspace/trinity.git"
WOFI_REPO="https://github.com/f0ldspace/wofi.git"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
  echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

prompt_yes_no() {
  local prompt="$1"
  local default="${2:-y}"
  local answer

  if [[ "$default" == "y" ]]; then
    prompt="$prompt [Y/n]: "
  else
    prompt="$prompt [y/N]: "
  fi

  read -r -p "$prompt" answer
  answer="${answer:-$default}"
  [[ "${answer,,}" == "y" || "${answer,,}" == "yes" ]]
}

ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    success "created directory: $dir"
  else
    info "directory exists: $dir"
  fi
}

preflight_checks() {
  info "Running pre-flight checks..."

  if [[ ! -f /etc/os-release ]] || ! grep -q "NixOS" /etc/os-release; then
    error "why would you run this on something other than nixos?"
  fi
  success "Running on NixOS"

  if [[ $EUID -eq 0 ]]; then
    error "dont run as root"
  fi
  success "Running as non-root user: $USER"

  if ! command -v git &>/dev/null; then
    warn "git not found. Attempting to use nix-shell..."
    if ! command -v nix-shell &>/dev/null; then
      error "Neither git nor nix-shell available. Install git first."
    fi
    export GIT_CMD="nix-shell -p git --run git"
  else
    export GIT_CMD="git"
    success "git is available"
  fi

  # Always ensure experimental features config exists (the check may pass
  # in nix-shell but fail for the regular user)
  enable_experimental_features

  if nix flake --help &>/dev/null 2>&1; then
    success "Nix flakes are enabled"
  else
    warn "Nix flakes check failed - you may need to restart your shell"
  fi
}

enable_experimental_features() {
  local nix_conf_dir="$HOME/.config/nix"
  local nix_conf="$nix_conf_dir/nix.conf"

  ensure_dir "$nix_conf_dir"

  if [[ -f "$nix_conf" ]]; then
    if grep -q "experimental-features" "$nix_conf"; then
      info "experimental-features already configured in $nix_conf"
      return 0
    fi
    echo "experimental-features = nix-command flakes" >> "$nix_conf"
  else
    echo "experimental-features = nix-command flakes" > "$nix_conf"
  fi
  success "Enabled experimental features (nix-command, flakes) in $nix_conf"
}

configure_user() {
  echo ""
  info "User Configuration"
  echo "===================="

  AVAILABLE_HOSTS=$(ls -d "$REPO_ROOT"/hosts/*/ 2>/dev/null | xargs -n1 basename || echo "")
  if [[ -z "$AVAILABLE_HOSTS" ]]; then
    error "No hosts found in $REPO_ROOT/hosts/"
  fi

  echo ""
  read -r -p "Enter target username [$DEFAULT_USER]: " TARGET_USER
  TARGET_USER="${TARGET_USER:-$DEFAULT_USER}"

  if ! id "$TARGET_USER" &>/dev/null; then
    error "User '$TARGET_USER' does not exist on this system"
  fi
  success "User '$TARGET_USER' exists"

  TARGET_HOME=$(eval echo "~$TARGET_USER")
  if [[ ! -d "$TARGET_HOME" ]]; then
    error "Home directory '$TARGET_HOME' does not exist"
  fi
  success "Home directory: $TARGET_HOME"

  echo ""
  echo "Available hosts:"
  for host in $AVAILABLE_HOSTS; do
    echo "  - $host"
  done
  echo ""
  read -r -p "Enter target hostname: " TARGET_HOST

  if [[ ! -d "$REPO_ROOT/hosts/$TARGET_HOST" ]]; then
    error "Host '$TARGET_HOST' not found in $REPO_ROOT/hosts/"
  fi
  success "Selected host: $TARGET_HOST"

  export TARGET_USER TARGET_HOME TARGET_HOST
}

setup_hardware_config() {
  echo ""
  info "Hardware Configuration"
  echo "========================"

  local source="/etc/nixos/hardware-configuration.nix"
  local dest="$REPO_ROOT/hosts/$TARGET_HOST/hardware-configuration.nix"

  if [[ ! -f "$source" ]]; then
    warn "Hardware configuration not found at $source"
    warn "You may need to run: sudo nixos-generate-config"
    warn "Then re-run this bootstrap script"
    return 1
  fi

  if [[ -f "$dest" ]]; then
    warn "Hardware configuration already exists at $dest"
    if prompt_yes_no "Overwrite with system hardware config?"; then
      cp "$source" "$dest"
      success "Copied hardware configuration to $dest"
    else
      info "Keeping existing hardware configuration"
    fi
  else
    cp "$source" "$dest"
    success "Copied hardware configuration to $dest"
  fi
}

update_paths_for_user() {
  echo ""
  info "Updating paths for user '$TARGET_USER'"
  echo "========================================"

  if [[ "$TARGET_USER" == "$DEFAULT_USER" ]]; then
    info "Username matches default ($DEFAULT_USER), no path updates needed"
    return 0
  fi

  local files_to_update=(
    "$REPO_ROOT/flake.nix"
    "$REPO_ROOT/home/f0ld.nix"
    "$REPO_ROOT/home/niri.nix"
    "$REPO_ROOT/hosts/ix/configuration.nix"
    "$REPO_ROOT/hosts/ix/websites.nix"
    "$REPO_ROOT/modules/navidrone.nix"
    "$REPO_ROOT/modules/audiobookshelf-server.nix"
  )

  for file in "${files_to_update[@]}"; do
    if [[ -f "$file" ]]; then
      # Create backup
      cp "$file" "$file.bak"

      sed -i "s|/home/$DEFAULT_USER/|/home/$TARGET_USER/|g" "$file"

      sed -i "s|home.username = \"$DEFAULT_USER\"|home.username = \"$TARGET_USER\"|g" "$file"
      sed -i "s|home.homeDirectory = \"/home/$DEFAULT_USER\"|home.homeDirectory = \"/home/$TARGET_USER\"|g" "$file"
      sed -i "s|user = \"$DEFAULT_USER\"|user = \"$TARGET_USER\"|g" "$file"
      sed -i "s|User = lib.mkForce \"$DEFAULT_USER\"|User = lib.mkForce \"$TARGET_USER\"|g" "$file"
      sed -i "s|users.users.$DEFAULT_USER|users.users.$TARGET_USER|g" "$file"
      sed -i "s|home-manager.users.$DEFAULT_USER|home-manager.users.$TARGET_USER|g" "$file"

      success "Updated paths in $file (backup: $file.bak)"
    else
      warn "File not found, skipping: $file"
    fi
  done

  if [[ "$TARGET_USER" != "$DEFAULT_USER" && -f "$REPO_ROOT/home/f0ld.nix" ]]; then
    local new_home_file="$REPO_ROOT/home/$TARGET_USER.nix"
    if [[ ! -f "$new_home_file" ]]; then
      cp "$REPO_ROOT/home/f0ld.nix" "$new_home_file"
      success "Created $new_home_file"
      warn "You may want to update flake.nix to import ./home/$TARGET_USER.nix"
    fi
  fi
}

clone_repositories() {
  echo ""
  info "Cloning Required Repositories"
  echo "==============================="

  local trinity_dest="$TARGET_HOME/trinity"
  if [[ -d "$trinity_dest" ]]; then
    info "Trinity already exists at $trinity_dest"
  else
    info "Cloning Trinity (Neovim config)..."
    $GIT_CMD clone "$TRINITY_REPO" "$trinity_dest"
    success "Cloned Trinity to $trinity_dest"
  fi

  local wofi_dest="$TARGET_HOME/wofi"
  if [[ -d "$wofi_dest" ]]; then
    info "Wofi scripts already exist at $wofi_dest"
  else
    info "Cloning Wofi scripts..."
    $GIT_CMD clone "$WOFI_REPO" "$wofi_dest"
    success "Cloned Wofi scripts to $wofi_dest"
  fi

  info "Updating flake lock (local path inputs may have changed)..."
  if nix flake update --flake "$REPO_ROOT" 2>/dev/null; then
    success "Flake lock updated"
  else
    warn "Could not update flake lock. You may need to run: nix flake update"
  fi
}

create_directories() {
  echo ""
  info "Creating Required Directories"
  echo "==============================="

  local dirs=(
    "$TARGET_HOME/wiki"
    "$TARGET_HOME/Music"
    "$TARGET_HOME/Audiobooks"
    "$TARGET_HOME/Podcasts"
    "$TARGET_HOME/worklog"
    "$TARGET_HOME/.icons"
    "$TARGET_HOME/Pictures/Screenshots"
  )

  for dir in "${dirs[@]}"; do
    ensure_dir "$dir"
  done
}

setup_secrets() {
  echo ""
  info "Setting up Secret Placeholders"
  echo "================================="
  echo ""
  warn "This step requires sudo to create files in /etc/"
  echo ""

  if ! prompt_yes_no "Create secret placeholder files?"; then
    info "Skipping secret setup"
    return 0
  fi

  sudo mkdir -p /etc/restic

  if [[ ! -f /etc/restic/b2-env ]]; then
    sudo tee /etc/restic/b2-env >/dev/null <<'EOF'
# Backblaze B2 credentials for restic backups
# Fill in your actual values:
B2_ACCOUNT_ID=your_account_id_here
B2_ACCOUNT_KEY=your_account_key_here
EOF
    sudo chmod 600 /etc/restic/b2-env
    success "Created /etc/restic/b2-env placeholder"
  else
    info "/etc/restic/b2-env already exists"
  fi

  if [[ ! -f /etc/restic/password ]]; then
    sudo tee /etc/restic/password >/dev/null <<'EOF'
REPLACE_WITH_YOUR_RESTIC_ENCRYPTION_PASSWORD
EOF
    sudo chmod 600 /etc/restic/password
    success "Created /etc/restic/password placeholder"
  else
    info "/etc/restic/password already exists"
  fi

  sudo mkdir -p /etc/wakapi

  if [[ ! -f /etc/wakapi/secrets.env ]]; then
    sudo tee /etc/wakapi/secrets.env >/dev/null <<'EOF'
# Wakapi secrets
# Generate a random salt with: openssl rand -hex 32
WAKAPI_PASSWORD_SALT=your_random_salt_here
EOF
    sudo chmod 600 /etc/wakapi/secrets.env
    success "Created /etc/wakapi/secrets.env placeholder"
  else
    info "/etc/wakapi/secrets.env already exists"
  fi

  if [[ ! -f "$TARGET_HOME/.wakatime.cfg" ]]; then
    cat >"$TARGET_HOME/.wakatime.cfg" <<'EOF'
[settings]
api_key = your_wakapi_api_key_here
api_url = http://localhost:3040/api
EOF
    success "Created $TARGET_HOME/.wakatime.cfg placeholder"
  else
    info "$TARGET_HOME/.wakatime.cfg already exists"
  fi
}

print_summary() {
  echo ""
  echo "============================================================================="
  echo -e "${GREEN}Bootstrap Complete!${NC}"
  echo "============================================================================="
  echo ""
  echo "What was done:"
  echo "  - Verified NixOS environment"
  echo "  - Configured for user: $TARGET_USER"
  echo "  - Configured for host: $TARGET_HOST"
  if [[ "$TARGET_USER" != "$DEFAULT_USER" ]]; then
    echo "  - Updated hardcoded paths from $DEFAULT_USER to $TARGET_USER"
  fi
  echo "  - Cloned required repositories (trinity, wofi)"
  echo "  - Created required directories"
  echo "  - Created secret placeholder files"
  echo ""
  echo "============================================================================="
  echo -e "${YELLOW}Manual Steps Required:${NC}"
  echo "============================================================================="
  echo ""
  echo "1. Fill in secrets with real values:"
  echo "   - /etc/restic/b2-env      (Backblaze B2 credentials)"
  echo "   - /etc/restic/password    (Restic encryption password)"
  echo "   - /etc/wakapi/secrets.env (Wakapi password salt)"
  echo "   - ~/.wakatime.cfg         (WakaTime/Wakapi API key)"
  echo ""
  echo "2. Add icon files to ~/.icons/:"
  echo "   - lesswrong.png"
  echo "   - nix.png"
  echo "   - openrouter.png"
  echo "   - audiobookshelf.png"
  echo "   - ea.png"
  echo ""
  echo "3. Build and switch to the configuration:"
  echo "   cd $REPO_ROOT"
  echo "   sudo nixos-rebuild switch --flake .#$TARGET_HOST"
  echo ""
  echo "4. Verify the build:"
  echo "   nix flake check"
  echo ""
  if [[ "$TARGET_USER" != "$DEFAULT_USER" ]]; then
    echo "5. Review the backup files (*.bak) and remove them when satisfied"
    echo ""
  fi
  echo "============================================================================="
}

# =============================================================================
# Main
# =============================================================================

main() {
  echo ""
  echo "============================================================================="
  echo "  Landsraad NixOS Configuration Bootstrap"
  echo "============================================================================="
  echo ""

  preflight_checks
  configure_user
  setup_hardware_config
  update_paths_for_user
  clone_repositories
  create_directories
  setup_secrets
  print_summary
}

main "$@"
