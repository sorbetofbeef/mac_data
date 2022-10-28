#!/usr/bin/env bash
# shellcheck source=/Users/me/.config/environment.d/dark_mode.sh

TARGET_DIR="$HOME/.config/environment.d"
TARGET_FILE="dark_mode.sh"
TARGET="${TARGET_DIR}/${TARGET_FILE}"

CACHE_DIR="$HOME/.cache/themer"
CACHE_TARGET="${CACHE_DIR}/${TARGET_FILE}.bak"

THEMES=$(ls /Users/me/.config/kitty/themes)

NEW_DARK_THEME=$DARK_THEME
NEW_DARK_VARIANT=$DARK_VARIANT
export CURRENT_DARK_THEME="$NEW_DARK_THEME $NEW_DARK_VARIANT"

NEW_LIGHT_THEME=$LIGHT_THEME
NEW_LIGHT_VARIANT=$LIGHT_VARIANT
export CURRENT_LIGHT_THEME="$NEW_LIGHT_THEME $NEW_LIGHT_VARIANT"

declare -ax THEME_SET


_get_themes ()
{
  themes=$1
  i=0
  for t in "${themes[@]}"; do
    declare -a "tmp_set[$i]=${t}"
    (( i=i+1 ))
  done
  THEME_SET=("${tmp_set[@]}")
}
_print_themes() 
{
  theme_set=$1
  i=1
  for theme in $theme_set; do
    printf '\e[36m %s ) %s \e[0m' "$i" "$theme"
    if [[ $((i%2)) -ne 0 ]]; then
      ((i=i+1))
      continue
    fi
    printf '\n'
    ((i=i+1))
  done
}
  
select_theme () 
{
  mode=$1
  themes=$2
  _print_themes "${themes[@]}"
  if [[ $mode -eq 1 ]]; then
    printf '\nSelect \e[31mDARK MODE\e[0m theme: '
  else
    printf '\nSelect \e[33mLIGHT MODE\e[0m theme: '
  fi ; read -r input 

  i=1
  for option in $themes; do
    if [[ $input = "$i" ]]; then
      option=${option%.*}
      if [[ $mode -eq 1 ]]; then
      NEW_DARK_THEME=${option%_*}
      NEW_DARK_VARIANT=${option##*_}
      CURRENT_DARK_THEME="$NEW_DARK_THEME $NEW_DARK_VARIANT"
    else
      NEW_LIGHT_THEME=${option%_*}
      NEW_LIGHT_VARIANT=${option##*_}
      CURRENT_LIGHT_THEME="$NEW_LIGHT_THEME $NEW_LIGHT_VARIANT"
    fi
      break
    fi
    (( i=i+1 ))
  done
}

write_environment () 
{
  target=$1
  tmp_dark_theme=$2
  tmp_dark_variant=$3
  tmp_light_theme=$4
  tmp_light_variant=$5

  cat > "${target}" << EOF
#!/usr/bin/env bash

export DARK_THEME="$tmp_dark_theme"
export DARK_VARIANT="$tmp_dark_variant"
export BAT_THEME_DARK="OneHalfDark"

export LIGHT_THEME="$tmp_light_theme"
export LIGHT_VARIANT="$tmp_light_variant"
export BAT_THEME_LIGHT="OneHalfLight"
EOF
}

greet ()
{
  clear
  printf '\n    **----------------**\n  ************************\n***        THEMER        ***\n  ************************\n    **----------------**\n'
  sleep 2
}
main_menu ()
{
  _get_themes "$THEMES"
  clear
  printf ' ╔════════╗  Dark Theme: %s\n ║  MENU  ║  Light Theme: %s\n' "$CURRENT_DARK_THEME" "$CURRENT_LIGHT_THEME"
  printf '╭╜        ╙───────────────┬──────────────────────────╮\n'
  printf '│                         │                          │\n'
  printf '│  1 ) Change Dark Theme  │  2 ) Change Light Theme  │\n'
  printf '│                         │                          │\n'
  printf '╰──────────┬────────┬─────┴───┬────────┬─────────────╯\n'
  printf '           │ (s)ave │ (r)eset │ (q)uit │\n'
  printf '           ╰────────┴─────────┴────────╯\n'
  printf '\n $ > '; read -r input
  case $input in
    1 | 2 ) select_theme "$input" "${THEME_SET[@]}"
    ;;
    s ) printf 'Saving Environment\n'
      sleep 2
      write_environment "$TARGET" "$NEW_DARK_THEME" "$NEW_DARK_VARIANT" "$NEW_LIGHT_THEME" "$NEW_LIGHT_VARIANT"
      dark_mode
    ;;
    r ) printf 'Reseting Environment\n'
      CURRENT_DARK_THEME="$DARK_THEME $DARK_VARIANT"
      CURRENT_LIGHT_THEME="$LIGHT_THEME $LIGHT_VARIANT"
      mv "$TARGET" "${TARGET}.tmp"
      (cp "$CACHE_TARGET" "$TARGET" && rm "${TARGET}.tmp") || (printf '\nERROR' && mv "${TARGET}.tmp" "$TARGET")

      source "$TARGET"
      dark_mode
    ;;
    q ) printf 'Quitting\n'
    sleep 1
    return 1 
    ;;
    * ) print 'Invalid choice...\n'
    ;;
  esac
}

main () 
{
  greet
  source "/Users/me/.config/zsh/functions/check_dir"
  check_dir "$CACHE_DIR"
  cp "$TARGET" "$CACHE_TARGET"
  loop=1
  while [[ $loop -gt 0 ]]; do
    main_menu || (( loop=loop-1 ))
  done
  sleep 1
  printf 'Good-bye...\n'
  sleep 1
}

main
unset CURRENT_DARK_THEME CURRENT_LIGHT_THEME THEME_SET
