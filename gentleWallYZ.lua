local tArgs = { ... }
if #tArgs ~= 2 then
	print( "Usage: wall <y> <z>" )
	return
end
function checkMat()
	if(turtle.getItemCount(tab[1]))==0 then
		table.remove(tab,1)
		for i=1,table.maxn(tab) do
			if turtle.getItemCount(tab[1])>0 then
				return tab
			else 
				table.remove(tab,1)
			end
		end 
		return 
	else 
		if(turtle.getItemCount(tab[1]))==1 then
			table.remove(tab,1)
		end
		return 
	end
end

function up(l)
  l=l or 1
  for i=1,l do
    local tries = 0
    while turtle.up() ~= true do
      turtle.digUp()
      turtle.attackUp()
      sleep(0.2)
      tries = tries + 1
      if tries>500 then
        print("Error: can't move up.")
        return false
      end
    end
  end
  return true
end




function setMats(slot)
	if turtle.getItemCount(slot)==0 then
		exit()
	end
	for i=1,16 do
		turtle.select(i)
		if turtle.compareTo(slot) then
			table.insert(tab,i)
			print("lo slot ",i," contiene il materiale scelto.")
		end
	end
	turtle.select(slot)
end

function dig()
  local tries = 0
  while turtle.detect() do
    turtle.dig()
    sleep(0.4)
    tries = tries + 1
    if tries>500 then
      print("Error: dug down for too long.")
      return false
    end
  end
  return true
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
function checkFuel()
	fuel = 100
	pcall(function() fuel =turtle.getFuelLevel() end)
	if fuel == "unlimited" then
		fuel = 100
	end
	print(fuel)
	if fuel<80  then
		turtle.select(16)
		turtle.refuel(1)
	end
end

function turn(right)
	if right then
		turtle.turnRight()
	else
		turtle.turnLeft()
	end	
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

function place()
  checkMat()
  checkFuel()
  turtle.select(tab[1])
  if turtle.detect() then
    return false
  else 
    if turtle.getItemCount(tab[1])==0 then
      outOfResource(tab[1])
    end
    turtle.place()
    return true
  end
end

function turnAround()
  turtle.turnRight()
  turtle.turnRight()
end

function placeColumn(l) 
	if l>1 then
		for j=1,l-1 do
			if not place() then
				--[[
				print("block detected, direction ",upward)
				if upward then
					for w=1,j-1 do
						
						print("block detected, direction ",upward)
						turtle.down()
					end				
				else
					for w=1,j-1 do

						print("block detected, direction ",upward)
						turtle.up()
					end
					upward = not upward 
					return
				end
				]]--
			end
			
			if upward then
				if not turtle.up() then
					for w=1,j-1 do
						turtle.down()
					end
					upward = not upward 
					return 
				end
			else
				if not turtle.down() then
					for w=1,j-1 do
						turtle.up()
					end
					upward = not upward 
					return 
				end
			end
		end
	end
	place()
end

local function outOfResource()
	print("Ran out of a resource. Block: ",block , ".")
	print("Refill, then say something to proceed.")
	read()
end

tab={}
local y,z,i,j
local slot = 1
y=tonumber( tArgs[1] )
z=tonumber( tArgs[2] )
if z<0 then 
	upward = false
	z = z*-1
else
	upward = true
end
if y<0 then
	y = y*-1
	right = false
else
	right = true
end
z1 = z	
turtle.select(slot)
setMats(slot)
for i=1, y do
		placeColumn(z1,upward)
		upward = not upward		
		turn(right)
		if turtle.detect() then
		print("detected")
			for k=1,z do
				if upward then
					turtle.up()
				else
					turtle.down()
				end
				print("forward")
				if turtle.forward() then
					turn(not right)
					placeColumn(z1-k)
					upward=not upward
					i=i+1
					break
				end
			end
		else
		turtle.forward()
		turn(not right)
		end

end