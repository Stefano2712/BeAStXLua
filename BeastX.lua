-- BEASTX.Lua by BEASTX - DEVTeam
-- (c) freakware GmbH 2025
-- v0.4.0
local device = {
    name = {"MICROBEAST", "MBPLUS", "AR7200BX", "MBULTRA", "AR7210BX", "", "Nanobeast"},
    hardware = 0,
    eeprom = 0,
    firmwaremajor = 0,
    firmwareminor = 0,
    firmwarepatch = 0,
    tailgain = 0,
    rescuegain = 0,
    bank = 0
}

local menus = {{
    name = "RX settings",
    items = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"}    
}, {
    name = "Basic setup",
    items = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"}
}, {
    name = "Parameters",
    items = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"}
}, {
    name = "Governor",
    items = {"A", "B", "C", "D", "E"}
}}

local menutext = {
    -- RX settings (some points are not accessible when using telemetry connection!)
    {
        {
            desc = " ",        
            hint = " "
        },
        {
            desc = "Thrust channel",        
            hint = "Move thrust stick"
        },
        {
            desc = "Roll channel",        
            hint = "Move roll stick"
        },
        {
            desc = "Pitch channel",        
            hint = "Move pitch stick"
        },
        {
            desc = "Rudder channel",        
            hint = "Move rudder stick"
        },
        {
            desc = "Gyro channel",        
            hint = "Move gyro channel"
        },
        {
            desc = "Motor channel",        
            hint = "Move motor channel"
        },
        {
            desc = "Aux channel",        
            hint = "Move aux channel"
        },
        {
            desc = "Gov channel",        
            hint = "Move gov channel"
        },
        {
            desc = "Rescue channel",        
            hint = "Move rescue channel"
        },
        {
            desc = " ",         
            hint = " "
        },
        {
            desc = " ",         
            hint = " "
        },
        {
            desc = "Telemetry input",         
            hint = "Tap rudder stick"
        },
        {
            desc = "Throttle F/S",         
            hint = "Move motor channel"
        }
    },

    -- Basic setup
    {
        {
            desc = "Device orientation",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Swash framerate",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Rudder pulse width",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Rudder framerate",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Rudder limit",        
            hint = "Use rudder to adjust"
        },
        {
            desc = "Rudder direction",        
            hint = "Tap roll to invert"
        },
        {
            desc = "Swash type",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Servo direction",        
            hint = "Use rudder and roll"
        },
        {
            desc = "Control direction",        
            hint = "Tap rudder stick"
        },
        {  
            desc = "Servo subtrim",        
            hint = "Use rudder and roll"
        },
        {  
            desc = "Swash throw",
            hint = "Use rudder and roll"
        },
        {  
            desc = "Collective pitch",
            hint = "Use rudder and roll"
        },
        {  
            desc = "Servo limit",
            hint = "Use rudder to adjust"
        },
        {  
            desc = "Motor control",
            hint = "Tap rudder stick"
        },
    },

    -- Parameter setup
    {
        {
            desc = "Swashplate trim",        
            hint = "Move sticks to trim"
        },
        {
            desc = "Control style",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Horizontal stability",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Gyro lock stability",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Stick deadband",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Rudder mix",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Pitch pump",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Cyclic acceleration",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Gov gain",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Gov soft start",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Gov acceleration",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Rescue mode",        
            hint = "Tap rudder stick"
        },
        {
            desc = "Rescue hover pitch",        
            hint = "Use rudder to adjust"
        }
    },

    -- Governor setup
    {
        {
            desc = "Sensor test",        
            hint = " "
        },
        {
            desc = "Start position",        
            hint = "Move throttle"
        },
        {
            desc = "Maximum position",
            hint = "Move throttle"
        },
        {
            desc = "Throttle curve",
            hint = "Move throttle"
        },
        {
            desc = "Signal divider",        
            hint = "Tap rudder stick"
        }
        -- add gear ratio setting points F,G,H or by direct adjustment
    }
}

local Command = {
    CMDReset = 0x00,
    CMDGetSystemInfo = 0x01,
    CMDGetEEPAddrbyID = 0x02,
    CMDReadEEP = 0x03,
    CMDWriteEEP = 0x04,
    CMDSetEEPRam = 0x05,
    CMDCopyEEP2Ram = 0x06,
    CMDMenuControl = 0x07,      
    CMDGetFFTData = 0x08,
    CMDGetLogData = 0x09,
    CMDDebug = 0x0a,
    CMDPcConnect = 0x0b,
    CMDSentError = 0x0f
    }

local MenuControl = {
    MCtrl_EnterMenu = 0x00,
    MCtrl_GetStatus = 0x01,      
    MCtrl_ItemControl = 0x02,
    MCtrl_GetPreset = 0x03,
    MCtrl_SetPreset = 0x04,
    MCtrl_ResetMenu = 0x05      
    }

-- local lastCommand = Commands.NONE 
local last_ping_time = 0

-- Statusvariablen
local current_menu = nil
local selected_item = 1
local edit_mode = false

local display_main_message = true
local selected_menu_index = 1

local forwardMsg = "Waiting for device..."

--- Use Parameter Write command 0x2D
--- u8 to (Flightcontrol 0xC8)
--- u8 from (TX 0xEA)
--- u8 packet number (1)
--- data
local function sendPing()    
    local payload = {0xC8, 0xEA, 1, Command.CMDGetSystemInfo}

    crossfireTelemetryPush(0x2D, payload)
    return true
end

local function sendGetMenuStatus()
    local payload = {0xC8, 0xEA, 1, Command.CMDMenuControl, MenuControl.MCtrl_GetStatus}

    crossfireTelemetryPush(0x2D, payload)
    return true
end

