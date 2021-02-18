f = fs.open("bricksup", "w") f.write(http.get("https://brooks.scorpionland.net/computercraft/bricks/oneliner.lua").readAll()) f.close() shell.run("bricksup") shell.run("rm", "bricksup")
