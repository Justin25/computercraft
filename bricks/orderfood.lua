side = ...

if side == nil then
	print "Usage: orderfood [side]"
	print "Where side is the side you have your modem on."
	return
end

rednet.open(side)

print "Connecting..."
terminalID = rednet.lookup("taconet")
if terminalID == nil then
	print "Unable to connect to TacoNet. Please try again later."
	return
end

order = {}
order.t = "order"
print "Name: "
order.name = io.read()
print "Order: "
order.order = io.read()
print "Quantity: "
order.quantity = io.read()

rednet.send(terminalID, order, "taconet")
print "[  0%] Waiting for confirmation..."
while true do
	sc, msg, dist = rednet.receive("taconet")
	if msg.t == "updateState" then
		if msg.state == 1 then
			print "[ 25%] You are in queue..."
		elseif msg.state == 2 then
			print "[ 50%] Your order is in the oven..."
		elseif msg.state == 3 then
			print "[ 75%] Your order is now being delivered."
		elseif msg.state == 4 then
			print "[100%] Your order has been delivered! Enjoy your food!"
			speaker = peripheral.find("speaker")
			if speaker ~= nil then
				speaker.playNote("bell", 100, 0)
			end
			return
		end
	end
	if msg.t == "reject" then
		print "Your order has been rejected."
		print("Reason: " .. msg.reason)
		return
	end
end
