#!/usr/bin/lua

local kitty = "kitty --hold --class='passwords' zsh -c '"
local gpg = "/usr/bin/gpg -d -q /home/me/.local/share/passwords/"

local options = {
    ["Outlook"] = kitty .. gpg .. "outlook.pgp'",
    ["Spotify"] = kitty .. "echo \"q26el34rgdc638l3ps3dih7f2\" && " .. gpg .. "spotify-q26el34rgdc638l3ps3dih7f2.pgp'"
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
        "printf '"
            .. options_string
            .. "' | wofi "
            .. "--dmenu --insensitive --prompt 'Passwords' --style ~/.config/wofi/style.css\n",
        "r"
    )
)
local s = assert(f:read("*a"))
s = string.gsub(s, "^%s+", "")
s = string.gsub(s, "%s+$", "")
s = string.gsub(s, "[\n]+", " ")
f:close()

os.execute(options[s])
