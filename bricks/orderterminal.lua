rednet.open("back")
rednet.host("taconet", "orderterm")

orders = {}
delivered = 0
f = io.open("orderstotal", "r")
if f ~= nil then
	delivered = tonumber(f:read("*a"))
end

speaker = nil
-- Check for speakers
if peripheral.getType("right") == "speaker" then
	speaker = peripheral.wrap("right")
end

function updateScreen()
	shell.run("clear")
	print("Orders delivered: " .. delivered)
	for k, v in pairs(orders) do
		print(v.name .. "(" .. k .. ")" .. ": " .. v.order .. "; qty " .. v.quantity .. "; state " .. v.state)
	end
end

updateScreen()

while true do
	sc, msg, distance = rednet.receive("taconet")
	if msg.t == "order" then
		msg.state = 0
		orders[sc] = msg
		if speaker ~= nil then
			speaker.playNote("bell", 100, 0)
			speaker.playNote("bell", 100, 0)
			speaker.playNote("bell", 100, 0)
		end
	elseif msg.t == "updateState" then
		if msg.state == 4 then
			orders[msg.target] = nil -- Remove order if completed
			delivered = delivered + 1
			f = io.open("orderstotal", "w")
			f:write(delivered)
			f:flush()
			f:close()
		else
			orders[msg.target].state = msg.state
		end
		rednet.send(msg.target, msg, "taconet") -- Forward message to end user
	elseif msg.t == "reject" then
		print "reject received"
		orders[msg.target] = nil
		rednet.send(msg.target, msg, "taconet") -- Forward
	end
	updateScreen()
end
