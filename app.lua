--
-- BOOT: CONNECT TO NETWORK
--
-- Step 1 - connect to the network
local sta_network_name = "julia"
local sta_network_password = "12345678"

local ap_network_name = "modulo"
local ap_network_password = "12345678"

wifi.setmode(wifi.STATIONAP) -- both AP and client

-- Step 1.1: Set AP mode
local ap_config = {
    ssid = ap_network_name,
    pwd = ap_network_password
}

wifi.ap.config(ap_config)

-- Step 1.2: Set client mode
local sta_config = {
    ssid = sta_network_name,
    pwd = sta_network_password,
    save = true
}

wifi.sta.config(sta_config)

--
-- WORK: WAIT FOR TCP STUFF
--
-- Step 2 - Wait for TCP broadcasts
--
-- Auxiliary functions

local function msg_to_table(str)
    t={}
    str:gsub(".",function(c) table.insert(t,c) end)
    return t
end

local port = 8972
local server = net.createServer(net.UDP)
server:on("receive", function(server, pl)
    print("received :"..pl)
    -- receives 12-char string, one for each gpio.
    -- 0 and 1 means set gpio to output and set high or low.
    -- 3 means read, return the value.
    -- 
    -- the returned value is also a 12-char value where each value is the gpio state.
    local t = msg_to_table(pl)
    local out = ""
    for i, v in ipairs(t) do
        if v == 0 or v == 1 then
            gpio.mode(i, gpio.OUTPUT)
            gpio.write(i, v)
            out = out .. v
        else if v == 3 then
            gpio.mode(i, gpio.INPUT)
            out = out .. tostring(gpio.read(i))
        end
    end

    server:send(out) 
   end
)

server:listen(port)