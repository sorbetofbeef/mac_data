#!/usr/bin/env python3.10

# Edits kitty's imported colorscheme depending on the time of day it is

import sys

kitty_config_dir = "/Users/me/.config/kitty"
kitty_config = f"{kitty_config_dir}/kitty.conf"
kitty_theme_dir = f"{kitty_config_dir}/themes"
kitty_theme_light = f"{kitty_theme_dir}/dayfox.conf"
kitty_theme_dark = f"{kitty_theme_dir}/nightfox_kitty.conf"

nvim_theme_config = "/Users/me/.config/nvim/lua/user/colorscheme.lua"
nvim_theme_light = "dayfox"
nvim_theme_dark = "carbonfox"



def get_content(input_file):
    readable_file = open(input_file, 'r')
    string_list = readable_file.readlines()
    readable_file.close()
    return string_list

def write_content(strings, output_file):
    writable_file = open(output_file, 'w')
    new_file = "".join(strings)
    writable_file.write(new_file)
    writable_file.close()

if sys.argv[1] == "day":
    kitty_content = get_content(kitty_config)
    kitty_content[2183] = f"include {kitty_theme_light}"
    write_content(kitty_content, kitty_config)

    nvim_content = get_content(nvim_theme_config)
    nvim_content[0] = f"local colorscheme = \"{nvim_theme_light}\""
    write_content(nvim_content, nvim_theme_config)

if sys.argv[1] == "night":
    kitty_content = get_content(kitty_config)
    kitty_content[2183] = f"include {kitty_theme_dark}"
    write_content(kitty_content, kitty_config)

    nvim_content = get_content(nvim_theme_config)
    nvim_content.insert(1, f"local colorscheme = \"{nvim_theme_dark}\"")
    nvim_content.pop(0)
    write_content(nvim_content, nvim_theme_config)
