local func = {}
local showFrisk = false
local friskCategory = "bag"
local friskMenu = 1
local friskItems = {}
local targetElement = nil
local screen = {guiGetScreenSize()}
local posW, posH = itemSize*column + margin*(column+1), itemSize * row + (1+row)*margin
local pos = {screen[1]/2 -posW/2,screen[2]/2 - posH/2}
local friskTable = {
	{"inv","Tárgyak","bag"},
	{"key","Kulcsok","key"},
	{"wallet","Iratok","licens"},
}

local friskMove = false
local friskDefX,friskDefY = 0,0

addEvent("setFriskItems", true)
addEventHandler("setFriskItems", getRootElement(),function(tbl, targ)
	friskItems = tbl
end)

function openFrisk(targ)
	showFrisk = true
	triggerServerEvent("getFriskItems",localPlayer,localPlayer,targ)
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

							if anim1 == "ped" and anim2 == "handsup" then
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
					if localPlayer ~= targetPlayer then
						if not showFrisk then
							openFrisk(targetPlayer)
							isAdminFrisk = true
							targetElement = targetPlayer
						else
							closeFrisk()
						end
					end
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

			dxDrawRectangle(pos[1], pos[2], 361+margin, 240,tocolor(32,32,32,255))

			dxDrawText("Készpénz: "..color..convertNumber(getElementData(targetElement,"char:money")).."#ffffff $", pos[1], pos[2], pos[1]+361, pos[2]+230, tocolor(255,255,255,255), 1, menuFont, "right", "bottom", true, true, true, true)

			for k,v in ipairs(friskTable) do
				if core:isInSlot(pos[1]-20+(k*25),pos[2]+210, 20, 20) then
					dxDrawImage (pos[1]-20+(k*25),pos[2]+210, 20, 20, "files/images/"..v[1]..".png", 0, 0, 0, tocolor(r,g,b,200))
					hoverFrisk = k
				else
					if friskMenu == k then 
						dxDrawImage (pos[1]-20+(k*25),pos[2]+210, 20, 20, "files/images/"..v[1]..".png", 0, 0, 0, tocolor(r,g,b,200))
					else
						dxDrawImage (pos[1]-20+(k*25),pos[2]+210, 20, 20,"files/images/"..v[1]..".png", 0, 0, 0, tocolor(255,255,255,200))
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
								
								if #friskItems[friskCategory][i]["name"] <= 0 then 
									itemName = getItemName(friskItems[friskCategory][i]["id"],tonumber(friskItems[friskCategory][i]["value"]))
								else
									itemName = friskItems[friskCategory][i]["name"]
								end

								if getElementData(localPlayer,"user:admin") >= 2 and getElementData(localPlayer,"user:aduty") == true then
									item_tooltip({"#D23131"..itemName.."#ffffff #ffa800("..friskItems[friskCategory][i]["id"]..")#ffffff","SQL azonosító: #D23131"..friskItems[friskCategory][i]["dbid"].."#ffffff","Érték: #D23131"..friskItems[friskCategory][i]["value"].."#ffffff", "Állapot: #D23131"..friskItems[friskCategory][i]["health"].."#ffffff %"})
								else

									if hotTable[weaponIndexByID[friskItems[friskCategory][i]["id"]]] then
										item_tooltip({color..itemName.."#ffffff #787878["..friskItems[friskCategory][i]["weaponserial"].."]#ffffff","Állapot: "..color..friskItems[friskCategory][i]["health"].."#ffffff %\nSúly: "..color..items[friskItems[friskCategory][i]["id"]].weight*friskItems[friskCategory][i]["count"].."#ffffff kg"})
									elseif friskItems[friskCategory][i]["id"] >= 2 and friskItems[friskCategory][i]["id"] <= 26 then
										item_tooltip({color..itemName.."#ffffff","Súly: "..color..items[friskItems[friskCategory][i]["id"]].weight*friskItems[friskCategory][i]["count"].."#ffffff kg \n Még "..color..friskItems[friskCategory][i]["value"].." #ffffffalkalom."})
									else
										item_tooltip({color..itemName.."#ffffff","Súly: "..color..items[friskItems[friskCategory][i]["id"]].weight*friskItems[friskCategory][i]["count"].."#ffffff kg"})
									end
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
							dxDrawImage(pos[1] + drawColumn * (itemSize + margin) + margin * 1, pos[2] + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize, getItemImage(tonumber(itemID)), 0, 0, 0, tocolor(255, 255, 255, 255))
							tooltip_item(pos[1] + drawColumn * (itemSize + margin) + margin * 1-15, pos[2] + drawRow * (itemSize + margin) + margin * 1.6-19,itemCount)
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
			if core:isInSlot(pos[1]-20+(hoverFrisk*25),pos[2]+210, 20, 20) then
				friskMenu = hoverFrisk
				friskCategory = friskTable[hoverFrisk][3]
			end	
		end
	end
end

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