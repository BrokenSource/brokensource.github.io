#!/bin/bash

# Attempt finding python executable, the binary might be
# named differently based on platform/package manager
python=""
for option in python3 python; do
    if [ -x "$(command -v $option)" ]; then
        python=$(readlink -f $(which $option))
        echo "Python was found at: $python"
        break
    fi
done
if [ -z "$python" ]; then
    echo "Python wasn't found, please install it for your platform"
    exit 1
fi

# # Standard installation procedure

echo "\n> Cloning BrokenSource Repository\n"
git clone https://github.com/BrokenSource/BrokenSource --recurse-submodules --jobs 4

echo "\n> Running brakeit.py"
python ./BrokenSource/brakeit.py
