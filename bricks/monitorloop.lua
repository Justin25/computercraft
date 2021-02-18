arg = {...}
shell.run("monitor", arg[1], "clear")
while true do
    shell.run("monitor", arg[1], arg[2])
    shell.run("monitor", arg[1], "clear")
end
