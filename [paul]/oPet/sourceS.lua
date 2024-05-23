
local petsDatas = {}
local summonedPets = {}

local dist = {}

local con = exports.oMysql:getDBConnection()
addEventHandler("onResourceStart",resourceRoot, function()

    local count = 0
    local count2 = 0
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then
            for k,row in pairs(result) do

                count = count + 1

                local petID = row["id"]
                local petOwner = row["owner"]
                local petName = row["name"]
                local petType = row["type"]
                local petHealth = row["health"]
                local petHunger = row["hunger"]
                local petThirsty = row["thirsty"]
                local bestFood = row["bestFood"]
                loadPets(petID,petOwner,petName,petType,petHealth,petHunger,petThirsty,false,bestFood)

            end
            print("Sikeresen betöltöttem ".. count .."db petet")
        end
    end, con, "SELECT * FROM pets")

end) 

function saveOnePet(pet)
    id = getElementData(pet,"pet:id")
    owner = getElementData(pet,"pet:owner")
    name = getElementData(pet,"pet:name")
    type = getElementData(pet,"pet:type")
    hp = getElementData(pet,"pet:health")
    hunger = getElementData(pet,"pet:hunger")
    thirsty = getElementData(pet,"pet:thirsty")
    bestFood = getElementData(pet,"pet:bestFood")

    dbExec(con, "UPDATE pets SET owner=?, name=?, type=?, health=?, hunger=?, thirsty=? WHERE id=?",owner,name,type,hp,hunger,thirsty,id)
    print("Sikeresen mentettem "..name.." pet adatait.")
end 

function saveAllPet(id)
    id = petsDatas[id][1]
    owner = petsDatas[id][2]
    name = petsDatas[id][3]
    type = petsDatas[id][4]
    hp = petsDatas[id][5]
    hunger = petsDatas[id][6]
    thirsty = petsDatas[id][7]
    bestFood = petsDatas[id][8]

    dbExec(con, "UPDATE pets SET owner=?, name=?, type=?, health=?, hunger=?, thirsty=? WHERE id=?",owner,name,type,hp,hunger,thirsty,id)
end 

addEventHandler("onResourceStop",resourceRoot,function()
    for k,v in pairs(petsDatas) do 
      saveAllPet(v[1])
    end 

    for k,v in pairs(getElementsByType("player")) do 
        if getElementData(v,"hasSummonedPet") then 
            local petID = getElementData(v,"summonedPetID")
            desummonPet(v,petID)
            setElementData(v,"hasSummonedPet",false)
        end 
    end 
end)

function setDogIdle(dog,value,element)
    if value == true then 
        --setPedAnimation(dog, "PET", "petanim1")
        setElementData(dog,"petIsIdle",true)
        clearPedTasks(dog)
    else 
        setPedAnimation(dog)
        --setElementData(dog,"petIsIdle",false)
        setPedTask(dog, {"walkFollowElement", element, 3})
    end 
end
addEvent("setDogIdle",true)
addEventHandler("setDogIdle",root,setDogIdle)

function loadPets(id,owner,name,type,health,hunger,thirsty,summoned,bestFood)
    petsDatas[id] = {id,owner,name,type,health,hunger,thirsty,summoned,bestFood}
end 

function makePet(owner,name,type)
    if not owner or not name or not type then return end 
    owner = tonumber(owner)
    name = tostring(name)
    type = tonumber(type)

    dbExec(con, "INSERT INTO pets SET owner=?, name=?, type=?, health=?, hunger=?, thirsty=?, bestFood=?",owner,name,type,100,100,100,math.random(1,4));

    setTimer(function()
        local count2 = 0
        local petID = 0
        local bestFood = 0
        dbQuery(function(qh)
            local result = dbPoll(qh, 0)
            if result then
                for k,row in pairs(result) do
                    if row["owner"] == owner and row["name"] == name then
                        petID = row["id"]
                        bestFood = row["bestFood"]
                    end 
                end
                loadPets(petID,owner,name,type,100,100,100,false,bestFood)
            end
        end, con, "SELECT * FROM pets")
    end,1000,1)

