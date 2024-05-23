
--local func = {}
local showFrisk = false
local friskCategory = "bag"
local friskMenu = 1
local friskItems = {}
local targetElement = nil
local screen = {guiGetScreenSize()}
local posW, posH = itemSize*column + margin*(column+1) , itemSize * row + (1+row)*margin
local pos = {screen[1]/2 -posW/2,screen[2]/2 - posH/2}
local friskTable = {
	{"backpack","Tárgyak","bag"},
	{"key","Kulcsok","key"},
	{"licens","Iratok","licens"},
}

local friskMove = false
local friskDefX,friskDefY = 0,0

func.setFriskItems = function(items,data)
    friskItems = items
end
addEvent("setFriskItems",true)
addEventHandler("setFriskItems",getRootElement(),func.setFriskItems)

function openFrisk(targ)
	showFrisk = true
	triggerServerEvent("requestFriskItems",localPlayer,targ)
	addEventHandler("onClientRender",getRootElement(),func["friskRender"])
	addEventHandler("onClientClick",getRootElement(),func["friskClick"])
end

function closeFrisk()
	showFrisk = false
	removeEventHandler("onClientRender",getRootElement(),func["friskRender"])
	removeEventHandler("onClientClick",getRootElement(),func["friskClick"])
end

local isAdminFrisk = false

function friskPlayer(player)
	if getElementData(localPlayer, "user:loggedin") then
		if player then
			if getElementData(player, "user:loggedin") then
				if not isPedDead(player) then
					if localPlayer ~= player then
						if core:getDistance(localPlayer, player) <= 3 then
							local anim1, anim2 = getPedAnimation(player)

							if anim1 == "ped" and anim2 == "handsup" or getElementData(player,'cuff:cuffed') then
								if not showFrisk then
									openFrisk(player)
									targetElement = player
									isAdminFrisk = false
									chat:sendLocalMeAction("megmotozza "..getPlayerName(player):gsub("_"," ").." -t.")
								else
									closeFrisk()
								end
							else
								outputChatBox(core:getServerPrefix("red-dark", "Motozás", 2).."A kiválasztott játékosnak nincs feltéve a keze.",61, 122, 188,true)
							end
						else
							outputChatBox(core:getServerPrefix("red-dark", "Motozás", 2).."A kiválasztott játékos túl messze van tőled.",61, 122, 188,true)
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Motozás", 2).."Magadat nem motozhatod meg.",61, 122, 188,true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Motozás", 2).."A kiválasztott játékos meg van halva.",61, 122, 188,true)
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Motozás", 2).."A kiválasztott játékos nincs bejelentkezve.",61, 122, 188,true)
			end
		end
	end
end

func["friskAdmin"] = function(cmd, id)
	if getElementData(localPlayer, "user:admin") >= 2 then
		if not (id) then
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."#ffffff/"..cmd.." [ID]", 255, 255, 255, true)
		else
			local targetPlayer, targetPlayerName = core:getPlayerFromPartialName(getLocalPlayer(), id)	
			if targetPlayer then
				if getElementData(targetPlayer, "user:loggedin") then
					--if localPlayer ~= targetPlayer then
						if not showFrisk then
							openFrisk(targetPlayer)
							isAdminFrisk = true
							targetElement = targetPlayer
						else
							closeFrisk()
						end
					--end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Motozás", 3).."A kiválasztott játékos nincs bejelentkezve.",61, 122, 188,true)
				end
			end
		end
	end
end
addCommandHandler("showinv",func["friskAdmin"])

