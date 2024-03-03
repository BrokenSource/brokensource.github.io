#!/bin/bash

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

# # Standard installation procedure

printf "\n:: Cloning BrokenSource Repository\n\n"
git clone https://github.com/BrokenSource/BrokenSource --recurse-submodules --jobs 4

printf "\n:: Running brakeit.py\n"
python ./BrokenSource/brakeit.py
