#!/usr/bin/env bash

exec alacritty msg create-window "$@" || exec alacritty "$@"
