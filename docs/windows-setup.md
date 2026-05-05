# Windows Setup — One-Time Prerequisites

Before running `bootstrap.ps1` or `install.ps1` for the first time.

---

## 1. Install Git for Windows

Required so `git` and `bash` are available in PowerShell (needed by `config_craft` and `skills_setup`).

```powershell
winget install --id Git.Git --exact
```

Restart your terminal after installing.

---

## 2. Install PowerShell 7

Windows ships with PowerShell 5.1. The dotfiles target PowerShell 7 (`pwsh`).

```powershell
winget install --id Microsoft.PowerShell --exact
```

Open a new **PowerShell 7** window (`pwsh`) for all subsequent steps.

---

## 3. Set Execution Policy

Allows running local scripts without signing.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 4. Enable Developer Mode (required for symlinks without Admin)

Symbolic links on Windows require either Developer Mode **or** running as Administrator.

**Windows 11:**
> Settings → Privacy & security → For developers → Developer Mode → **On**

**Windows 10:**
> Settings → Update & Security → For developers → Developer Mode → **On**

If you prefer Administrator instead, skip this step and always run `install.ps1` from an elevated prompt.

---

## 5. Verify winget is available

winget ships with Windows 11 and recent Windows 10 builds. If `winget` is not found, install **App Installer** from the Microsoft Store.

---

## All set

```powershell
cd $HOME\.dotfiles
pwsh -ExecutionPolicy Bypass -File automation\install\windows\bootstrap.ps1
pwsh -File automation\install\windows\install.ps1
. $PROFILE
```
