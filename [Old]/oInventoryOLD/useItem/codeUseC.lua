if fileExists("useItem/codeUseC.lua") then
	fileDelete("useItem/codeUseC.lua")
end

local s = {guiGetScreenSize()}
local box = {46,46}
local panel = {s[1]/2 -box[1]/2,s[2]/1.27 - box[2]/1.27}
local hasznalhat = false

function outputMeMessage(msg)
	exports.oChat:sendLocalMeAction(msg)
end

function givePlayerArmor(num)
	triggerServerEvent("givePlayerArm",localPlayer,localPlayer,num)
end

local core = exports.oCore

local kajalas = false

local weapon_timer

local badge_timer = false
local gyogyszer_timer = false
local policeLight_timer = false

local lastLuckyGame = 0
local lastFuelCan = 0
local lastCigaret = 0
local lastCigaretUseage = 0

function useItem(itemData,itemSlot)
	if (itemData) then
		if not getElementData(localPlayer,"toggleBinds") then
			if getElementData(localPlayer, "cuff:cuffed") then return end
			local itemName = ""
			if #itemData["name"] <= 0 then 
				itemName = getItemName(itemData["id"],tonumber(itemData["value"]))
			else
				itemName = itemData["name"]
			end
			if itemData["id"] == 1 then
				exports.oPhone:setPhoneVisible(itemData["value"])
			elseif itemData["id"] >= 2 and itemData["id"] <= 18 then -- kaják
				if not kajalas then 
					if itemData["count"] == 1 then 
						if getElementData(localPlayer,"char:hunger") >= 100 then 
							outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Jelenleg nem vagy éhes!", 61, 122, 188, true)
						else
							if tonumber(itemData["value"]) > 1 then 
								setItemValue(itemSlot, tonumber(itemData["value"])-1)
							else
								delItem(itemSlot)
							end
							foodAmount = math.random(5,10)
							kajalas = true
							if tonumber(getElementData(localPlayer,"char:hunger"))+foodAmount > 100 then
								setElementData(localPlayer,"char:hunger",100)
							else
								setElementData(localPlayer,"char:hunger",getElementData(localPlayer,"char:hunger")+foodAmount)
							end
							triggerServerEvent("itemAnims",localPlayer,localPlayer,1)

							local attachedObjectID = 2703 

							if itemData["id"] == 4 then 
								attachedObjectID = 2769
							elseif itemData["id"] == 5 then 
								attachedObjectID = 2702
							elseif itemData["id"] == 3 then 
								attachedObjectID = 2769 
							end

							triggerServerEvent("attachItemPlayer",root,localPlayer,attachedObjectID)
							outputMeMessage("eszik egy "..getItemName(itemData["id"],1).."-(e)t.")
							setTimer(function() kajalas = false triggerServerEvent("detachItemPlayer",root,localPlayer) end, 4250, 1)
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Csak úgy eheted meg, ha csak egy darab van belőle egy sloton.", 61, 122, 188, true)
					end
				end
			elseif itemData["id"] >= 19 and  itemData["id"] <= 26  then -- italok
				if not kajalas then 
					if itemData["count"] == 1 then 
						if getElementData(localPlayer,"char:thirst") >= 100 then 
							outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Jelenleg nem vagy szomjas!", 61, 122, 188, true)
						else
							if tonumber(itemData["value"]) > 1 then 
								setItemValue(itemSlot, tonumber(itemData["value"])-1)
							else
								delItem(itemSlot)
							end
							drinkAmount = math.random(5,12)
							kajalas = true

							if tonumber(getElementData(localPlayer,"char:thirst"))+drinkAmount > 100 then
								setElementData(localPlayer,"char:thirst",100)
							else
								setElementData(localPlayer,"char:thirst",getElementData(localPlayer,"char:thirst")+drinkAmount)
							end

							triggerServerEvent("itemAnims",localPlayer,localPlayer,2)

							local attachedObjectID = 1546 

							if itemData["id"] == 21 then 
								attachedObjectID = 2647
							elseif itemData["id"] == 24 then 
								attachedObjectID = 1543 
							elseif itemData["id"] == 25 then
								attachedObjectID = 1509  
							end

							triggerServerEvent("attachItemPlayer",root,localPlayer,attachedObjectID)

							outputMeMessage("iszik egy "..getItemName(itemData["id"],1).."-(e)t.")
							setTimer(function() 
								kajalas = false 
								triggerServerEvent("detachItemPlayer",root,localPlayer) 
								setPedAnimation(localPlayer, "", "")
								triggerServerEvent("itemAnims",localPlayer,localPlayer, 0) 
							end, 1500, 1)
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Csak úgy ihatod meg, ha csak egy darab van belőle egy sloton.", 61, 122, 188, true)
					end
				end
			elseif itemData["id"] == 55 then -- joint
				if hasItem(72) then 
					if exports.oDrugs:useDrug("joint") then 
						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						outputMeMessage("elszívott egy füves cigit.")
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Nincs nálad öngyújtó.", 61, 122, 188, true)
				end
			elseif itemData["id"] == 56 then -- heroin
				if exports.oDrugs:useDrug("heroin") then 
					if tonumber(itemData["count"]) > 1 then 
						setItemCount(itemSlot, tonumber(itemData["count"])-1)
					else
						delItem(itemSlot)
					end

					outputMeMessage("injekciót ad magának egy heroinos fecskendővel.")
				end
			elseif itemData["id"] == 57 then -- kokain 
				if exports.oDrugs:useDrug("cocaine") then 
					if tonumber(itemData["count"]) > 1 then 
						setItemCount(itemSlot, tonumber(itemData["count"])-1)
					else
						delItem(itemSlot)
					end

					outputMeMessage("felszívott egy kis kokaint.")
				end
			elseif itemData["id"] == 58 then -- marihuana 
				if exports.oDrugs:useDrug("marihuana") then 
					if tonumber(itemData["count"]) > 1 then 
						setItemCount(itemSlot, tonumber(itemData["count"])-1)
					else
						delItem(itemSlot)
					end

					outputMeMessage("felszívott egy kis szárított marihuanát.")
				end
			elseif itemData["id"] == 65 then
				local state = exports.oLicenses:toggleCard(65, itemData["value"], itemData["dbid"]) 
				if not state then 
					chat:sendLocalMeAction("elrak egy személyi igazolványt.")
					setElementData(localPlayer, "active:itemValue", false)
				else
					chat:sendLocalMeAction("elővesz egy személyi igazolványt.")
					setElementData(localPlayer, "active:itemValue", itemData["value"])
				end
			elseif itemData["id"] == 66 then
				local state = exports.oLicenses:toggleCard(66, itemData["value"], itemData["dbid"]) 
				if not state then 
					chat:sendLocalMeAction("elrak egy vezetői engedélyt.")
					setElementData(localPlayer, "active:itemValue", false)
				else
					chat:sendLocalMeAction("elővesz egy vezetői engedélyt.")
					setElementData(localPlayer, "active:itemValue", itemData["value"])
				end
			elseif itemData["id"] == 68 then
				local state = exports.oLicenses:toggleCard(68, itemData["value"], itemData["dbid"]) 
				if not state then 
					chat:sendLocalMeAction("elrak egy fegyver engedélyt.")
					setElementData(localPlayer, "active:itemValue", false)
				else
					chat:sendLocalMeAction("elővesz egy fegyver engedélyt.")
					setElementData(localPlayer, "active:itemValue", itemData["value"])
				end
			elseif itemData["id"] == 69 then 
				if not isTimer(badge_timer) then 
					if getElementData(localPlayer, "badgeInUse") then 
						triggerServerEvent("setPlayerBadge", resourceRoot, false, "nan")
						chat:sendLocalMeAction("levesz egy jelvényt.")
					else
						triggerServerEvent("setPlayerBadge", resourceRoot, true, itemData["value"])
						chat:sendLocalMeAction("felvesz egy jelvényt.")
					end

					badge_timer = setTimer(function()
						if isTimer(badge_timer) then 
							killTimer(badge_timer)
						end
					end, 500, 1)
				end
			elseif itemData["id"] == 71 then 
				if lastCigaretUseage + 1000 > getTickCount() then return end 
				if kajalas then return end

				lastCigaretUseage = getTickCount()

				if tonumber(itemData["value"]) > 1 then 
					setItemValue(itemSlot, tonumber(itemData["value"])-1)
				else
					delItem(itemSlot)
				end

				chat:sendLocalMeAction("beleszív egy slukkot a cigarettába.")

				if not getPedOccupiedVehicle(localPlayer) then 
					triggerServerEvent("itemAnims", localPlayer, localPlayer, 3)
					triggerServerEvent("attachItemPlayer",root,localPlayer, 9891)

					kajalas = true
					setTimer(function() kajalas = false triggerServerEvent("detachItemPlayer",root,localPlayer) end, 6000, 1)
				end
			elseif itemData["id"] == 73 then 
				if not elementInProtectedPlace(localPlayer) then 
					if not getPedOccupiedVehicle(localPlayer) then 
						local playerPos = Vector3(getElementPosition(localPlayer))
						
						local placeEnabled = true
						for k, v in ipairs(getElementsByType("object")) do 
							if core:getDistance(v, localPlayer) < 10 then 
								if getElementData(v, "isHifi") then 
									placeEnabled = false 
									break 
								end
							end
						end

						if placeEnabled then 
							delItem(itemSlot)
							chat:sendLocalMeAction("lerak egy hifit.")
							triggerServerEvent("createHifi", resourceRoot)
						else
							outputChatBox(core:getServerPrefix("red-dark", "Hifi", 2).."Már van a közeledben elhelyezett hifi!", 255, 255, 255, true)
						end
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Hifi", 2).."Védett helyen nem helyezheted le a hifit!", 255, 255, 255, true)
				end
			elseif itemData["id"] == 74 then 
				if (activeWeaponSlot == itemSlot) or (activeWeaponSlot == -1) then
					if not isTimer(weapon_timer) then 
						weapon_timer = setTimer(function() 
							if isTimer(weapon_timer) then 
								killTimer(weapon_timer)
							end
						end, 500, 1)

						if getElementData(localPlayer, "hasFishingRod") then 
							chat:sendLocalMeAction("elrak egy horgászbotot.")
							activeWeaponSlot = -1
						else
							if not getPedOccupiedVehicle(localPlayer) then 
								chat:sendLocalMeAction("elővesz egy horgászbotot.")
								activeWeaponSlot = itemSlot
							else
								return
							end
						end

						triggerServerEvent("giveFishingRod", resourceRoot)
					end
				end
			elseif itemData["id"] == 76 then 
				if not isTimer(gyogyszer_timer) then 
					if getElementHealth(localPlayer) < 95 then 

						setElementHealth(localPlayer, getElementHealth(localPlayer) + 35)
						setElementData(localPlayer, "char:health", getElementHealth(localPlayer))
						chat:sendLocalMeAction("bevett egy gyógyszert.")

						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						gyogyszer_timer = setTimer(function()
							if isTimer(gyogyszer_timer) then 
								killTimer(gyogyszer_timer)
							end
						end, core:minToMilisec(5), 1)
					else
						outputChatBox(core:getServerPrefix("red-dark", "Gyógyszer", 3).."Nincs szükséged gyógyszerre.", 255, 255, 255, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Gyógyszer", 3).."Csak "..core:getServerColor().."5 #ffffffpercenként használhatsz gyógyszert.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 79 then
				local state = exports.oLicenses:toggleCard(79, itemData["value"], itemData["dbid"]) 
				if not state then 
					chat:sendLocalMeAction("elrak egy vadászati engedélyt.")
					setElementData(localPlayer, "active:itemValue", false)
				else
					chat:sendLocalMeAction("elővesz egy vadászati engedélyt.")
					setElementData(localPlayer, "active:itemValue", itemData["value"])
				end
			elseif itemData["id"] == 82 then 
				if not getPedOccupiedVehicle(localPlayer) then return end

				if (((getElementData(localPlayer, "lastFixCardUse") or 0) + 120000) < getTickCount() )then 
					if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						triggerServerEvent("inv > unflipVehicle", resourceRoot, getPedOccupiedVehicle(localPlayer))

						setElementData(localPlayer, "lastFixCardUse", getTickCount())
						chat:sendLocalMeAction("felhasznált egy unflip kártya.")
					else
						outputChatBox(core:getServerPrefix("red-dark", "Unflip kártya", 2).."Ez a művelet csak vezető ülésben működik.", 255, 255, 255, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Prémium kártya", 2).."Az előző használat óta nem telt még el "..color.."2 #ffffffperc.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 83 then 
				if isTimer(policeLight_timer) then return end
				if not getPedOccupiedVehicle(localPlayer) then return end 
				if getPedOccupiedVehicleSeat(localPlayer) >= 2 then return end
				if itemData["value"] == 2 then 
					if exports.oFactionScripts:removePoliceLightFromOccupiedVehicle() then
						chat:sendLocalMeAction("levett a jármű tetejéről egy rendőrségi villogót.")
						setItemValue(itemSlot, 1)
						policeLight_timer = setTimer(function()
							if isTimer(policeLight_timer) then killTimer(policeLight_timer) end
						end, 1000, 1)
					end
				else 
					if exports.oFactionScripts:applyPoliceLightToOccupiedVehicle() then 
						chat:sendLocalMeAction("feltett a jármű tetejére egy rendőrségi villogót.")
						setItemValue(itemSlot, 2)
						policeLight_timer = setTimer(function()
							if isTimer(policeLight_timer) then killTimer(policeLight_timer) end
						end, 1000, 1)
					end
				end
			elseif itemData["id"] == 89 then 
				if getElementData(localPlayer, "playerInDead") then 
					outputChatBox(core:getServerPrefix("red-dark", "Gyógyítás kártya", 2).."Ez a kártya halál közben nem használható.", 255, 255, 255, true)
					return
				end

				if (((getElementData(localPlayer, "lastFixCardUse") or 0) + 120000) < getTickCount() )then 
					if tonumber(itemData["count"]) > 1 then 
						setItemCount(itemSlot, tonumber(itemData["count"])-1)
					else
						delItem(itemSlot)
					end

					triggerServerEvent("inv > userInstantHealCard", resourceRoot)

					setElementData(localPlayer, "lastFixCardUse", getTickCount())
					chat:sendLocalMeAction("felhasznált egy instant gyógyítás kártyát.")
				else
					outputChatBox(core:getServerPrefix("red-dark", "Prémium kártya", 2).."Az előző használat óta nem telt még el "..color.."2 #ffffffperc.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 90 then 
				if not getPedOccupiedVehicle(localPlayer) then return end

				if (((getElementData(localPlayer, "lastFixCardUse") or 0) + 120000) < getTickCount() )then 
					if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						triggerServerEvent("inv > fixVehicle", resourceRoot, getPedOccupiedVehicle(localPlayer))

						setElementData(localPlayer, "lastFixCardUse", getTickCount())
						chat:sendLocalMeAction("felhasznált egy prémium szerelőládát.")
					else
						outputChatBox(core:getServerPrefix("red-dark", "Szerelőláda", 2).."Ez a művelet csak vezető ülésben működik.", 255, 255, 255, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Prémium kártya", 2).."Az előző használat óta nem telt még el "..color.."2 #ffffffperc.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 91 then 
				if not getPedOccupiedVehicle(localPlayer) then return end

				if (((getElementData(localPlayer, "lastFixCardUse") or 0) + 120000) < getTickCount() )then 
					if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						triggerServerEvent("inv > fuelVehicle", resourceRoot, getPedOccupiedVehicle(localPlayer))

						setElementData(localPlayer, "lastFixCardUse", getTickCount())
						chat:sendLocalMeAction("felhasznált egy instant tankolás kártyát.")
					else
						outputChatBox(core:getServerPrefix("red-dark", "Instant tankolás kártya", 2).."Ez a művelet csak vezető ülésben működik.", 255, 255, 255, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Prémium kártya", 2).."Az előző használat óta nem telt még el "..color.."2 #ffffffperc.", 255, 255, 255, true)
				end
			elseif itemData["id"] >= 112 and itemData["id"] <= 114 then 
				if lastCigaret + 1000 > getTickCount() then return end 

				lastCigaret = getTickCount()

				if tonumber(itemData["value"]) > 1 then 
					setItemValue(itemSlot, tonumber(itemData["value"])-1)
				else
					delItem(itemSlot)
				end
				
				giveItem(71, 5, 1, 0)

				chat:sendLocalMeAction("kihúzott egy szál cigarettát egy "..getItemName(itemData["id"]).." dobozból.")
			elseif itemData["id"] == 115 then
				if not getPedOccupiedVehicle(localPlayer) then return end

				if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
					if getElementData(getPedOccupiedVehicle(localPlayer), "veh:protected") == 0 then 
						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						setElementData(getPedOccupiedVehicle(localPlayer), "veh:protected", 1)

						outputChatBox(core:getServerPrefix("green-dark", "Prémium Jármű Protect Kártya", 2).."Sikeresen leprotectelted a járművet.", 255, 255, 255, true)
					else
						outputChatBox(core:getServerPrefix("red-dark", "Prémium Jármű Protect Kártya", 2).."Ez a jármű már protectes.", 255, 255, 255, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Prémium Jármű Protect Kártya", 2).."Ez a művelet csak vezető ülésben működik.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 149 then
				exports.oJob_Newspaper:showNote() 
			elseif itemData["id"] == 150 then 
				if not isTimer(gyogyszer_timer) then 
					if getElementHealth(localPlayer) < 95 then 

						setElementHealth(localPlayer, getElementHealth(localPlayer) + 15)
						setElementData(localPlayer, "char:health", getElementHealth(localPlayer))
						chat:sendLocalMeAction("bevett egy vitamint.")

						if tonumber(itemData["count"]) > 1 then 
							setItemCount(itemSlot, tonumber(itemData["count"])-1)
						else
							delItem(itemSlot)
						end

						gyogyszer_timer = setTimer(function()
							if isTimer(gyogyszer_timer) then 
								killTimer(gyogyszer_timer)
							end
						end, core:minToMilisec(5), 1)
					else
						outputChatBox(core:getServerPrefix("red-dark", "Vitamin", 3).."Nincs szükséged vitaminra.", 255, 255, 255, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Vitamin", 3).."Csak "..core:getServerColor().."5 #ffffffpercenként használhatsz vitamint.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 151 then 
				triggerServerEvent("inv > setPedArmor", resourceRoot, 100)

				chat:sendLocalMeAction("felvett egy golyóálló mellényt.")

				if tonumber(itemData["count"]) > 1 then 
					setItemCount(itemSlot, tonumber(itemData["count"])-1)
				else
					delItem(itemSlot)
				end
			elseif itemData["id"] == 171 then  
				if getElementDimension(localPlayer) > 0 then 
					delItem(itemSlot)
					triggerServerEvent("inv > createPot", resourceRoot, {{getElementPosition(localPlayer)}, getElementDimension(localPlayer), getElementInterior(localPlayer)})
					chat:sendLocalMeAction("lerakott egy cserepet.")
				else
					outputChatBox(core:getServerPrefix("red-dark", "Cserép", 3).."Csak interiorban rakhatsz le cserepet!", 255, 255, 255, true) 
				end
				return
			elseif itemData["id"] == 179 then -- dobókocka
				if lastLuckyGame + 4000 < getTickCount() then 
					lastLuckyGame = getTickCount()
					chat:sendLocalMeAction("dobott egy dobókockával. A dobás eredménye: "..math.random(1, 6)..".")
					triggerServerEvent("inv > playLuckGameSound", resourceRoot, "dice.mp3", getElementPosition(localPlayer))
				else
					outputChatBox(core:getServerPrefix("red-dark", "Dobókocka", 3).."Csak "..core:getServerColor().."4 #ffffffmásodpercenként dobhatsz a dobókockával.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 180 then -- kártyapakli
				if lastLuckyGame + 4000 < getTickCount() then 
					lastLuckyGame = getTickCount()

					local cardValues = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "K", "Q"}
					chat:sendLocalMeAction("kihúzott egy lapot egy pakliból. A húzott lap: "..cardValues[math.random(#cardValues)]..".")
					triggerServerEvent("inv > playLuckGameSound", resourceRoot, "card.mp3", getElementPosition(localPlayer))
				else
					outputChatBox(core:getServerPrefix("red-dark", "Dobókocka", 3).."Csak "..core:getServerColor().."4 #ffffffmásodpercenként húzhatsz kártyát a pakliból.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 181 then -- érme
				if lastLuckyGame + 4000 < getTickCount() then 
					lastLuckyGame = getTickCount()

					local coinValues = {"fej", "írás"}
					chat:sendLocalMeAction("feldobott egy pénzérmét: "..coinValues[math.random(#coinValues)]..".")
					triggerServerEvent("inv > playLuckGameSound", resourceRoot, "coin.wav", getElementPosition(localPlayer))
				else
					outputChatBox(core:getServerPrefix("red-dark", "Dobókocka", 3).."Csak "..core:getServerColor().."4 #ffffffmásodpercenként dobhatod fel a pénzérmét.", 255, 255, 255, true)
				end
			elseif itemData["id"] == 183 or itemData["id"] == 184 then
				if lastFuelCan + 1000 < getTickCount() then 
					lastFuelCan = getTickCount()
					local fuelType = ""

					if itemData["id"] == 183 then 
						fuelType = "D"
					else
						fuelType = "95"
					end

					triggerServerEvent("inv > takePetrolCan", resourceRoot)

					local petrolCan = getElementData(localPlayer, "activePetrolCan") or false
					if isElement(petrolCan) then 
						exports.oFuel:destroyFuelMarker()
						activeWeaponSlot = -1

						if getElementData(localPlayer, "availableFuelInCan") == 0 then
							delItem(itemSlot)
						else
							setItemValue(itemSlot, getElementData(localPlayer, "availableFuelInCan"))
						end
						outputMeMessage("eltett egy üzemanyag kannát.")
					else
						exports.oFuel:createFuelMarker()
						setElementData(localPlayer, "petrolCanType", fuelType)
						setElementData(localPlayer, "availableFuelInCan", tonumber(itemData["value"]))
						activeWeaponSlot = itemSlot
						outputMeMessage("elővett egy üzemanyag kannát.")
					end
				end
			elseif items[itemData["id"]].isWeapon then
				if not isTimer(weapon_timer) then 
					weapon_timer = setTimer(function() 
						if isTimer(weapon_timer) then 
							killTimer(weapon_timer)
						end
					end, 700, 1)
					--toggleControl("fire",true)
					--toggleControl("action",true)
					setElementData(localPlayer,"handTaser",false)
					if activeWeaponSlot == itemSlot then
						activeWeaponSlot = -1
						activeAmmoSlot = - 1
						triggerServerEvent("addAttachWeapon",localPlayer,localPlayer,itemData["id"],itemData["value"],itemData["dbid"])
						outputMeMessage("elrakott egy fegyvert. ("..itemName..")")
						triggerServerEvent("elveszfegyot", localPlayer, localPlayer,weaponIndexByID[itemData["id"]],tonumber(itemData["value"]))
						setElementData(localPlayer,"active:weaponSlot",-1)
						setElementData(localPlayer,"active:itemID",-1)
						setElementData(localPlayer,"active:itemSlot",-1)
					elseif activeWeaponSlot == -1 then
						local weaponAmmoBoxID = tonumber(items[itemData["id"]].ammo)
						local statja,itemidje,valueja,slotja,typ,_,darab = hasItem(weaponAmmoBoxID)

						if hotTable[itemData["id"]] then
							local itemID = itemData["id"]
							if not (itemID == 36 or itemID == 29 or itemID == 31 or itemID == 32 or itemID == 33 or itemID == 43) then 
								if tonumber(itemData["value"]) <= 10 then 
									outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A fegyver rossz állapotú.",255,255,255,true)
									return
								end
							end
						end

						if statja then
							activeAmmoSlot = slotja
							activeWeaponSlot = itemSlot
							triggerServerEvent("delAttachWeapon",localPlayer,localPlayer,itemData["id"],itemData["value"],itemData["dbid"])
							outputMeMessage("elővett egy fegyvert. ("..itemName..")")
							triggerServerEvent("adjfgytolivel", localPlayer, localPlayer,weaponIndexByID[itemData["id"]],darab,itemData["value"])
							setElementData(localPlayer,"active:weaponSlot",itemSlot)
							setElementData(localPlayer,"active:itemID",itemData["id"])
							setElementData(localPlayer,"active:itemSlot",activeAmmoSlot)

							setElementData(localPlayer, "weapon:hot", (melegedes[itemSlot] or 0))
						else
							if items[itemData["id"]].ammo then
								outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Nincs elég lőszered.",255,255,255,true)
							else 
								activeWeaponSlot = itemSlot
								if hotTable[weaponIndexByID[itemData["id"]]] then
									weapTimer = setTimer(function()
										toggleControl("fire",false)
										toggleControl("action",false)
										killTimer(weapTimer)
									end,200,1)
								end
								triggerServerEvent("delAttachWeapon",localPlayer,localPlayer,itemData["id"],itemData["value"],itemData["dbid"])
								outputMeMessage("elővett egy fegyvert. ("..itemName..")")
								triggerServerEvent("adjfgytolivel", localPlayer, localPlayer,weaponIndexByID[itemData["id"]],1,tonumber(itemData["value"]))
								setElementData(localPlayer,"active:weaponSlot",itemSlot)
								setElementData(localPlayer,"active:itemID",itemData["id"])
								setElementData(localPlayer,"active:itemSlot",activeAmmoSlot)

								setElementData(localPlayer, "weapon:hot", (melegedes[itemSlot] or 0))
							end
						end
					end
				end
			end
		end
	end
end

local protectedCols = {}
function createProtectedPlaces()
	for k, v in ipairs(protectedPlaces) do 
		local col = createColCuboid(v.pos.x, v.pos.y, v.pos.z, v.w, v.d, v.h)
		table.insert(protectedCols, #protectedCols+1, col)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, createProtectedPlaces)

function elementInProtectedPlace(element)
	local inPlace = false
	for k, v in pairs(protectedCols) do 
		if isElementWithinColShape(element, v) then 
			inPlace = true 
			break
		end
	end

	return inPlace
end

addEvent("inv > playLuckGameSoundInClient", true)
addEventHandler("inv > playLuckGameSoundInClient", root, function(sound, x, y, z)
	playSound3D("files/sounds/"..sound, x, y, z)
end)