# Install Python
winget install -e --id Git.Git --source winget

# Install Git
winget install -e --id Python.Python.3.11

# Get BrokenSource repo
git clone https://github.com/BrokenSource/BrokenSource

# Run brakeit.py
python ./BrokenSource/brakeit.py
