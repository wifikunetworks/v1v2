#!/bin/bash

# Lokasi file log
LOG_FILE="/usr/bin/bengong.txt"

# URL untuk memeriksa kesehatan proxy
HEALTH_CHECK_URL="http://www.gstatic.com/generate_204"

# Waktu antara setiap pengecekan (dalam detik)
CHECK_INTERVAL=3

# Waktu yang dibutuhkan untuk merestart modem setelah tidak ada respon (dalam detik)
RESTART_TIMEOUT=$((60))  # 1 menit

# Jumlah ping yang gagal yang harus dilalui sebelum merestart modem dan interface
PING_FAILURE_THRESHOLD=$((RESTART_TIMEOUT / CHECK_INTERVAL))

# Port untuk mengirim perintah ke modem
MODEM_PORT="/dev/ttyACM2"

# Nama interface yang ingin di-restart
INTERFACE="mm"

# Fungsi untuk memasukkan log
log() {
    echo "$(date +'%A %H:%M:%S %d-%m-%Y') $1" >> $LOG_FILE
}

# Fungsi untuk merestart modem dan interface
restart_modem_and_interface() {
    log "Restarting modem and interface..."
    # Merestart modem
    echo -e "at+cfun=1,1\r" > $MODEM_PORT
    # Merestart interface
    ifdown $INTERFACE && ifup $INTERFACE
    # Tunggu sejenak untuk memastikan modem telah merespon kembali
    sleep 10
}

# Fungsi untuk melakukan pengecekan kesehatan proxy
check_health() {
    local http_code
    local status
    local ping_failure_count=0
    while true; do
        http_code=$(curl --silent --max-time 10 --head $HEALTH_CHECK_URL | grep "HTTP/" | awk '{print $2}')
        if [[ "$http_code" == "204" ]]; then
            status="ONLINE"
            log "Status: $status > Ping 204"
            ping_failure_count=0
        else
            status="OFFLINE"
            log "Status: $status > Ping HTTP Failed"
            ((ping_failure_count++))
            if (( ping_failure_count >= PING_FAILURE_THRESHOLD )); then
                restart_modem_and_interface
                log "Modem and interface restarted"
                ping_failure_count=0
            fi
        fi
        sleep $CHECK_INTERVAL
    done
}

# Memanggil fungsi untuk melakukan pengecekan kesehatan proxy
check_health
