#!/bin/sh
set -eu
if ! [ -f $HOME/.gnupg/gpg-agent.conf ]; then
    mkdir -p $HOME/.gnupg
    touch $HOME/.gnupg/gpg-agent.conf
fi
if ! [ -d $HOME/.local/share/gnupg ]; then
    mkdir -p $HOME/.local/share/gnupg
    chmod 700 $HOME/.local/share/gnupg
fi
git restore --staged private || :
tar cvf private.tar.gz ./private
rm private.tar.gz.gpg || :
gpg -c private.tar.gz
git add private.tar.gz.gpg
git commit -m "x private archive"
rm private.tar.gz
