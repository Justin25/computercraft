arg1 = ...
modem = peripheral.wrap("back")
modem.open(tonumber(arg1))
while true do
    event, side, sc, rc, msg, distance = os.pullEvent("modem_message")
    redstone.setBundledOutput("front", tonumber(msg))
    sleep(2/20)
    redstone.setBundledOutput("front", 0)
end
