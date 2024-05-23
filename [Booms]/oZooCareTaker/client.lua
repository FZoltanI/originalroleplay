local sX, sY = guiGetScreenSize()
local pX, pY = 1280, 1024

local trashPositions = {
	{-2403.67529, -601.24487, 132.64844},
	{-2409.75122, -594.66248, 132.64844},
}

local food = {
	{2806, 0.4, 0, 0, 0, 0, 0, 100} -- apple
}

local time = 0
setElementData(localPlayer, "zoo:boxhold", false)
setPedAnimation(localPlayer)

function menu()
	if isElementWithinColShape ( localPlayer, objcolshape) then
		dxDrawRectangle(490/pX*sX, 362/pY*sY, 300/pX*sX, 300/pY*sY, tocolor(200, 200, 200), false)	
		dxDrawRectangle(posX/pX*sX, posY/pY*sY, 10/pX*sX, 10/pY*sY, tocolor(100, 100, 100), false)	
		dxDrawText( time.." másodperc",490/pX*sX, 342/pY*sY, 790/pX*sX, 362/pY*sY, tocolor(200, 200, 200), 1, "default", "center", "center", false, false, false, false)
		dxDrawText( count.." darab kell",490/pX*sX, 342/pY*sY, 790/pX*sX, 362/pY*sY, tocolor(200, 200, 200), 1, "default", "right", "center", false, false, false, false)
	end	
end

function spawnTrash()
	index = math.random(1, #trashPositions)
	theElement = createObject(849, trashPositions[index][1], trashPositions[index][2], trashPositions[index][3])
	objcolshape = createColCircle (trashPositions[index][1], trashPositions[index][2], 2 )   
end
spawnTrash()

function destroyTrash()
	if (isElement(theElement)) then
		destroyElement(theElement)
	end
	if (isElement(objcolshape)) then
		destroyElement(objcolshape)
	end	
end

function hitCol(theElement, mDim)
	if (theElement == localPlayer) and mDim and (source==objcolshape) then
		outputChatBox("Nyomd meg az [E] gombot,hogy felszethesd az állat ürüléket!")
	end	
end
addEventHandler("onClientColShapeHit", root, hitCol)

function leaveCol(theElement, mDim)
	if (theElement==localPlayer) and mDim and (source==objcolshape) then
		if (isTimer(timer1)) then
			killTimer(timer1)
		end
		removeEventHandler("onClientRender", root, menu)
		destroyTrash()
		outputChatBox("Sikertelen")	
		setElementFrozen(localPlayer, false)
	end
end
addEventHandler("onClientColShapeLeave", root, leaveCol)
function playerPressedKey(button, press)
	if (button=="e") and press and  isElementWithinColShape(localPlayer, objcolshape) then
		setElementFrozen(localPlayer, true)
		count = math.random(15, 40)
		multiplier = 1.25
		time = math.floor(count*multiplier)
		genPos()
		timer1 = 	setTimer(function ()
						if (time > 0) then
							time = time - 1
						else
							removeEventHandler("onClientRender", root, menu)
							destroyTrash()
							outputChatBox("Sikertelen")
							killTimer(timer1)
							setElementFrozen(localPlayer, false)
						end	
					end, 1000, 0)
		removeEventHandler("onClientRender", root, menu)
		addEventHandler("onClientRender", root, menu)
	elseif (button=="mouse1") and press and (time>0) and isElement(objcolshape) and isElementWithinColShape(localPlayer, objcolshape) and isInSlot(posX/pX*sX, posY/pY*sY, 10/pX*sX, 10/pY*sY) then	
		count = count - 1
		if (count > 0) then
			genPos()
		else
			killTimer(timer1)
			removeEventHandler("onClientRender", root, menu)
			destroyTrash()
			outputChatBox("Siker")
			setElementFrozen(localPlayer, false)	
		end	
	end	
end
addEventHandler("onClientKey", root, playerPressedKey)
function genPos()
	posX = math.random(490, 780)
	posY = math.random(362, 652)
end

function toggleCursor()
	showCursor(not isCursorShowing())
end
bindKey("m", "down", toggleCursor)

setDevelopmentMode(true)

function isInSlot(x, y, w, h) 
    if isCursorShowing() then 
        cPosX, cPosY = getCursorPosition()
        cPosX, cPosY = cPosX*sX, cPosY*sY

        if ( (cPosX > x) and (cPosY > y) and (cPosX < x+w) and (cPosY < y+h) ) then 
            return true 
        else
            return false
        end
    end
end

function createFood(type)
	meal = createObject(food[type][1], 0, 0, 0)
	setObjectScale (meal, food[type][2])
	attachElements(meal, box, food[type][3], food[type][4], food[type][5], food[type][6], food[type][7], food[type][8])
end

function createBox()
	box = createObject(917, -2409.03076, -607.87982, 131.92)
	createFood(1)
end
createBox()


function addLabelOnClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if ((clickedElement == box) or (clickedElement == meal)) and (button=="left") and (state=="down") and (getDistance(box, localPlayer)<2) and not(getElementData(localPlayer, "zoo:boxhold")) then  
		setElementData(localPlayer, "zoo:boxhold", true)
		exports.bone_attach:attachElementToBone (box, localPlayer, 12, 0.23, 0.1, 0, -100, -5, -25)
		detachElements(meal)
		exports.bone_attach:attachElementToBone (meal, localPlayer, 12, 0.23, 0.025, 0, 0, 100, 70)
		setPedAnimation(localPlayer, "carry", "crry_prtial", 1000)
	end
end
addEventHandler ( "onClientClick", root, addLabelOnClick )

function getDistance(element, other)
	local x, y, z = getElementPosition(element)
	if isElement(element) and isElement(other) then
		return getDistanceBetweenPoints3D(x, y, z, getElementPosition(other))
	end
end