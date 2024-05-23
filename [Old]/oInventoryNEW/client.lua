addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInventory" or getResourceName(res) == "oInterface" or getResourceName(res) == "oBone" or getResourceName(res) == "oFont" or getResourceName(res) == "oChat" then  
		core = exports.oCore
		chat = exports.oChat
		admin = exports.oAdmin
		font = exports.oFont
		bone = exports.oBone
		interface = exports.oInterface

		logcolor = "#ed6b0e"
		color, r, g, b = core:getServerColor()
	end
end)

local _dxDrawImage = dxDrawImage
local textures = {}
local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
    if type(image) == "string" then 
        if not textures[image] then 
            textures[image] = dxCreateTexture(image, "dxt5", true)
        end

        image = textures[image]
    end
    _dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
end

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local inventoryItems = {
	[localPlayer] = {
		["bag"] = {
			[3] = {1, 5, 1, 1, "asd"}, -- {dbid, itemid, count, value, weaponSerial, name, isDutyItem}
			[1] = {2, 5, 7, 1, "asd"}, -- {itemid, count, value, serial}
			[27] = {3, 2, 3, 1, "asd"}, -- {itemid, count, value, serial}
			[21] = {4, 1, 1, 1, "asd"}, -- {itemid, count, value, serial}
			[22] = {5, 1, 1, 1, "asd"}, -- {itemid, count, value, serial}
		},
	
		["keys"] = {
			[23] = {52, 1, 1, "asd"}, -- {itemid, count, value, serial}
			[40] = {54, 1, 1, "asd"}, -- {itemid, count, value, serial}
		},
	
		["licens"] = {
			[1] = {36, 1, 1, "asd"}, -- {itemid, count, value, serial}
			[19] = {100, 3, 1, "asd"}, -- {itemid, count, value, serial}
		},
	},
}

local openedElementInventory = nil 
local inventoryState = false
local activeSide = "bag"

local inventoryTick = 0
local inventoryAnimationState = "open"
local inventoryAlpha = 0

local invPosX, invPosY = sx*0.7, sy*0.4
local invW, invH = sx*0.215, sy*0.2385
local inventoryInMoving = false

local inventorySlots = {}

local movedItem, moveStartSlot = nil, 0

function generateSlots()
	inventorySlots = {}
	local margin = 2
	local slotStartX, slotStartY = invPosX + margin/myX*sx, invPosY + margin/myY*sy + sy*0.023
	local rowCount = 0
	for i = 1, slotCount do
		if rowCount == 9 then 
			slotStartX = invPosX + margin/myX*sx
			slotStartY = slotStartY + itemSize / myY*sy + margin/myY*sy
			rowCount = 1
		else
			if i > 1 then
				slotStartX = slotStartX + itemSize/myX*sx + margin/myX*sx
			end
			rowCount = rowCount + 1
		end
		table.insert(inventorySlots, {slotStartX, slotStartY, itemSize/myX*sx, itemSize/myY*sy})
	end
end
generateSlots()

