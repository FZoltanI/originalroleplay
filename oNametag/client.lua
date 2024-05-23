local showNametag = true
local adminNames = false
local alpha = 50

local fontsScript = exports.oFont
local font = fontsScript:getFont("condensed", 14)
local font3 = fontsScript:getFont("condensed", 20)
local font2 = fontsScript:getFont("bebasneue", 55)
local prefixFont = fontsScript:getFont("bebasneue", 25)
local icon = fontsScript:getFont("fontawesome2", 10)

local adminLevels = {"(AdminSegéd)", "(Admin 1)", "(Admin 2)", "(Admin 3)", "(Admin 4)", "(Admin 5)", "(FőAdmin)", "(AdminController)", "(Server Manager)", "<Fejlesztő/>", "(Tulajdonos)"}
local adminColors = {"#f7931e", "#f7931e", "#f7931e", "#f7931e", "#f7931e", "#f7931e", "#ae61e8", "#72b55e", "#ffcc00", "#5db2f7", "#f44141"}

local sx,sy = guiGetScreenSize()

local size = 1.6

local core = exports.oCore

local streamedPlayers = {}
local streamedPed = {}

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	if getElementData(localPlayer, "user:loggedin") then 
		local ownNametagShowing = exports.oDashboard:getDashboardSettingsValue("other", 3) or false
		for k,v in pairs(getElementsByType("player", getRootElement(), true)) do 
			if (v ~= localPlayer or ownNametagShowing) and not streamedPlayers[v] then 
				streamedPlayers[v] = {}
				if streamedPlayers[v] then 
					if getElementData(v, "user:loggedin") then
						streamedPlayers[v].element = v
						streamedPlayers[v].playerId = getElementData(v, "playerid") or 0
						streamedPlayers[v].playerName = getElementData(v, "char:name"):gsub("_", " ") or getPlayerName(v)
						streamedPlayers[v].adminLevel = getElementData(v, "user:admin")
						streamedPlayers[v].adminNick = getElementData(v, "user:adminnick")
						streamedPlayers[v].isAfk = getElementData(v, "char:afk")
						streamedPlayers[v].afkHours = getElementData(v, "afk:hours")
						streamedPlayers[v].afkMinutes = getElementData(v, "afk:minutes")
						streamedPlayers[v].afkSeconds = getElementData(v, "afk:seconds")
						streamedPlayers[v].isTyping = getElementData(v, "chat")
						streamedPlayers[v].isConsoling = getElementData(v, "console")
						streamedPlayers[v].showedItems = getElementData(v, "inventory:showedItem")
						streamedPlayers[v].hiddenAdmin = getElementData(v, "user:hadmin")
						streamedPlayers[v].adminDuty = getElementData(v, "user:aduty")
						streamedPlayers[v].playedTime = getElementData(v, "char:playedTime")
						streamedPlayers[v].level = exports.oLvl:countPlayerLevel(getElementData(v, "char:playedTime")[1]) or 1
						streamedPlayers[v].badgeInUse = getElementData(v, "badgeInUse")
						streamedPlayers[v].badgeText = getElementData(v, "badgeText")
						streamedPlayers[v].paintVisibleOnPlayers = getElementData(v, "atmRob:painting")
						streamedPlayers[v].customDeath = getElementData(v, "customDeath")
						streamedPlayers[v].bloodLevel = getElementData(v, "char:blood")
						streamedPlayers[v].playerInAnim = getElementData(v, "playerInAnim")
						streamedPlayers[v].playerInDead = getElementData(v, "playerInDead")
						streamedPlayers[v].idgAs = getElementData(v, "user:idgAs")
					end
				end
			end
		end
		for k, v in pairs(getElementsByType("ped", getRootElement(), true)) do
			if not streamedPed[v] then 
			--	print("a")
			--print(#streamedPed)
				streamedPed[v] = {}
				if streamedPed[v] then 
					--print("a")
					streamedPed[v].element = v
					streamedPed[v].visibleName = getElementData(v, "ped:name")
					streamedPed[v].pedPrefix = getElementData(v, "ped:prefix") or "NPC"
					streamedPed[v].pedIcon = getElementData(v, "ped:icon") or false
				end
			end
		end
	end
	
end)

