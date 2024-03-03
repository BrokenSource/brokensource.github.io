
# # Utility functions

function Reload-Path {
    # Trivia: I don't know why, but this must be a single line command. I really don't PowerShell
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Print-Step {
    echo "`n> $args`n"
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

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Print-Step "Installing FFMPEG"
    winget install -e --id FFMPEG.FFMPEG
}

Reload-Path

# # Bootstrap BrokenSource Monorepo

Print-Step "Cloning BrokenSource Repository"
git clone https://github.com/BrokenSource/BrokenSource --recurse-submodules

echo "`n> Running brakeit.py"
python ./BrokenSource/brakeit.py
