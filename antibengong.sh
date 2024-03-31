#!/bin/bash

# Lokasi file log
LOG_FILE="/usr/bin/bengong.txt"

# URL untuk memeriksa kesehatan proxy
HEALTH_CHECK_URL="http://www.gstatic.com/generate_204"

# Jumlah pengecekan yang diperlukan untuk mengambil keputusan
NUM_CHECKS=$((60 / 3))  # 1 menit / 3 detik

# Waktu antara setiap pengecekan (dalam detik)
CHECK_INTERVAL=3

# Waktu untuk menunggu sebelum memutuskan bahwa proxy tidak sehat (dalam detik)
HEALTH_CHECK_TIMEOUT=3

# Waktu yang dibutuhkan untuk merestart modem setelah tidak ada respon (dalam detik)
RESTART_TIMEOUT=$((60))  # 1 menit

# Port untuk mengirim perintah ke modem
MODEM_PORT="/dev/ttyACM2"

# Fungsi untuk memasukkan log
log() {
    echo "$(date +'%A %H:%M:%S %d-%m-%Y') $1" >> $LOG_FILE
}

# Fungsi untuk merestart modem
restart_modem() {
    log "Restarting modem..."
    # Mengirim perintah restart ke modem melalui port
    echo -e "at+cfun=1,1\r" > $MODEM_PORT
    # Tunggu sejenak untuk memastikan modem telah merespon kembali
    sleep 10
}

# Fungsi untuk melakukan pengecekan kesehatan proxy
check_health() {
    local http_code
    local status
    local offline_count=0
    local offline_threshold=$((RESTART_TIMEOUT / HEALTH_CHECK_TIMEOUT))
    for ((i = 0; i < $NUM_CHECKS; i++)); do
        http_code=$(curl --silent --max-time $HEALTH_CHECK_TIMEOUT --head $HEALTH_CHECK_URL | grep "HTTP/" | awk '{print $2}')
        if [[ "$http_code" == "204" ]]; then
            status="ONLINE"
            log "Status: $status > Ping 204"
            offline_count=0
        else
            status="OFFLINE"
            log "Status: $status > Ping HTTP Failed"
            ((offline_count++))
            if (( offline_count >= offline_threshold )); then
                restart_modem
                log "Modem restarted"
                offline_count=0
            fi
        fi
        sleep $CHECK_INTERVAL
    done
}

# Memanggil fungsi untuk melakukan pengecekan kesehatan proxy
check_health
