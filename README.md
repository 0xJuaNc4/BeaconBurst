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
## Usage example

Before starting the attack, a check is made to ensure that the tools necessary to carry out the attack are installed on the system.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/d32b00f3-5850-4ef6-8e3a-c74c3d9e1f5e)

The available wireless network interfaces are listed. You must select the interface that is already configured in monitor mode to carry out the attack.

<div align="center">
<img src="https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/beed607d-cbbd-46f5-9358-8f6bee2dca79)">  
</div>

It will check if the selected interface exists and is configured in monitor mode. If it is not, it will ask you to activate it before continuing.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/3295c275-0033-4adc-9627-8018e0f36362)

Once the interface is correctly configured and selected, the user will be prompted for confirmation to continue scanning for available WiFi networks.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/ba6decf3-be36-48fc-ada1-19516d5de35e)

A parallel terminal will open to perform the network scan. You can close this window or press `Ctrl+C` at any time to stop the scan.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/004a94dc-b63e-45f1-a16c-a6bbac280b1e)

Once the scan is finished, a table with the available networks will be displayed, including information such as BSSID, ESSID, Channel, you must select the target network.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/cb2ab0ca-4952-427a-b316-0f8a00425c86)

Once the network is selected, a dictionary for the attack will be created in the background.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/a5fb25cb-cb0c-4aee-8d1c-c452ce565b3e)

Once at this point, the attack will start automatically. To stop it, use `Ctrl + C`.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/563365ec-6fb9-4abb-9d54-d4ff2f981002)

You can use `airodump-ng` to verify attack activity by applying network and channel filters.

![image](https://github.com/0xJuaNc4/BeaconBurst/assets/130152767/9949a2d6-154a-44a8-acc0-d9cccbec744c)
