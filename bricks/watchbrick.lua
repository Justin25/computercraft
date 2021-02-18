arg = {...}
if arg[1] == nil then
	print "Please specify a package to watch"
	return
end

while true do
	shell.run("bricks", "install", arg[1])
	os.sleep(5)
end
