#!/bin/bash

workspace=/Users/me/Desktop
loop=true
show_loop=true

active="$workspace/active/*.todo"
completed="$workspace/completed/*.todo"
abandoned="$workspace/abandoned/*.todo"
in_active="${abandoned} ${completed}"

show_menu () {
  printf '\e[0m┏━━━━━━━━━━━━━━━━━━━┓ \n┃      SubMenu      ┃ \n┗━━━┳━━━━━━━━━━━━━┳━┻━━━━━━━━━━━┓\n    ┃  (a)ctive   ┃ (i)nactive  ┃   \n    ┣━━━━━━━━━━━━━╋━━━━━━━━━━━━━┫ \n    ┃ (c)ompleted ┃ a(b)andoned ┃  \n    ┣━━━━━━━━━━━━━╋━━━━━━━━━━━━━┫  \n    ┃   (q)uit    ┃  \n    ┗━━━━━━━━━━━━━┛ \n'
  read -r -n1 status
  printf '\n'

  case "$status" in
    a) 
      show "$active"
      next
      ;;
    i) 
      show "$in_active"
      next
      ;;
    c) 
      show "$completed"
      next
      ;;
    b) 
      show "$abandoned"
      next
      ;;
    q)
      clear
      echo "Quiting to menu..."
      show_loop=false
      return 0
      ;;
    *)
      clear
      echo "Invalid input..."
      ;;
  esac
  unset status
}

show () {
  status=$1
  i=0

  if [[ $status = "$in_active" ]] ; then
    f_status='In-Active'
  else
    f_status="${status%/*}"
    f_status="${f_status##*/}"
    # f_status="${f_status}"
  fi

  clear
  printf '\n\e[1;31;3m* TODO *\e[0m\n\n'
  printf '  \e[1;36m|>\e[0m \e[31;3m%s items\e[0m\n\n' "${f_status}"

  for f in $status; do
    i=$((i + 1))
    printf "      \e[36m[\e[0m \e[1;31;3mentry %s\e[0m \e[36m]\e[0m\n" $i
    bat --style grid --terminal-width 40 "$f"
  done 
  unset i f status
}

check_digit () {
  input=$1
  if [[ $input = [[:digit:]] ]]; then
    return 0
  else
    echo "Invalid Input"
    return 1
  fi
}

next () {
  printf '\n \e[1;32m*\e[0m \e[32mPress any key to continue..\e[0m \e[1;32m*\e[0m\n'
  read -r -n1 key
  [[ -n "$key" ]] && return 0
  return 0
}


create () {
  show "$active"
  prio=
  ret_val=1

  _priority_input () {
    prio=
    flags=(' ' ' ' ' ' ' ')
    while [[ $ret_val -eq 1 ]]; do
      printf '\nPriority[1-(4)]: ' ; read -r prio
    	case "$prio" in
    	 '1') flag_id=0; ret_val=0
    	 ;;
    	 '2') flag_id=1; ret_val=0
    	 ;;
    	 '3') flag_id=2; ret_val=0
    	 ;;
    	 '4') flag_id=3; ret_val=0
    	 ;;
    	 '') flag_id=3; prio='4'; ret_val=0
    	 ;;
    	 *) ret_val=1
    	 ;;
    	esac
    done
    unset ret_val
    
    # while [ "$ret_val" -eq 1 ]; do
    #   printf '\nPriority[1-(4)]: ' ; read -r prio
    #   if [[ -z $prio ]]; then
    #     ret_val="$?"
    #     prio=4
    #     flag_id=3
    #     return 0
    #   else
    #     if (check_digit "$prio" && [[ $prio -lt 4 ]]) ; then
    #       ret_val="$?"
    #       flag_id=$((prio - 1))
    #       return 0
    #     else
    #       printf ' \e[1;31m!\e[0m \e[1;31;3mInvalid Input\e[0m \e[1;31m!\e[0m'
    #       return 1
    #     fi
    #   fi
    # done
    # unset retval
  }

  _due_date_input () {
    printf '\n'
    cal
    printf '\n\nDue: ' ; read -r due

    due=${due//\.\-\,\/}
  }

  _title_input () {
    printf '\nTitle: ' ; read -ra title
    formatting="${title[*]//[\[\]\!:?@#$%^\&\*]}"
    formatting="${formatting[*]//[\ \-\.\,]/_}"
    formatting="${formatting[*]//____/_}"
    formatting="${formatting[*]//___/_}"
    formatting="${formatting[*]//__/_}"
    formatting="${formatting[*]//__/_}"
    f_title="${formatting[*],,}"

    unset formatting
  }

  printf '\nCategory: '; read -r category
  _title_input
  _priority_input
  _due_date_input
  printf '\nNotes: ' ; read -r notes

  # printf '> %s %s: %s\n|    Due: %s\n|    NOTES\n       %s ' "${flags[${flag_id}]}" "${category}" "${title[@]}" "${due}" "$notes" > ${active%/*}/${prio}0-$(date '+%m.%d')-${f_title[@]}.todo

  cat  > "${active%/*}/${prio}0-$(date '+%m.%d')-${f_title[*]}.todo" <<EOF
> ${flags[${flag_id}]} ${category}: ${title[@]}
|    Due: ${due}
|    NOTES
-      $notes
EOF

  show "$active"
  next
  unset flags category title prio due_date flag_id notes
}

