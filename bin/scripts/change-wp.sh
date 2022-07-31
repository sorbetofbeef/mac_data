#!/bin/bash

PIX_DIR="${HOME}/media/wp"
SYM_LINK="${PIX_DIR}/current-bg"
TARGET_PIC=$1

err(){
  msg="$1"
  code="$?"
  printf '%s. Error Code %d\n' "${msg}" "${code}"
}

changeWallpaper(){
  new_wallpaper="${PIX_DIR}/${FILE##*/}"

  if [[ -e $new_wallpaper ]]; then
    ln -sfv "$new_wallpaper" "$SYM_LINK"
  else
    mv "${SYM_LINK}~" "${SYM_LINK}"
    return 1
  fi
  printf 'Linked %s to %s...\n' "$FILE" "$SYM_LINK"
  rm "${SYM_LINK}~"
}

restart_river(){
  if [[ ! -e ${SYM_LINK}~ ]]; then
    echo "River is *ONLY* reloading it's config files. You may want to logout completely.
to avoid side effects."
    echo "Would you like to logout completely?"
    read -r -n1 check 
    if [ "$check"='y' ]; then
      riverctl exit
    else
      riverctl spawn '~/.config/river/init'
    fi
  else
    err "Symbolic link was not created properly"
    exit 1
  fi
}

restart_sway(){
  if [[ ! -e ${SYM_LINK}~ ]]; then
    swaymsg 'reload'
  else
    err "Symbolic link was not created properly"
    return 1
  fi
}

main () {
  mv "$SYM_LINK" "${SYM_LINK}~"
  
  if [[ ! -z $TARGET_PIC ]]; then
    FILE="$TARGET_PIC"
  else 
    echo "Wallpaper Listing:"
    ls --color=auto "$PIX_DIR"
    
    echo "Enter title of desired wallpaper: "
    read -r FILE 
    echo "$FILE"
  fi
  
  if changeWallpaper; then
    echo "Set wallpaper succesfully!" 
    sleep 2
  else
    err "Specified image does not exist" 
    sleep 2
    exit 1
  fi
  
  case "$XDG_CURRENT_DESKTOP" in
    'river' ) 
      echo "Restarting River..."
  	  [[ -n $new_wallpaper ]] && restart_river || exit $? 
      sleep 1
      echo "River restarted succesfully"
      sleep 1
      ;;
    'sway' )
      echo "Restarting River..."
  	  [[ -n $new_wallpaper ]] && restart_river || exit $? 
      sleep 1
      echo "Sway restarted succesfully"
      sleep 1
      ;;
  esac
  echo "Bye!"
}

main
