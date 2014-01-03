#
# Regular cron jobs for the devpi package
#
0 4	* * *	root	[ -x /usr/bin/devpi_maintenance ] && /usr/bin/devpi_maintenance
