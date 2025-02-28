# BeAStXLua

OpenTX Lua Script for BEASTX RC Flight Control (Microbeast PLUS/Ultra and Nanobeast).
Script is communicating with BEASTX FBL system using the CRSF Telemetry protocol. Please make sure to use a compatible telemetry firmware version 5.9.11 or above. 


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


## Code
code description will be added soon ...
