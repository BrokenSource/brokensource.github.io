#!/bin/bash

# # Have Python

# Attempt finding python executable, the binary might be
# named differently based on platform/package manager
python=""
for option in python3 python; do
    if [ -x "$(command -v $option)" ]; then
        python=$(readlink -f $(which $option))
        break
    fi
done
if [ -z "$python" ]; then
    echo "Python wasn't found, please install it for your platform"
    exit 1
fi

# # Have Git

if [ -z "$(command -v git)" ]; then
    echo "Git wasn't found, please install it for your platform"
    exit 1
fi

# # "Standard" installation procedure

printf "\n:: Cloning BrokenSource Repository\n\n"
git clone https://github.com/BrokenSource/BrokenSource --recurse-submodules --jobs 4
cd BrokenSource

# Brakeit shouldn't spawn a shell on its own as that will be always bash
# in this script, but we want the user's shell defined in $SHELL
printf "\n:: Running brakeit.py\n"
export BRAKEIT_NO_SHELL=1
$python ./brakeit.py

# Source the venv (we are in bash)
printf ":: Sourcing the Virtual Environment\n\n"
source `$python -m poetry env info --path`/bin/activate

# Spawn a new user's shell
exec $SHELL
