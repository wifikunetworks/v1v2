#!/bin/bash

# Lokasi file log
LOG_FILE="/usr/bin/bengong.txt"

# URL untuk memeriksa kesehatan proxy
HEALTH_CHECK_URL="http://www.gstatic.com/generate_204"

# Waktu untuk menunggu sebelum memutuskan bahwa proxy tidak sehat (dalam detik)
HEALTH_CHECK_TIMEOUT=3

# Waktu yang dibutuhkan untuk merestart modem setelah tidak ada respon (dalam detik)
RESTART_TIMEOUT=$((60))  # 1 menit

# Port untuk mengirim perintah ke modem
MODEM_PORT="/dev/ttyACM2"

# Fungsi untuk memasukkan log
log() {
    echo "$(date +'%A %H:%M:%S %d-%m-%Y') Status: $1 > Ping $2" >> $LOG_FILE
}

# Fungsi untuk merestart modem
restart_modem() {
    log "Restarting modem..." ""
    # Mengirim perintah restart ke modem melalui port
    echo -e "at+cfun=1,1\r" > $MODEM_PORT
}

# Fungsi untuk melakukan pengecekan kesehatan proxy
check_health() {
    local http_code
    local status
    local offline_count=0
    while true; do
        http_code=$(curl --silent --max-time $HEALTH_CHECK_TIMEOUT --head $HEALTH_CHECK_URL | grep "HTTP/" | awk '{print $2}')
        if [[ "$http_code" == "204" ]]; then
            status="ONLINE"
            log "$status" "204"
            offline_count=0
        else
            status="OFFLINE"
            log "$status" "HTTP Failed"
            ((offline_count++))
            if (( offline_count >= RESTART_TIMEOUT / HEALTH_CHECK_TIMEOUT )); then
                restart_modem
                offline_count=0
            fi
        fi
        sleep $HEALTH_CHECK_TIMEOUT
    done
}

# Memanggil fungsi untuk melakukan pengecekan kesehatan proxy
check_health
