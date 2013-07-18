local tArgs = { ... }
if #tArgs ~= 1 then
        print( "Usage: wells <y>" )
        return
end
function placeDown(n)
  turtle.select(n)
  if turtle.compareDown()==false then
    digDown()
    turtle.placeDown()
  end
  return tab
end

function digDown()
  local tries = 0
  while turtle.detectDown() do
    turtle.digDown()
    sleep(0.4)
    tries = tries + 1
    if tries>500 then
      print("Error: dug down for too long.")
      return false
    end
  end
  return true
end
function turnAround()
  turtle.turnRight()
  turtle.turnRight()
end
function forward(l)
  l=l or 1
  for i=1,l do
        local tries = 0
        while turtle.forward() ~= true do
                turtle.dig()
                turtle.attack()
                sleep(0.2)
                tries = tries + 1
                if tries>500 then
                        print("Error: can't move forward.")
                        return false
                end
        end
  end
  return true
end

x=tonumber( tArgs[1] )
local i
	for i=1,x do
		forward()
		placeDown(1)
		turtle.turnLeft()
		forward()
		placeDown(2)
		turnAround()
		forward(2)
		placeDown(3)
		turnAround()
		forward(2)
		turtle.select(2)
		digDown()
		turnAround()
		forward(2)
		turtle.select(3)
		digDown()
		turnAround()
		forward(1)
		turtle.select(1)
		digDown()
		turtle.turnRight()
	end