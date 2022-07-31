#!/usr/bin/env bash

pkill wofi || /home/me/.local/bin/scripts/wofi-pass.lua "$@"