end 
addEvent("makePet",true)
addEventHandler("makePet",root,makePet)

function delPetByID(id,player)
    id = tonumber(id)

    if not player then 
        if not petsDatas[id][8] then 
            petsDatas[id] = nil 
            dbExec(con, "DELETE FROM pets WHERE id=?", id)
            print("Sikeresen töröltem "..petsDatas[id][3].." petet!")
        end 
    else 
        if not petsDatas[id][8] then 
            petsDatas[id] = nil 
            dbExec(con, "DELETE FROM pets WHERE id=?", id)
            triggerClientEvent(player,"fixTable",player,id)
        end 
    end 
end

function changePetName(id,name)
    id = tonumber(id)
    petsDatas[id][3] = name

    if petsDatas[id][8] then 
        setElementData(summonedPets[id],"ped:name",name)
    end 
end 
addEvent("changePetName",true)
addEventHandler("changePetName",root,changePetName)

function reHealPet(player,id)
    id = tonumber(id)
    petsDatas[id][5] = 100
    petsDatas[id][6] = 100
    petsDatas[id][7] = 100
end 
addEvent("reHealPet",true)
addEventHandler("reHealPet",root,reHealPet)

function syncMyPets(player)
    dbID = getElementData(player,"user:id")
    for k,v in pairs(petsDatas) do 
        if v[2] == dbID then 
            triggerClientEvent(player,"getMyPets",player,v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8],v[9])
        end 
    end 
end 
addEvent("syncMyPets",true)
addEventHandler("syncMyPets",root,syncMyPets)

local elementTimer = {}
local distanceTimer = {}