addEventHandler("onPlayerJoin", getRootElement(), function()
	streamedPlayers[source] = {}
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
	streamedPlayers[source] = nil
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementType(source) == "player" then 
		local ownNametagShowing = exports.oDashboard:getDashboardSettingsValue("other", 3) or false
		if (source ~= localPlayer or ownNametagShowing) and not streamedPlayers[source] then 
			streamedPlayers[source] = {}
			if streamedPlayers[source] then 
				if getElementData(source, "user:loggedin") then
					streamedPlayers[source].element = source
					streamedPlayers[source].playerId = getElementData(source, "playerid") or 0
					streamedPlayers[source].playerName = getElementData(source, "char:name"):gsub("_", " ") or getPlayerName(v)
					streamedPlayers[source].adminLevel = getElementData(source, "user:admin")
					streamedPlayers[source].adminNick = getElementData(source, "user:adminnick")
					streamedPlayers[source].isAfk = getElementData(source, "char:afk")
					streamedPlayers[source].afkHours = getElementData(source, "afk:hours")
					streamedPlayers[source].afkMinutes = getElementData(source, "afk:minutes")
					streamedPlayers[source].afkSeconds = getElementData(source, "afk:seconds")
					streamedPlayers[source].isTyping = getElementData(source, "chat")
					streamedPlayers[source].isConsoling = getElementData(source, "console")
					streamedPlayers[source].showedItems = getElementData(source, "inventory:showedItem")
					streamedPlayers[source].hiddenAdmin = getElementData(source, "user:hadmin")
					streamedPlayers[source].adminDuty = getElementData(source, "user:aduty")
					streamedPlayers[source].playedTime = getElementData(source, "char:playedTime")
					streamedPlayers[source].level = exports.oLvl:countPlayerLevel(getElementData(source, "char:playedTime")[1]) or 1
					streamedPlayers[source].badgeInUse = getElementData(source, "badgeInUse")
					streamedPlayers[source].badgeText = getElementData(source, "badgeText")
					streamedPlayers[source].paintVisibleOnPlayers = getElementData(source, "atmRob:painting")
					streamedPlayers[source].customDeath = getElementData(source, "customDeath")
					streamedPlayers[source].bloodLevel = getElementData(source, "char:blood")
					streamedPlayers[source].playerInAnim = getElementData(source, "playerInAnim")
					streamedPlayers[source].playerInDead = getElementData(source, "playerInDead")
					streamedPlayers[source].idgAs = getElementData(source, "user:idgAs")
				end
			end
		end
	elseif getElementType(source) == "ped" and not streamedPed[source] then 
		streamedPed[source] = {}
		if streamedPed[source] then 
			streamedPed[source].element = source
			streamedPed[source].visibleName = getElementData(source, "ped:name")
			streamedPed[source].pedPrefix = getElementData(source, "ped:prefix") or "NPC"
			streamedPed[source].pedIcon = getElementData(source, "ped:icon") or false
		end
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
	if getElementType(source) == "player" and streamedPlayers[source] then 
		local ownNametagShowing = exports.oDashboard:getDashboardSettingsValue("other", 3) or false
		if (source ~= localPlayer or ownNametagShowing) and streamedPlayers[source] then
			streamedPlayers[source] = nil
		end
	elseif getElementType(source) == "ped" and streamedPed[source] then 
		streamedPed[source] = nil
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue)
	local ownNametagShowing = exports.oDashboard:getDashboardSettingsValue("other", 3) or false
	if (source ~= localPlayer or ownNametagShowing) and streamedPlayers[source] then
		if dataName == "playerid" then 
			streamedPlayers[source].playerId = getElementData(source, "playerid")
		elseif dataName == "char:name" then 
			streamedPlayers[source].playerName = getElementData(source, "char:name"):gsub("_", " ") or getPlayerName(source)
		elseif dataName == "user:admin" then 
			streamedPlayers[source].adminLevel = getElementData(source, "user:admin")		
		elseif dataName == "user:adminnick" then 
			streamedPlayers[source].adminNick = getElementData(source, "user:adminnick")		
		elseif dataName == "char:afk" then 
			streamedPlayers[source].isAfk = getElementData(source, "char:afk")
			streamedPlayers[source].afkHours = getElementData(source, "afk:hours")
			streamedPlayers[source].afkMinutes = getElementData(source, "afk:minutes")
			streamedPlayers[source].afkSeconds = getElementData(source, "afk:seconds")
		elseif dataName == "afk:seconds" then 
			streamedPlayers[source].isAfk = getElementData(source, "char:afk")
			streamedPlayers[source].afkHours = getElementData(source, "afk:hours")
			streamedPlayers[source].afkMinutes = getElementData(source, "afk:minutes")
			streamedPlayers[source].afkSeconds = getElementData(source, "afk:seconds")
		elseif dataName == "chat" then
			streamedPlayers[source].isTyping = getElementData(source, "chat")		
		elseif dataName == "console" then
			streamedPlayers[source].isConsoling = getElementData(source, "console")		
		elseif dataName == "inventory:showedItem" then
			streamedPlayers[source].showedItems = getElementData(source, "inventory:showedItem")		
		elseif dataName == "user:hadmin" then
			streamedPlayers[source].hiddenAdmin = getElementData(source, "user:hadmin")		
		elseif dataName == "user:aduty" then
			streamedPlayers[source].adminDuty = getElementData(source, "user:aduty")		
		elseif dataName == "char:playedTime" then
			streamedPlayers[source].playedTime = getElementData(source, "char:playedTime")
			streamedPlayers[source].level = exports.oLvl:countPlayerLevel(getElementData(source, "char:playedTime")[1]) or 1
		elseif dataName == "badgeInUse" then
			streamedPlayers[source].badgeInUse = getElementData(source, "badgeInUse")		
		elseif dataName == "badgeText" then
			streamedPlayers[source].badgeText = getElementData(source, "badgeText")		
		elseif dataName == "atmRob:painting" then
			streamedPlayers[source].paintVisibleOnPlayers = getElementData(source, "atmRob:painting")		
		elseif dataName == "customDeath" then
			streamedPlayers[source].customDeath = getElementData(source, "customDeath")		
		elseif dataName == "char:blood" then
			streamedPlayers[source].bloodLevel = getElementData(source, "char:blood")		
		elseif dataName == "playerInAnim" then
			streamedPlayers[source].playerInAnim = getElementData(source, "playerInAnim")		
		elseif dataName == "playerInDead" then
			streamedPlayers[source].playerInDead = getElementData(source, "playerInDead")		
		elseif dataName == "user:idgAs" then
			streamedPlayers[source].idgAs = getElementData(source, "user:idgAs")
		end
	end
	if getElementType(source) == "ped" then 
		if dataName == "ped:name" then 
			if streamedPed[source] then
				streamedPed[source].visibleName = getElementData(source, "ped:name") or " "
			end
		elseif dataName == "ped:prefix" then 
			if streamedPed[source] then 
				streamedPed[source].pedPrefix = getElementData(source, "ped:prefix") or "NPC"
			end
		elseif dataName == "ped:icon" then 
			streamedPed[source].pedIcon = getElementData(source, "ped:icon") or false
		end
	end
