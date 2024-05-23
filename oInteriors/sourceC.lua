local showIcons = true
local marker = nil
local displayWidth, displayHeight = guiGetScreenSize();
local renderState = false

local notificationFont = exports.oFont:getFont("condensed", 12) 
local markerCache = {};

sX, sY = guiGetScreenSize()
defaultX, defaultY = sX/2 - 426/2, (sY/2 - 280/2) * 2;
myX, myY = 1768, 992

if fileExists("sourceC.lua") then 
	fileDelete("sourceC.lua")
end

local lastSoundPlayer = 0

addEventHandler("onClientResourceStart", getRootElement(), function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oChat" or getResourceName(res) == "oAdmin" or getResourceName(res) == "oInteriors" then  
        core = exports.oCore
		color, r ,g ,b = core:getServerColor()
		chat = exports.oChat
		admin = exports.oAdmin
		serverColor = core:getServerColor()
		serverSyntax = serverColor.."["..core:getServerName().."]:#ffffff"
	end
end)

function renderInteriorPanel()
	if getElementData(localPlayer, "int:Marker") then
		if not interiorTick then
			interiorTick = getTickCount();
		end

		if interiorAnimation == 'inComing' then
			alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - interiorTick) / 200, "Linear");
		else
			alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - interiorTick) / 200, "Linear");
		end
		
		intMarker = getElementData(localPlayer, "int:Marker") or false
		interiorOwner = getElementData(intMarker, "owner") or false
		interiorType = getElementData(intMarker,"inttype") or 0
		interiorCost = getElementData(intMarker, "cost") or 0
		intLock = getElementData(intMarker, "locked") or 0
		intR, intG, intB = getMarkerColor(intMarker)

		if interiorType == 4 then
			asdType = 'Garázs'
			typeColor = interior_colors.garage
		elseif interiorType == 3 then
			asdType = 'Bérház'
			typeColor = '#3D7ABC'
		elseif interiorType == 2 then 
			asdType = 'Önkormányzati'
			typeColor = interior_colors.gov
		elseif interiorType == 1 then
			asdType = 'Biznisz'
			typeColor = interior_colors.business
		elseif interiorType == 0 then
			asdType = 'Ház'
			typeColor = interior_colors.house
		elseif interiorType == 5 then 
			asdType = 'Drogtelep'
			typeColor = interior_colors.weed_farm
		else
			asdType = 'N/A'
		end

		if interiorOwner <= 0 then
			if interiorType == 5 then 
				core:drawWindow(sx*0.4, sy*0.8, sx*0.2, sy*0.06, "#cc5737("..interiorCost.."$/Hét)#ffffff "..interiorInformations, alpha)
			elseif interiorType ~= 2 then
				if interiorCost > 0 then
					core:drawWindow(sx*0.4, sy*0.8, sx*0.2, sy*0.06, "#5cd17b("..interiorCost.."$)#ffffff "..interiorInformations, alpha)
				else
					core:drawWindow(sx*0.4, sy*0.8, sx*0.2, sy*0.06, "#5cd17b(Ingyenes)#ffffff "..interiorInformations, alpha)
				end
			else
				core:drawWindow(sx*0.4, sy*0.8, sx*0.2, sy*0.06, interiorInformations, alpha)
			end
		else
			core:drawWindow(sx*0.4, sy*0.8, sx*0.2, sy*0.06, interiorInformations, alpha)
		end

		if bellStatus then 
			dxDrawText("Belépéshez használd az "..color.."[E] #ffffffgombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65/myX*sx, notificationFont, "center", "center", false, false, false, true)

			if core:isInSlot(sx*0.41, sy*0.822, sx*0.01875, sy*0.033) then 
				dxDrawImage(sx*0.41, sy*0.822, sx*0.01875, sy*0.033, "files/images/icons/bell.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))
			else
				dxDrawImage(sx*0.41, sy*0.822, sx*0.01875, sy*0.033, "files/images/icons/bell.png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
			end

			if core:isInSlot(sx*0.574, sy*0.822, sx*0.01875, sy*0.033) then 
				dxDrawImage(sx*0.574, sy*0.822, sx*0.01875, sy*0.033, "files/images/icons/knock.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))
			else
				dxDrawImage(sx*0.574, sy*0.822, sx*0.01875, sy*0.033, "files/images/icons/knock.png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
			end

			if intLock == 1 then 
				dxDrawImage(sx*0.582,sy*0.797, (sx*0.01875)*0.95, (sy*0.033)*0.95,"files/images/icons/locked.png", 0, 0, 0, tocolor(196, 35, 35, 150*alpha))
			else 
				dxDrawImage(sx*0.582,sy*0.797, (sx*0.01875)*0.95, (sy*0.033)*0.95,"files/images/icons/unlocked.png", 0, 0, 0, tocolor(63, 196, 107, 150*alpha))
			end
		else
			if interiorOwner <= 0 then
				if interiorType == 5 then 
					dxDrawText("A bérlés megkezdéséhez használd az "..color.."[E] #ffffffgombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65/myX*sx, notificationFont, "center", "center", false, false, false, true)
				elseif interiorType ~= 2 then
					if interiorCost > 0 then
						dxDrawText("Vásárláshoz használd az "..color.."[E] #ffffffgombot, megtekintés pedig az "..color.."[F]#ffffff gombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65/myX*sx, notificationFont, "center", "center", false, false, false, true)
					else
						dxDrawText("Vásárláshoz használd az "..color.."[E] #ffffffgombot, megtekintés pedig az "..color.."[F]#ffffff gombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65/myX*sx, notificationFont, "center", "center", false, false, false, true)
					end
				else
					dxDrawText("Belépéshez használd az "..color.."[E] #ffffffgombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65/myX*sx, notificationFont, "center", "center", false, false, false, true)
				end
			else
				dxDrawText("Belépéshez használd az "..color.."[E] #ffffffgombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65/myX*sx, notificationFont, "center", "center", false, false, false, true)
			end
		end
		
		local interior_icon = "house"
		local interior_name = "Ház"

		if interiorType == 0 then 
			interior_icon = "house"
		elseif interiorType == 1 then 
		elseif interiorType == 2 then 
			interior_icon = "government"
		elseif interiorType == 3 then 	
		elseif interiorType == 4 then 
			interior_icon = "garage"
		elseif interiorType == 5 then 
			interior_icon = "weed"
		end 

		dxDrawImage(sx*0.5 - 20/myX*sx,sy*0.76,40/myX*sx,40/myY*sy,"files/icons/"..interior_icon..".png", 0, 0, 0, tocolor(intR, intG, intB, 255*alpha))
		--dxDrawText(asdType, sx*0.415, sy*0.805, _, _, tocolor(intR, intG, intB, 200*alpha), 0.7, notificationFont)
	end
end

function onPlayerClick(btn,state)
	if state == "down" and btn == "left" and getElementData(localPlayer, "isInIntMarker") and bellStatus then
		if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then
			local intMarker = getElementData(localPlayer, "int:Marker") 
			local otherIntMarker = getElementData(intMarker, "other")
			local otherDim = getElementDimension(otherIntMarker);
			local otherInt = getElementInterior(otherIntMarker)
			if (otherIntMarker) then
				if core:isInSlot(sx*0.574, sy*0.822, sx*0.01875, sy*0.033) then 
					if isTimer(knockSpam) then return end
					knockX, knockY, knockZ = getElementPosition(otherIntMarker);
					playSound("files/sounds/knocking.mp3")
					triggerServerEvent("playSoundServer", localPlayer, "files/sounds/knocking.mp3", knockX, knockY, knockZ, otherInt, otherDim)

					knockSpam = setTimer(function() end, 3000,1)
				elseif core:isInSlot(sx*0.41, sy*0.822, sx*0.01875, sy*0.033) then 
					if isTimer(bellSpam) then return end
					bellX, bellY, bellZ = getElementPosition(otherIntMarker);
					playSound("files/sounds/belling.mp3")
					triggerServerEvent("playSoundServer", localPlayer, "files/sounds/belling.mp3", bellX, bellY, bellZ, otherInt, otherDim)
					
					bellSpam = setTimer(function() end, 3000,1)
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), onPlayerClick)

function clientMarkerHit(thePlayer, matchingDimension)
	cancelEvent()
	if thePlayer == localPlayer then
		if getElementDimension(source) == getElementDimension(thePlayer) then
			if getElementData(source,"isIntMarker") == true or getElementData(source,"isIntOutMarker") == true then
				if isTimer(markerTimer) then
					killTimer(markerTimer)
				end

				marker = nil

				if core:getDistance(localPlayer, source) <= 2 then
					bindKey("e", "up", bindKeyInteriorFunctions)
					bindKey("k", "up", lockInteriorFunctions)
					local intOwner = getElementData(source,"owner")
					local inttype = getElementData(source,"inttype")
					if intOwner <= 0 then
						if inttype == 0 or inttype == 1 or inttype == 4 then 
							bindKey("f", "up", goInteriorWhenSell)
						end
					end
					setElementData(thePlayer, "isInIntMarker",true)
					setElementData(thePlayer, "int:Marker", source)
					setElementData(source, "intMarker:bell", false)
					setElementData(source, "intMarker:knock", false)

					if getElementData(source, "isIntMarker") then
						if getElementData(source,"custom") > 0 then
							if intOwner == getElementData(localPlayer, "char:id") then 
								outputChatBox(core:getServerPrefix("server", "Interior szerkesztés", 2).."Az interior szerkesztéséhez használd a "..color.."/szerkesztes#ffffff parancsot.", 255, 255, 255, true)
							end 
						end
					end

					marker = source
					local owner = getElementData(marker,"owner")
					local ownerName = getElementData(marker,"ownerName") or "Senki"

					interiorInformations = tostring(getElementData(marker,"name"))
					interiorInformations2 = tostring(getElementData(marker,"name")).." ["..tonumber(getElementData(marker,"dbid")).."] "

					if getElementData(localPlayer, "user:aduty") then
						interiorInformations = interiorInformations..color.." ["..tonumber(getElementData(marker,"dbid")).."] "
					end 
					

					if owner <= 0 then
						num = 32
					end

					if lastSoundPlayer + 300 < getTickCount() then 
						local sound = playSound("files/sounds/menter.wav")
						setSoundVolume(sound, 1)
						lastSoundPlayer = getTickCount()
					end

					-- sima
					if inttype == 0 and owner <= 0 then
						bellStatus = false;
					elseif inttype == 0 and owner >= 1 then
						bellStatus = true;
					elseif inttype == 1 and owner <= 0 then
						bellStatus = false;
					elseif inttype == 1 and owner >= 1 then
						bellStatus = true;
					elseif inttype == 2 then
						bellStatus = false;
					elseif inttype == 4 and owner <= 0 then
						bellStatus = false;
					elseif inttype == 4 and owner >= 1 then
						bellStatus = true;
					else
						infoText = "Hibás interior"
						interiorIcon = "#D23131"
					end
					
					if (notificationData ~= nil) then
						table.remove(notificationData, #notificationData);
					end
			
					interiorTick = nil;
					interiorAnimation = 'inComing';

					if not renderState then
						createRender("renderInteriorPanel", renderInteriorPanel)
						renderState = true
					end
				end
			end
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, clientMarkerHit)

addEventHandler("onClientMarkerLeave", resourceRoot, function(thePlayer, matchingDimension)
	if thePlayer == localPlayer then
		marker = nil
		unbindKey("e", "up", bindKeyInteriorFunctions)
		unbindKey("k", "up", lockInteriorFunctions)
		unbindKey("f", "up", goInteriorWhenSell)
		setElementData(thePlayer, "isInIntMarker",false)

		markerTimer = setTimer(function()
			setElementData(thePlayer, "int:Marker", nil)
		end, 1200, 1)

		interiorTick = nil;
		interiorAnimation = 'leaveOut';
	end
end)

local editTick = 0
addCommandHandler("szerkesztes",
	function ()
		if isElement(marker) and getElementData(marker, "isIntMarker") and getElementData(marker, "custom") > 0 then
			if tonumber(getElementData(marker, "owner")) == tonumber(getElementData(localPlayer, "char:id")) then
				if editTick + 5000 <= getTickCount() then
					triggerServerEvent("editInterior", localPlayer, marker)
					editTick = getTickCount()
				else
					outputChatBox(core:getServerPrefix("red-dark", "Interior szerkesztés", 2).."Ezt a parancsot csak 5 másodpercenként használhatod.", 255, 255, 255, true)
				end
			end
		end
	end
)

local createdAmbientSounds = {}

function bindKeyInteriorFunctions()
	if isElement(marker) then
		local theElement = getElementData(marker, "other")
		if theElement then
			local intID = getElementData(marker,"dbid")
			local intLocked = getElementData(marker,"locked")
			local intType = getElementData(marker,"inttype")
			local intOwner = getElementData(marker,"owner")
			local intCost = getElementData(marker,"cost")

			if intOwner <= 0 and (intType == 0 or intType == 1 or intType == 4 or intType == 5) then 
				if getElementData(localPlayer,"char:money") >= intCost then
					if intType == 5 then 
						setElementData(localPlayer,"char:money",getElementData(localPlayer,"char:money")-intCost)
						outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).."Sikeresen kibéreltél egy drogtelepet egy hétre. "..color.."("..intCost.." $.)",61,122,188,true)
						triggerServerEvent("updateInteriorOwner", localPlayer, intID,intType, localPlayer)
					else
						if getPlayerAllOwnedInteriorCount() + 1 <= getElementData(localPlayer, "char:intSlot") then
							setElementData(localPlayer,"char:money",getElementData(localPlayer,"char:money")-intCost)
							triggerServerEvent("updateInteriorOwner", localPlayer, intID,intType, localPlayer)
							triggerServerEvent("giveInteriorKey",localPlayer,localPlayer,intID)

							if intType == 0 then 
								outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).."Sikeresen vásároltál egy házat. "..color.."("..intCost.." $.)",61,122,188,true)
								outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).."Egy heted van meghosszabbítani az ingatlan lejáratát a városházán!",61,122,188,true)
							elseif intType == 1 then 
								outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).."Sikeresen vásároltál egy bizniszt. "..color.."("..intCost.." $.)",61,122,188,true)
							elseif intType == 4 then 
								outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).."Sikeresen vásároltál egy garázst. "..color.."("..intCost.." $.)",61,122,188,true)
							end
						else
							outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Nincs elég slotod az ingatlan megvásárlásához.",61,122,188,true)
						end
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Nincs nálad elég pénz, hogy megvehesd ezt az ingatlant.",61,122,188,true)
				end
			else
				if intLocked == 0 then
					if isPedInVehicle(localPlayer) and intType == 4 then
                        if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                            local x,y,z = getElementData(theElement,"x"),getElementData(theElement,"y"),getElementData(theElement,"z")
                            local intInt = getElementInterior(theElement)
                            local intDim = getElementDimension(theElement)
                            triggerServerEvent("changeVehInterior",localPlayer,localPlayer,getPedOccupiedVehicle(localPlayer),x,y,z,intInt,intDim)
                            --lockedSound = playSound("files/sounds/intenter.mp3")
							lockedSound = playSound("files/sounds/tp.wav")
                        else
							outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Nem te vagy a jármű vezetője.",61,122,188,true)
                        end
					else
						if not isPedInVehicle(localPlayer) then
							local x,y,z = getElementData(theElement,"x"),getElementData(theElement,"y"),getElementData(theElement,"z")
							local intInt = getElementInterior(theElement)
							local intDim = getElementDimension(theElement)

							triggerServerEvent("changeInterior",localPlayer,localPlayer,x,y,z,intInt,intDim,theElement)
							lockedSound = playSound("files/sounds/tp.wav")

							local newInteriorID = getElementData(theElement, "interiorid") or 0

							for k, v in ipairs(createdAmbientSounds) do 
								if isElement(v) then destroyElement(v) end 
							end
							createdAmbientSounds = {}
							
							if newInteriorID > 0 then
								if customInteriorSoundEffects[newInteriorID] then 
									for k, v in ipairs(customInteriorSoundEffects[newInteriorID]) do 
										local tempsound = playSound3D("files/sounds/custom_interior_sounds/"..newInteriorID.."/"..v[1], v[2], v[3], v[4], v[5])
										setElementDimension(tempsound, intDim)
										setElementInterior(tempsound, intInt)
										setSoundVolume(tempsound, v[7])
										setSoundMaxDistance(tempsound, v[6])
										setSoundMinDistance(tempsound, 0)
										table.insert(createdAmbientSounds, tempsound)
									end
								end

								if intType == 5 then 
									exports.oDrugs:drugFarmEnter(intID)
								end
							end

							--lockedSound = playSound("files/sounds/intenter.mp3")
						else
							outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Csak garázsba mehetsz be járművel.",61,122,188,true)
						end
					end
				else
					if isElement(lockedSound) then
						destroyElement(lockedSound)
					end
					lockedSound = playSound("files/sounds/locked.mp3")
					outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Az ingatlan ajtaja be van zárva.",61,122,188,true)
				end
			end
		end
	end
