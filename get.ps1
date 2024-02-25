
# # Utility functions

function Reload-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";"
              + [System.Environment]::GetEnvironmentVariable("Path"," User")
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

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Print-Step "Installing Git"
    winget install -e --id Git.Git --source winget
}

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Print-Step "Installing Python"
    winget install -e --id Python.Python.3.11
}

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Print-Step "Installing FFMPEG"
    winget install -e --id FFMPEG.FFMPEG
}

Reload-Path

# # Bootstrap BrokenSource Monorepo

Print-Step "Cloning BrokenSource Repository"
git clone https://github.com/BrokenSource/BrokenSource

Print-Step "Running brakeit.py"
python ./BrokenSource/brakeit.py
