PART 1
~~~
# INSTALL AUTO TIME SYNC
opkg update && wget --no-check-certificate "https://raw.githubusercontent.com/wifikunetworks/v1v2/main/autotimesync.sh" -O /usr/bin/autotimesync.sh && chmod +x /usr/bin/autotimesync.sh

# INSTALL SPEEDTEST
opkg remove --force-remove luci-app-speedtest ; rm /usr/bin/speedtest ; wget --no-check-certificate -P /root https://github.com/animegasan/luci-app-speedtest/releases/download/v1.3/luci-app-speedtest_1.3_all.ipk && opkg install --force-reinstall /root/luci-*-speedtest*.ipk && rm /root/*.ipk

# INSTALL TAILSCALE
wget --no-check-certificate -P /root https://github.com/wifikunetworks/v1v2/raw/main/luci-app-tailscale_1.0.5_all.ipk && opkg install --force-overwrite /root/luci-*-tailscale*.ipk && rm /root/*.ipk

# INSTALL PING MONITOR
wget --no-check-certificate -N -P /www/ping-monitor/ https://raw.githubusercontent.com/wifikunetworks/ping-monitor/main/ping.sh && chmod +x /www/ping-monitor/ping.sh 

# INSTALL INTERNET DETECTOR
opkg remove --force-removal-of-dependent-packages internet-detector && rm /etc/config/internet-detector ; wget --no-check-certificate -O /tmp/internet-detector_1.3-0_all.ipk https://github.com/wifikunetworks/luci-app-internet-detector/raw/master/internet-detector_1.3-0_all.ipk && opkg install /tmp/internet-detector_1.3-0_all.ipk && rm /tmp/internet-detector_1.3-0_all.ipk && /etc/init.d/internet-detector start && /etc/init.d/internet-detector enable && wget --no-check-certificate -O /tmp/luci-app-internet-detector_1.3-0_all.ipk https://github.com/wifikunetworks/luci-app-internet-detector/raw/master/luci-app-internet-detector_1.3-0_all.ipk && opkg install /tmp/luci-app-internet-detector_1.3-0_all.ipk && rm /tmp/luci-app-internet-detector_1.3-0_all.ipk && /etc/init.d/rpcd restart && wget --no-check-certificate -O /tmp/internet-detector-mod-modem-restart_1.3-0_all.ipk https://github.com/wifikunetworks/luci-app-internet-detector/raw/master/internet-detector-mod-modem-restart_1.3-0_all.ipk && opkg install /tmp/internet-detector-mod-modem-restart_1.3-0_all.ipk && rm /tmp/internet-detector-mod-modem-restart_1.3-0_all.ipk && /etc/init.d/internet-detector restart

# INSTALL CONNECTION MONITOR
opkg remove --force-remove luci-app-lite-watchdog && rm /etc/modem/log.txt ; wget --no-check-certificate -P /root https://raw.githubusercontent.com/wifikunetworks/v1v2/main/luci-app-lite-watchdog_1.0.13-20231207_all.ipk && opkg install --force-reinstall /root/luci-*-watchdog*.ipk && rm /root/*.ipk

# INSTALL ZEROTIER
opkg remove --force-remove luci-app-zerotier ; opkg remove --force-remove zerotier ; rm /etc/config/zerotier ; wget --no-check-certificate -P /root https://raw.githubusercontent.com/wifikunetworks/v1v2/main/luci-app-zerotier_git-23.137.55137-42dce6a_all.ipk && opkg install --force-reinstall /root/luci-*-zerotier*.ipk && rm /root/*.ipk

# INSTALL SMS TOOL
opkg remove --force-remove luci-app-sms-tool-js && rm /etc/config/sms_tool_js ; wget --no-check-certificate -P /root https://raw.githubusercontent.com/wifikunetworks/v1v2/main/luci-app-sms-tool-js_2.0.20-20240201_all.ipk && opkg install --force-reinstall /root/luci-*-sms*.ipk && rm /root/*.ipk
~~~

