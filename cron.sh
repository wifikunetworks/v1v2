0 * * * * /sbin/free.sh >/dev/null 2>&1
0 * * * * /usr/bin/autotimesync.sh
*/5 * * * * /www/vnstati/vnstati.sh >/dev/null 2>&1
0 */2 * * * echo "AT+CMGD=1,4" | atinout - "/dev/ttyACM2" -
0 3 * * * /sbin/reboot
