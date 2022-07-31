#!/bin/sh

program="$1"
tmp_dir="${XDG_CACHE_HOME}/tmp-alt"
io_file="${program}-alt.txt"

_clean_up () {
  rm -rf "${tmp_dir}"
  unset program
  unset io_file
  unset tmp_dir
}

error_out () {
  local msg="$1"
  [[ -z "$msg" ]] && msg="uknown error"
  printf "ERROR: %s. Cleaning up and aborting \n"  "$msg"
  _clean_up
  sleep 2
  exit 1
}

_check_exist () {
  [[ ! -d  "$tmp_dir" ]] && mkdir -p "$tmp_dir" 
  [[ -z "$(kiss a | rg -i $program)" ]] && error_out "$program does not exist"
  [[ ! -f "${tmp_dir}/${io_file}" ]] && touch "${tmp_dir}/${io_file}"
}

# user_check () {
#   read -r choice
#   if [[ "$choice" == "n" ]]; then
#     echo "Exiting"
#     sleep 2
#     exit 1
#   else
#     return 0
#   fi
#   error_out "how?"
# }

create () {
  echo "Populating list of alternates for ${program}..."
  sleep 2
  sudo kiss a | rg -i "${program}" > "${tmp_dir}/${io_file}" || error_out "create list of alternates failed"
  echo "Success!"
  return 0
}

run_kiss () {
  echo "Setting kiss to use ${program}..."
  while read -r line; do
    sudo kiss a $(echo $line) || error_out 'failed to read input file into "kiss a"'
  done < "${tmp_dir}/${io_file}"
  echo "Success!"
  return 0
}

main () {
  local arg="$1"

  echo "kiss-alternate script to run 'kiss a' on all available choices of a given program"
  _check_exist
  create || error_out "kiss alt failed to create"
  run_kiss || error_out "kiss alt failed to complete"
  _clean_up
}

main $program

