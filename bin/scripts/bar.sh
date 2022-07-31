#!/bin/bash

pidof -q waybar && kill "$(pidof waybar)"
exec waybar
