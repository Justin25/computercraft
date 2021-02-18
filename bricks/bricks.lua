-- Deps
json = dofile("lib/json")

function update()
    print "Updating bricks package list..."
    get = http.get("https://brooks.scorpionland.net/computercraft/bricks/packages.json")
    if get ~= nil then
        file = fs.open("brickdata/packages.json", "w")
        file.write(get.readAll())
        file.close()
    else
        print "Failed to open connection."
    end
end

function install(brick)
    print ("Installing " .. brick .. "...")
    packages = json.decode(fs.open("brickdata/packages.json", "r").readAll())
    if packages[brick] ~= nil then
        for i, dep in ipairs(packages[brick].deps) do
            install(dep)
        end
        get = http.get("https://brooks.scorpionland.net/computercraft/bricks/" .. brick .. ".lua")
        if get ~= nil then
            file = fs.open(brick, "w")
            file.write(get.readAll())
            file.close()
            get.close()
            print "Installation successful!"
        else
            print "Unable to establish connection. Installation failed."
        end
    else
        print "Brick not found."
    end
end

function remove(brick)
    shell.run("rm", brick)
end


arg = {...}
if arg[1] == "update" then
    update()
elseif arg[1] == "install" then
    if arg[2] ~= nil then
        install(arg[2])
    else
        print "Please specify a brick to install."
    end
elseif arg[1] == "remove" then
    if arg[2] ~= nil then
        if arg[2] == "lua/json" then
            print "you're a retard"
        else
            remove(arg[2])
        end
    else
        print "Please specify a brick."
    end
elseif arg[1] == "list" then
    print "Available packages:"
    packages = json.decode(fs.open("brickdata/packages.json", "r").readAll())
    for name, package in pairs(packages) do
        print (name .. ": " .. package.description)
    end
elseif arg[1] == "search" then
    if arg[2] == nil then
        print "Please specify what package to search for."
        return
    end
    local pattern = arg[2]
    print "Matches:"
    packages = json.decode(fs.open("brickdata/packages.json", "r").readAll())
    for name, package in pairs(packages) do
        if string.match(name, pattern) or string.match(package.description, pattern) then
            print (name .. ": " .. package.description)
        end
    end
else
    print "=== Bricks Package Manager ==="
    print "Options:"
    print "    install [brick] - Installs a brick"
    print "    remove [brick] - Removes an installed bricks"
    print "    update - Updates your local packages list"
    print "    list - Shows all bricks available for install"
    print "    search [pattern] - Shows all bricks matching a pattern"
    print "See https://brooks.scorpionland.net/computercraft/bricks/ for more info."
end
