#!/bin/bash

# Function to restart modem
restart_modem() {
    echo "Restarting modem..."
    # Add your command to restart modem here
    # Example: at+cfun=1,1 > /dev/ttyACM2
}

# Function to restart modem interface
restart_modem_interface() {
    echo "Restarting modem interface..."
    # Add your command to restart modem interface here
    # Example: ifdown mm && ifup mm
}

# Function to log the check result
log_check_result() {
    echo "$(date +"%A %d %B %Y %T")  Status: $1 > HTTP Status Code: $2" >> /usr/bin/antibengong/log.txt
}

# Main function to perform health check
health_check() {
    while true; do
        response=$(curl -s -o /dev/null -w "%{http_code}" "http://www.gstatic.com/generate_204")
        if [ $response -eq 204 ]; then
            echo "$(date +"%A %d %B %Y %T")  Status: ONLINE > HTTP Status Code: $response" 
            log_check_result "ONLINE" "$response"
        else
            echo "$(date +"%A %d %B %Y %T")  Status: OFFLINE > HTTP Status Code: $response" 
            log_check_result "OFFLINE" "$response"
            restart_modem
            sleep 5
            restart_modem_interface
        fi
        sleep 3
    done
}

# Check if log file exists, if not create it
mkdir -p /usr/bin/antibengong
touch /usr/bin/antibengong/log.txt

# Start health check
health_check