edit () {
  i=0

  show "$active"
  printf "Entry: " ; read -r choice
  check_digit "$choice" || return 1
  for f in $active; do
    i=$((i + 1))
    [[ ! $choice = "$i" ]] && continue 
    [[ $choice = "$i" ]] && nvim "$f" 
  done

  show "$active"
  next
  unset i choice
}

remove_to () {
  target_dir=${1%/*}

  show "$active"
  printf "Entry: " ; read -r choice
  clear
  check_digit "$choice" || return 1
  _remove "$choice" "$target_dir"
  unset choice target_dir
}

_remove () {
  choice=$1
  target_dir=$2
  i=0

  for f in active/*.todo; do
    i=$((i + 1))
    [[ ! $choice = "$i" ]] && continue 
    [[ $choice = "$i" ]] && mv "$f" "${target_dir}"
    action=${target_dir#*/}
    name=${f##*/}
    name=${name##*-}
    name=${name//_/\ }
    echo "You ${action}: \"${name}\" on $(date '+%m.%d.%Y') at $(date '+%H:%M')"
    echo "${action}: $(date '+%m.%d.%Y %H:%M')" >> "${target_dir}/${f}"
    echo "${f%.todo}-$(date '+%m%d.%Y_%H:%M')" >> "${target_dir}/summary"
  done

  show "$target_dir/*.todo"
  next
  unset choice target_dir i f action name 
}

check () {
  while getopts "ns" opt ; do
    case ${opt} in 
      n ) new; exit 0 ;;
      s ) show ; exit 0 ;;
      \? ) echo "invalid option" ;;
    esac
  done
  unset opt
}

_menu_ui () {
  printf '\e[0m┏━━━━━━━━━━━━━━━━┓ \n┃   Main Menu    ┃ \n┗━━━┳━━━━━━━━━━┳━┻━━━━━━━━┓\n    ┃  (s)how  ┃ (f)inish ┃   \n    ┣━━━━━━━━━━╋━━━━━━━━━━┫ \n    ┃ (c)reate ┃ (d)elete ┃  \n    ┣━━━━━━━━━━╋━━━━━━━━━━┫  \n    ┃  (e)dit  ┃  (u)ndo  ┃  \n    ┣━━━━━━━━━━┫━━━━━━━━━━┛  \n    ┃  (q)uit  ┃  \n    ┗━━━━━━━━━━┛ \n'
}

main() {
  show "$active"
  _menu_ui
  read -r -n1 select
  printf '\n'
  
  case $select in 
    s ) # Show active todo items
      clear
      while $show_loop; do
        show_menu || show_loop=false
      done
      ;;
    c ) # Create a new todo item
      create
      ;;
    e ) # Edit a todo item
      edit 
      ;;
    f ) # Complete a todo item
      remove_to "$completed"
      ;;
    d ) # Abandon a todo item
      remove_to "$abandoned"
      ;;
    u ) # Undo an abandoned or completed todo item
      undo_from "$in_active"
      ;;
    q ) # Exits the program
      printf '\nQuiting... \n' 
      export loop=false
      ;;
    * ) clear ; printf '\nInvalid selection\n';;
  esac

  unset select
}

check "$@"
while $loop; do 
  pushd $workspace > /dev/null || return 1
  main || loop=false
  popd > /dev/null || return 1
done

unset active completed abandoned in_active loop workspace show_loop
