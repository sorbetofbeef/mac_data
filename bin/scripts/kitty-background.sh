#!/usr/bin/env bash

index="$(shuf -i 1-$(\ls ~/media/pics/kitty-pics | wc -w) -n 1 )"
pic="$(\ls -1 ~/media/pics/kitty-pics/ | bat -p -r ${index}:${index})"
target=/home/me/media/pics/kitty-pics/${pic}
KITTY_LISTEN_ON=unix:@mykitty
# sed -i -e "/window_logo_path/ c window_logo_path $target" ~/.config/kitty/kitty.conf

kitty -1 -o window_logo_path=$target
unset index pic target