end

function getPlayerAllOwnedInteriorCount()
	local count = 0
    for k, v in ipairs(getElementsByType("marker")) do 
        if getElementData(v, "isIntMarker") then 
            if getElementData(v, "owner") == getElementData(localPlayer, "char:id") then 
				count = count + 1
            end
        end
    end
	return count
end

function goInteriorWhenSell()
	if isElement(marker) then
		local theElement = getElementData(marker, "other")
		if theElement then
			local intID = getElementData(marker,"dbid")
			local intLocked = getElementData(marker,"locked")
			local intType = getElementData(marker,"inttype")
			local intOwner = getElementData(marker,"owner")
			local intCost = getElementData(marker,"cost")
			if intType >= 0 and intOwner <= 0 then
				if not isPedInVehicle(localPlayer) then
					local x,y,z = getElementData(theElement,"x"),getElementData(theElement,"y"),getElementData(theElement,"z")
					local intInt = getElementInterior(theElement)
					local intDim = getElementDimension(theElement)
					triggerServerEvent("changeInterior",localPlayer,localPlayer,x,y,z,intInt,intDim,theElement)
					lockedSound = playSound("files/sounds/intenter.mp3")
				else
					outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Ez az ingatlan nem egy garázs.",61,122,188,true)
				end
			end
		end
	end