function summonPet(summoner,id)
    if getElementData(summoner,"hasSummonedPet") then return end
    id = tonumber(id)
        for k,pet in pairs(petsDatas) do 
            if pet[2] == getElementData(summoner,"user:id") then 

                if pet[1] == id then 
                    if summonedPets[pet[1]] then return end
                    if pet[5] <= 0 then return infobox:outputInfoBox("Halott állatot nem tudsz megidézni!", "error", summoner) end

                    local x,y,z = getElementPosition(summoner)
                    local int = getElementInterior(summoner)
                    local dim = getElementDimension(summoner)
                    summonedPets[pet[1]] = createPed(pet[4],x + 1,y,z)

                    setElementDimension(summonedPets[pet[1]],dim)
                    setElementInterior(summonedPets[pet[1]],int)

                    --setPedTask(summonedPets[pet[1]], {"walkFollowElement", summoner, 3})

                    setElementData(summoner,"char:avaliblePet",summonedPets[pet[1]])
                    setElementData(summonedPets[pet[1]],"pet",true)
                    setElementData(summonedPets[pet[1]],"pet:id",pet[1])
                    setElementData(summonedPets[pet[1]],"pet:owner",pet[2])
                    setElementData(summonedPets[pet[1]],"pet:name",pet[3])
                    setElementData(summonedPets[pet[1]],"pet:type",pet[4])
                    setElementData(summonedPets[pet[1]],"pet:health",pet[5])
                    setElementData(summonedPets[pet[1]],"pet:hunger",pet[6])
                    setElementHealth(summonedPets[pet[1]],pet[5])
                    setElementData(summonedPets[pet[1]],"pet:thirsty",pet[7])
                    setElementData(summonedPets[pet[1]],"pet:summoned",true)

                    setElementData(summonedPets[pet[1]], "ped:prefix",getDogCastByID(getElementModel(summonedPets[pet[1]])))
                    setElementData(summonedPets[pet[1]],"ped:name",pet[3])

                    setElementData(summonedPets[pet[1]],"ped:damageable",true)
                    setElementData(summonedPets[pet[1]],"pet:bestFood",pet[9])

                    setElementData(summonedPets[pet[1]], "ped.isControllable", true)

                    setElementData(summonedPets[pet[1]],"petIsIdle",false)

                    setElementData(summoner,"summonedPetID",pet[1])
                    setElementData(summoner,"hasSummonedPet",true)

                    petsDatas[pet[1]][8] = true

                    elementTimer[pet[1]] = setTimer(function()
                        setElementData(summonedPets[pet[1]],"pet:health",getElementHealth(summonedPets[pet[1]]))

                        if getElementData(summonedPets[pet[1]],"pet:hunger") > 0 then 
                            setElementData(summonedPets[pet[1]],"pet:hunger",getElementData(summonedPets[pet[1]],"pet:hunger") - 0.01)
                        else 
                            setElementHealth(summonedPets[pet[1]],getElementHealth(summonedPets[pet[1]]) - 0.05)
                        end 

                        if getElementData(summonedPets[pet[1]],"pet:thirsty") > 0 then 
                            setElementData(summonedPets[pet[1]],"pet:thirsty",getElementData(summonedPets[pet[1]],"pet:thirsty") - 0.005)
                        else 
                            setElementHealth(summonedPets[pet[1]],getElementHealth(summonedPets[pet[1]]) - 0.05)
                        end 

                        health,hunger,thirsty = getElementData(summonedPets[pet[1]],"pet:health"),getElementData(summonedPets[pet[1]],"pet:hunger"),getElementData(summonedPets[pet[1]],"pet:thirsty")
                        petsDatas[pet[1]][5],petsDatas[pet[1]][6],petsDatas[pet[1]][7] = health,hunger,thirsty

                        if getElementHealth(summonedPets[pet[1]]) <= 0 then 
                            desummonPet(summoner,pet[1])
                            infobox:outputInfoBox("Meghalt az állatod, részletek a chatboxban!", "info", summoner)
                            outputChatBox("[Kisállat]: #ffffffPeted életét vesztette, újraéleszteni az "..color.."(F4)#ffffff-es panelben vagy az állatorvosnál tudod!", summoner, r, g, b, true)

                            return
                        end 
                    end,1000,0)

                    distanceTimer[pet[1]] = setTimer(function()
                        local x,y,z = getElementPosition(summoner)
                        local px,py,pz = getElementPosition(summonedPets[pet[1]])
                        local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
                        local int,pint = getElementInterior(summoner),getElementInterior(summonedPets[pet[1]])
                        local dim,pdim = getElementDimension(summoner),getElementInterior(summonedPets[pet[1]])

                        if distance > 25 then 
                            setElementDimension(summonedPets[pet[1]],dim)
                            setElementInterior(summonedPets[pet[1]],int)
                            setElementPosition(summonedPets[pet[1]],x + 0.5,y,z)
                        end 

                    end,1000,0)
                    
                end 
            end 
        end 
end 
addEvent("summonPet",true)
addEventHandler("summonPet",root,summonPet) 

function desummonPet(summoner,id)

    if not getElementData(summoner,"hasSummonedPet") then return end
    id = tonumber(id)
    setElementData(summonedPets[id],"pet:summoned",false)
    killTimer(elementTimer[id])
    killTimer(distanceTimer[id])
    if isTimer(dist[summonedPets[id]]) then killTimer(dist[summonedPets[id]]) end
    health,hunger,thirsty = getElementData(summonedPets[id],"pet:health"),getElementData(summonedPets[id],"pet:hunger"),getElementData(summonedPets[id],"pet:thirsty")
    petsDatas[id][5],petsDatas[id][6],petsDatas[id][7] = health,hunger,thirsty
    saveOnePet(summonedPets[id])
    destroyElement(summonedPets[id])
    summonedPets[id] = nil
    setElementData(summoner,"summonedPetID",false)
    setElementData(summoner,"hasSummonedPet",false)
    setElementData(summoner,"char:avaliblePet",false)


end 
addEvent("desummonPet",true)
addEventHandler("desummonPet",root,desummonPet) 

function sellPetPanel(target,price,name,petID)

    setElementData(target, "pet:inTrade", true)
    setElementData(client, "pet:inTrade", true)

    modelID = petsDatas[petID][4]
    
    infobox:outputInfoBox(getPlayerName(client):gsub("_", " ").." el akar neked adni egy állatot, részletek a panelen! ("..price.."$)", "info", target)
    triggerClientEvent(target, "makeBuy", target, client, price, petID,modelID)

