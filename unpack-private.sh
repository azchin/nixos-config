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
rm -r private-old || :
cp -r private private-old || :
gpg -d private.tar.gz.gpg > private.tar.gz
tar xvf private.tar.gz
diff -r private-old private
rm -r private-old private.tar.gz
