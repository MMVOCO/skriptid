#!/bin/bash

# script to install latest php package and extensions
#
# checks if php package is installed
PHP=$(dpkg-query -W -f='${status}' php 2>/dev/null | grep -c 'ok installed')

# if php is not installed
if [ $PHP -eq 0 ]; then
	# installs php and dependencies
	echo -e "\nInstallingpackage php libapache2-mod-php php-mysql\n"
	apt install php libapache2-mod-php php-mysql -y
	echo -e "\nphp package has been installed\n"
# if php is installed
elif [ $PHP -eq 1 ]; then
	# shows php version ja asukohta
	echo -e "\nphp package has already been installed\n"
	which php
	php -v
fi
