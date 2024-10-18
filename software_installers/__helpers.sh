#!/bin/sh

ghRepoCloneLatestRelease ()
{
    [[ ${1} =~ / ]] &&
        wget -qO- https://github.com/${1}/$(curl -s https://github.com/${1}/releases |
            grep -m1 -Eo "archive/refs/tags/[^/]+\.tar\.gz") |
                tar --strip-components=1 -xzv >/dev/null
}
