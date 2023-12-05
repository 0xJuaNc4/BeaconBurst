# BeaconBurst

<div align="center">
  <img src="https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/76c5b11a-c98d-4429-9ef6-3a2f1692330d" width="160px">
</div>

<br>

Bash script that automates the Beacon Flooding attack on WiFi networks. The attack is carried out using the mdk3 tool and is implemented with the aim of flooding the attacked network with fake Beacon frames, causing outages and possible denial of service (DoS) effects.

## Requirements

1. Root permissions for the execution of the script.
2. Network card in monitor mode.
3. Necessary tools installed: (iw, airmon-ng, airodump-ng, mdk3, xterm).


## Uso

1. Clone the repository or otherwise download the beaconburst.sh script.
```
git clone https://github.com/0xJuaNc4/BeaconBurst
```
2. Change to the script directory.
```
cd BeaconBurst
```
3. Set execution permissions to the script.
```
chmod +x beaconburst.sh
```
4. Before running the script, make sure that your wireless network interface is set to monitor mode.
```
airmon-ng start <interfaz>
```
5. Execute the script with root permissions.
```
sudo ./beaconburst.sh
```
