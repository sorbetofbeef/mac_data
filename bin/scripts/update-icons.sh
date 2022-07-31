#!/bin/bash

target_dirs=/usr/share/icons

# update icon cache helper function
function update_all_icons {
  for dir in ${target_dirs}/*; do
    echo "Updating ${dir}..."
    gtk-update-icon-cache -t -f --include-image-data "${dir}" || exit 1
    echo "Finished with ${dir}."
  done
  sleep 1
  return
}

# main function
function main {
  echo "Starting icon cache updates..."
  sleep 1
  if update_all_icons; then
    echo "Updated all icons successfuly."
    sleep 1
  else
    echo "Failed to updat icons."
    sleep 2
    exit 1
  fi
  echo "Finished, good-bye."
  sleep 2
}

main || exit 1