end 
addEvent("sellPetPanel",true)
addEventHandler("sellPetPanel",root,sellPetPanel) 

function dismissBuyPanel(target)
    setElementData(target, "pet:inTrade", false)
    setElementData(client, "pet:inTrade", false)
    infobox:outputInfoBox("Valamilyen hiba lépett fel a vásárlás során vagy a játékos elutasította az ajánlatod így az megszakadt! Próbáld újra!","error", target)
end 
addEvent("dismissBuyPanel",true)
addEventHandler("dismissBuyPanel",root,dismissBuyPanel) 

function setPetAnOtherPlayer(oldOwner,newOwner,petID,price)

    owner = getElementData(newOwner,"user:id")
    dbExec(con, "UPDATE pets SET owner=? WHERE id=?",owner,petID)
    petsDatas[petID][2] = owner 
    syncMyPets(newOwner)
    syncMyPets(oldOwner)
    setElementData(newOwner,"char:money",getElementData(newOwner,"char:money") - price)
    setElementData(oldOwner,"char:money",getElementData(oldOwner,"char:money") + price)
    infobox:outputInfoBox("Sikeresen eladtad az állatod!","success", oldOwner)
    infobox:outputInfoBox("Sikeresen megvásároltad az állatot!","success", newOwner)
    triggerClientEvent(oldOwner,"fixTable",oldOwner,petID)
    print("Sikeresen megtörtént a trade")

end 
addEvent("succesTrade",true)
addEventHandler("succesTrade",root,setPetAnOtherPlayer) 

function takePetPP(element,pp)
	setElementData(element,"char:pp",getElementData(element,"char:pp") - pp)
end
addEvent("takePetPP",true)
addEventHandler("takePetPP",root,takePetPP)  

function takePetMoney(element,money)
	setElementData(element,"char:money",getElementData(element,"char:money") - money)
end
addEvent("takePetMoney",true)
addEventHandler("takePetMoney",root,takePetMoney)  

function warpPetInToVeh ( theVehicle, seat, jacked )
    if getElementData(source,"hasSummonedPet") then 
        local petID = getElementData(source,"summonedPetID")
        setElementData(source,"lastSummonedPetID",petID)
        setElementData(source,"hasWaitedToSummon",true)

        desummonPet(source,petID)
        outputChatBox("[Kisállat]: #ffffffMivel beszáltál egy autóba így az állatod autómatikusan eltünt, kiszálláskor vissza fog kerülni!", thePlayer, r, g, b, true)
    end 
end
addEventHandler ( "onPlayerVehicleEnter", getRootElement(), warpPetInToVeh )

function warpPetOutOfVeh ( theVehicle, seat, jacked )
    if getElementData(source,"hasWaitedToSummon") then 
        local petID = getElementData(source,"lastSummonedPetID")
        summonPet(source,petID)
        setElementData(source,"lastSummonedPetID",0)
        setElementData(source,"hasWaitedToSummon",false)


        local animalElement = getElementData(source,"char:avaliblePet")
        setPedTask(animalElement, {"walkFollowElement", source, 3})

    end 
end
addEventHandler ( "onPlayerVehicleExit", getRootElement(), warpPetOutOfVeh )

function makePetCommand(thePlayer,cmd,target,name,skin)
    if not target or not name or not skin then return outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Kisállat Neve] [Kisállat Típus (skin TÁBLÁZAT A FÓRUMON)]", thePlayer, r, g, b, true) end
    if not tostring(name) then return outputChatBox("[Használat]: #ffffffA név csak betűkből álhat!", thePlayer, r, g, b, true) end
    if not tonumber(skin) then return outputChatBox("[Használat]: #ffffffA típus csak szám lehet!", thePlayer, r, g, b, true) end
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    local targetPlayer = core:getPlayerFromPartialName(thePlayer, target)
    local aLevel = getElementData(thePlayer,"user:admin")

    if aLevel >= 7 then 
        admin:sendMessageToAdmins(thePlayer, "létrehozott "..nameColor..getPlayerName(targetPlayer)..adminMessageColor.." játékos számára egy állatot! ")
        outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #fffffflétrehozott számodra egy állatot! (F4)", targetPlayer, 255, 255, 255, true)
        makePet(getElementData(targetPlayer,"user:id"),tostring(name),tonumber(skin))
    end