function renderInventory()
	if inventoryAnimationState == "open" then
		inventoryAlpha = interpolateBetween(inventoryAlpha, 0, 0, 1, 0, 0, (getTickCount() - inventoryTick) / 200, "Linear")
	else
		inventoryAlpha = interpolateBetween(inventoryAlpha, 0, 0, 0, 0, 0, (getTickCount() - inventoryTick) / 200, "Linear")
	end

	dxDrawRectangle(invPosX - 2/myX*sx, invPosY - 2/myY*sy, invW + 4/myX*sx, invH + 4/myY*sy, tocolor(30, 30, 30, 150 * inventoryAlpha))
	dxDrawRectangle(invPosX, invPosY, invW, invH, tocolor(35, 35, 30, 255 * inventoryAlpha))
	dxDrawRectangle(invPosX, invPosY, invW, sy*0.023, tocolor(30, 30, 30, 255 * inventoryAlpha))

	local startX = invPosX + 3/myX*sx 
	for k, v in ipairs(inventoryPages) do 
		if core:isInSlot(startX, invPosY + 3/myY*sy, 18/myX*sx, 18/myY*sy) then 
			dxDrawText(v[2], startX, invPosY + 3/myY*sy, startX + 18/myX*sx, invPosY + 3/myY*sy + 20/myY*sy, tocolor(r, g, b, 200 * inventoryAlpha), 1, font:getFont("fontawesome2", 10/myX*sx), "center", "center")
		else
			dxDrawText(v[2], startX, invPosY + 3/myY*sy, startX + 18/myX*sx, invPosY + 3/myY*sy + 20/myY*sy, tocolor(255, 255, 255, 200 * inventoryAlpha), 1, font:getFont("fontawesome2", 10/myX*sx), "center", "center")
		end

		startX = startX + 25/myX*sx
	end

	dxDrawText("OriginalRoleplay - #ffffffInventory", invPosX, invPosY, invPosX + invW, invPosY+sy*0.023, tocolor(r, g, b, 255 * inventoryAlpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center", false, false, false, true)

	for k, v in ipairs(inventorySlots) do 
		if core:isInSlot(v[1], v[2], v[3], v[4]) then 
			dxDrawRectangle(v[1], v[2], v[3], v[4], tocolor(40, 40, 40, 255 * inventoryAlpha))
		else
			dxDrawRectangle(v[1], v[2], v[3], v[4], tocolor(40, 40, 40, 150 * inventoryAlpha))
		end

		if inventoryItems[openedElementInventory][activeSide][k] then 
			dxDrawImage(v[1], v[2], v[3], v[4], getItemImage(inventoryItems[openedElementInventory][activeSide][k][2]), 0, 0, 0, tocolor(255, 255, 255, 255 * inventoryAlpha))
			dxDrawText(inventoryItems[openedElementInventory][activeSide][k][3], v[1], v[2], v[1]+v[3] - 2/myX*sx, v[2]+v[4], tocolor(255, 255, 255, 255 * inventoryAlpha), 1, font:getFont("condensed", 9/myX*sx), "right", "bottom")
		end
	end

	dxDrawRectangle(invPosX - 2/myX*sx, invPosY + invH + sy*0.005 - 2/myY*sy, invW + 4/myX*sx, sy*0.015 + 4/myY*sy, tocolor(30, 30, 30, 150 * inventoryAlpha))
	dxDrawRectangle(invPosX, invPosY + invH + sy*0.005, invW, sy*0.015, tocolor(35, 35, 35, 255 * inventoryAlpha))
	dxDrawRectangle(invPosX, invPosY + invH + sy*0.005, invW, sy*0.015, tocolor(r, g, b, 200 * inventoryAlpha))

	if movedItem then 
		local cx, cy = getCursorPosition()
		cx, cy = cx*sx, cy*sy 

		dxDrawImage(cx - itemSize/myX*sx/2, cy - itemSize/myY*sy/2, itemSize/myX*sx, itemSize/myY*sy, getItemImage(movedItem[2]))
	end

	if inventoryInMoving then 
		local cx, cy = getCursorPosition()
		invPosX, invPosY = cx*sx + inventoryInMoving[1], cy*sy + inventoryInMoving[2]
		generateSlots()
	end
end

function inventoryKey(key, state)
	if key == "mouse1" then 
		if state then 
			local startX = invPosX + 3/myX*sx 
			for k, v in ipairs(inventoryPages) do 
				if core:isInSlot(startX, invPosY + 3/myY*sy, 18/myX*sx, 18/myY*sy) then 
					activeSide = v[1]
					playSound("files/sounds/bincoselect.mp3")
					return 
				end

				startX = startX + 25/myX*sx
			end

			if core:isInSlot(invPosX, invPosY, invW, sy*0.023) then 
				local cx, cy = getCursorPosition()
				cx, cy = cx*sx, cy*sy 

				cx = invPosX - cx 
				cy = invPosY - cy 

				inventoryInMoving = {cx, cy}
			end

			for k, v in ipairs(inventorySlots) do 
				if core:isInSlot(v[1], v[2], v[3], v[4]) then 
					if inventoryItems[openedElementInventory][activeSide][k] then 
						movedItem = inventoryItems[openedElementInventory][activeSide][k]
						moveStartSlot = k 
						inventoryItems[openedElementInventory][activeSide][k] = nil
						playSound("files/sounds/move.mp3")
					end
				end
			end
		else
			if movedItem then
				for k, v in ipairs(inventorySlots) do 
					if core:isInSlot(v[1], v[2], v[3], v[4]) then 
						if not inventoryItems[openedElementInventory][activeSide][k] then 
							triggerServerEvent("setItemSlot", resourceRoot, openedElementInventory, movedItem, moveStartSlot, k, activeSide)

							inventoryItems[openedElementInventory][activeSide][k] = movedItem
							destroyItemMove()
							return
						elseif getItemStackable(movedItem[2]) and inventoryItems[openedElementInventory][activeSide][k][2] == movedItem[2] and inventoryItems[openedElementInventory][activeSide][k][4] == movedItem[4] then 
							inventoryItems[openedElementInventory][activeSide][k][3] = inventoryItems[openedElementInventory][activeSide][k][3] + movedItem[3]
							destroyItemMove()
							return
						end
					end
				end

				inventoryItems[openedElementInventory][activeSide][moveStartSlot] = movedItem 
				destroyItemMove()
			end

			inventoryInMoving = false
		end
	end
end

function destroyItemMove()
	movedItem = false
	moveStartSlot = 0
end

function openInventory(element)
	if inventoryTick + 200 < getTickCount() then
		if inventoryState then 
			inventoryTick = getTickCount()
			inventoryAnimationState = "close"
			removeEventHandler("onClientKey", root, inventoryKey)
			setTimer(function()
				removeEventHandler("onClientRender", root, renderInventory)
				openedElementInventory = nil
			end, 200, 1)
		else
			openedElementInventory = element
			addEventHandler("onClientRender", root, renderInventory)
			addEventHandler("onClientKey", root, inventoryKey)
			inventoryTick = getTickCount()
			inventoryAnimationState = "open"
		end
		inventoryState = not inventoryState
	end
end

--[[setTimer(function()
	openInventory(localPlayer)
end, 1000, 1)]]

bindKey("i", "up", function()
	if getElementData(localPlayer, "user:loggedin") then
		openInventory(localPlayer)
	end
end)

addEvent("updateItems", true)
addEventHandler("updateItems", root, function(itemTable)
	inventoryItems = itemTable
end)