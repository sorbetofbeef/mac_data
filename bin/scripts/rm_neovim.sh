#!/bin/bash
#@doc 

main ()
{
  printf "\n\e[32mRemoving all NeoVim associated files and directories...\e[0m\n\n"
  ( (sudo rm -rfv /usr/local/{bin,lib,share}/nvim && rm -rfv /Users/me/.local/share/nvim/site/pack/packer/*) && 
    printf '\n\e[32mSuccess!!\e[0m\n\n' ) || 
    (printf '\n\e[31mFailed to remove NeoVim and its associated files!\e[0m\n\n' && return 1)
}

main || exit 1
