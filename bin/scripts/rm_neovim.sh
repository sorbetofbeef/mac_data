#!/bin/bash
#@doc 

# checks to see if the logs dir is available to write to
_check_dir ()
{
  if [[ -d $HOME/.local/var/logs ]]; then
    return 0
  else
    echo "I can't output logs to your local directory becaise it does not exist!"
    echo "Creating a directory at ~/.local/var/logs for log storage..."
    sleep 1
    mkdir -p "$HOME/.local/var/logs" && echo "Success!"
  fi
  return 0
}

main ()
{
  echo "Removing neovim binary and it's system data and libraries..."
  echo "--***--***--*** -< $(date '+%R_%d.%m.%Y') >- ***--***--***--" >> ~/.local/var/logs/rm_nvim.logs
  _check_dir && sudo rm -rfv /usr/local/{bin,lib,share}/nvim | tee ~/.local/var/logs/rm_nvim.logs
}

main
