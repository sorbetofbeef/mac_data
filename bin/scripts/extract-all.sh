#!/bin/bash

mode="$1"
dir="$2"

function check_args {
  if [ -z "$mode" ] || [ -z "$dir" ]; then
    echo "You must specify a mode, and then a directory without extension as arguements"
    exit 1
  fi
  return
}

function archive {
  [[ ! -d ./.backup ]] && mkdir -p ./.backup
  mv ./${dir}/*."${mode}" ./${dir}/.backup || exit 1
  echo "Moving all ${mode} files to ./.backup"
  return
}

function un_tar {
  echo "Beginning to extract tarballs"
  for i in "$dir"/*.tar*; do
    echo "untarring ${i}..."
    sleep 1
    tar -C "$dir" -xf "${i}"
    echo "${i} untarred."
    sleep 1
  done
  echo "Finished extracting tarballs"
  return
}

function un_zip {
  echo "Beginning to extract zipped files"
  for i in "$dir"/*.zip; do
    echo "unzipping ${i}..."
    sleep 1
    unzip "${i}"
    echo "${i} unzipped."
    sleep 1
  done
  echo "Finished extracting zipped files"
  return
}

function main {
  check_args || exit 1
  case $mode in
    tar ) un_tar || exit 1
      ;;
    zip ) un_zip || exit 1
      ;;
    * ) echo "Unable to extract ${mode} files"
      exit 1
      ;;
  esac
  archive || exit 1
  return
}

main || exit 1