func["friskRender"] = function()
	hoverFrisk = 0

	if not isAdminFrisk then 
		if core:getDistance(targetElement, localPlayer) > 3 then 
			closeFrisk()
		end
	end
	
	if showFrisk then
		if isElement(targetElement) then
			if friskMove then
				if isCursorShowing() then
					local x, y = getCursorFuck()
					pos[1],pos[2] = x - friskDefX,y - friskDefY
				end
			end

			dxDrawRectangle(pos[1], pos[2], posW, posH + 30,tocolor(32,32,32,255))

			dxDrawText("Készpénz: "..color..convertNumber(getElementData(targetElement,"char:money")).."#ffffff $", pos[1], pos[2], pos[1]+posW-5, pos[2]+235, tocolor(255,255,255,255), 1, font:getFont("condensed", 13), "right", "bottom", true, true, true, true)

			for k,v in ipairs(friskTable) do
				if core:isInSlot(pos[1]-20+(k*25),pos[2]+215, 20, 20) then
					dxDrawImage (pos[1]-20+(k*25),pos[2]+215, 20, 20, "files/images/icons/"..v[1]..".png", 0, 0, 0, tocolor(r,g,b,200))
					hoverFrisk = k
				else
					if friskMenu == k then 
						dxDrawImage (pos[1]-20+(k*25),pos[2]+215, 20, 20, "files/images/icons/"..v[1]..".png", 0, 0, 0, tocolor(r,g,b,200))
					else
						dxDrawImage (pos[1]-20+(k*25),pos[2]+215, 20, 20,"files/images/icons/"..v[1]..".png", 0, 0, 0, tocolor(255,255,255,200))
					end
				end
			end
			
			local drawRow = 0
			local drawColumn = 0
			if friskCategory == "bag" or friskCategory == "licens" or friskCategory == "key" then
				if friskItems[friskCategory] then
					for i = 1, row * column do
						if core:isInSlot(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize) then
							inSlotBox = true
							dxDrawRectangle(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize,tocolor(20,20,20,255))
							--
							hoverSlot = i
							if (friskItems[friskCategory][i]) then
								if selectedSound ~= i then
									playSound("files/sounds/hover.mp3")
								end
								selectedSound = i
								hoverItem = (friskItems[friskCategory][i])
								local itemName = ""
								
								--if #friskItems[friskCategory][i].name <= 0 then 
									itemName = getItemName(friskItems[friskCategory][i].item,tonumber(friskItems[friskCategory][i].value))
								--else
								--	itemName = friskItems[friskCategory][i].name
								--end

								if getElementData(localPlayer,"user:aduty") and getElementData(localPlayer, "user:admin") >= 5 then
									func.toolTip(itemName..color, " [sql id: "..friskItems[friskCategory][i].id.." itemid: "..friskItems[friskCategory][i].item.."]","#ffffff"..tostring(friskItems[friskCategory][i].value));
								else
									func.toolTip(unpack(getItemTooltip(friskItems[friskCategory][i].id,friskItems[friskCategory][i].item,friskItems[friskCategory][i].value,friskItems[friskCategory][i].count,friskItems[friskCategory][i].state,friskItems[friskCategory][i].weaponserial)));
								end
							else
								hoverItem = nil
							end
						else
							dxDrawRectangle(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize,tocolor(25,25,25,255))
							inSlotBox = false
						end
						local itemData = friskItems[friskCategory][i]
						if (itemData) then
							local itemDbid = itemData["dbid"]
							local itemID = itemData["id"]
							local itemCount = itemData["count"]
							local itemHeath = itemData["health"]
							dxDrawImage(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize, getItemImage(itemData.item), 0, 0, 0, tocolor(255, 255, 255, 255))
							dxDrawText(itemData.count, pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, pos[1] + drawColumn * (itemSize + margin) + margin * 1 + itemSize - 2, pos[2] + drawRow * (itemSize + margin) + margin * 1.6+itemSize, tocolor(255, 255, 255, 255), 1, font:getFont("condensed", 9), "right", "bottom")
						end
						drawColumn = drawColumn + 1
						if (drawColumn == column) then
							drawColumn = 0
							drawRow = drawRow + 1
						end
					end
				end
			end
		else
			showFrisk = false
		end
	end
end

func["friskClick"] = function(button,state)
	if showFrisk then
		if button == "left" and state == "down" then
			if core:isInSlot(pos[1]-20+(hoverFrisk*25),pos[2]+215, 20, 20) then
				friskMenu = hoverFrisk
				friskCategory = friskTable[hoverFrisk][3]
			end	
		end
	end
end

func.deleteItemKey = function()
	if getElementData(localPlayer,"user:admin") >= 7 then
		if (showFrisk) then
			triggerServerEvent("deleteItemfrisk",localPlayer,targetElement,friskItems[friskCategory][hoverSlot],true,localPlayer)
			closeFrisk()
			openFrisk(targetElement)
			isAdminFrisk = true
		end
	end
end
bindKey("delete","down",func.deleteItemKey)


function convertNumber(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end