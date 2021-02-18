arg = {...}
rednet.open("back")

print "Connecting..."
terminalID = rednet.lookup("taconet")
if terminalID == nil then
	print "Unable to connect to TacoNet. Please try again later."
	return
end


if arg[1] == "updateState" then
	msg = {}
	msg.t = "updateState"
	msg.target = tonumber(arg[2])
	msg.state = tonumber(arg[3])
	rednet.send(terminalID, msg, "taconet")
elseif arg[1] == "reject" then
	msg = {}
	msg.t = "reject"
	msg.target = tonumber(arg[2])
	msg.reason = arg[3]
	if msg.reason == nil then 
		msg.reason = "No reason provided."
	end
	rednet.send(terminalID, msg, "taconet")
end
