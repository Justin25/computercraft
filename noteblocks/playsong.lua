songname = ...
modem = peripheral.wrap("top")
for line in io.lines(songname) do
    line_list = {}
    i = 0
    for statement in string.gmatch(line, "[^%s]+") do
        line_list[i] = statement
        i = i + 1
    end
    if line_list[0] == "//" then
        print(string.sub(line, 3, -1))
    else
        channel = tonumber(line_list[0])
        num = line_list[1]
        len = line_list[2]
        msg = num .. " " .. len
        modem.transmit(channel, channel, msg)
    end
end
modem.transmit(1, 1, "PLAY")
