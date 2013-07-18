local tArgs = { ... }
if #tArgs ~= 3 then
	print( "Usage: dig <x> <y> <z>" )
	return
end
os.loadAPI("/sm")


local x,y,z,i,j,k
local odd

x=tonumber( tArgs[1] )
y=tonumber( tArgs[2] )
z=tonumber( tArgs[3] )

odd = true
if z%2==1 then
	oddity = true
else oddity = false
end

for i=1, x do
	if i==1 then
		k=1
	else 
		k=0
	end
	digRow(y+k-1)
	for j=1,z-1 do
		sm.digUp()
		sm.up()
		sm.turnAround()
		sm.digRow(y-1)
	end
	for j=1,z-1 do
		sm.down()	
	end
	if oddity == false then
		turtle.turnLeft()
		sm.forward()
		turtle.turnLeft()
	else
		if odd == true then
			turtle.turnRight()
			sm.forward()
			turtle.turnRight()
			odd = false
		else
			
			turtle.turnLeft()
			sm.forward()
			turtle.turnLeft()
			odd = true
		end		
	end
end