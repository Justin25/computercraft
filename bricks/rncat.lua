arg = {...}

function printTable(tbl, indent)
	if indent == nil then
		indent = ""
	end
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			print(indent .. k .. " = {")
			printTable(v, indent .. "    ")
			print(indent .. "}")
		else
			print(indent .. k .. " = " .. v)
		end
	end
end

if arg[1] ~= nil and arg[2] ~= nil and arg[3] ~= nil then
	side = arg[2]
	channel = tonumber(arg[3])
	if arg[1] == "modem" then
		modem = peripheral.wrap(side)
		modem.open(channel)
		lastMessage = nil
		local modemLoop = function()
			local event, side, sender, reply, message, distance = os.pullEvent("modem_message")
			if sender == channel then
				if type(message) == "table" then -- TODO: Add recursive table printing
					print("[ Table Message ] reply addr: " .. reply)
					printTable(message)
				elseif type(message) == "function" then
					print("Function received with reply channel " .. reply)
					return
				else
					print("[" .. reply .. "] " .. message)
				end
			end
		end
		local ioLoop = function()
			line = io.read()
			modem.transmit(channel, channel, line)
		end
		while true do
			parallel.waitForAny(modemLoop, ioLoop)
		end
	elseif arg[1] == "rednet" then
		rednet.open(side)
		lastMessage = nil
		local rednetLoop = function()
			while true do
				local senderID, message, distance, protocol = rednet.receive()
				if senderID == channel then
					if protocol ~= nil then
						lastMessage = "<" .. protocol .. ">" .. message
					else 
						lastMessage = message
					end
					return
				end
			end
		end
		local ioLoop = function()
			line = io.read()
			rednet.send(channel, line)
			return
		end
		while true do
			returned = parallel.waitForAny(rednetLoop, ioLoop)
			if returned == 1 then
				print(lastMessage)
			end
		end
	end
else
	print "Options: "
	print "    modem [side] [channel] - Broadcast and listen to broadcasts on [channel] using [side]'s "
	print "    rednet [side] [receiver] - Open a rednet channel to computer ID [receiver]"
end
