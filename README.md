# nixway

NixOS flake configuration for multiple machines.

## Structure

```
├── flake.nix                 # Flake definition with all hosts
├── hosts/
│   ├── ix/                   # Desktop workstation
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── *.nix             # Host-specific modules
│   └── caladan/              # Media server
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/                  # Shared modules
│   └── programming.nix       # Dev tools (importable by any host)
└── overlays/
    └── railway-wallet.nix
```

## Commands

### Rebuild local machine (ix)

```bash
sudo nixos-rebuild switch --flake .#ix
```

### Test configuration without switching

```bash
# Build only (no switch)
nixos-rebuild build --flake .#ix

# Build and activate, but don't add to bootloader
sudo nixos-rebuild test --flake .#ix
```

### Update flake inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs
```

### Remote deployment

Build locally, deploy to remote machine:

```bash
# Build on local machine, switch on caladan
nixos-rebuild switch --flake .#caladan \
  --target-host f0ld@caladan \
  --use-remote-sudo

# Or use the IP/tailscale name
nixos-rebuild switch --flake .#caladan \
  --target-host f0ld@100.x.x.x \
  --use-remote-sudo
```

Build AND evaluate on remote machine (useful if architectures differ):

```bash
nixos-rebuild switch --flake .#caladan \
  --target-host f0ld@caladan \
  --build-host f0ld@caladan \
  --use-remote-sudo
```

### First-time setup for a new host

1. Boot NixOS installer on the new machine
2. Run `nixos-generate-config` to get hardware-configuration.nix
3. Copy that file to `hosts/<hostname>/hardware-configuration.nix`
4. Install with:

```bash
nixos-rebuild switch --flake .#<hostname> \
  --target-host root@<ip> \
  --build-host root@<ip>
```

### Garbage collection

```bash
# Clean old generations (runs weekly automatically)
sudo nix-collect-garbage -d

# Remove generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d
```

### Debugging

```bash
# Check flake syntax
nix flake check

# Show flake outputs
nix flake show

# Build with verbose output
nixos-rebuild build --flake .#ix --show-trace

# Open a repl with the config loaded
nix repl --expr 'builtins.getFlake "/home/f0ld/nixway"'
```

## Adding a shared module

1. Create `modules/foo.nix`:

```nix
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.foo ];
}
```

2. Import in any host's configuration.nix:

```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/foo.nix
];
```

## Requirements for remote deployment

- SSH access to target (key-based auth recommended)
- User must have sudo access on target
- Nix must be able to connect (check firewall)
- For `--use-remote-sudo`: passwordless sudo or enter password when prompted
