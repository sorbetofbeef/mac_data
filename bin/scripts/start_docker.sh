#!/bin/bash

declare -a DOCKER_PIDS

_open_docker ()
{
  read -Ar DOCKER_PIDS "$(pgrep -d ' ' Docker)"
  if [ -n "${DOCKER_PIDS[1]}" ]; then
    return 0
  else
    if open -a Docker ; then
      wait "$!"
      return 0
    else
      return 0
    fi
  fi
  return 0
}

main ()
{
  _open_docker
  wait "$!"
  sleep 60
  exec lazydocker
}

main