end 
addCommandHandler("makepet",makePetCommand)

function delPetCommand(thePlayer,cmd,target,id)
    if not target or not id then return outputChatBox("[Használat]: #ffffff/"..cmd.." [TulajdonosID] [PetID]", thePlayer, r, g, b, true) end 
    if not tonumber(id) then return outputChatBox("[Használat]: #ffffffAz ID csak szám lehet!", thePlayer, r, g, b, true) end
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    if petsDatas[tonumber(id)] then 

        local targetPlayer = core:getPlayerFromPartialName(thePlayer, target)
        local aLevel = getElementData(thePlayer,"user:admin")

        if aLevel >= 7 then 
            admin:sendMessageToAdmins(thePlayer, "törölte "..nameColor..getPlayerName(targetPlayer)..adminMessageColor..nameColor.." ("..id..")"..adminMessageColor.." idvel rendelkező állatát!")
            outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #fffffftörölte "..id.."-idjű állatod! (F4)", targetPlayer, 255, 255, 255, true)
            delPetByID(id,targetPlayer)
        end
    else 
        outputChatBox("[Használat]: #ffffffa kiválasztott játékosnak nincs ilyen ID vel rendelkező állata!", thePlayer, r, g, b, true) 
    end
end 
addCommandHandler("delpet",delPetCommand)

function changePetNameCommand(thePlayer,cmd,target,id,name)
    if not target or not id or not name then return outputChatBox("[Használat]: #ffffff/"..cmd.." [TulajdonosID] [PetID] [Név]", thePlayer, r, g, b, true) end 
    if not tonumber(id) then return outputChatBox("[Használat]: #ffffffAz ID csak szám lehet!", thePlayer, r, g, b, true) end
    if not tostring(name) then return outputChatBox("[Használat]: #ffffffA név betűből állhat!", thePlayer, r, g, b, true) end
    if not petsDatas[tonumber(id)] then return outputChatBox("[Használat]: #ffffffa kiválasztott játékosnak nincs ilyen ID vel rendelkező állata!", thePlayer, r, g, b, true) end 
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    
    local targetPlayer = core:getPlayerFromPartialName(thePlayer, target)
    local aLevel = getElementData(thePlayer,"user:admin")

    if aLevel >= 6 then 
        admin:sendMessageToAdmins(thePlayer, "beállította "..nameColor..getPlayerName(targetPlayer)..adminMessageColor..nameColor.." ("..id..")"..adminMessageColor.." idvel rendelkező állatának nevét a következőre: "..nameColor..name)
        outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította "..id.."-idjű állatod nevét! (F4)", targetPlayer, 255, 255, 255, true)
        changePetName(id,name)
    end 
end 
addCommandHandler("changepetname",changePetNameCommand)

function reHealPetCommand(thePlayer,cmd,target,id)
    if not target or not id then return outputChatBox("[Használat]: #ffffff/"..cmd.." [TulajdonosID] [PetID]", thePlayer, r, g, b, true) end 
    if not tonumber(id) then return outputChatBox("[Használat]: #ffffffAz ID csak szám lehet!", thePlayer, r, g, b, true) end
    if not petsDatas[tonumber(id)] then return outputChatBox("[Használat]: #ffffffa kiválasztott játékosnak nincs ilyen ID vel rendelkező állata!", thePlayer, r, g, b, true) end 
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    local targetPlayer = core:getPlayerFromPartialName(thePlayer, target)
    local aLevel = getElementData(thePlayer,"user:admin")

    if aLevel >= 6 then 
        admin:sendMessageToAdmins(thePlayer, "újraélesztette "..nameColor..getPlayerName(targetPlayer)..adminMessageColor..nameColor.." ("..id..")"..adminMessageColor.." idével rendelkező állatát!")
        outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffújraélesztette "..id.."-idjű állatodat! (F4)", targetPlayer, 255, 255, 255, true)
        reHealPet(player,id)
    end 
