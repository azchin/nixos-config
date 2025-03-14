#!/usr/bin/env bash
node="nixpkgs"
unix_time=$(yq ".nodes.$node.locked.lastModified" flake.lock)
today=$(date +%s)
time_diff=$(($today - $unix_time))
days_diff=$(echo "$time_diff / 86400" | bc)
echo -n "$node last modified "
date -d @"$unix_time"
echo "Last updated $days_diff days ago"
