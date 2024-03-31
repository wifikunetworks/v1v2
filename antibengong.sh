#!/bin/bash

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

# Fungsi untuk memeriksa kesehatan proxy
check_health() {
    local healthy_count=0
    for ((i = 0; i < $NUM_CHECKS; i++)); do
        if curl --silent --max-time $HEALTH_CHECK_TIMEOUT --head $HEALTH_CHECK_URL | grep "HTTP/1.1 204 No Content" > /dev/null; then
            healthy_count=$((healthy_count + 1))
        fi
        sleep $CHECK_INTERVAL
    done
    if [ $healthy_count -lt $NUM_CHECKS ]; then
        return 1
    else
        return 0
    fi
}

# Fungsi untuk merestart modem
restart_modem() {
    echo "Restarting modem..."
    # Mengirim perintah restart ke modem melalui port
    echo -e "at+cfun=1,1\r" > $MODEM_PORT
}

# Pemanggilan fungsi untuk memeriksa kesehatan proxy
if ! check_health; then
    echo "Proxy tidak sehat. Akan memeriksa ulang setelah $RESTART_TIMEOUT detik."
    sleep $RESTART_TIMEOUT
    if ! check_health; then
        echo "Proxy masih tidak sehat setelah restart. Akan merestart modem."
        restart_modem
    else
        echo "Proxy kembali sehat setelah restart."
    fi
else
    echo "Proxy sehat."
fi
