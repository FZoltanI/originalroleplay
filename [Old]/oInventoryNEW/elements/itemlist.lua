local sX, sY = guiGetScreenSize()
local myX, myY = 1768, 992 

local selectedItemInList = 1
local listShow = false
local itemListButtons = {
	{"Item kérése"},
	{"(50db) Ammo kérése"},
}

local listWheel = 0

local listPos = {sX/2 - sX*0.225/2, sY/2 - sY*0.15/2 - sY*0.07}
local listBox = {sX*0.225, sY*0.15}

function renderItemlist()
	dxDrawRectangle(listPos[1], listPos[2], listBox[1], listBox[2], tocolor(30, 30, 30, 255))

	local count = 0
	local count2 = 0

	for k, v in ipairs(items) do
		if k > listWheel and count < 4 then
			count2 = count2 + 1

			if getItemImage(tonumber(k + listWheel*10)) then
				dxDrawImage(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY, getItemImage(tonumber(k + listWheel*10)))
				if core:isInSlot(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY) or tonumber(k + listWheel*10) == selectedItemInList then 
					core:dxDrawOutLine(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY, tocolor(r, g, b, 255), 1)
				end
			end

			if count2 == 11 then 
				count = count + 1
				count2 = 0
			end
		end
	end

	if selectedItemInList > 0 then 
		dxDrawRectangle(listPos[1], listPos[2] + listBox[2] + 2/myY*sY, listBox[1], sY*0.1, tocolor(30, 30, 30, 255))
		dxDrawImage(listPos[1] + 2/myX*sX, listPos[2] + listBox[2] + 4/myY*sY, 50/myX*sX, 50/myY*sY, getItemImage(selectedItemInList))

		--dxDrawRectangle(listPos[1] + 2/myX*sX + 55/myX*sX, listPos[2] + listBox[2] + 4/myY*sY, sX*0.1, sY*0.03)
		dxDrawText(color.."("..selectedItemInList..") #ffffff"..getItemName(selectedItemInList), listPos[1] + 2/myX*sX + 55/myX*sX, listPos[2] + listBox[2] + 4/myY*sY, listPos[1] + 2/myX*sX + 55/myX*sX + sX*0.1, listPos[2] + listBox[2] + 4/myY*sY + sY*0.03, tocolor(255, 255, 255, 255), 1, font:getFont("bebasneue", 15/myX*sX), "left", "center", false, false, false, true)
		dxDrawText("Súly: "..getItemWeight(selectedItemInList).."kg", listPos[1] + 2/myX*sX + 55/myX*sX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.03, listPos[1] + 2/myX*sX + 55/myX*sX + sX*0.1, listPos[2] + listBox[2] + 4/myY*sY + sY*0.03 + sY*0.015, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 10/myX*sX), "left", "center", false, false, false, true)
	
		local startX = listPos[1] + 2/myX*sX
		for k, v in ipairs(itemListButtons) do 
			local bWidth = dxGetTextWidth(v[1], 1, font:getFont("condensed", 12/myX*sX)) + 4/myX*sX

			local allowed = true 

			if k == 2 then 
				if not items[selectedItemInList].ammo then 
					allowed = false
				end
			end

			if allowed then
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04) then 
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 220))
				else
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 150))
				end

				core:dxDrawShadowedText(v[1], startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, startX+bWidth, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055+sY*0.04, tocolor(255, 255, 255), tocolor(0, 0, 0), 1, font:getFont("condensed", 10/myX*sX), "center", "center")
			else
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04) then 
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 100))
				else
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 70))
				end

				core:dxDrawShadowedText(v[1], startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, startX+bWidth, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055+sY*0.04, tocolor(255, 255, 255, 100), tocolor(0, 0, 0, 100), 1, font:getFont("condensed", 10/myX*sX), "center", "center")
			end
			startX = startX + bWidth + 2/myX*sX
		end
	end
end

function itemListClick(key, state)
	if state and key == "mouse1" then 
		local count = 0
		local count2 = 0

		for k, v in ipairs(items) do
			if k > listWheel and count < 4 then
				count2 = count2 + 1

				if getItemImage(tonumber(k + listWheel*10)) then
					if core:isInSlot(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY) then 
						selectedItemInList = tonumber(k + listWheel*10)
					end
				end

				if count2 == 11 then 
					count = count + 1
					count2 = 0
				end
			end
		end

		local startX = listPos[1] + 2/myX*sX
		for k, v in ipairs(itemListButtons) do 
			local bWidth = dxGetTextWidth(v[1], 1, font:getFont("condensed", 12/myX*sX)) + 4/myX*sX

			local allowed = true 

			if k == 2 then 
				if not items[selectedItemInList].ammo then 
					allowed = false
				end
			end

			if allowed then
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04) then 
					if k == 1 then 
						if not items[selectedItemInList].ammo then 
							giveItem(selectedItemInList, 1, 1, 0, true)
						else
							giveItem(selectedItemInList, 100, 1, 0, true)
						end
					elseif k == 2 then 
						giveItem(items[selectedItemInList].ammo, 1, 50, 0, true)
					end
				end
			end
			startX = startX + bWidth + 2/myX*sX
		end
	end
end

addCommandHandler("itemlist",function(cmd,typ)
	if getElementData(localPlayer, "user:admin") >= 7 then
		if not listShow then
			listShow = true

			addEventHandler("onClientRender", getRootElement(), renderItemlist)
			addEventHandler("onClientKey", root, itemListClick)
		else
			listShow = false
			removeEventHandler("onClientRender", getRootElement(), renderItemlist)
			removeEventHandler("onClientKey", root, itemListClick)
		end
	end
end)

function upList()
	if listShow then
		--if guiGetText(searchGui) == "" then
			listWheel = listWheel - 1
			if listWheel < 1 then
				listWheel = 0
			end
		--end
	end
end
bindKey("mouse_wheel_up", "down",upList)
bindKey("arrow_u", "down",upList)

function downList()
	if listShow then
		--if guiGetText(searchGui) == "" then
			listWheel = listWheel + 1

			if listWheel > math.floor(#items / 11) - 3 then
				listWheel = math.floor(#items / 11) - 3
			end
		--end
	end
end
bindKey("mouse_wheel_down", "down",downList)
bindKey("arrow_d", "down",downList)