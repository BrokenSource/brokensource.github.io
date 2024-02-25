function Print-Step {
    param([string]$step)
    Write-Host ""
    Write-Host > $step
    Write-Host ""
}

Print-Step "Installing Git"
winget install -e --id Git.Git --source winget
Print-Step "Installling Python"
winget install -e --id Python.Python.3.11
print-Step "Reloading Path"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
print-Step "Cloning BrokenSource"
git clone https://github.com/BrokenSource/BrokenSource
print-Step "Running brakeit.py"
python ./BrokenSource/brakeit.py
