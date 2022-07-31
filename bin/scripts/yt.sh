printf '%s\n' $(pbpaste) | dmenu-mac | xargs -o /Applications/MacPorts/WezTerm.app/Contents/MacOS/wezterm-gui start -- yt-dlp
