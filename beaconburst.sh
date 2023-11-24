#!/bin/bash
# Author: 0xJuaNc4

# Paleta de colores ANSI
GREEN="\e[0;92m"
RED="\e[0;91m"
YELLOW="\e[0;93m"
CYAN="\e[0;96m"
RESET="\e[0;97m"

# Limpiar consola
clear

# Función salir del script
trap ctrl_c INT
stty -ctlecho
function ctrl_c(){
    echo -e "\n${CYAN}[*]${RESET} Saliendo...\n"
    airmon-ng stop "$interface" && service wpa_supplicant start &> /dev/null
    exit 0
}

# Función panel de ayuda
help_panel() {
    echo -e "\n${CYAN}uso: ./beaconburst <interfaz>${RESET}\n"
    echo -e "${CYAN}ejemplo: ./beaconburst wlan0${RESET}\n"
}

# Variable nombre de la interfaz
interface=$1

# Comprobacion de herramienta y modo monitor antes de continuar
tools=("iwconfig" "airmon-ng" "airodump-ng" "mdk3" "xterm")

checking(){
    # Comprobar si la interfaz existe
    echo -e "\n${CYAN}[*]${RESET} Comprobando que la interfaz ${YELLOW}${interface}${RESET} existe...\n"
    sleep 1
    if ! ifconfig "$interface" > /dev/null 2>&1; then
        echo -e "\n${RED}[!]${RESET} La interfaz ${YELLOW}${interface}${RESET} no existe\n"
        exit 1
    else
        echo -e "\n${GREEN}[!]${RESET} La interfaz ${YELLOW}${interface}${RESET} existe, continuando...\n"
    fi
    # Comprobar modo monitor
    echo -e "\n${CYAN}Comprobando modo monitor en ${YELLOW}${interface}${RESET}\n"
    sleep 1
    if ! iwconfig $interface | grep "Mode:Monitor" > /dev/null 2>&1; then
        echo -e "\n${RED}[*]${RESET} La interfaz ${YELLOW}${interface}${RESET} no se encuentra en modo monitor\n"
        echo -e "\n${CYAN}[*]${RESET} Activando modo monitor en la interfaz ${YELLOW}$interface${RESET}\n"
        if ! airmon-ng start "$interface" > /dev/null 2>&1; then
            echo -e "\n${RED}[!]${RESET} Error al activar el modo monitor en ${YELLOW}${interface}${RESET}\n"
            exit 1
        else
            echo -e "\n${GREEN}[*]${RESET} Modo monitor ${GREEN}activado${RESET} en la interfaz ${YELLOW}${interface}${RESET}, continuando...\n"
        fi
    else
        echo -e "\n${GREEN}[!]${RESET} La interfaz ${YELLOW}${interface}${RESET} se encuentra en modo monitor, continuando...\n"
    fi
    sleep 1
    # Comprobar herramientas
    echo -e "\n${CYAN}Comprobando instalación de herramientas esenciales${RESET}\n"
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo -e "$tool....${GREEN}ok${RESET}"
        else
            echo -e "$tool....${RED}no${RESET}"
            echo -e "\n${RED}[!]${RESET} La herramienta ${YELLOW}$tool${RESET} no se encuentra instalada, instala antes de continuar...\n"
            exit 1
        fi
        sleep 1
    done
}

# Escaneo de la red con la herramienta airodump-ng
net_scan(){
    echo -e "\n${CYAN}[*]${RESET} ¿Quieres proceder con el escaneo de la red? ${YELLOW}(s/n)${RESET}:\n"
    read -p "# " start_scan
    if [[ "${start_scan,,}" == "s" ]]; then
        echo -e "\nhola\n"
    else
        echo -e "\n${RED}[!] Saliendo...${RESET}\n"
        exit 0
    fi
}

# Programa principal
if [ "$(id -u)" == "0" ]; then
    if [[ $# -eq 1 ]]; then
        checking
        net_scan
    else
        help_panel
        exit 1
    fi
else
    echo -e "\n${RED}[!]${RESET} Se requieren permisos de superusuario ${RED}(root)${RESET} para ejecutar el script\n"
    exit 1
fi
