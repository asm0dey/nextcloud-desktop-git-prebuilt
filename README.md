# arch-kodi-devel-builder [![Build Status](https://travis-ci.org/asm0dey/kodi-devel-prebuilt.svg?branch=master)](https://travis-ci.org/asm0dey/kodi-devel-prebuilt)

## About

This repository holds everything necessary for building [kodi-devel](https://aur.archlinux.org/pkgbase/kodi-devel/) into binary packages, installable on linux.

## Releases

You can find releases in unofficial user repository, which is listed on [Unofficial user repositories list](https://wiki.archlinux.org/index.php/Unofficial_user_repositories#kodi-devel-prebuilt)

## How does it work

1. `Dockerfile`: This is simple `Dockerfile` which install everything necessary to build virtually any arch package, but with several special things: it also installs ccache which will save binary build caches of kodi. After installation it creates user `builder`, which has rights to call `pacman` as root without entering password (which is necessary to install dependencies in docker)
2. `build.sh`: This is main file, which is responsible for process of building itself. It calls docker with mounted directories for ccache and kodi sources. It runs no longer then 43 minutes, printing 50 last lines of build log every minute.
3. `.travis.yml`: Does lots of things (as any CI descriptor I think):
   1. Builds image from scratch every build (which makes sense because we always build on latest Arch)
   2. Clones AUR repo to folder named `kodi`
   3. Applies any custom patch I want to be applied to build itself. Currently no. File names should start with `0000*`
   4. Runs `build.sh`
   5. Creates directory `dist/x86_64` for being released as part of repo
   6. Moves all build `*.tar.xz` files to this directory
   7. Regenerates repository with help of `repo-add` which is also installed in those `Docker` image
   8. Publishes to `Releases` page on tags and to [gh-pages](https://github.com/asm0dey/kodi-devel-prebuilt/tree/gh-pages) branch on tags and on any successfully built build from [master](https://github.com/asm0dey/kodi-devel-prebuilt/tree/master) branch
4. `gh-pages` branch is configured to be a github pages (quite obviously) source which holds binaries.