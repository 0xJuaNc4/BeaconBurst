# BeaconBurst

<div align="center">
  <img src="https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/76c5b11a-c98d-4429-9ef6-3a2f1692330d" width="160px">
</div>

<br>

Script en Bash que automatiza el ataque Beacon Flooding en redes WiFi. El ataque se lleva a cabo utilizando la herramienta mdk3 y se implementa con el objetivo de inundar la red atacada con frames Beacon falsos, causando interrupciones y posibles efectos de denegación de servicio (DoS).

## Requisitos

1. Permisos root para la ejecución del script.
2. Tarjeta de red en modo monitor.
3. Herramientas necesarias instaladas: (iw, airmon-ng, airodump-ng, mdk3, xterm)


## Uso

1. Clona el repositorio o en su defecto descarga el script beaconburst.sh
```
git clone https://github.com/0xJuaNc4/BeaconBurst
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
## Ejemplo de uso

Antes de iniciar el ataque, se realiza una comprobación para asegurarse de que las herramientas necesarias para llevar el ataque acabo estén instaladas en el sistema.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/d32b00f3-5850-4ef6-8e3a-c74c3d9e1f5e)

Se procede a listar las interfaces de red inalámbricas disponibles. Deberás seleccionar la interfaz que ya esté configurará previamente en modo monitor para llevar a cabo el ataque.

<div align="center">
<img src="https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/beed607d-cbbd-46f5-9358-8f6bee2dca79)">  
</div>

Verificará si la interfaz seleccionada existe y está configurada en modo monitor. Si no lo está, te pedirá que la actives antes de continuar.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/3295c275-0033-4adc-9627-8018e0f36362)

Una vez que la interfaz esté configurada y seleccionada correctamente, se solicitará una confirmación al usuario para continuar con el escaneo de redes WiFi disponibles.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/ba6decf3-be36-48fc-ada1-19516d5de35e)

Se abrirá una terminal paralela para realizar el escaneo de redes. Puedes cerrar esta ventana o pulsar `Ctrl+C` en cualquier momento para detener el escaneo.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/004a94dc-b63e-45f1-a16c-a6bbac280b1e)

Una vez finalizado el escaneo, se mostrará una tabla con las redes disponibles, incluyendo información como BSSID, ESSID, Canal, debes seleccionar la red objetivo

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/cb2ab0ca-4952-427a-b316-0f8a00425c86)

Una vez seleccionada la red se creará en segundo plano un diccionario para el ataque.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/a5fb25cb-cb0c-4aee-8d1c-c452ce565b3e)

Una vez en este punto, el ataque comenzará automáticamente. Para detenerlo, utilizamos `Ctrl + C`.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/563365ec-6fb9-4abb-9d54-d4ff2f981002)

Puedes usar `airodump-ng` para verificar la actividad del ataque aplicando filtros de red y canal.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/9949a2d6-154a-44a8-acc0-d9cccbec744c)