end

function lockInteriorFunctions()
	if isElement(marker) then
		local markID = tonumber(getElementData(marker, "dbid")) or 0
		local markType = tostring(getElementData(marker, "inttype"))
		local markLocked = tonumber(getElementData(marker, "locked")) or 0
		if markID then
			if getElementData(localPlayer, "user:aduty") or exports.oInventory:hasItem(52,markID) or exports.oInventory:hasItem(235,markID) then
				local theElement = getElementData(marker, "other")
				if theElement then
					
					if getElementData(marker,"time") == 0 and getElementData(theElement,"time") == 0 then
					
						if markLocked == 0 then
							if isElement(openCloseSound) then
								destroyElement(openCloseSound)
							end

							local inttype = getElementData(marker,"inttype")
							openCloseSound = playSound("files/sounds/openclose.mp3")
							setElementData(marker, "locked", 1)
							setElementData(theElement, "locked", 1)
							chat:sendLocalMeAction("bezárja egy ingatlan ajtaját. ("..string.gsub(getElementData(marker, "name") or getElementData(theElement, "name"), "_", " ")..")")
							triggerServerEvent("lockIntToClient",localPlayer,localPlayer,tonumber(markID),1)
							return
						else
							if isElement(openCloseSound) then
								destroyElement(openCloseSound)
							end
							openCloseSound = playSound("files/sounds/openclose.mp3")
							setElementData(marker, "locked", 0)
							setElementData(theElement, "locked", 0)
							chat:sendLocalMeAction("kinyitja egy ingatlan ajtaját. ("..string.gsub(getElementData(marker, "name") or getElementData(theElement, "name"), "_", " ")..")")
							triggerServerEvent("lockIntToClient",localPlayer,localPlayer,tonumber(markID),0)
							return
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Nem használhatod az ingatlan zárat még #D23131"..(getElementData(marker, "time") or getElementData(theElement, "time")).."#ffffff percig.",61,122,188,true)
					end
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).."Nincs kulcsod az ingatlanhoz.",61,122,188,true)
			end
		end
	end
