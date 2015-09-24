#!/bin/bash

set -xe

DEBIAN_CODE_NAME=`lsb_release -sc`

if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get update
	apt-get install -y apt-transport-https
fi

case $DEBIAN_CODE_NAME in
    wheezy|jessie)
        echo "deb http://http.debian.net/debian ${DEBIAN_CODE_NAME}-backports main" > /etc/apt/sources.list.d/${DEBIAN_CODE_NAME}-backports.list
        ;;
    *)
        echo "WARNING: dokku-deb-al works best on Debain, you probably use something different than jessie or wheezy"
        ;;
esac

wget -qO- https://get.docker.com/gpg | sudo apt-key add -
wget -qO- https://get.docker.com/ | sh

apt-get update -y
wget http://debian.netbrick.cz/debian.netbrick.cz.gpg.key -O - | apt-key add -
echo deb http://debian.netbrick.cz/ jessie main > /etc/apt/sources.list.d/netbrick.list

if [[ -t 0 ]]; then
	apt-get install -y dokku-alt ruby ruby-sinatra
else
	unset UCF_FORCE_CONFFOLD
	export UCF_FORCE_CONFFNEW=YES
	apt-get install -o Dpkg::Options::="--force-confnew" --yes --force-yes dokku-alt ruby ruby-sinatra
fi

set +xe

case $DEBIAN_CODE_NAME in
    wheezy|jessie)
    	echo
	    echo "OK: You made right decision - Debian"
        echo "deb http://http.debian.net/debian ${DEBIAN_CODE_NAME}-backports main" > /etc/apt/sources.list.d/${DEBIAN_CODE_NAME}-backports.list
        ;;
    *)
        echo
        echo "WARNING: dokku-deb-al works best on Debain"
        ;;
esac

echo
echo "Almost done!"
echo "Open now web browser pointing to http://$(hostname):2000/ to finish configuartion."
echo "For manual installation instructions press Ctrl-C and visit https://github.com/dokku-alt/dokku-alt."
echo

ruby /usr/local/share/dokku-alt/contrib/dokku-installer.rb