end 
addCommandHandler("rehealpet",reHealPetCommand)

function getPlayerPetsCommand(thePlayer,cmd,target)
    if not target then return outputChatBox("[Használat]: #ffffff/"..cmd.." [Tulajdonos]", thePlayer, r, g, b, true) end 
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    local targetPlayer = core:getPlayerFromPartialName(thePlayer, target)
    if not targetPlayer then return end
    local aLevel = getElementData(thePlayer,"user:admin")

    local havePets = false 

    if aLevel >= 4 then 
        local owner = getElementData(targetPlayer,"user:id")

        for k,v in pairs(petsDatas) do 
            if v[2] == owner then 
                havePets = true 
            end 
        end 

        if havePets then 
            outputChatBox("--- A kiválasztott játékosnak állatainak listája:"..color.." ---", thePlayer, r, g, b, true)

            for k,v in pairs(petsDatas) do 
                if v[2] == owner then 
                    outputChatBox("Név: "..color..v[3].."#ffffff ID: "..color..v[1], thePlayer, 255,255,255, true)
                end 
            end 

            havePets = false
        else 
            outputChatBox("--- A kiválasztott játékosnak nincs egy állata sem!"..color.." ---", thePlayer, r, g, b, true)
        end 
    end 

end 
addCommandHandler("getplayerpets",getPlayerPetsCommand)

--functions 

function clearPedTasks(pedElement)
	if isElement(pedElement) then
		local thisTask = getElementData(pedElement, "ped.thisTask")
		if thisTask then

			local lastTask = getElementData(pedElement, "ped.lastTask")
			for currentTask = thisTask, lastTask do
				removeElementData(pedElement,"ped.task." .. currentTask)
				--setElementData(pedElement, "ped.task." .. currentTask, nil)
			end

			removeElementData(pedElement, "ped.thisTask")
			--setElementData(pedElement, "ped.thisTask", nil)
			removeElementData(pedElement, "ped.lastTask")
			--setElementData(pedElement, "ped.lastTask", nil)
			return true
		end
	else
		return false
	end
end

function setPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		clearPedTasks(pedElement)
		setElementData(pedElement, "ped.task.1", selectedTask)
		setElementData(pedElement, "ped.thisTask", 1)
		setElementData(pedElement, "ped.lastTask", 1)
		return true
	else
		return false
	end
end


function findRotation( x1, y1, x2, y2 )
	local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	return t < 0 and t + 360 or t
end

addEventHandler("onResourceStart",resourceRoot,function()
    num = math.random(1,10)
    rehealPed = createPed(14,reHealPedPos[num][1],reHealPedPos[num][2],reHealPedPos[num][3],reHealPedPos[num][4])
    pedBag = createObject(2805,reHealPedPos[num][1],reHealPedPos[num][2],reHealPedPos[num][3],0,0,reHealPedPos[num][4])
    setElementFrozen(rehealPed,true)
    attachElements(pedBag,rehealPed,-0.3,0,-0.35,10,0,90)
    --exports.oBone:attachElementToBone(pedBag,rehealPed,11,-0.5,0,-0.3,0,0,90)
    setElementCollisionsEnabled(pedBag,false)
    setObjectScale(pedBag,0.5)
    setElementData(rehealPed, "ped:prefix","Maszek Állatorvos")
    setElementData(rehealPed,"ped:name","Fredy Jackson")
    setElementData(rehealPed,"rehealPed",true)
    print("[PET-ÁLLATORVOS] Jelenlegi pozíciója "..reHealPedPos[num][1]..","..reHealPedPos[num][2]..","..reHealPedPos[num][3])

    setTimer(function()
        num = math.random(1,10)
        setElementPosition(rehealPed,reHealPedPos[num][1],reHealPedPos[num][2],reHealPedPos[num][3])
        setElementRotation(rehealPed,0,0,reHealPedPos[num][4])

        print("[PET-ÁLLATORVOS] Jelenlegi pozíciója "..reHealPedPos[num][1]..","..reHealPedPos[num][2]..","..reHealPedPos[num][3])

    end,300000,0)
end)