end

function dxDrawBorder(x, y, w, h, radius, color)
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

local interiors = {}
local count = 0
local state = false
local maxDist = 16

addEventHandler("onClientElementStreamOut", root,
    function()
        if getElementType(source) == "marker" and getElementData(source, "dbid") then
			if markerCache[source] then
				markerCache[source] = nil;
			end
            --outputChatBox("TÖRLÉS")
            interiors[source] = nil
            local cont = 0
            for k,v in pairs(interiors) do
                count = count + 1
                break
            end
            if count <= 0 then
                if state then
                    --removeEventHandler("onClientRender", root, renderIcons)
                    state = false
                end
            end
        end
    end
)

addEventHandler("onClientElementStreamIn", root,
    function()
        if getElementType(source) == "marker" and getElementData(source, "dbid") and getElementDimension(localPlayer) == getElementDimension(source) then
            if not markerCache[source] then
				markerCache[source] = true;
			end
			
            local pX,pY,pZ = getElementPosition(localPlayer)
            local x,y,z = getElementPosition(source)
            local cont = 0
            for k,v in pairs(interiors) do
                count = count + 1
                break
            end
            interiors[source] = {
                ["position"] = getElementPosition(source),
                ["markType"] = getElementData(source,"inttype"),
				["markOwner"] = getElementData(source,"owner"),
                ["distance"] = getDistanceBetweenPoints3D(pX,pY,pZ,x,y,z),
                --["line"] = isLineOfSightClear(pX,pY,pZ,x,y,z,true,false,false,true,false,false,false),
            }
            if count >= 1 then
                if not state then
                    --addEventHandler("onClientRender", root, renderIcons, true, "low")
                    state = true
                end
            end
        end
    end
)

