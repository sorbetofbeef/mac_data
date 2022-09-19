#!/usr/bin/env bash

exec open -na Alacritty --args msg create-window "$@" || exec open -na Alacritty "$@"
