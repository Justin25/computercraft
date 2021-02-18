function note_to_color(note)
    if note == 0 then return colors.black, 1 end
    if note == 1 then return colors.white, 0  end
    if note == 2 then return colors.orange, 0  end
    if note == 3 then return colors.magenta, 0 end
    if note == 4 then return colors.yellow, 0 end
    if note == 5 then return colors.red, 0 end
    if note == 6 then return colors.lime, 0 end
    if note == 7 then return colors.blue, 0 end
    if note == 8 then return colors.lightBlue, 0 end
    if note == 9 then return colors.green, 0 end
    if note == 10 then return colors.pink, 0 end
    if note == 11 then return colors.purple, 0 end
    if note == 12 then return colors.cyan, 0 end
    if note == 13 then return colors.white, 1 end
    if note == 14 then return colors.orange, 1 end
    if note == 15 then return colors.magenta, 1 end
    if note == 16 then return colors.yellow, 1 end
    if note == 17 then return colors.red, 1 end
    if note == 18 then return colors.lime, 1 end
    if note == 19 then return colors.blue, 1 end
    if note == 20 then return colors.lightBlue, 1 end
    if note == 21 then return colors.green, 1 end
    if note == 22 then return colors.pink, 1 end
    if note == 23 then return colors.purple, 1 end
    if note == 24 then return colors.cyan, 1 end
end

function list_iter(t)
    local i = 0
    local n = table.getn(t)
    return function()
        i = i + 1
        if i <= n then
            return t[i]
        end
    end
end

arg, lowerchan, higherchan = ...

modem = peripheral.wrap("back")
modem.open(tonumber(arg))


while true do
    song = {}
    i = 1
    loading = true
    -- Phase 1: Receiving the song from another computer
    while loading do
        event, side, sc, rc, msg, distance = os.pullEvent("modem_message")
        if msg == "PLAY" then
            loading = false
        else
            song[i] = msg
            i = i + 1
        end
    end
    -- Phase 2: Playing the song
    for note in list_iter(song) do
        note_table = {}
        i3 = 0
        for n in string.gmatch(note, "%d+") do
            note_table[i3] = n
            i3 = i3 + 1
        end
        color, channel_choice = note_to_color(tonumber(note_table[0]))
        if channel_choice == 0 then
            modem.transmit(tonumber(lowerchan), tonumber(lowerchan), color)
        end
        if channel_choice == 1 then
            modem.transmit(tonumber(higherchan), tonumber(higherchan), color)
        end
        ticks = note_table[1]
        sleep(1 / ticks)
    end
end
