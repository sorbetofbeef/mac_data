#!/usr/bin/env bash

pkill wofi || wofi --show run "$@"
