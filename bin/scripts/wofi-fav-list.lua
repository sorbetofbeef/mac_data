#!/usr/bin/lua
local options = {
    [" Firefox"] = "firefox",
    [" Spotify TUI"] = "kitty -1 start-spotify",
    [" Neovim IDE"] = "kitty -1 --working-directory '/home/me/github.com/sorbetofbeef' nvim --cmd ':cd /home/me/github.com/sorbetofbeef' -c ':NvimTreeOpen'",
    [" HTop"] = "kitty -1 htop",
    [" Neomutt"] = "kitty -1 neomutt",
    [" Configuration"] = "kitty -1 --working-directory '/home/me/.config' nvim --cmd ':cd /home/me/.config' -c ':NvimTreeOpen'",
    [" Data Files"] = "kitty -1 --working-directory '/home/me/.local' nvim --cmd ':cd /home/me/.local' -c ':NvimTreeOpen'",
    [" Font Manager"] = "font-manager",
    [" Files"] = "kitty -1 lf",
    [" Super HTop"] = "kitty -1 sudo htop",
    [" Super Configuration"] = "kitty -1 --working-directory '/usr' sudo nvim --cmd ':cd /etc' -c ':Lexplore'",
    [" Super Data Files"] = "kitty -1 --working-directory '/etc' sudo nvim --cmd ':cd /usr' -c ':Lexplore'",
    [" System Files"] = "kitty -1 sudo lf",
}

local options_string = ""
local length = 0
for key, _ in pairs(options) do
    options_string = options_string .. key .. "\n"
    length = length + 1
end
options_string = options_string:sub(1, -2)

local f = assert(
    io.popen(
        "echo -e '"
            .. options_string
            .. "' | wofi "
            .. "--dmenu --insensitive --prompt 'dmenu' --style ~/.config/wofi/style.css",
        "r"
    )
)
local s = assert(f:read("*a"))
s = string.gsub(s, "^%s+", "")
s = string.gsub(s, "%s+$", "")
s = string.gsub(s, "[\n]+", " ")
f:close()

os.execute(options[s])
