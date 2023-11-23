# BeaconBurst
Script en Bash el cual simplifica y automatiza la inyección de paquetes Beacon en una red inalámbrica, de cara a realizar el ataque Beacon Flooding Attack en redes WPA-WPA2 (PSK)

## Requisitos
1. Asegúrate de tener la suite de Aircrack-ng instalada, sino instala con el siguiente comando:
```
sudo apt-get install -y aircrack-ng
```
2. Asegúrate de tener permisos root para la ejecución del script.
```
id -u
```
4. Asegurate de tener la tarjeta de red en modo monitor. Sino es así el script lo hará en su defecto
```
iwconfig
```

## Uso

1. Clona el repositorio o en su defecto descarga el script beaconburst.sh
```
git clone https://github.com/0xJuaNc4/BeaconBurst.git
```
2. Cambia al directorio del script.
```
cd BeaconBurst
```
3. Otorga permisos de ejecución al script.
```
chmod +x beaconburst.sh
```
