#!/bin/bash

. /Users/me/.config/zsh/functions/lfcd

main ()
{

  mode=$1

  case $mode in
    f ) exec open -na kitty --args --single-instance --instance-group "Float" --title "PopUp"  -d ~
      ;;
    m ) exec open -na kitty --args --single-instance --instance-group "Float" --title "Mail"  -d ~ neomutt
      ;;
    t ) exec open -na kitty --args --single-instance --instance-group "General" -d ~ 
     ;;
    e ) exec open -na kitty.app --args --single-instance --instance-group "IDE" --title "Development" --session "$HOME/.config/kitty/sessions/ide.conf"
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