PART 2
~~~
wget --no-check-certificate -O /etc/profile.d/30-sysinfo.sh https://raw.githubusercontent.com/wifikunetworks/v1v2/main/30-sysinfo.sh
wget --no-check-certificate -O /tmp/sysinfo/model https://raw.githubusercontent.com/wifikunetworks/v1v2/main/model
wget --no-check-certificate -O /etc/banner https://raw.githubusercontent.com/wifikunetworks/v1v2/main/banner
wget --no-check-certificate -O /etc/config/ttyd https://raw.githubusercontent.com/wifikunetworks/v1v2/main/ttyd
wget --no-check-certificate -O /etc/config/tinyfilemanager https://raw.githubusercontent.com/wifikunetworks/v1v2/main/tinyfilemanager
wget --no-check-certificate -O /etc/config/system https://raw.githubusercontent.com/wifikunetworks/v1v2/main/system
wget --no-check-certificate -O /etc/config/wireless https://raw.githubusercontent.com/wifikunetworks/v1v2/main/wireless
wget --no-check-certificate -O /etc/config/network https://raw.githubusercontent.com/wifikunetworks/v1v2/main/network
wget --no-check-certificate -O /etc/config/firewall https://raw.githubusercontent.com/wifikunetworks/v1v2/main/firewall
wget --no-check-certificate -O /etc/config/sms_tool_js https://raw.githubusercontent.com/wifikunetworks/v1v2/main/sms_tool_js
wget --no-check-certificate -O /etc/config/internet-detector https://raw.githubusercontent.com/wifikunetworks/v1v2/main/internet-detector
wget --no-check-certificate -O /etc/modem/atcommands.user https://raw.githubusercontent.com/wifikunetworks/v1v2/main/atcommands.user
wget --no-check-certificate -O /etc/modem/atcmmds.user https://raw.githubusercontent.com/wifikunetworks/v1v2/main/atcmmds.user
wget --no-check-certificate -O /etc/config/atcmds.user https://raw.githubusercontent.com/wifikunetworks/v1v2/main/atcmds.user
wget --no-check-certificate -O /www/luci-static/material/brand.png https://raw.githubusercontent.com/wifikunetworks/v1v2/main/brand.png
wget --no-check-certificate -O /www/luci-static/argon/brand.png https://raw.githubusercontent.com/wifikunetworks/v1v2/main/brand.png
wget --no-check-certificate -O /etc/rc.local https://raw.githubusercontent.com/wifikunetworks/v1v2/main/rc.local
wget --no-check-certificate -O /etc/crontabs/root https://raw.githubusercontent.com/wifikunetworks/v1v2/main/root
wget --no-check-certificate -O /usr/bin/bled https://raw.githubusercontent.com/wifikunetworks/v1v2/main/bled && chmod +x /usr/bin/bled
wget --no-check-certificate -O - https://raw.githubusercontent.com/wifikunetworks/v1v2/main/navbar.tar | tar -xf - -C /www/luci-static/argon/
wget --no-check-certificate -O /usr/lib/lua/luci/view/themes/argon/footer_login.htm https://raw.githubusercontent.com/wifikunetworks/v1v2/main/footer_login.htm
wget --no-check-certificate -O /usr/lib/lua/luci/view/themes/argon/footer.htm https://raw.githubusercontent.com/wifikunetworks/v1v2/main/footer.htm
wget --no-check-certificate -O /usr/lib/lua/luci/view/themes/argon/header.htm https://raw.githubusercontent.com/wifikunetworks/v1v2/main/header.htm
wget --no-check-certificate -O /usr/bin/lite_watchdog.sh https://raw.githubusercontent.com/wifikunetworks/v1v2/main/lite_watchdog.sh && chmod +x /usr/bin/lite_watchdog.sh
wget --no-check-certificate -O /www/cron.sh https://raw.githubusercontent.com/wifikunetworks/v1v2/main/cron.sh && chmod +x /www/cron.sh 

wget --no-check-certificate -O /etc/netdata/netdata.conf https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/netdata.conf
wget --no-check-certificate -O /etc/config/vnstat https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/vnstat
wget --no-check-certificate -O /etc/vnstat.conf https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/vnstat.conf
wget --no-check-certificate -N -P /usr/lib/lua/luci/controller https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/netmon.lua
wget --no-check-certificate -N -P /usr/lib/lua/luci/view/ https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/netmon.htm
wget --no-check-certificate -N -P /www https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/netdata.html
wget --no-check-certificate -N -P /www/vnstati https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/index.html
wget --no-check-certificate -N -P /www/vnstati https://raw.githubusercontent.com/wifikunetworks/netmonitor/main/vnstati.sh && chmod +x /www/vnstati/vnstati.sh
service vnstat restart
/www/vnstati/vnstati.sh
~~~
