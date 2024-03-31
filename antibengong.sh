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
    echo "$(date +"%A %d %B %Y %T")  Status: $1 > Ping $2" >> /usr/bin/antibengong/log.txt
}

# Main function to perform health check
health_check() {
    while true; do
        if ping -q -w 1 -c 1 "http://www.gstatic.com/generate_204" > /dev/null; then
            echo "$(date +"%A %d %B %Y %T")  Status: ONLINE > Ping $(ping -q -w 1 -c 1 "http://www.gstatic.com/generate_204" | grep -oP '(?<=time=)[0-9]+')" 
            log_check_result "ONLINE" "$(ping -q -w 1 -c 1 "http://www.gstatic.com/generate_204" | grep -oP '(?<=time=)[0-9]+')ms"
        else
            echo "$(date +"%A %d %B %Y %T")  Status: OFFLINE > Ping Failed" 
            log_check_result "OFFLINE" "Failed"
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
