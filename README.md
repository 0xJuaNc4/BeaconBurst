# BeaconBurst
Script en Bash que automatiza el ataque Beacon Flooding en redes WiFi. El ataque se lleva a cabo utilizando la herramienta mdk3 y se implementa con el objetivo de realizar un DoS en la red objetivo.

## Requisitos

1. Permisos root para la ejecución del script.
2. Tarjeta de red en modo monitor.
3. Herramientas necesarias instaladas: (iw, airmon-ng, airodump-ng, mdk3, xterm)


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
4. Antes de ejecutar el script, asegúrate de que tu interfaz de red inalámbrica esté configurada en modo monitor.
```
airmon-ng start <interfaz>
```
5. Ejecuta el script con permisos de superusuario (root)
```
sudo ./beaconburst.sh
```