--GuardMod

local playerFirstTry = {}
local tryTimer = {}

addEventHandler("onPlayerDamage",root,function(attacker,weapon,_,loss)
    if not attacker then return end
    if not getElementData(source,"hasSummonedPet") then return end 
    local Player = source

    if weapon == 0 then
        if not playerFirstTry[attacker] then 
            playerFirstTry[attacker] = true
        
            tryTimer[attacker] = setTimer(function()
                playerFirstTry[attacker] = nil
                tryTimer[attacker] = nil
            end,1000,1)
        
            outputChatBox("[Kisállat]#ffffff Valaki megütött téged! Ha mégegyszer megüt vagy valahogyan megsebez az állatod meg fogja támadni!",source,r,g,b,true)
            return  
        else 
            local dog = getElementData(source,"char:avaliblePet")
            setPedTask(dog, {"killPed", attacker, 5,1})
            outputChatBox("[Kisállat] #ffffffAz állatod megtámadott valakit! Csak akkor hagyja abba a támadást ha a támadó elég messze ment vagy visszahívod "..color.."(F4)#ffffff!",source,r,g,b,true)

            if not isTimer(dist[dog]) then
                dist[dog] = setTimer(function()
                    x,y,z = getElementPosition(attacker)
                    px,py,pz = getElementPosition(Player)

                    if getDistanceBetweenPoints3D(x,y,z,px,py,pz) >= 20 then 
                        setPedTask(dog, {"walkFollowElement", Player, 3})
                        killTimer(dist[dog])

                        playerFirstTry[attacker] = nil
                        if isTimer(tryTimer[attacker]) then tryTimer[attacker] = nil end
                    end 

                    if getElementHealth(attacker) <= 15 then 
                        setPedTask(dog, {"walkFollowElement", Player, 3})
                        killTimer(dist[dog])

                        playerFirstTry[attacker] = nil
                        if isTimer(tryTimer[attacker]) then tryTimer[attacker] = nil end
                    end

                end,500,0)
            end
        end 
    else 
        local dog = getElementData(source,"char:avaliblePet")
        setPedTask(dog, {"killPed", attacker, 5,1})
        outputChatBox("[Kisállat] #ffffffAz állatod megtámadott valakit! Csak akkor hagyja abba a támadást ha a támadó elég messze ment vagy visszahívod "..color.."(F4)#ffffff!",source,r,g,b,true)

        if not isTimer(dist[dog]) then
            dist[dog] = setTimer(function()
                x,y,z = getElementPosition(attacker)
                px,py,pz = getElementPosition(Player)

                if getDistanceBetweenPoints3D(x,y,z,px,py,pz) >= 20 then 
                    setPedTask(dog, {"walkFollowElement", Player, 3})
                    killTimer(dist[dog])

                    playerFirstTry[attacker] = nil
                    if isTimer(tryTimer[attacker]) then tryTimer[attacker] = nil end
                end 

                if getElementHealth(attacker) <= 15 then 
                    setPedTask(dog, {"walkFollowElement", Player, 3})
                    killTimer(dist[dog])

                    playerFirstTry[attacker] = nil
                    if isTimer(tryTimer[attacker]) then tryTimer[attacker] = nil end
                end

            end,500,0)
        end
    end 
end)

addEventHandler("onPlayerQuit",root,function()
    if getElementData(source ,"hasSummonedPet") then 
        local pet = getElementData(source ,"char:avaliblePet")
        local petID = getElementData(pet ,"pet:id")
        desummonPet(source,petID)
        setElementData(source ,"hasSummonedPet",false)
    end 
end)