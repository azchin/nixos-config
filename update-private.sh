#!/bin/sh
set -eu
git restore --staged private || :
tar cvf private.tar.gz ./private
rm private.tar.gz.gpg || :
gpg -c private.tar.gz
git add private.tar.gz.gpg
git commit -m "x private archive"
rm private.tar.gz
git add private
