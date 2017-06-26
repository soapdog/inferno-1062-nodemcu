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
local port = 8972
local server = net.createServer(net.UDP)
server:on("receive", function(server, pl)
      print("received :"..pl)
      server:send("Yes") 
   end
)

server:listen(port)