# Docker — Setup Guide (Ubuntu)

> Package manager used: [`nala`](https://github.com/volitank/nala) (wrapper over apt with better UX)
> Install nala first if you haven't: `sudo apt install nala`

> **Do NOT install Docker from the default Ubuntu repos** — the version there is outdated and
> doesn't include `docker compose` (v2). Always install from Docker's official repository.

---

## 1. Remove Conflicting Packages

```bash
# Remove any old/unofficial Docker packages before starting
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo nala remove "$pkg"
done
```

> This won't remove your existing images, containers or volumes — those live in `/var/lib/docker`.

---

## 2. Add Docker's Official APT Repository

```bash
# Install HTTPS transport + CA certs + curl
sudo nala install ca-certificates curl

# Create keyring directory
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh package index
sudo nala update
```

---

## 3. Install Docker Engine + Compose Plugin

```bash
# Install the full stack: Engine, CLI, containerd, buildx, compose
sudo nala install \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

> `docker compose` (v2, no hyphen) is now a plugin — not a standalone binary.
> `docker-compose` (v1, with hyphen) is legacy Python — do NOT install it.

---

## 4. Run Without sudo (Post-install Steps)

```bash
# Add your user to the docker group
sudo usermod -aG docker $USER

# Apply the new group without rebooting
newgrp docker

# Verify it works without sudo
docker run hello-world
```

> You need to log out and back in (or use `newgrp docker`) for the group change to take effect.
> On WSL2, a full shell restart is usually required.

---

## 5. Verify Installation

```bash
# Check Docker Engine version
docker version

# Check Compose plugin version
docker compose version

# Confirm docker group is active for current user
groups | grep docker

# Run the official test image
docker run --rm hello-world
```

---

## 6. Enable Docker on System Boot

```bash
# Enable + start Docker daemon
sudo systemctl enable docker
sudo systemctl start docker

# Optional: also enable containerd
sudo systemctl enable containerd
sudo systemctl start containerd

# Check status
sudo systemctl status docker
```

---

## 7. Docker Compose — Usage

```bash
# Start services in detached mode
docker compose up -d

# Stop services
docker compose down

# Rebuild images before starting
docker compose up -d --build

# Follow logs from all services
docker compose logs -f

# Run a one-off command inside a service
docker compose exec <service> bash

# Pull latest images without starting
docker compose pull
```

> Always prefer `docker compose` (v2 plugin) over `docker-compose` (v1 binary).
> The v2 plugin is faster, maintained, and supports all modern features.

---

## 8. Essential CLI Commands

```bash
# --- Images ---
docker images                        # list local images
docker pull <image>:<tag>            # pull from Docker Hub
docker rmi <image>                   # remove an image
docker image prune                   # remove dangling images

# --- Containers ---
docker ps                            # list running containers
docker ps -a                         # list all containers (including stopped)
docker run -it <image> bash          # run interactively
docker run -d -p 8080:80 <image>     # run detached with port mapping
docker stop <container>              # graceful stop
docker rm <container>                # remove stopped container
docker rm -f <container>             # force remove (even if running)

# --- Logs & Inspection ---
docker logs <container>              # view container logs
docker logs -f <container>           # follow logs (like tail -f)
docker inspect <container>           # full JSON metadata
docker stats                         # live resource usage

# --- Exec ---
docker exec -it <container> bash     # open shell in running container
docker exec -it <container> sh       # if bash isn't available

# --- Volumes ---
docker volume ls                     # list volumes
docker volume inspect <volume>       # inspect a volume
docker volume rm <volume>            # remove a volume
docker volume prune                  # remove all unused volumes

# --- Networks ---
docker network ls                    # list networks
docker network inspect <network>     # inspect a network
docker network prune                 # remove all unused networks
```

---

## 9. Cleanup — Reclaim Disk Space

```bash
# Remove all stopped containers
docker container prune

# Remove all dangling images (untagged)
docker image prune

# Remove all unused images (not just dangling)
docker image prune -a

# Remove all unused volumes
docker volume prune

# Remove all unused networks
docker network prune

# Nuclear option — removes everything not currently in use
docker system prune -a --volumes
```

> `docker system prune -a --volumes` will remove ALL stopped containers, unused images,
> unused networks, and volumes. Don't run it in production environments without reviewing first.

---

## 10. Modern Terminal Setup (pretty, fast, Nerd Fonts-ready)

> Your terminal already runs Zsh + Starship + Dank Mono/Hack Nerd Font.
> These tools are built for exactly that setup — full color, icons, TUI panels.

### lazydocker — your main Docker UI (replaces 90% of raw docker commands)

```bash
# Install
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Run
lazydocker
# or alias: lzd (see zsh aliases section below)
```

> Think lazygit but for Docker. Full TUI: containers, images, volumes, logs, stats — all in one.
> Supports Nerd Fonts icons out of the box. Navigates with vim keys (`j/k`, `g/G`, `q`).
> This is your default way to interact with Docker. Raw `docker ps` is for scripts, not humans.

**lazydocker config** — enable icons and set your preferred theme:

```bash
mkdir -p ~/.config/lazydocker
```

```yaml
# ~/.config/lazydocker/config.yml
gui:
  theme:
    activeBorderColor:
      - green
      - bold
    inactiveBorderColor:
      - white
    selectedLineBgColor:
      - blue
  icons: true          # requires Nerd Font — you already have it
  scrollHeight: 5
  language: "en"
reporting: "off"       # disable anonymous usage stats
```

---

### dive — inspect image layers, find bloat

```bash
# Install — pulls latest version dynamically from GitHub API
DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" \
  | grep '"tag_name":' \
  | sed -E 's/.*"v([^"]+)".*/\1/')
curl -fOL "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb"
sudo apt install ./dive_${DIVE_VERSION}_linux_amd64.deb
rm ./dive_${DIVE_VERSION}_linux_amd64.deb   # cleanup

# Usage
dive <image>:<tag>
dive build -t myapp:latest .   # build + analyze in one shot
```

> Shows you exactly which layer added those 200MB. Essential before pushing to a registry.
> Tab to switch panels, Space to collapse/expand layers, `^L` to filter unmodified files.

---

### hadolint — Dockerfile linter (inline warnings in your editor)

```bash
# Install — single binary, no package manager needed
sudo wget -qO /usr/local/bin/hadolint \
  https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
sudo chmod a+x /usr/local/bin/hadolint

# Usage
hadolint Dockerfile

# With bat for pretty output
hadolint Dockerfile | bat --language=sh
```

---

### docker logs — piped through bat (syntax highlight + line numbers)

```bash
# Pretty logs with bat
docker logs <container> 2>&1 | bat --language=log --paging=never

# Follow mode (bat doesn't support -f natively, use this instead)
docker logs -f <container> | bat --paging=never -l log

# Or just pipe to less with color preserved
docker logs --color <container> 2>&1 | less -R
```

---

### Zsh Aliases — add to your `_aliases/utils.sh`

```bash
# lazydocker
alias lzd='lazydocker'

# Containers
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dlogp='docker logs --tail=100 2>&1 | bat --paging=never -l log'

# Compose
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose up -d --build'
alias dcl='docker compose logs -f'
alias dcp='docker compose pull'
alias dcr='docker compose restart'

# Cleanup
alias dprune='docker system prune -f'
alias dprunea='docker system prune -a --volumes -f'

# Stats
alias dstats='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'
```

> `dps` uses a custom format — cleaner than the default wall of text.
> `lzd` is all you need 90% of the time. The rest are for quick one-liners in scripts.

---

### docker-slim — shrink images dramatically

```bash
# Install
curl -sL https://raw.githubusercontent.com/slimtoolkit/slim/master/scripts/install-slim.sh | sudo -E bash -

# Usage
slim build --target myapp:latest
# Outputs: myapp.slim — same functionality, fraction of the size
```

> Typical result: 200MB image → 8MB. No joke. It probes the container to find what's actually used.

---

## Recommended Minimal Install (fast start)

```bash
# 1. Remove old packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo nala remove "$pkg"
done

# 2. Add repo
sudo nala install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo nala update

# 3. Install Docker
sudo nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Post-install
sudo usermod -aG docker $USER
newgrp docker

# 5. Verify
docker run --rm hello-world
docker compose version
```

---

## 11. VSCode Extensions for Docker

Install via CLI:

```bash
code --install-extension ms-azuretools.vscode-docker
code --install-extension exiasr.hadolint
code --install-extension ms-vscode-remote.remote-containers
```

### Core — Non-negotiable

| Extension | ID | Why |
| --- | --- | --- |
| **Docker** | `ms-azuretools.vscode-docker` | Full Docker integration: manage containers, images, compose, registries |
| **Hadolint** | `exiasr.hadolint` | Inline Dockerfile linting — catches bad practices in real time |

### Productivity

| Extension | ID | Why |
| --- | --- | --- |
| **Dev Containers** | `ms-vscode-remote.remote-containers` | Run your full dev environment inside a container — game changer for team consistency |

### settings.json — Docker block

```json
"[dockerfile]": {
  "editor.defaultFormatter": "ms-azuretools.vscode-docker",
  "editor.formatOnSave": true
},
"docker.languageserver.formatter.ignoreMultilineInstructions": true
```

---

## Notes

- Always use the **official Docker repository** — never `sudo nala install docker.io`.
- Use `docker compose` (v2, plugin) — not `docker-compose` (v1, Python binary).
- Add your user to the `docker` group to avoid running every command with `sudo`.
- Use named volumes over bind mounts for persistent data in production containers.
- **`lazydocker`** (`lzd`) is your default UI — open it instead of typing raw docker commands.
- **`dive`** before every push to a registry — bloated images are a silent tax on your infra.
- Lint your Dockerfiles with `hadolint` before building — catches real issues early.
- Pipe `docker logs` through `bat` for syntax-highlighted, readable output.
- Your Nerd Font (Dank Mono / Hack) is already configured — `lazydocker` icons just work.