addEventHandler("onClientElementDataChange", root,
    function(dName, oValue)
        if dName == "owner" and getElementType(source) == "marker" and isElementStreamedIn(source) then
            if getElementType(source) == "marker" and getElementData(source, "dbid") and getElementDimension(localPlayer) == getElementDimension(source) then
                --outputChatBox("HOZZÁADÁS!")
                local pX,pY,pZ = getElementPosition(localPlayer)
                local x,y,z = getElementPosition(source)
                local cont = 0
                for k,v in pairs(interiors) do
                    count = count + 1
                    break
                end
                interiors[source] = {
                    ["position"] = getElementPosition(source),
                    ["markType"] = getElementData(source,"inttype"),
                    ["markOwner"] = getElementData(source,"owner"),
                    ["distance"] = getDistanceBetweenPoints3D(pX,pY,pZ,x,y,z),
                    --["line"] = isLineOfSightClear(pX,pY,pZ,x,y,z,true,false,false,true,false,false,false),
                }
                if count >= 1 then
                    if not state then
                        --addEventHandler("onClientRender", root, renderIcons, true, "low")
                        state = true
                    end
                end
            end 
        end
    end
)

addEventHandler("onClientResourceStart",resourceRoot,function()
	for i = 1, 10 do
		setInteriorFurnitureEnabled(i, false)
	end

	for k,v in ipairs(getElementsByType("marker")) do
		if getElementType(v) == "marker" and getElementData(v, "dbid") and getElementDimension(localPlayer) == getElementDimension(v) then
            --outputChatBox("HOZZÁADÁS!")
            local pX,pY,pZ = getElementPosition(localPlayer)
            local x,y,z = getElementPosition(v)
            local cont = 0
            for k,v in pairs(interiors) do
                count = count + 1
                break
            end
            interiors[v] = {
                ["position"] = getElementPosition(v),
                ["markType"] = getElementData(v,"inttype"),
				["markOwner"] = getElementData(v,"owner"),
                ["distance"] = getDistanceBetweenPoints3D(pX,pY,pZ,x,y,z),
                --["line"] = isLineOfSightClear(pX,pY,pZ,x,y,z,true,false,false,true,false,false,false),
            }
            if count >= 1 then
                if not state then
                    --addEventHandler("onClientRender", root, renderIcons, true, "low")
                    state = true
                end
            end
        end
	end
	
	for k,v in ipairs(getElementsByType("marker")) do
		if getElementType(v) == "marker" and getElementData(v, "dbid") and getElementDimension(localPlayer) == getElementDimension(v) and not markerCache[v] then
			markerCache[v] = true;
        end
	end
	
end)

addEventHandler("onClientElementDestroy", getRootElement(),function()
    if getElementType(source) == "marker" and getElementData(source, "dbid") and getElementDimension(localPlayer) == getElementDimension(source) then
		if markerCache[source] then
			markerCache[source] = nil;
		end
        if interiors[source] then
            interiors[source] = nil
        end
        if marker == source then
            marker = nil
            if renderState then
				destroyRender("renderInteriorPanel")

				
                renderState = false
            end
		    unbindKey("e", "up", bindKeyInteriorFunctions)
		    unbindKey("k", "up", lockInteriorFunctions)
			unbindKey("f", "up", goInteriorWhenSell)
		    setElementData(localPlayer, "isInIntMarker",false)
		    setElementData(localPlayer, "int:Marker", nil)
        end
    end
end)

local renderCache = {}
minus = true
plus = false
progress = 0

setTimer(
    function()
        
        local pX,pY,pZ, _, _, _ = getCameraMatrix()
        
        renderCache = {}
        for v, k in pairs(interiors) do
            if isElementStreamedIn(v) and not renderCache[v] then
                local markX,markY,markZ = getElementPosition(v)
                local markType = k["markType"]
                local markOwner = k["markOwner"]
                local x, y = getScreenFromWorldPosition(markX, markY, markZ+1)
                local distance = getDistanceBetweenPoints3D(markX, markY, markZ, pX, pY, pZ)
                k["distance"] = distance
                --local line = true
                if distance <= 50 then
                    local line = isLineOfSightClear(markX, markY, markZ+1, pX, pY, pZ, true, false, false, true, false, false, false, localPlayer)
                    if line then
                        renderCache[v] = k
                    end
                end
            end
        end
    end, 50, 0
)

textures = {
    ["files/icons/house.png"] = dxCreateTexture("files/icons/house.png", "argb"),
    ["files/icons/goverment.png"] = dxCreateTexture("files/icons/government.png", "argb"),
    ["files/icons/garage.png"] = dxCreateTexture("files/icons/garage.png", "argb"),
    ["files/icons/business.png"] = dxCreateTexture("files/icons/business.png", "argb"),
    ["files/icons/weed.png"] = dxCreateTexture("files/icons/weed.png", "argb"),
    ["elevator"] = dxCreateTexture("files/icons/lift.png", "argb"),
}

tick = getTickCount()

