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
HEALTH_CHECK_TIMEOUT=10

# Waktu yang dibutuhkan untuk merestart modem setelah tidak ada respon (dalam detik)
RESTART_TIMEOUT=$((60 * 1))  # 1 menit

# Port untuk mengirim perintah ke modem
MODEM_PORT="/dev/ttyACM2"

# Fungsi untuk memasukkan log
log() {
    echo "$(date +'%A %H:%M:%S %d-%m-%Y') Status: $1 > Ping $2" >> $LOG_FILE
}

# Fungsi untuk memeriksa kesehatan proxy
check_health() {
    local ping_result
    local status
    for ((i = 0; i < $NUM_CHECKS; i++)); do
        ping_result=$(ping -c 1 $HEALTH_CHECK_URL | grep "bytes from" | awk '{print $8}' | cut -d "=" -f 2)
        if [[ -n "$ping_result" ]]; then
            status="ONLINE"
            log "$status" "$ping_result ms"
        else
            status="OFFLINE"
            log "$status" "Ping Failed"
        fi
        sleep $CHECK_INTERVAL
    done
}

# Fungsi untuk merestart modem
restart_modem() {
    log "Restarting modem..." ""
    # Mengirim perintah restart ke modem melalui port
    echo -e "at+cfun=1,1\r" > $MODEM_PORT
}

# Pemanggilan fungsi untuk memeriksa kesehatan proxy
check_health

# Jika proxy masih OFFLINE setelah beberapa cek, restart modem
if grep -q "OFFLINE" "$LOG_FILE"; then
    restart_modem
fi
