#!/bin/bash

. /Users/me/.config/zsh/functions/lfcd

main ()
{

  mode=$1

  case $mode in
    f ) exec open -na kitty --args --single-instance --instance-group "Float" --title "PopUp"  -d ~ zsh -c 'lf'
      ;;
    m ) exec open -na kitty --args --single-instance --instance-group "Float" --title "Mail"  -d ~ zsh -c 'neomutt'
      ;;
    t ) exec open -na kitty --args --single-instance --instance-group "General" -d ~ zsh -c 'lf'
     ;;
    e ) exec open -na kitty.app --args --single-instance --instance-group "IDE" --title "Development"  nvim +cd ~/Projects
     ;;
    l ) exec open -na kitty.app --args --single-instance --instance-group "Float" --title "Launcher" ~/Projects/sk-launcher 
     ;;
    n ) exec open -na Neovide --args --multigrid --frameless -- +cd ~/Projects/
     ;;
    * ) printf "\e[31mFAILED!!\e[0m"
     ;;
  esac


}


main "$@"
