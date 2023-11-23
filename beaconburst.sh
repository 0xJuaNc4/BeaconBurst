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
    exit 0
}

# Comprobar configuraciones y herramientas esenciales
tools=("iwconfig" "airmon-ng" "airodump-ng" "mdk4")
interfaces=$(iw dev | grep Interface | awk '{print $2}')

checking() {
    echo -e "\n${CYAN}Comprobando instalación de herramientas esenciales${RESET}\n"
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo -e "$tool....${GREEN}Ok${RESET}"
        else
            echo -e "\n${RED}[!]${RESET} $tool no instalado, Instalala antes de continuar...\n"
            exit 1
        fi
        sleep 1
    done
    echo -e "\n${CYAN}Selecciona la interfaz de red inalámbrica con la que deseas trabajar (ingresa el número):${RESET}\n"
    # Personalizando el prompt de select
    PS3="> "
    select interface in $interfaces; do
    if [ -n "$interface" ]; then
        echo -e "\n${CYAN}[*]${RESET} Has seleccionado ${YELLOW}$interface${RESET}\n"
        break
    else
        echo -e "\n${RED}[!]${RESET}Opción no válida. Por favor, selecciona una interfaz\n"
    fi
    done
    # Comprobando modo monitor
    if ! iwconfig $interface | grep "Mode:Monitor" &> /dev/null; then
        echo -e "\n${RED}[*]${RESET} La interfaz ${YELLOW}${interface}${RESET} no se encuentra en modo monitor\n"
        echo -e "\n${CYAN}[*]${RESET} Activando modo monitor en la interfaz ${YELLOW}$interface${RESET}\n"
    else
        echo -e "\n${GREEN}[!]${RESET} La interfaz ${YELLOW}${interface}${RESET} se encuentra en modo monitor\n"
    fi
}


# Programa principal
if [ "$(id -u)" != "0" ]; then
    echo -e "\n${RED}[!]${RESET} Se requieren permisos de superusuario (root) para ejecutar el script\n"
else
    checking
fi