setTimer(function()
		local pX,pY,pZ = getElementPosition(localPlayer)
        
		for v,k in pairs(renderCache) do
            if not isElement(v) then renderCache[v] = nil else
                local markX,markY,markZ = getElementPosition(v)
                local markType = k["markType"]
                local markOwner = k["markOwner"]

				local scale, zplus = interpolateBetween(0.4, 1.2, 0, 0.55, 1.7, 0, (getTickCount() - tick) / 5000, "CosineCurve")

                local x, y = getScreenFromWorldPosition(markX, markY, markZ+zplus)  
                local distance = k["distance"]
                local r, g, b = getMarkerColor(v)
				
                --[[dxDrawRectangle3D(markX-0.5, markY-0.5, markZ+0.35, 1, tocolor(r, g, b, 150 - (0 * 30)), 1)
                dxDrawRectangle3D(markX-0.5, markY-0.5, markZ+0.6, 1, tocolor(r, g, b, 150 - (1 * 30)), 1)
                dxDrawRectangle3D(markX-0.5, markY-0.5, markZ+0.85, 1, tocolor(r, g, b, 150 - (2 * 30)), 1)
                dxDrawRectangle3D(markX-0.5, markY-0.5, markZ+1.05, 1, tocolor(r, g, b, 150 - (3 * 30)), 1)]]

				
				--dxDrawCircle3D(markX, markY, markZ+0.35, 0.5, tocolor(r, g, b, 150 - (30)), 4)

                dxDrawCircle3D(markX, markY, markZ+0.6, scale, tocolor(r, g, b, 150 - (2 * 30)), 3)
                dxDrawCircle3D(markX, markY, markZ+0.75, scale, tocolor(r, g, b, 150 - (3 * 30)), 2)
				dxDrawCircle3D(markX, markY, markZ+0.9, scale, tocolor(r, g, b, 150 - (4 * 30)), 1)
				

				--[[
				dxDrawOctagon3D(markX, markY, markZ+0.35, 0.5, 1, tocolor(r, g, b, 150 - (0 * 30)))
                dxDrawOctagon3D(markX, markY, markZ+0.6, 0.5, 1, tocolor(r, g, b, 150 - (1 * 30)))
                dxDrawOctagon3D(markX, markY, markZ+0.85, 0.5, 1, tocolor(r, g, b, 150 - (2 * 30)))
				dxDrawOctagon3D(markX, markY, markZ+1.05, 0.5, 1, tocolor(r, g, b, 150 - (3 * 30)))
				]]

                if (x) and (y) then

                    local size = interpolateBetween(40,0,0, 40 - distance/1.4,0,0, k["distance"], "Linear")

                    if markType == 0 and markOwner <= 0 then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/house.png"],0,0,90, tocolor(95, 161, 108,200),false)
                    elseif markType == 0 and markOwner >= 1 then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/house.png"],0,0,90, tocolor(204, 129, 49,200),false)
                    elseif markType == 2 and markOwner <= 0 then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/goverment.png"],0,0,0, tocolor(204, 72, 49,200),false)
                    elseif markType == 4 and markOwner <= 0 then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/garage.png"],0,0,0, tocolor(95, 161, 108, 200),false)
                    elseif markType == 4 and markOwner >= 1 then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/garage.png"],0,0,0, tocolor(43, 158, 171, 200),false)
                    elseif markType == 1 and markOwner >= 1 then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/business.png"],0,0,0, tocolor(248, 126, 136, 200),false)
                    elseif markType == 1 and markOwner <= 0 then
                    	dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/business.png"],0,0,0, tocolor(124, 197, 118, 200),false)
					elseif markType == 5 and markOwner <= 0 then
                    	dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/weed.png"],0,0,0, tocolor(124, 197, 118, 200),false)
					elseif markType == 5 and markOwner >= 1 then
                    	dxDrawImage(x-size/2,y-size/2,size,size,textures["files/icons/weed.png"],0,0,0, tocolor(204, 87, 55, 200),false)
                   end
                end
            end
		end
end,5,0) 

function playSoundClient(sound, x, y, z, int, dim)
	theSound = playSound3D(sound, x, y, z)
	setElementDimension(theSound, dim)
	setElementInterior(theSound, int)
	setSoundMaxDistance(theSound, 30)
end
addEvent("playSoundClient", true)
addEventHandler("playSoundClient", getRootElement(), playSoundClient)


function dxDrawCircle3D( x, y, z, radius, color, width )
    local playerX,playerY,playerZ = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,x, y, z) <= 50 then
        segments = segments or 16;
        color = color or tocolor( 248, 126, 136, 200 );  
        width = width or 1; 
        local segAngle = 360 / segments; 
        local fX, fY, tX, tY;  
        local alpha = 20
        for i = 1, segments do 
            fX = x + math.cos( math.rad( segAngle * i ) ) * radius; 
            fY = y + math.sin( math.rad( segAngle * i ) ) * radius; 
            tX = x + math.cos( math.rad( segAngle * (i+1) ) ) * radius;  
            tY = y + math.sin( math.rad( segAngle * (i+1) ) ) * radius; 
            dxDrawLine3D( fX, fY, z, tX, tY, z, color, width);
        end
     end    
end

function dxDrawRectangle3D(x,y,z,r,color,w)
    dxDrawLine3D (x,y,z,x+r,y,z,color,w)
    dxDrawLine3D (x,y,z,x,y+r,z,color,w)
    dxDrawLine3D (x+r,y,z,x+r,y+r,z,color,w)
    dxDrawLine3D (x,y+r,z,x+r,y+r,z,color,w)
end

