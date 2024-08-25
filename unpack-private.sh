#!/bin/sh
set -eu
rm -r private-old || :
cp -r private private-old
gpg -d private.tar.gz.gpg > private.tar.gz
tar xvf private.tar.gz
diff -r private-old private
rm -r private-old private.tar.gz
