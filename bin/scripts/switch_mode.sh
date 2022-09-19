#!/bin/bash

while [[ $(date '+%H') -lt 20 ]]; do
  python3 "$HOME/.local/bin/scripts/darkmode.py" &&
  . "/Users/me/.config/zsh/.zshenv" 
  sleep $(( 60 * 60 ))
done
while [[ $(date '+%H') -ge 20 ]]; do
  python3 "$HOME/.local/bin/scripts/darkmode.py" &&
 . "/Users/me/.config/zsh/.zshenv" 
  sleep $(( 60 * 60 ))
done
