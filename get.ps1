
# # Utility functions

function Reload-Path {
    # Trivia: I don't know why, but this must be a single line command. I really don't PowerShell
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Print-Step {
    echo "`n:: $args`n"
}

# # Install basic dependencies

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Print-Step "Installing winget"
    Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
}

Reload-Path

Print-Step "Installing Git"
winget install -e --id Git.Git --source winget

Print-Step "Installing Python"
winget install -e --id Python.Python.3.11 --scope=machine

Reload-Path

# # Fail-safe: Install Python as admin if it's still not found

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    echo "`n:: Python Installation Error`n"
    echo "Python was installed but not found. Maybe it was already installed without --scope=machine, or not enough permissions."
    echo "> Will uninstall it, open a Powershell as Admin and install it. After that, please run this script again (irm url | iex)`n"
    pause
    winget uninstall -e --id Python.Python.3.11
    Start-Process -FilePath "powershell" -ArgumentList "winget install -e ---id Python.Python.3.11 --scope=machine; pause" -Verb RunAs
    exit
}

# # Bootstrap BrokenSource Monorepo

Print-Step "Cloning BrokenSource Repository"
git clone https://github.com/BrokenSource/BrokenSource --recurse-submodules --jobs 4

echo "`n> Running brakeit.py"
python ./BrokenSource/brakeit.py