local function sendEnterMenu(menu, step)
    if step == nil or step == 0 then
        step = 1
    end

    step = step - 1

    local payload = {0xC8, 0xEA, 1, Command.CMDMenuControl, MenuControl.MCtrl_EnterMenu, menu, step}

    crossfireTelemetryPush(0x2D, payload)
    return true
end

function toSigned16(value)
    if bit32.band(value, 0x8000) ~= 0 then
        return value - 0x10000
    else
        return value
    end
end

local function handleTelemetry()
    local command, data = crossfireTelemetryPop()

    if command == 0x29 and data ~= nil then
        if data[1] == Command.CMDGetSystemInfo then
            device.hardware = tonumber(data[3])
            device.eeprom = tonumber(data[2])
            device.firmwaremajor = tonumber(data[4])
            device.firmwareminor = tonumber(data[5])
            device.firmwarepatch = tonumber(data[6])
            device.tailgain = toSigned16(bit32.lshift(data[7], 8) + data[8])
            device.rescuegain = toSigned16(bit32.lshift(data[9], 8) + data[10])
            device.bank = tonumber(data[11])
        end

        if data[1] == Command.CMDMenuControl and data[2] == MenuControl.MCtrl_GetStatus and data[3] ~= 0 then
            if (data[4]) ~= selected_item then
                if current_menu ~= 4 then
                    selected_item = data[4]
                else
                    selected_item = data[4] - 14
                end
            end
            forwardMsg = ""
            for i, v in ipairs(data) do
                if i > 4 then
                    forwardMsg = forwardMsg .. string.char(v)
                end
            end
        elseif data[3] == 0 then
            current_menu = nil
        end        
    end
end

local function drawMainScreen()
    gaintext = " "
    rescuetext = " "

    if device.tailgain > 0 then
        gaintext = " HL"
    elseif device.tailgain < 0 then
        gaintext = " RT"
    end

    if device.rescuegain > 0 then
        rescuetext = " ON"
    end

    if device.hardware ~= 0 then
        lcd.drawText(5, 5, device.name[device.hardware], 0)
        lcd.drawText(5, 15, "v" .. device.firmwaremajor .. "." .. device.firmwareminor .. "." .. device.firmwarepatch, 0)
        lcd.drawText(5, 30, "Gain: " .. device.tailgain .. gaintext, 0)
        lcd.drawText(5, 40, "Rescue: " .. device.rescuegain .. rescuetext, 0)
        lcd.drawText(5, 50, "Bank: " .. device.bank, 0)
        lcd.drawText(100, 50, " --> ", INVERS)
    else
        lcd.drawText(5, 5,  "BEASTX Lua!", 0)
        lcd.drawText(5, 15, "Connecting...", 0)
    end
end

local function drawMenuList()
    for i, menu in ipairs(menus) do
        local mode = (i == selected_menu_index) and INVERS or 0
        lcd.drawText(5, -5 + (i * 10), menu.name, mode)
    end
    lcd.drawText(5, 0 + (#menus + 1) * 10, "EXIT", (selected_menu_index == #menus + 1) and INVERS or 0)
end

-- only list one menu item after another
local function drawSubmenuItem()
        for i, item in ipairs(menus[current_menu].items) do
            if (i == selected_item) then            
                lcd.drawText(5, 5, menus[current_menu].name .. " - " .. item, 0)
                lcd.drawText(5, 15, menutext[current_menu][i].desc, 0)
                lcd.drawText(5, 27, forwardMsg, 0)
                lcd.drawText(5, 45, menutext[current_menu][i].hint, 0)
            end
        end
end

local function handleEvent(event)    
    -- main screen
    if display_main_message then
        if event == EVT_VIRTUAL_ENTER and device.hardware ~= 0 then
            display_main_message = false
        end

    -- Menu screen
    elseif current_menu == nil then
        if event == EVT_VIRTUAL_INC then
            selected_menu_index = (selected_menu_index % (#menus + 1)) + 1
        elseif event == EVT_VIRTUAL_DEC then
            selected_menu_index = (selected_menu_index - 2) % (#menus + 1) + 1
        elseif event == EVT_VIRTUAL_ENTER then            
            if selected_menu_index > #menus then
                display_main_message = true
            else
                -- open first menu point of selected menu                
                current_menu = selected_menu_index
                if (current_menu == 1) then -- RX menu starts with point 'B'!
                    selected_item = 2
                else                    
                    selected_item = 1                
                end

                sendEnterMenu(selected_menu_index, selected_item)
            end
        elseif event == EVT_VIRTUAL_MENU then
            display_main_message = true
        end
    
    -- Menu open
    else
        if event == EVT_VIRTUAL_ENTER then
            -- Next ....
            nextitem = selected_item + 1
            if nextitem > #menus[current_menu].items then                
                sendEnterMenu(0)
                current_menu = nil                
            else
                sendEnterMenu(current_menu, nextitem)
            end
        elseif event == EVT_VIRTUAL_MENU then
            nextitem = selected_item - 1
            if nextitem == 0 then
                sendEnterMenu(0)
                current_menu = nil
            else
                sendEnterMenu(current_menu, nextitem)
            end
        end        
    end
end

local function run(event)
    lcd.clear()
    
    handleEvent(event)
    if display_main_message then
        drawMainScreen()
    elseif current_menu == nil then
        drawMenuList()
    else
        drawSubmenuItem()
    end

    -- PING device every 200ms to get status and keep menu open
    local now = getTime()    
    if now - last_ping_time > 20 then
        --local success = false
        if current_menu == nil then
          sendPing()        
        else
          sendGetMenuStatus()
        end

        --if success then -- for DEBUG removed!!
            last_ping_time = now
        --end
    end

    handleTelemetry()
    return 0
end

return {
    run = run
}
