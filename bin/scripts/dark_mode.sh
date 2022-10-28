#!/usr/bin/env bash
declare CURRENT_HOUR

mode=$1
all_hours=('00' '01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23')


switch()
{

  variant () 
  {
    has_variant=$1
    main_theme=$2
    variant=$3

    if [[ $TERM = "xterm-kitty" ]]; then
    if [[ $has_variant = false ]]; then
      kitty @ set-colors --all /Users/me/.config/kitty/themes/"$main_theme".conf
    else
      kitty @ set-colors --all /Users/me/.config/kitty/themes/"${main_theme}"_"$variant".conf
    fi
    fi
  }

  day_night=$1
  python3 /Users/me/.local/bin/scripts/darkmode.py "$day_night" &> /dev/null &

    case $day_night in
      'day' ) 
        if [[ ! $LIGHT_VARIANT ]]; then
          variant false "$LIGHT_THEME"
        else
          variant true "$LIGHT_THEME" "$LIGHT_VARIANT"
        fi
        return
        ;;

      'night' ) 
        if [[ ! $DARK_VARIANT ]]; then
          variant false "$DARK_THEME"
        else
          variant true "$DARK_THEME" "$DARK_VARIANT"
        fi
        return
        ;;

      * ) printf '\e[31mError: Unknown argument!\n\e[0m'
        exit
        ;;
    esac
}

if [[ ($mode = 'day') || ($mode = 'night') || (-z $mode) ]] ; then
  if [[ -z $mode ]]; then

    for h in {0..23}; do
      if [[ $(date '+%H') = "${all_hours[$h]}" ]]; then
        CURRENT_HOUR=$h
      fi
    done

    if [[ ($CURRENT_HOUR -lt 7) || ($CURRENT_HOUR -gt 18) ]]; then
      mode='night'
    else
      mode='day'
    fi
  fi
  switch "$mode"
else
  printf '\e[31mError: Argument must be null, night, or day\n\e[0m'
fi
