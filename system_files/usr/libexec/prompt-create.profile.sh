#!/bin/bash

# if dconf doesn't exist, just return
if ! command -v dconf >/dev/null; then
    return
fi

# shellcheck disable=SC2001
gen_uuid() {
	uuid="$(cat /proc/sys/kernel/random/uuid)"
	echo "$uuid" | sed 's/-//g'
}

guid=$(gen_uuid)
name="$1"

profile="/org/gnome/Prompt/Profiles/${guid}/"

dconf write "${profile}custom-command" "'sh -c \"[ ! -e /run/.containerenv ] && [ ! -e /run/.dockerenv ] && distrobox enter ${name} || ${SHELL}\"'"
dconf write "${profile}label" "'${name}'"
dconf write "${profile}login-shell" "true"
dconf write "${profile}use-custom-command" "true"

/usr/libexec/prompt-add-profile.sh "$guid"
