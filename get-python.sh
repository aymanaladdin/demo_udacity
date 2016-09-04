#!/bin/bash
# Copyright (c) 2015, Patrick Jahns <projects@patrickjahns.de>
# Licensed under 3-clause BSD.

DEB_REQUIREMENTS=(
    "libsqlite3-0"
    "libssl1.0.0"
    "libexpat1"
    "libffi6"
)

DEB_BUILD_REQUIREMENTS=(
    "wget"
    "build-essential"
    "libsqlite3-dev"
    "libreadline-dev"
    "libssl-dev"
    "zlib1g-dev"
    "libbz2-dev"
    "libncurses5-dev"
    "libffi-dev"
    "libexpat-dev"
)


#
# Install a given packages to the system.
#
# $@ - array of packages to be installed
#
function install_packages {
    apt-get update
    apt-get -y install "${@}"
}


#
# Install and configure the PyEnv tool.
#
function install_pyenv {
    wget https://github.com/yyuu/pyenv/archive/master.tar.gz
    tar -xzf master.tar.gz
    bash pyenv-master/plugins/python-build/install.sh
    rm -rf pyenv-master/master.tar.gz
}


install_packages "${DEB_REQUIREMENTS[@]}"
install_packages "${DEB_BUILD_REQUIREMENTS[@]}"
install_pyenv

while read pyversion
do
if [ ! -f "/tmp/script/dist/python-${pyversion}_x86_32.tar.gz" ]; then
	CFLAGS="-g -O2" python-build "$pyversion" "/tmp/python/$pyversion"
	if [[ -e /tmp/python/$pyversion ]]; then
		cd /tmp/python/$pyversion
		tar -czvf /tmp/script/dist/python-${pyversion}_x86_32.tar.gz *
       	fi
fi
done < /tmp/script/python-versions.txt
rm -rf pyenv-master
