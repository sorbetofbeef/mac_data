#!/bin/bash

# exec kitty -1 --class "ide" --title "Neovim IDE" nvim --cmd ":cd /home/me/github"
open -a Neovide --args --multigrid --wayland-app-id "dev" -- --cmd ":cd /home/me/github"
