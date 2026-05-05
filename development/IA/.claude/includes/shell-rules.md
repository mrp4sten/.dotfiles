# Shell & Environment Rules
 
## Shell Hygiene
- Always quote variables: `"$VAR"` not `$VAR`
- Use `set -euo pipefail` at the top of any script
- Prefer `[[` over `[` for conditionals in bash
- Use `$(command)` not backticks
- Check exit codes — never assume a command succeeded
## File Operations
- Use relative paths inside projects, absolute paths for system-level ops
- Always verify a path before deleting or overwriting
- Use `cp -i` / `mv -i` when unsure (prompt before overwrite)
- Prefer `mkdir -p` to avoid errors on existing dirs
## Environment
- Never hardcode paths like `/home/mauricio/` — use `$HOME` or `~`
- Load env vars from `.env` files, never export them into shell history
- Avoid polluting `PATH` with project-local binaries globally
## Arch Linux Specifics
- Package manager: `pacman` / `yay` for AUR
- Init system: `systemctl` for services
- Config dirs follow XDG spec: `$HOME/.config/<app>/`
 