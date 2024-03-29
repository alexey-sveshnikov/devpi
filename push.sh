#!/bin/sh
set -ex

if [ -z "$1" ]; then
    HOST='virtual'
else
    HOST=$1
fi

PACKAGE='devpi'

echo "Deploying to $HOST"

HOME=`ssh $HOST pwd`

pdebuild --buildresult .. --debbuildopts '-us -uc' \
&& ssh $HOST 'mkdir -p repo' \
&& ssh $HOST 'sudo sh -c "echo \"deb file:$HOME/repo /\" > /etc/apt/sources.list.d/local.list"' \
&& scp ../devpi_0.1-1_amd64.deb $HOST:repo \
&& ssh $HOST 'cd repo && dpkg-scanpackages . /dev/null | gzip -9 > Packages.gz' \
&& ssh $HOST 'sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/local.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"' \
&& ssh $HOST "sudo dpkg -P $PACKAGE; sudo apt-get install -y --force-yes $PACKAGE"
