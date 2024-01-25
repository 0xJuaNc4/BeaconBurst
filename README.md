# BeaconBurst

<div align="center">
  <img src="https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/76c5b11a-c98d-4429-9ef6-3a2f1692330d" width="160px">
</div>

<br>

Script en Bash que automatiza el ataque Beacon Flooding a redes WiFi. El ataque se lleva a cabo utilizando la herramienta mdk3 y se implementa con el objetivo de inundar la red atacada con tramas Beacon falsas, provocando cortes y posibles efectos de denegación de servicio (DoS).

## Requisitos

1. Permisos de root para la ejecución del script.
2. Tarjeta de red en modo monitor.
3. Herramientas necesarias instaladas: (iw, airmon-ng, airodump-ng, mdk3, xterm).


## Uso

1. Clona el repositorio o descarga el script beaconburst.sh.

```
git clone https://github.com/0xJuaNc4/BeaconBurst
```

2. Cambia al directorio del script.

```
cd BeaconBurst
```

3. Establece permisos de ejecución para el script.

```
chmod +x beaconburst.sh
```

4. Antes de ejecutar el script, asegúrate de que tu interfaz de red inalámbrica está configurada en modo monitor.

```
airmon-ng start <interfaz>
```

5. Ejecuta el script con permisos de root.

```
sudo ./beaconburst.sh
```
