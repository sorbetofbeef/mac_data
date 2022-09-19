#!/usr/bin/env zsh

zparseopts -D -E -F -M -A opts -- -target: -temp-basedir T=-temp-basedir || {
	echo "Usage: qutebrowser [--target <target>] [--temp-basedir | -T] [<url or command> [<url or command> [...]]]"
	return 1
}

if (( ! ${+opts[--temp-basedir]} )); then
	print -l ${(qqq)@} |
		jq -cs '{args:.,target_arg:$target,version:$ver,protocol_version:$proto_ver,cwd:$cwd}' \
			--arg target ${opts[--target]:-auto} --arg cwd $PWD \
			--arg ver 1.0.4 --arg proto_ver 1 |
		socat - UNIX-CONNECT:${XDG_RUNTIME_DIR}/qutebrowser/ipc-${$(print -n $USER | md5sum)::1} ||
	/usr/local/bin/qutebrowser ${opts[--target]:+--target=$opts[--target]} --untrusted-args "$@" &
else
	/usr/local/bin/qutebrowser -T ${opts[--target]:+--target=$opts[--target]} --untrusted-args "$@"
fi    
