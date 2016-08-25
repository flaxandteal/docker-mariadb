#!/usr/bin/env bash

# if the /data/mariadb directory doesn't contain anything, then initialise it
directory="/data/mariadb/."
mkdir -p $directory

if [ ! "$(ls -A $directory)" ]; then
  chown -R mysql:mysql $directory
fi

su -s '/bin/bash' -c '/opt/bin/mariadb-start.sh' mysql
