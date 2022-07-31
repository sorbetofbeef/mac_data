#!/bin/bash

. /Users/me/.config/zsh/functions/lfcd

main ()
{

  mode=$1

  case $mode in
    f ) exec /Applications/MacPorts/kitty.app/Contents/MacOS/kitty --single-instance --instance-group "Float" --title "PopUp"  -d ~ zsh -c '. /Users/me/.config/zsh/functions/lfcd && lfcd "\$@"'
      ;;
    t ) exec /Applications/MacPorts/kitty.app/Contents/MacOS/kitty --single-instance --instance-group "General" -d ~ zsh -c '. /Users/me/.config/zsh/functions/lfcd && lfcd "\$@"'
     ;;
    # e ) exec /Applications/MacPorts/kitty.app/Contents/MacOS/kitty --single-instance --instance-group "IDE" --title "Development" ide
    #  ;;
    * ) printf "\e[31mFAILED!!\e[0m"
     ;;
  esac


}


main "$@"
