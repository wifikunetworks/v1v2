#!/bin/sh

# File crontab yang akan diubah
CRON_FILE="/etc/crontabs/root"

# Isi baru dari crontab
CRON_CONTENT="0 * * * * /sbin/free.sh >/dev/null 2>&1
0 * * * * /usr/bin/autotimesync.sh
*/5 * * * * /www/vnstati/vnstati.sh >/dev/null 2>&1
0 2 * * * echo "AT+CMGD=1,4" | atinout - "/dev/ttyACM2" -
0 3 * * * /sbin/reboot"

# Mengganti isi file crontab
echo "$CRON_CONTENT" > "$CRON_FILE"

# Reload crontab untuk mengaplikasikan perubahan
/etc/init.d/cron restart
