# BeAStXLua

OpenTX Lua Script for BEASTX RC Flight Control (Microbeast PLUS/Ultra and Nanobeast). The BEASTX.Lua script is designed to interact with BEASTX flight controllers via OpenTX-compatible radio transmitters. It provides a graphical user interface for configuring various device settings, including receiver parameters, basic setup options, flight parameters, and governor settings. The script communicates with the flight controller through the Crossfire telemetry protocol.

This script is still under development. Contributions and feedback are welcome!


## Installation
* Copy 'BeastX.lua' file your OpenTX/EdgeTX radio's file system. Recommended folder is /SCRIPTS/TOOLS/.
* Connect TX line of ELRS / CRSF receiver with DI1 port of MICROBEAST/nanobeast.
* Connect RX line of ELRS / CRSF receiver with SYS port of MICROBEAST/nanobeast.
* Make sure to set MICROBEAST/nanobeast to CRSF receiver type.
* When MICROBEAST/nanobeast is in operation mode start 'Beastx' script on radio (usualy long press menu button once to enter TOOLS menu)


## Usage
* Main screen shows "Connecting..." message while script is tring to communicate with MICROBEAST/nanobeast. Once it has read informations from flight control it will show version information. (TODO: add device status, i.e. gain, rescue, banks).
* Press 'Enter' to access menu selection and choose menu as needed.
* You can navigate through menu steps pressing 'Enter' or 'Back' buttons. To change values and interact in menus use sticks on the radio. You will see hints which sticks to use at the bottom of each menu screen.
* After last menu step (or when stepping back from first menu item) you will get back to main screen.
* If leaving lua script completely, MICROBEAST/nanobeast will exit menu automatically after a second. 

## Code structure
- **Device Information Handling**:
  - The `device` table stores details about the connected BEASTX device.
- **Menu System**:
  - The `menus` table defines available configuration categories.
  - The `menutext` table provides descriptions and hints for menu items.
- **Command Definitions**:
  - The `Command` table contains constants for various control commands sent to the flight controller.
  - The `MenuControl` table defines commands specific to the menu navigation system.
- **Functions**:
  - `sendPing()`: Sends a status request to the flight controller. The script continuously sends periodic `ping` messages to maintain an active connection.
  - `sendGetMenuStatus()`: Requests the current menu status from the device.
  - `sendEnterMenu(menu, step)`: Opens a specific menu and step within the configuration system.
  - `handleTelemetry()`: Processes incoming telemetry data (response to commands) from the BEASTX device.
  - `drawMainScreen()`: Displays the main device status screen.
  - `drawMenuList()`: Displays the list of available configuration menus.
  - `drawSubmenuItem()`: Shows details for a selected menu item.
  - `handleEvent(event)`: Handles user input events for navigation and selection.
  - `run(event)`: Main loop function responsible for rendering the UI and managing communication with the device.

## Notes
- This is an early version (`v0.1.0`) and some menu descriptions still need to be completed.
- The script relies on the **Crossfire telemetry protocol**, so it requires a compatible radio system. We use the extended commands 0x29 and 0x2D as mentioned in CRSF documentation (https://github.com/crsf-wg/crsf/wiki/Packet-Types). Here the script is sending 0x2D (write command) to BEASTX flight control and system answers with 0x29 (device info).
