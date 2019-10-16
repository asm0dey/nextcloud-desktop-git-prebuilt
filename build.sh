#!/bin/bash -x

DOCKER="$(docker run -e "MAKEFLAGS=-j2" -v "$(pwd)"/cache:/home/builder/.ccache -v "$(pwd)"/nextcloud:/home/builder/pkg -d makepkg bash -c 'cd ~/pkg && makepkg -As --noconfirm')"

TIME_TO_RUN=43
while test "$TIME_TO_RUN" -gt 0; do
    sleep 60
    echo Not sleeping!
    TIME_TO_RUN=$((TIME_TO_RUN-1))
    if (! (docker ps -q --no-trunc| grep "$DOCKER" > /dev/null)); then
        break
    fi
    docker logs --tail=50 "$DOCKER"
done

if (docker ps -q -a --no-trunc| grep "$DOCKER" > /dev/null); then
    echo Last Logs
    docker logs --tail=50 "$DOCKER"
    docker stop --time 3 "$DOCKER"
fi
test "$(find "$(pwd)"/nextcloud -name '*.tar.xz' | wc -l)" -gt 0 || exit 1

