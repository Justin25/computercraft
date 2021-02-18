inventory_location = 1
going_forward = true
-- Phase 1, harvesting the cactus
-- End condition is when the turtle reaches the stone brick
detected, block = turtle.inspect()
while (block ~= "minecraft:stonebrick") do
    -- If the turtle has reached a wall, turn around and move on to the next
    -- row.
    if (block == "minecraft:sandstone") then
        if going_forward then
            turtle.turnRight()
            turtle.forward()
            turtle.forward()
            turtle.turnRight()
            going_forward = false
        else
            turtle.turnLeft()
            turtle.forward()
            turtle.forward()
            turtle.turnLeft()
            going_forward = true
        end
    end
    -- Move to the next slot if the suck fails
    if (turtle.suck() == false) then
        inventory_location = inventory_location + 1
        turtle.select(inventory_location)
        turtle.suck()
    end
    turtle.forward()
    detected, block = turtle.inspect()
end
-- Phase 2, placing the cactus back down
-- Basically just a reverse of phase 1
while true do
    while (turtle.back() == false) do
        -- Place the cactus back down
        if (turtle.place() == false) then
            -- Move the selected inventory slot down if the current slot is
            -- out of items.
            inventory_location = inventory_location - 1
            turtle.select(inventory_location)
        end
    end
    -- Turn the turtle around, check the block, and turn back around
    turtle.turnRight()
    turtle.turnRight()
    detected, block = turtle.inspect()
    turtle.turnRight()
    turtle.turnRight()
    if (block == "IronChest:BlockIronChest") then
        -- Once the turtle reaches the end, turn it around
        if (going_forward) then
            turtle.turnRight()
            turtle.back()
            turtle.back()
            turtle.turnRight()
            going_forward = false
        else
            turtle.turnLeft()
            turtle.back()
            turtle.back()
            turtle.turnLeft()
            going_forward = true
        end
    else break end
end
-- Phase 3, unloading the turtle
-- Turn the turtle around
turtle.turnRight()
turtle.turnRight()
while (inventory_location > 0) do
    turtle.drop()
    inventory_location = inventory_location - 1
end