end)

addEventHandler("onClientPlayerChangeNick", getRootElement(), function(oldName, newName)
	if streamedPlayers[source] then
		streamedPlayers[source].playerName = newName
	end
end)
 
setTimer(function()
	if not getElementData(localPlayer, "user:loggedin") or not showNametag or getElementData(localPlayer,"cctv:useCCTV") then return end
	local now = getTickCount() 
	local px, py, pz = getCameraMatrix()

	for k, v in pairs(streamedPlayers) do
		if isElement(v.element) then
			local ownNametagShowing = exports.oDashboard:getDashboardSettingsValue("other", 3) or false
			if ownNametagShowing == true or v.element ~= localPlayer then
				local tx, ty, tz = getElementPosition(v.element)
				local dist = math.sqrt(( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2)

				local maxDist = 25 

				if adminNames then 
					maxDist = 200
				end

				if dist < maxDist then
					if isLineOfSightClear(px, py, pz, tx, ty, tz, true, false, false, true, false, false, false, localPlayer) or adminNames then
						if (getElementDimension(localPlayer) == getElementDimension(v.element) and getElementInterior(localPlayer) == getElementInterior(v.element)) then 
							local sx, sy, sz = getPedBonePosition(v.element, 5)
							local x, y = getScreenFromWorldPosition(sx, sy, sz + 0.5)

							local scale = 0.3
							scale = scale*(sx+1280)/(1280*2)

							local size = 1 - (dist / 25)
							if adminNames then 
								size = 1
								dist = 1
							end

							local alpha = interpolateBetween(0,0,0,1,0,0,now/3500,"SineCurve")

							if x then
								if getElementAlpha(v.element) > 200 then 
									local playerName = ""

									local showedItem = v.showedItems

									if adminNames then 
										dxDrawRectangle(x-120*size/2, y+30*size, 120*size, 20*size, tocolor(0, 0, 0, 200))
										dxDrawRectangle(x-120*size/2+2*size, y+30*size+2*size, (120*size-4*size)*getElementHealth(v.element)/100, 20*size-4*size, tocolor(220, 0, 0, 200))

										dxDrawRectangle(x-120*size/2, y+55*size, 120*size, 20*size, tocolor(0, 0, 0, 200))
										dxDrawRectangle(x-120*size/2+2*size, y+55*size+2*size, (120*size-4*size)*getPedArmor(v.element)/100, 20*size-4*size, tocolor(31, 165, 209, 200))
									end
									local hadmin = v.hiddenAdmin
									if v.adminDuty and not hadmin then
										local pName = v.adminNick
										local aLevel = v.adminLevel

										shadowedText(adminColors[aLevel].." ("..v.playerId..") ".."#ffffff"..pName..adminColors[aLevel].." "..adminLevels[aLevel], x, y - dist/4, x, y - dist/4, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										playerName = adminLevels[aLevel]..pName.."("..v.playerId..")"

										local posZ = 70

										if v.isAfk then 
											posZ = 80
										end

										if not (v.playerInDead or v.playerInAnim or showedItem) then 
											dxDrawImage(x - (69.3/2 * size), y - (10 * size) - (posZ * size) + (1 * size), 69.3 * size, 61.875 * size, "files/icon.png", 0, 0, 0, tocolor(hexToRGB(adminColors[v.adminLevel])[1],hexToRGB(adminColors[v.adminLevel])[2],hexToRGB(adminColors[v.adminLevel])[3],255*alpha))
										end
									elseif v.adminLevel == 1 then 
										local pName = string.gsub(v.playerName, "_", " ")
										local aLevel = v.adminLevel

										shadowedText(adminColors[aLevel]..adminLevels[aLevel].." #ffffff"..pName.." #f7931e("..v.playerId..") ", x, y - dist/4, x, y - dist/4, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										playerName = adminColors[aLevel]..adminLevels[aLevel].." #ffffff"..pName.." #f7931e("..v.playerId..") "
									
									elseif v.idgAs then 
										--print(idgas)
										local pName = v.playerName
										pName = string.gsub(v.playerName, "_", " ")
										--local aLevel = datas.alevel

										shadowedText("#f7931e(AdminSegéd) #ffffff"..pName.." #f7931e("..v.playerId..") ", x, y - dist/4, x, y - dist/4, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										playerName = "#f7931e(AdminSegéd) #ffffff"..pName.." #f7931e("..v.playerId..") "
									else
										local playedTime = v.playedTime

										local pName = v.playerName
										pName = string.gsub(v.playerName, "_", " ")


										local level = v.level
										local dmg = getElementData(v.element, "char:dmg")

										if level < 5 then 
											playerName = adminColors[1].."[Kezdő] #ffffff"..pName.." #f7931e("..v.playerId..")"
											shadowedText(adminColors[1].."[Kezdő] #ffffff"..pName.." #f7931e("..v.playerId..")", x, y - dist/4, x, y - dist/4, dmg and tocolor(255, 60, 60, 255 - dist*5) or tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										else
											playerName = pName.." #f7931e("..v.playerId..")"
											shadowedText(pName.." #f7931e("..v.playerId..")", x, y - dist/4, x, y - dist/4, dmg and tocolor(255, 60, 60, 255 - dist*5) or tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										end
									end

									if v.isAfk then 
										shadowedText("[AFK - "..(v.afkHours)..":"..(v.afkMinutes)..":"..(v.afkSeconds).."]", x, y - dist/4 - 22, x, y - dist/4 - 22, tocolor(201, 47, 36, 255- dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										--shadowedText("Away From Keyboard", x, y - dist/4 - 40, x, y - dist/4 - 40, tocolor(201, 47, 36, 255- dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
										--shadowedText("AFK", x, y - dist/4 - 100, x, y - dist/4 - 100, tocolor(201, 47, 36, 255- dist*5), 0.9 - dist/35, font2, "center", "top", false, false, false, true)
									end

									if showedItem then 
										dxDrawImage(x - (20*size), y - (40*size) - (40*size), 40*size, 40*size, exports.oInventory:getItemImage(showedItem[1], showedItem[2]), 0, 0, 0, tocolor(255, 255, 255, 255))
										shadowedText(exports.oInventory:getItemName(showedItem[1], showedItem[2]), x, y - dist/4 - 40*size, x, y - dist/4 - 40*size, tocolor(255, 255, 255, 255- dist*5), 0.9 - dist/35, font, "center", "top", false, false, false, true)

										if string.len(showedItem[3]) > 0 then 
											shadowedText("["..showedItem[3].."]", x, y - dist/4 - 18*size, x, y - dist/4 - 18*size, tocolor(200, 200, 200, 255- dist*5), 0.8 - dist/35, font, "center", "top", false, false, false, true)
										end
									end

									if v.badgeInUse then 
										if not v.playerInDead then 
											shadowedText(v.badgeText, x, y - dist/4 + 20, x, y - dist/4 + 20, tocolor(245, 141, 66, 255 - dist*5), 0.9 - dist/35, font, "center", "top", false, false, false, true)
										end
									end

									if v.isConsoling then
										local width = dxGetTextWidth(playerName, 1 - dist/35, font, true)*1.2
										shadowedText("", x-width, y - dist/4 + 2, x, y - dist/4 + 2, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, icon, "center", "top", false, false, false, true)
									elseif v.isTyping then
										local width = dxGetTextWidth(playerName, 1 - dist/35, font, true)*1.2
										shadowedText("", x-width, y - dist/4 + 2, x, y - dist/4 + 2, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, icon, "center", "top", false, false, false, true)
									end

									if v.paintVisibleOnPlayers > 0 then 
										local rendY = y - dist/4 + 20

										if v.badgeInUse then 
											rendY = y - dist/4 + 40
										end

										shadowedText("*festék látható az arcán*", x, rendY, x, rendY, tocolor(141, 41, 204, 200 - dist*5), 0.9 - dist/35, font, "center", "top", false, false, false, true)
									end

									if not v.isAfk then 
										if v.playerInDead then 
											dxDrawImage(x - (60/2 * size), y - (10 * size) - (60 * size) + (1 * size), 60 * size, 60 * size, "files/death.png", 0, 0, 0, tocolor(227, 59, 59, 255))
											shadowedText("Elhunyt (Oka: ".. v.customDeath .. ")", x, y - dist/4 + 20, x, y - dist/4 + 20, tocolor(227, 59, 59, 255 - dist*5), 0.9 - dist/35, font, "center", "top", false, false, false, true)
										elseif v.playerInAnim then 
											dxDrawImage(x - (25 * size), y - (10 * size) - (50 * size) + (1 * size), 50*size, 50*size, "files/anim.png", 0, 0, 0, tocolor(227, 59, 59, 255))
										--	outputChatBox(getElementData(v, "playerInAnim.datas")[1]-getTickCount())
											shadowedText("Vérszint: "..v.bloodLevel.."%", x, y - dist/4 + 20, x, y - dist/4 + 20, tocolor(227, 59, 59, 255 - dist*5), 0.9 - dist/35, font, "center", "top", false, false, false, true)
										end
									end

									if v.playerInAnim then 
										shadowedText("Vérszint: "..v.bloodLevel.."%", x, y - dist/4 + 20, x, y - dist/4 + 20, tocolor(227, 59, 59, 255 - dist*5), 0.9 - dist/35, font, "center", "top", false, false, false, true)
									end
								end
							end
						end
					end
				end
			end
		end
    end
		
	for k, v in pairs(streamedPed) do
		local pedName = v.visibleName
		local pedPrefix = v.pedPrefix
		local pedIcon  = v.pedIcon
		if pedName and isElement(v.element) then
		--	print("a")
			local tx, ty, tz = getElementPosition(k)
			local dist = math.sqrt(( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2)
			if dist < 25 then
				if isLineOfSightClear(px, py, pz, tx, ty, tz, true, false, false, true, false, false, false, localPlayer) then
					local sx, sy, sz = getPedBonePosition(k, 5)
					local isPet = getElementData(v.element,"pet")

					local x, y = getScreenFromWorldPosition(sx, sy, sz + 0.35)

					if x and y then
						if not isPet then 
							shadowedText(pedName:gsub("_", " ").." #f7931e("..pedPrefix..")", x, y - dist/4, x, y - dist/4, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
						else 
							shadowedText(pedName:gsub("_", " ").." #f7931e("..pedPrefix..")", x, y - dist*4 + 100, x, y - dist/4 + 100, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, font, "center", "top", false, false, false, true)
						end 

						if pedIcon then 
							dxDrawText(pedIcon, x, y - 64 + dist*1.5, x, y - 55 + dist*1.5, tocolor(0, 0, 0, 180 - dist*5), 1 - dist/35, icon, "center", "top", false, false, false, true)
							dxDrawText(pedIcon, x, y - 65 + dist*1.5, x, y - 55 + dist*1.5, tocolor(255, 255, 255, 255 - dist*5), 1 - dist/35, icon, "center", "top", false, false, false, true)
						end
					end
				end
			end
		end
	end
end,10,0)

addEventHandler("onClientMinimize", getRootElement(), function()
    if getElementData(localPlayer, "user:loggedin") then
		setElementData(localPlayer, "afk", true)
		setElementData(localPlayer, "afk:start", getTickCount())
    end
end)

addEventHandler("onClientRestore", getRootElement(), function()
    if getElementData(localPlayer, "user:loggedin") then
        setElementData(localPlayer, "afk", false)
    end
end)

addCommandHandler("togname", function()
    if getElementData(localPlayer, "user:loggedin") then
        showNametag = not showNametag
    end
end)

addCommandHandler("anames", function()
	local available = false 

	if getElementData(localPlayer, "user:admin") >= 7 then 
		available = true 
	elseif getElementData(localPlayer, "user:admin") >= 2 and getElementData(localPlayer, "user:aduty") then 
		available = true
	end

    if available then
		adminNames = not adminNames
    end
end)

addEventHandler("onClientElementDataChange", localPlayer, function(data, old, new)
	if source == localPlayer then
		if data == "user:aduty" then 
			if new == false then 
				adminNames = false
			end
		end
	end
end)

setTimer(function()
	if getElementData(localPlayer, "user:loggedin") then
		setElementData(localPlayer, "console", isConsoleActive())
		setElementData(localPlayer, "chat", isChatBoxInputActive())
	end
end, 1000, 0)

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,rot)

	if not rot then 
		rot = 0 
	end

	if not text then 
		text = " "
	end

	local shadowType = (exports.oDashboard:getDashboardSettingsValue("other", 2) or 1)

	if shadowType == 1 then 
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true,true,rot) 
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true,true,rot)
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true,true,rot) 
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true,true,rot) 
	elseif shadowType == 2 then 
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+2,w,h+2,tocolor(0,0,0,200),fontsize,font,aligX,alignY, false, false, false, true,true,rot)
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+2,y,w+2,h,tocolor(0,0,0,200),fontsize,font,aligX,alignY, false, false, false, true,true,rot) 
	end

    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true,true,rot)
end

function hexToRGB(hex)
    hex = hex:gsub("#","")
    return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end

exports.oAdmin:addAdminCMD("anames", 2, "Játékos nevek megtekintése távolabbról, falon keresztül.")