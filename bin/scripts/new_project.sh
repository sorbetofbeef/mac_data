#!/usr/bin/env bash

source /Users/me/.config/environment.d/source/colors.sh

greet ()
{
  printf '%s+--------------------+\n|*  \ \ \ || / / /  *|\n|** CREATE PROJECT **|\n|***  *  *  *  *  ***|\n+--------------------+\n\n\n%s' "$CYAN" "$NC"

}

main () 
{
  greet
  return 3
}

main || ( printf '%sERRORS\nReturn Code: %s%s\n\n' "$RED" "$?" "$NC"  && exit "$?" )