function dxDrawOctagon3D(x, y, z, radius, width, color)
	if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
		return false
	end

	local radius = radius or 1
	local radius2 = radius/math.sqrt(2)
	local width = width or 1
	local color = color or tocolor(255,255,255,150)

	point = {}

		for i=1,8 do
			point[i] = {}
		end

		point[1].x = x
		point[1].y = y-radius
		point[2].x = x+radius2
		point[2].y = y-radius2
		point[3].x = x+radius
		point[3].y = y
		point[4].x = x+radius2
		point[4].y = y+radius2
		point[5].x = x
		point[5].y = y+radius
		point[6].x = x-radius2
		point[6].y = y+radius2
		point[7].x = x-radius
		point[7].y = y
		point[8].x = x-radius2
		point[8].y = y-radius2
		
	for i=1,8 do
		if i ~= 8 then
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[i+1].x,point[i+1].y,z
		else
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[1].x,point[1].y,z
		end
		dxDrawLine3D(x, y, z, x2, y2, z2, color, width)
	end
	return true
end

function findInteriorOwnerByDbid(dbid)
	for v,k in pairs(markerCache) do
		if getElementData(v,"dbid") == dbid then
			return true,getElementData(v,"owner");
		end
	end
	return false,-1
end

function isInteriorOwner(dbid)
	for v,k in pairs(markerCache) do
		if getElementData(v,"dbid") == dbid and getElementData(v,"owner") == getElementData(localPlayer,"player:dbid") then
			return true;
		end
	end
	return false;
end

local admin = exports.oAdmin

--[[admin:addAdminCMD("createinterior", 7, "Interior létrehozása")
admin:addAdminCMD("delinterior", 7, "Interior törlése")
admin:addAdminCMD("setinteriorname", 4, "Interior nevének módosítása")
admin:addAdminCMD("setinteriorcost", 7, "Interior árának módosítása")
admin:addAdminCMD("getinteriorcost", 4, "Interior alapárának lekérése")
admin:addAdminCMD("asellint", 7, "Interior eladóvá tétele")
admin:addAdminCMD("gotohouse", 3, "Interiorhoz teleportálás")
admin:addAdminCMD("setinteriorid", 7, "Interior IDjének beállítása")
admin:addAdminCMD("setinteriorexit", 7, "Interior kilépési pozíciójának állítása")
admin:addAdminCMD("addelevator", 7, "Lift létrehozása")
admin:addAdminCMD("delelevator", 7, "Lift törlése")]]



local panelWidth, panelHeight = 500, 190
local panelX, panelY = sX/2 - panelWidth/2, sY/2 - panelHeight/2
local panelState = false
local renewalInteriors = {}
local inBox = false
local minLines = 1
local maxLines = 0
local interiorPrice = 0
local pedPosX, pedPosY, pedPosZ = 0, 0, 0
local playerPosX, playerPosY, playerPosZ = 0, 0, 0
local element = false
local startTick = false
local animState = "show"
--[[
addEventHandler("onClientClick", getRootElement(), function(button, state, abx, aby, worldx, worldy, worldz, clickElement)
	if clickElement and getElementData(clickElement, "renewalPed") then 
		if button == "right" and state == "down" then 
			if not panelState then 
				pedPosX, pedPosY, pedPosZ = getElementPosition(clickElement)
				playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
				element = clickElement
				if getDistanceBetweenPoints3D(pedPosX, pedPosY, pedPosZ, playerPosX, playerPosY, playerPosZ) <= 3 then
					--outputChatBox("asd")
					interiorCount = 0 
					renewalInteriors = {}
					--panelState = true
					for k,v in ipairs(getElementsByType("marker")) do 
						if getElementData(v,"isIntMarker") then
							if (tonumber(getElementData(v, "owner")) == tonumber(getElementData(localPlayer, "char:id"))) then
								interiorCount = interiorCount + 1
								--outputChatBox(k)
								--if getElementData(v, "renewalTime") then 
								--interiorPrice = 
								table.insert(renewalInteriors, {getElementData(v, "dbid"), getElementData(v, "name"), getElementData(v, "renewalTime"), getElementData(v, "cost")})
							end
						end
					end
					if interiorCount > 0 then
						startTick = getTickCount() 
						animState = "show"
						panelState = true
						addEventHandler("onClientRender", getRootElement(), drawPropertyRenewal)
						minLines = 1
						maxLines = 4
					end
					if interiorCount <= 0 then 
						outputChatBox(serverSyntax.." Nincs egy ingatlanod se.", 255, 255, 255, true)
						return
					end
				end
			end
		end
	end
	if button == "left" and state == "down" and panelState then 
		local startY = panelY + 20
		for k = minLines, maxLines do 
			local data = renewalInteriors[k]
			if exports["oCore"]:isInSlot(panelX+panelWidth - 120 - 5,startY+7, 120, 30) then 
				--outputChatBox(data[1])
				triggerServerEvent("renewalInterior", localPlayer, data[1], localPlayer, math.ceil(data[4]/100*2))
				animState = "hide"
				startTick = getTickCount() 
			end
			startY = startY + 42
		end
	end
end)]]

addEventHandler("onClientKey", getRootElement(), function(button, state)
	if button == "mouse_wheel_down"  then 
		if state then 
			if inBox and panelState then
				scrollDown()
			end
		end
	end
	if button == "mouse_wheel_up" then 
		if state then 
			if inBox  and panelState then
				scrollUP()
			end
		end
	end	
	if button == "backspace" then 
		if state then 
			if panelState then
				animState = "hide"
				startTick = getTickCount() 
			end
		end
	end
end)


