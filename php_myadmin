#!/bin/bash

# script to install and start phpmyadmin service
#
# checks if phpmyadmin package is installed
PMA=$(dpkg-query -W -f='${status}' phpmyadmin 2>/dev/null | grep -c 'ok installed')

# if phpmyadmin is not installed
if [ $PMA -eq 0 ]; then
	# installs phpmyadmin
	echo -e "\nInstallingpackage phpmyadmin\n"
	apt install phpmyadmin -y
	echo -e "\nphpmyadmin package has been installed\n"
# if phpmyadmin is installed
elif [ $PMA -eq 1 ]; then
	# shows phpmyadmin status
	echo -e "\nphpmyadmin package has already been installed\n"
fi
