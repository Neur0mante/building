local tArgs = { ... }
if #tArgs ~= 2 then
	print( "Usage: wall <y> <z>" )
	return
end
function checkMat(tab)
	if(turtle.getItemCount(tab[1]))==0 then
		table.remove(tab,1)
		for i=1,table.maxn(tab) do
			if turtle.getItemCount(tab[1])>0 then
				return tab
			else 
				table.remove(tab,1)
			end
		end 
		return tab
	else 
		if(turtle.getItemCount(tab[1]))==1 then
			table.remove(tab,1)
		end
		return tab
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

function down(l)
  l=l or 1
  for i=1,l do
    local tries = 0
    while turtle.down() ~= true do
      turtle.digDown()
      turtle.attackDown()
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


function setMats(slot,tab)
	if turtle.getItemCount(slot)==0 then
		exit()
	end
	for i=1,16 do
		turtle.select(i)
		if turtle.compareTo(slot) then
			table.insert(tab,i)
			print("The slot ",i," contain the selected material.")
		end
	end
	turtle.select(slot)
	return tab
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

function place(tab)
  tab = checkMat(tab)
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
  turtle.select(tab[1])
  if turtle.compare()==false then
    if turtle.getItemCount(tab[1])==0 then
      outOfResource(tab[1])
    end
    dig()
    turtle.place()
	return tab
  else 
    turtle.place()
  end
  return tab
end
function turnAround()
  turtle.turnRight()
  turtle.turnRight()
end

function placeColumn(tab,l,upward) 
	if l>1 then
		for j=1,l-1 do
			tab = place(tab)
			if upward==1 then
				up()
			else
				down()
			end
		end
	end
	tab = place(tab)
	return tab
end

local function outOfResource()
	print("Ran out of a resource. Block: ",block , ".")
	print("Refill, then say something to proceed.")
	read()
end

mat1={}
local y,z,i,j
local slot = 1
y=tonumber( tArgs[1] )
z=tonumber( tArgs[2] )
if z<0 then 
	odd = false
	z = z*-1
else
	odd = true
end
if y<0 then
	y = y*-1
	right = false
else
	right = true
end
	
turtle.select(slot)
mat1=setMats(slot,mat1)
for i=1, y do
	if odd== true then
		tab = placeColumn(mat1,z,1) 
		odd = false
	else
		tab = placeColumn(mat1,z,0) 
		odd = true
	end
	if right then
		turtle.turnRight()
		forward()
		turtle.turnLeft()
	else	
		turtle.turnLeft()
		forward()
		turtle.turnRight()
	end
end