function drawPropertyRenewal()
	local nowTick = getTickCount()
    if animState == "show" then
		local progress = (nowTick - startTick) / 250
		if progress < 1 then
		  alpha = interpolateBetween(
			0, 0, 0,
			1, 0, 0,
			progress, "Linear"
		  )
		else
		  alpha = 1
		  progress = 1 
		end
	   -- outputChatBox(progress)
	  elseif animState == "hide" then
		local progress = (nowTick - startTick) / 250
		if progress < 1 then
		  alpha = interpolateBetween(
			1, 0, 0,
			0, 0, 0,
			progress, "Linear"
		  )
		else
		  --animState =
		  alpha = 0
		  progress = 1
		end
		--outputChatBox(progress)
		if progress >= 1 then 
		
			panelState = false
			removeEventHandler("onClientRender", getRootElement(), drawPropertyRenewal)
		end
	  end

	--if getElementData(localPlayer, "char:name") == "Dexter_Power" then
		exports["oCore"]:drawWindow(panelX, panelY, panelWidth, panelHeight, color .."Ingatlan bejelentés",alpha)
		if exports["oCore"]:isInSlot(panelX, panelY, panelWidth, panelHeight) then 
			inBox = true
		else 
			inBox = false
		end

		local startY = panelY + 20
		for k = minLines, maxLines do 
			local data = renewalInteriors[k]
			dxDrawImage(panelX+2.5, startY+2.5, panelWidth - 5, 40, "files/test.png", 0,0,0,tocolor(r,g,b,40*alpha))
		--	dxDrawRectangle(panelX+2.5, startY+2.5, panelWidth - 5, 40, tocolor(30,30,30,150*alpha))
		--	dxDrawRectangle(panelX+2, startY+2.5, 2, 40, tocolor(r,g,b,150*alpha))
			if data then
				dxDrawText("[ID: "..data[1] .. "]\n"..data[2], panelX +10, startY+2.5+5, 0, 0, tocolor(255,255,255,255*alpha),0.75,notificationFont)
				if exports["oCore"]:isInSlot(panelX+panelWidth - 120 - 5,startY+7, 120, 30) then 
					exports["oCore"]:dxDrawButton(panelX+panelWidth - 120 - 5,startY+7, 120, 30, r, g, b, 150*alpha, math.ceil(data[4]/100*2) .. "$", tocolor(255,255,255,255*alpha),0.85,notificationFont, true, tocolor(0,0,0,255*alpha))
				else
					exports["oCore"]:dxDrawButton(panelX+panelWidth - 120 - 5,startY+7, 120, 30, r, g, b, 150*alpha, "Bejelentés", tocolor(255,255,255,255*alpha),0.85,notificationFont, true, tocolor(0,0,0,255*alpha))
				end
				dxDrawText("Lejárati dátum: #eb5146"..formatDate("Y-m-d", "'", tostring(data[3])), sX/2, startY+2.5+12, sX/2, 0, tocolor(255,255,255,255*alpha),0.75,notificationFont, "center", "top", false, false, false, true)
			end
			startY = startY + 42
		end

		local percent = #renewalInteriors
		if percent >= 1 then
			local gW, gH = 3, panelHeight - 38
			local gX, gY = panelX + panelWidth, panelY +30


			local multiplier = math.min(math.max((maxLines - (minLines - 1)) / percent, 0), 1)
			local multiplier2 = math.min(math.max((minLines - 1) / percent, 0), 1)
			local gY = gY + ((gH) * multiplier2)
			local gH = gH * multiplier

			dxDrawRectangle(panelX + panelWidth, panelY +30, 3, panelHeight - 38, tocolor(30,30,30, 150*alpha))
			dxDrawRectangle(gX, gY, gW, gH, tocolor(r, g, b, 150*alpha))
			
		end
	--end
end

function scrollDown()
	if maxLines + 1 <= #renewalInteriors then
        minLines = minLines + 1
        maxLines = maxLines + 1
    end
end

function scrollUP()
    if minLines - 1 >= 1 then
        minLines = minLines - 1
        maxLines = maxLines - 1
    end
end

local weekDays = {"Vasárnap", "Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek", "Szombat"}

function formatDate(format, escaper, timestamp)
	escaper = escaper or "'"
	escaper = string.sub(escaper, 1, 1)

	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false

	time.year = time.year + 1900
	time.month = time.month + 1
	
	local datetime = {
		d = string.format("%02d", time.monthday),
		h = string.format("%02d", time.hour),
		i = string.format("%02d", time.minute),
		m = string.format("%02d", time.month),
		s = string.format("%02d", time.second),
		w = string.sub(weekDays[time.weekday + 1], 1, 2),
		W = weekDays[time.weekday + 1],
		y = string.sub(tostring(time.year), -2),
		Y = time.year
	}
	
	for char in string.gmatch(format, ".") do
		if char == escaper then
			escaped = not escaped
		else
			formattedDate = formattedDate .. (not escaped and datetime[char] or char)
		end
	end
	
	return formattedDate
end


-- render

renderTimers = {}

function createRender(id, func)
    if not isTimer(renderTimers[id]) then
        renderTimers[id] = setTimer(func, 5, 0)
    end
end

function destroyRender(id)
    if isTimer(renderTimers[id]) then
        killTimer(renderTimers[id])
        renderTimers[id] = nil
        collectgarbage("collect")
    end
end

function checkRender(id)
    return renderTimers[id]
end