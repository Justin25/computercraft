local function install(url, path)
    local req = http.get(url)
    if req ~= nil then
        local out = fs.open(path, "w")
        if out ~= nil then
            out.write(req.readAll())
            out.close()
            return 0
        else
            print ("Failed to install " .. path .. " (failed to open file)")
            return nil
        end
    else
        print ("Failed to install " .. path .. " (failed to open connection)")
        return nil
    end
end

print "Building directory structure..."
shell.run("mkdir", "lib")
shell.run("mkdir", "brickdata")
print "Installing dependencies..."
if install("https://brooks.scorpionland.net/computercraft/bricks/lib/json.lua", "lib/json") == nil then
    print "Installation failed"
    return nil
end
print "Installing bricks..."
if install("https://brooks.scorpionland.net/computercraft/bricks/bricks.lua", "bricks") == nil then
    print "Installation failed."
    return nil
end
shell.run("bricks", "update")
print "Installation successful!"
