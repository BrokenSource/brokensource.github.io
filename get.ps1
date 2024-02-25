echo "`n> Installing Git`n"
winget install -e --id Git.Git --source winget
echo "`n> Installling Python`n"
winget install -e --id Python.Python.3.11
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")+";"+
            [System.Environment]::GetEnvironmentVariable("Path","User")
echo "`n> Cloning BrokenSource`n"
git clone https://github.com/BrokenSource/BrokenSource
echo "`n> Running brakeit.py`n"
python ./BrokenSource/brakeit.py
