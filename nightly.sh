#!/bin/bash

# # Constants

INSTALL_MAX_ATTEMPTS=3
MACOS=$((uname=="Darwin"?1:0))

# # Utilities Functions

install_brew() {
  if [ $MACOS -eq 0 ]; then
    return
  fi
  while true; do
    if [ -z "$(command -v brew)" ]; then
      echo "Homebrew wasn't found, will install it with the recommended command"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      continue
    fi
    break
  done
}

# A over-engineered attempt to install Git and Python automatically
install_package() {
  package=$1

  # Already have the package
  if [ -x "$(command -v $package)" ]; then
    return
  fi

  # MacOS at least is "centralized"
  if [ $MACOS -eq 1 ]; then
    install_brew
    brew install $package
    return
  fi

  command=""

  # Try finding the most common Linux package managers
  if   [ -x "$(command -v apt)"    ]; then
    command="sudo apt install -y $package"
  elif [ -x "$(command -v yay)"    ]; then
    command="yay -Sy --noconfirm $package"
  elif [ -x "$(command -v paru)"   ]; then
    command="paru -Sy --noconfirm $package"
  elif [ -x "$(command -v pacman)" ]; then
    command="sudo pacman -Sy --noconfirm $package"
  elif [ -x "$(command -v dnf)"    ]; then
    command="sudo dnf install -y $package"
  elif [ -x "$(command -v yum)"    ]; then
    command="sudo yum install -y $package"
  elif [ -x "$(command -v zypper)" ]; then
    command="sudo zypper install -y $package"
  fi

  if [ -z "$command" ]; then
    echo "Couldn't find a Package Manager to install ($package)"
    echo "• Consider sending a Pull Request"
    exit 1
  fi

  echo "Will install missing package ($package) with the following command:"
  echo "• $command\n"

  # Ask for confirmation
  while true; do
    read -p "\nDo you want to proceed? [y/n] " yn
    case $yn in
      [Yy]* ) eval $command; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

# # Have Python

python=""

# New: Try N times installing Python
for attempt in $(seq 1 $INSTALL_MAX_ATTEMPTS); do
  for option in python3 python; do
    if [ -x "$(command -v $option)" ]; then
      python=$(readlink -f $(which $option))
      break
    fi
  done

  # Attempt installing it
  if [ $attempt -eq 1 ]; then
    install_package python
  else
    install_package python3
  fi

  # Reached maximum attempts
  if [ $attempt -eq $INSTALL_MAX_ATTEMPTS ]; then
    echo "Couldn't find Python after $INSTALL_MAX_ATTEMPTS install attempts"
    exit 1
  fi
done

# # Have Git

for attempt in $(seq 1 $INSTALL_MAX_ATTEMPTS); do
  if [ -x "$(command -v git)" ]; then
    break
  fi

  # Attempt installing it
  install_package git

  # Reached maximum attempts
  if [ $attempt -eq $INSTALL_MAX_ATTEMPTS ]; then
    echo "Couldn't find Git after $INSTALL_MAX_ATTEMPTS install attempts"
    exit 1
  fi
done

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
