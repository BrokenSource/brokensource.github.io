#!/bin/bash

{ # Prevent execution if partially downloaded

# Find 'git', exit if not found
git=""
if [ -x "$(command -v git)" ]; then
  git=$(readlink -f $(which git))
  echo "• Found Git at ($git)"
else
  echo "• Git wasn't found, please get it at (https://git-scm.com)"
  exit 1
fi

# Find 'rye', install if not found
rye=""
for attempt in $(seq 1 2); do
  if [ -x "$(command -v rye)" ]; then
    rye=$(readlink -f $(which rye))
    echo "• Found Rye at ($rye)"
    break
  fi

  if [ $attempt -eq 2 ]; then
    echo "Rye wasn't found after an installation attempt"
    echo "• Do you have the Shims directory on PATH?"
    echo "• Try restarting the Shell and retrying"
    echo "• Get it at (https://rye.astral.sh)"
    exit 1
  fi

  echo "• Rye wasn't found, will attempt to install it"
  export RYE_TOOLCHAIN_VERSION="cpython@3.11"
  export RYE_INSTALL_OPTION="--yes"
  export RYE_NO_AUTO_INSTALL=1
  /bin/bash -c "$(curl -sSf https://rye.astral.sh/get)"
done

# # Clone the Repositories, Install Python Dependencies on venv and Spawn a new Shell

# Only clone if not already on a BrokenSource Repository
if [ ! -d "Broken" ]; then
  printf "\n:: Cloning BrokenSource Repository and all Submodules\n\n"
  $git clone https://github.com/BrokenSource/BrokenSource --recurse-submodules --jobs 4
  cd BrokenSource

  printf "\n:: Checking out main branch for all submodules\n"
  $git submodule foreach --recursive 'git checkout main || true'
else
  printf "\n:: Already on a BrokenSource Repository\n"
fi

# Make scripts executable for later use
chmod +x Website/get.sh
chmod +x ./Scripts/activate.sh

printf "\n:: Creating Virtual Environment and Installing Dependencies\n"
$rye self update
$rye config --set-bool behavior.autosync=true
$rye config --set-bool behavior.use-uv=true
$rye config --set-bool global-python=false
$rye sync

printf "\n:: Spawning a new Shell in the Virtual Environment\n"
source .venv/bin/activate
exec $SHELL

}