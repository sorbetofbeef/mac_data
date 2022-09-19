#!/bin/bash
#@doc 

LOG_DIR=$HOME/.local/var/logs/neovim

# checks to see if the logs dir is available to write to
_check_dir ()
{
  if [[ -d $LOG_DIR ]]; then
    return 0
  else
    printf '\e[33mI can not output logs to your local directory because it does not exist!\e[0m\n'
    printf '\n\e[32mCreating a directory at %s for log storage...\e[0m\n' "${LOG_DIR%/*}"
    sleep 1
    mkdir -pv "$LOG_DIR" && printf '\n\e[32mSuccess!\e[0m'
  fi
  return 0
}

main ()
{
  echo "\e[32mRemoving neovim binary and it's system data and libraries...\e[0m"
  echo "--***--***--*** -< $(date '+%R_%d.%m.%Y') >- ***--***--***--" >> ~/.local/var/logs/rm_nvim.logs
  _check_dir && sudo rm -rfv /usr/local/{bin,lib,share}/nvim | tee "$LOG_DIR"/rm_nvim.logs
  _check_dir && rm -rfv /Users/me/.local/share/nvim/site/pack/packer/start/* | tee "$LOG_DIR"/rm_nvim.logs
  echo "--***--***--*** -< $(date '+%R_%d.%m.%Y') >- ***--***--***--" >> ~/.local/var/logs/rm_nvim.logs
}

main
