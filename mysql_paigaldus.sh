#!/bin/bash

# script to install latest mysql-server package and extensions
#
# checks if mysql-server package is installed
MYSQL=$(dpkg-query -W -f='${status}' mysql-server 2>/dev/null | grep -c 'ok installed')

# adds the ability to use mysql command without adding a user or password
# checks if the config file exists and if it doesn't creates it
if [ ! -e "$HOME/.my.cnf" ]; then
	touch $HOME/.my.cnf
	echo "[client]" >>$HOME/.mv.cnf
	echo "host = localhost" >>$HOME/.mv.cnf
	echo "user = root" >>$HOME/.mv.cnf
	echo "password = qwerty" >>$HOME/.mv.cnf
fi

# if mysql-server is not installed
if [ $MYSQL -eq 0 ]; then
	# installs mysql-server
	echo -e "\nInstalling package mysql-server\n"
	apt install mysql-server -y
	echo -e "\nmysql-server package has been installed\n"
# if mysql-server is installed
elif [ $MYSQL -eq 1 ]; then
	# shows mysql-server version ja asukohta
	echo -e "\nmysql-server package has already been installed\n"
	mysql
fi
