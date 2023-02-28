function EDRV_Init()
	--Initiation of driver. Nothing too special.
	ELAN_Trace('\n  ')
	ELAN_Trace('  ')
	ELAN_Trace('  ')
	ELAN_Trace([[  _____           _ _               _____  _     _        _ _           _   _             ]])
	ELAN_Trace([[ |_   _|         | (_)             |  __ \(_)   | |      (_) |         | | (_)            ]])
	ELAN_Trace([[   | |  _ __   __| |_  __ _  ___   | |  | |_ ___| |_ _ __ _| |__  _   _| |_ _  ___  _ __  ]])
	ELAN_Trace([[   | | |  _ \ / _` | |/ _` |/ _ \  | |  | | / __| __| |__| | |_ \| | | | __| |/ _ \| |_ \ ]])
	ELAN_Trace([[  _| |_| | | | (_| | | (_| | (_) | | |__| | \__ \ |_| |  | | |_) | |_| | |_| | (_) | | | |]])
	ELAN_Trace([[ |_____|_| |_|\__,_|_|\__, |\___/  |_____/|_|___/\__|_|  |_|_.__/ \__,_|\__|_|\___/|_| |_|]])
	ELAN_Trace([[                       __/ |                                                              ]])
	ELAN_Trace([[  ______ _            |___/___       _                  _____                             ]])
	ELAN_Trace([[ |  ____| |             |  __ \     (_)                |  __ \                            ]])
	ELAN_Trace([[ | |__  | | __ _ _ __   | |  | |_ __ ___   _____ _ __  | |  | | _____   __                ]])
	ELAN_Trace([[ |  __| | |/ _` | |_ \  | |  | | |__| \ \ / / _ \ |__| | |  | |/ _ \ \ / /                ]])
	ELAN_Trace([[ | |____| | (_| | | | | | |__| | |  | |\ V /  __/ |    | |__| |  __/\ V /                 ]])
	ELAN_Trace([[ |______|_|\__,_|_| |_| |_____/|_|  |_| \_/ \___|_|    |_____/ \___| \_/                  ]]) 
	ELAN_Trace('\n  ')
	ELAN_Trace('  ')
	ELAN_Trace('  ')
	ELAN_Trace("Driver iniated")

	--create a TCP socket and show status green if successful. 
	--This is in case IP address is already set and "update driver" button was pressed, otherwise useless
	userName = ELAN_GetUserName()
	password = ELAN_GetPassword()
	encodedPassword = ELAN_GetAuthBasic()
	ipAddress = ELAN_GetIPString()
	port = ELAN_GetIPPort()
	tcpSocket = ELAN_CreateTCPClientSocket(ipAddress, port)
	if ELAN_ConnectTCPSocket(tcpSocket) then
		ELAN_Trace(string.format("Connetion successful on socket: %s",tcpSocket))
		ELAN_SetDeviceState("GREEN","Intercom online")
	end
end

function EDRV_SetIPConfig()
	--When the "apply" button is pressed, create a TCP socket
	ipAddress = ELAN_GetIPString()
	port = ELAN_GetIPPort()
	userName = ELAN_GetUserName()
	password = ELAN_GetPassword()
	encodedPassword = ELAN_GetAuthBasic()
	tcpSocket = ELAN_CreateTCPClientSocket(ipAddress, port)
	if ELAN_ConnectTCPSocket(tcpSocket) then
		--set state green if socket creation was successful
		ELAN_Trace(string.format("Connetion successful on socket: %s",tcpSocket))
		ELAN_SetDeviceState("GREEN","Intercom online")
		--getInfo() is a custom function which sends the /api/system/info command. 
		--Response is a JSON file which contains general information
		--The other "config" functions are custom functions that return specific informatoin fields from the JSON file
		res = getInfo()
		FW = configFW(res)
		model = configModel(res)
		macAddress = configMAC(res)
		--setting the relevant fields in the configurator
		ELAN_SetConfigurationString("sVarFW", FW)
		ELAN_SetConfigurationString("sVarMAC", macAddress)
		ELAN_SetConfigurationString("sVarModel", model)
		ELAN_Trace(string.format("Info dump here: %s",res))
	else
		--If socket was not successfully created, show corresponding status in configurator
		ELAN_Trace("No connection!")
		ELAN_SetDeviceState("RED","Not connected")
	end
end

function EDRV_SetOutput(index, state)
	--We don't really need a state==0 option because the Akuvox intercom does not have a toggle option to its relays apparently (I didn't find any in the manual at least)
	if state == 1 then
		--sending a GET command with username, password and door number (their relays start at 1, our start at 0)
		--Also get username and password for the get command
		userName = ELAN_GetUserName()
		password = ELAN_GetPassword()
		sHTTP = string.format("GET /api/relay/trig?mode=0&num=%d&level=1&delay=5 HTTP/1.0\r\n",index+1)
		sHTTP = sHTTP .. "Host: " .. ipAddress .. "\r\n"
		sHTTP = sHTTP .. "Content-Type: text/html; charset=UTF-8\r\n"
		sHTTP = sHTTP .. "Connection: keep-alive\r\n\r\n"
		ELAN_Trace(string.format("Just sent this command: %s",sHTTP))
		--HTTPExchange is a godsent, such a great function. Allows to send the command to the intercom and capture response in one go. Very convinient.
		response = ELAN_DoHTTPExchange(tcpSocket,sHTTP, false)
		ELAN_Trace(string.format("The response was %s", response))
	else
		userName = ELAN_GetUserName()
		password = ELAN_GetPassword()
		sHTTP = string.format("GET /api/relay/trig?mode=0&num=%d&level=1&delay=5 HTTP/1.0\r\n",index+1)
		sHTTP = sHTTP .. "Host: " .. ipAddress .. "\r\n"
		sHTTP = sHTTP .. "Content-Type: text/html; charset=UTF-8\r\n"
		sHTTP = sHTTP .. "Connection: keep-alive\r\n\r\n"
		ELAN_Trace(string.format("Just sent this command: %s",sHTTP))
		--HTTPExchange is a godsent, such a great function. Allows to send the command to the intercom and capture response in one go. Very convinient.
		response = ELAN_DoHTTPExchange(tcpSocket,sHTTP, false)
		ELAN_Trace(string.format("The response was %s", response))
	end
end

--Pressing the "reboot intercom" button does... guess...
function EDRV_ExecuteConfigProc()
	UserName = ELAN_GetUserName()
	password = ELAN_GetPassword()
	encodedPassword = ELAN_GetAuthBasic()
	sHTTP = "GET api/system/reboot/ HTTP/1.0\r\n"
	--sHTTP = sHTTP .. string.format("Authorization: Basic %s", encodedPassword)
	sHTTP = sHTTP .. "Host: " .. ipAddress .. "\r\n"
	sHTTP = sHTTP .. "Content-Type: text/html; charset=UTF-8\r\n"
	sHTTP = sHTTP .. "Connection: keep-alive\r\n\r\n"
	ELAN_Trace(string.format("Just sent this command: %s",sHTTP))
	--HTTPExchange is a godsent, such a great function. Allows to send the command to the intercom and capture response in one go. Very convinient.
	response = ELAN_DoHTTPExchange(tcpSocket,sHTTP, false)
	ELAN_Trace(string.format("The response was %s", response))
end

--[[********************************************
CUSTOM FUNCTIONS FROM HERE ON OUT	 
********************************************--]]

--this function is mean to aquire general system information
function getInfo()
	sHTTP = "GET /api/system/info HTTP/1.0\r\n"
	sHTTP = sHTTP .. "Authorization: Basic " .. encodedPassword
	sHTTP = sHTTP .. "Host: " .. ipAddress .. "\r\n"
	sHTTP = sHTTP .. "Content-Type: text/html; charset=UTF-8\r\n"
	sHTTP = sHTTP .. "Connection: keep-alive\r\n\r\n"
	ELAN_Trace(string.format("Just sent this command: %s",sHTTP))
	--HTTPExchange is a godsent, such a great function. Allows to send the command to the intercom and capture response in one go. Very convinient.
	response = ELAN_DoHTTPExchange(tcpSocket,sHTTP,false)
	return response
end

--returns the firmware version from the Info JSON response
function configFW(response)
	hJSON = ELAN_CreateJSONMsg(response)
	baseNode = ELAN_FindJSONNode(hJSON,hJSON,"data")
	baseSubNode  = ELAN_FindJSONNode(hJSON,baseNode,"Status")
	firmwareVersion = ELAN_FindJSONValueByKey(hJSON,baseSubNode,"FirmwareVersion")
	return firmwareVersion
end

--returns the MAC address from the Info JSON response
function configMAC(response)
	hJSON = ELAN_CreateJSONMsg(response)
	baseNode = ELAN_FindJSONNode(hJSON,hJSON,"data")
	baseSubNode  = ELAN_FindJSONNode(hJSON,baseNode,"Status")
	macAd = ELAN_FindJSONValueByKey(hJSON,baseSubNode,"MAC")
	return macAd 
end

--returns the model from the Info JSON response
function configModel(response)
	hJSON = ELAN_CreateJSONMsg(response)
	baseNode = ELAN_FindJSONNode(hJSON,hJSON,"data")
	baseSubNode  = ELAN_FindJSONNode(hJSON,baseNode,"Status")
	mod = ELAN_FindJSONValueByKey(hJSON,baseSubNode,"Model")
	return mod
end

















