#!/usr/bin/env python3.10

# Edits kitty's imported colorscheme depending on the time of day it is

import sys
import os

light_theme = os.getenv("LIGHT_THEME")
dark_theme = os.getenv("DARK_THEME")

light_variant = os.getenv("LIGHT_VARIANT")
dark_variant = os.getenv("DARK_VARIANT")


def get_content(input_file):
    readable_file = open(input_file, "r")
    string_list = readable_file.readlines()
    readable_file.close()
    return string_list


def write_content(strings, output_file):
    writable_file = open(output_file, "w")
    new_file = "".join(strings)
    writable_file.write(new_file)
    writable_file.close()


def change_tty_theme(theme, variant):
    zdotdir = "/Users/me/.config/zsh"
    zsh_config = f"{zdotdir}/.zshrc"

    zsh_theme = f"{zdotdir}/themes/{theme}/{variant}.sh"
    zshrc_content = get_content(zsh_config)
    zshrc_content.pop(65)
    zshrc_content.insert(65, f"source {zsh_theme}\n")
    write_content(zshrc_content, zsh_config)


def change_kitty_theme(theme, variant):
    kitty_config_dir = "/Users/me/.config/kitty"
    kitty_config = f"{kitty_config_dir}/kitty.conf"
    kitty_theme_dir = f"{kitty_config_dir}/themes"
    if variant is None:
        kitty_theme = f"{kitty_theme_dir}/{theme}.conf"
    else:
        kitty_theme = f"{kitty_theme_dir}/{theme}_{variant}.conf"

    kitty_content = get_content(kitty_config)
    kitty_content[2183] = f"include {kitty_theme}"
    write_content(kitty_content, kitty_config)


def change_nvim_theme(theme, variant):
    lua_dir = "/Users/me/.config/nvim/lua/user"
    nvim_theme = f"{lua_dir}/themes/current_theme.lua"
    nvim_content = get_content(nvim_theme)
    nvim_content.pop(2)
    nvim_content.pop(2)
    nvim_content.insert(2, f'M.main = "{theme}"\n')
    if light_variant is None:
        nvim_content.insert(2, "M.variant = dark\n")
    else:
        nvim_content.insert(2, f'M.variant = "{variant}"\n')

    write_content(nvim_content, nvim_theme)


if sys.argv[1] == "day":
    change_kitty_theme(light_theme, light_variant)
    change_nvim_theme(light_theme, light_variant)
    # change_tty_theme(light_theme, light_variant)


if sys.argv[1] == "night":
    change_kitty_theme(dark_theme, dark_variant)
    change_nvim_theme(dark_theme, dark_variant)
    # change_tty_theme(dark_theme, dark_variant)
