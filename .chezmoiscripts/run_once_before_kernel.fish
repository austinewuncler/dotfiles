#!/usr/bin/env fish

if string match --quiet "*surface*" (uname --kernel-release)
	exit 0
end

set --local KEY "56C464BAAC421453"

if not sudo pacman-key --finger "$KEY" &> /dev/null
	curl --silent "https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc"\
		| sudo pacman-key --add -
	sudo pacman-key --finger "$KEY"
end

sudo pacman-key --lsign-key "$KEY"

set --local LINUX_SURFACE_REPO_NAME "linux-surface"
set --local PACMAN_CONF_FILE "/etc/pacman.conf"

if not grep --quiet --extended-regexp "^\[$LINUX_SURFACE_REPO_NAME\]" "$PACMAN_CONF_FILE"
	printf "
[%s]
Server = https://pkg.surfacelinux.com/arch/
"\
	"$LINUX_SURFACE_REPO_NAME"\
	| sudo tee --append "$PACMAN_CONF_FILE" > /dev/null
end
