local screenX, screenY = guiGetScreenSize()


reMap = function(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultiplier = math.min(1, reMap(screenX, 1024, 1920, 0.75, 1))

resp = function(value)
	return value * responsiveMultiplier
end

respc = function(value)
	return math.ceil(value * responsiveMultiplier)
end

local interface = exports.oInterface
local admin = exports.oAdmin
local core = exports.oCore
local font = exports.oFont
local info = exports.oInfobox
color, r, g, b = exports.oCore:getServerColor()

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oHud" or getResourceName(res) == "oInterface" or getResourceName(res) == "oAdmin" or getResourceName(res) == "oFont" or getResourceName(res) == "oInfobox" then  
        interface = exports.oInterface
        color, r, g, b = exports.oCore:getServerColor()
        admin = exports.oAdmin
        core = exports.oCore
        font = exports.oFont
        info = exports.oInfobox
	end
end)

-- init
local elements = {}
local ordersFood = {}
local selectedTable = {}
local selectedTableId = false
local pedTable = {}
local blipTable = {}
local foodInHand = false
local deliveredCars = false
local hintW, hintH = 300, 40
local hintX, hintY = screenX/2 - hintW/2, screenY - 300
local hintW2, hintH2 = 300, 300
local hintX2, hintY2 = screenX - hintW2 - resp(10),screenY/2 - hintH/2 - respc(150)
fonts = {
    ["condensed-11"] = exports.oFont:getFont("condensed", 11),
    ["condensed-13"] = exports.oFont:getFont("condensed", 13),
    ["bebasneue-15"] = exports.oFont:getFont("bebasneue", 15),
    ["houseScript-15"] = exports.oFont:getFont("houseScript", 15),
    ["houseScript-20"] = exports.oFont:getFont("houseScript", 20),
}

jobConfig = {
    barInterpolation = {},
	interpolationStartValue = {},
	lastBarValue = {},
    peds = {},
}
local markerElement = false
setElementData(localPlayer, "jobVeh:ownedJobVeh", false)

---
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
    
    if getElementData(localPlayer, "char:job") == 9 then 
        displayFoodDelivery()
    else
        destroyFoodDelivery()
    end
end)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), function()
    destroyFoodDelivery()


    for k, v in pairs(getElementsByType("player")) do
		if getElementData(v, "foodDeliveryStarted") then
		--	triggerServerEvent("packagesToPlayer", v, v, false)
			setElementData(v, "foodDeliveryStarted", false)
		end
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName)
    if source == localPlayer then 
        if dataName == "char:job" then 
            if getElementData(source, dataName) == 9 then 
                displayFoodDelivery()
            else
                destroyFoodDelivery()
                
            end
        end
    end
end)

function displayFoodDelivery()
    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Feladatod a rendelt ételek ki szállítása", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."A munka kezdéséhez menj el a térképen megjelölt bolthoz ("..color .."Sárga táska ikon#FFFFFF).", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Majd vedd fel a munkajárműved!", 255, 255, 255, true)
    jobBlips = createBlip(2101.9375,-1806.4381103516,21.885347366333, 11)
    setElementData(jobBlips, "blip:name", "Ételfutár munka")
    vehicleMarker = createMarker(2107.6140136719,-1782.4810791016,13.388251304626-1, "checkpoint", 2, r, g, b, 150)
    table.insert(elements,vehicleMarker)
    table.insert(elements, jobBlips)
  --  table.insert(elements, jobMarker)
end

function createNPCafterSpawnedVehicle(state)
    if state then 
        markerElement = createMarker(379.57431030273,-116.21134185791,1001.4921875-1, "cylinder", 1.2, r,g,b, 150)
        outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Menj be a boltba, majd vedd fel a rendeléseket!", 255, 255, 255, true) 
        setElementInterior(markerElement, 5)
        setElementDimension(markerElement, 12)
    else
        if isElement(markerElement) then 
            destroyElement(markerElement)
        end
    end
end
addEvent("createNPCafterSpawnedVehicle", true)
addEventHandler("createNPCafterSpawnedVehicle", getRootElement(), createNPCafterSpawnedVehicle)

function destroyFoodDelivery(delivered)
    --outputChatBox("bazd")
    if not delivered then
        for k,v in pairs(elements) do 
            if isElement(v) then 
                destroyElement(v)
            end
        end
    end
    for i=1, #blipTable do
		if isElement(blipTable[i]) then
			destroyElement(blipTable[i])
		end
	end
	for i=1, #pedTable do
		if isElement(pedTable[i]) then
			destroyElement(pedTable[i])
		end
	end

    createNPCafterSpawnedVehicle(false)
    if getElementData(localPlayer, "foodDeliveryStarted") then
        setElementData(localPlayer, "foodDeliveryStarted", false)
        removeEventHandler("onClientRender", getRootElement(), drawHeater)
        removeEventHandler("onClientClick", getRootElement(), clickHeater)
        ordersFood = {}
        if isElement(deliveredCars) then
            setElementData(deliveredCars, "packageTable", false)
            deliveredCars = false
        end
        pedTable = {}
        blipTable = {}
   end
end

addEvent("setJob", true)
addEventHandler("setJob", getRootElement(), function()
    destroyFoodDelivery(true)
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(hitPlayer, mDim)
    if hitPlayer == localPlayer and mDim then 
        if source == markerElement then 
            addEventHandler("onClientRender", getRootElement(), drawHint)
            addEventHandler("onClientKey", getRootElement(), hintKeyEvent)
        elseif source == vehicleMarker then
            if getElementData(localPlayer, "jobVeh:ownedJobVeh") then
                if not isPedInVehicle(localPlayer) then 
                    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Már van egy munkajárműved!", 255, 255, 255, true)
                    return
                end
            end
            if isPedInVehicle(localPlayer) then 
                setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
            end
            exports["oJob"]:createVehicleRequestPanel("Ételfutár", 565, true)
            addEventHandler("onClientClick", getRootElement(), vehicleClick)
        end
    end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(hitPlayer, mDim)
    if hitPlayer == localPlayer and mDim then 
        if source == markerElement then 
            removeEventHandler("onClientRender", getRootElement(), drawHint)
            removeEventHandler("onClientKey", getRootElement(), hintKeyEvent)
        elseif source == vehicleMarker then 
            if isPedInVehicle(localPlayer) then 
                setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
            else
                setElementFrozen(localPlayer, false)
            end
            exports["oJob"]:destroyVehicleRequestPanel(true)
            removeEventHandler("onClientClick", getRootElement(), vehicleClick)
        end
    end
end)

function drawHint()
    dxDrawRectangle(hintX-2, hintY-2, hintW+4, hintH+4, tocolor(30,30,30,150))
    dxDrawRectangle(hintX, hintY, hintW, hintH, tocolor(30,30,30,255))
    dxDrawText("Nyomj ".. color.."[E]#FFFFFF gombot a rendelés fevételéhez", screenX/2, hintY, screenX/2, hintY + hintH+resp(4), tocolor(255,255,255,255),resp(0.95),fonts["bebasneue-15"], "center", "center", false, false, false, true)
end

function hintKeyEvent(key, state)
    if key == "e" and state then 
        generateOrders()
    end
end

function generateOrders()
    --[[for i=1, math.random(7,11) do 
        myOrders[i] = {}
        myOrders[i]["name"] = orders[math.random(1,#orders)]["name"]
        myOrders[i]["isDelivered"] = false
        myOrders[i]["deliveryTime"] = math.random(5,10)
        myOrders[i]["pickupFoodTime"] = getRealTime().timestamp
        if i == 1 then 
            myOrders[i]["isActive"] = true
        else 
            myOrders[i]["isActive"] = false
        end
    end]]
    if not getElementData(localPlayer, "foodDeliveryStarted") then
        triggerServerEvent("setPosition", localPlayer, localPlayer)
        randNumOfOrders = math.random(5, 11)
        for i=1, randNumOfOrders do 
            randNumOfPosition = math.random(1,#npcPositions)
            if npcPositions[randNumOfPosition][5] == true then 
                while npcPositions[randNumOfPosition][5] == true do 
                   randNumOfPosition = math.random(1,#npcPositions)
                end
            end
            npcPositions[randNumOfPosition][5] = true

            randNumOfGender = math.random(0,1)
            if randNumOfGender == 0 then 
                selectedName = core:createRandomName("female")
                npcSkinId = skinsTable["Woman"][math.random(1,#skinsTable["Woman"])]
            else
                selectedName = core:createRandomName("male")
                npcSkinId = skinsTable["Man"][math.random(1,#skinsTable["Man"])]
            end
            orderName = orders[math.random(1,#orders)]["name"]
            orderTime = math.random(5,10)
            pickupFoodTime = getRealTime().timestamp
            asd = false
            table.insert(ordersFood,{selectedName, npcSkinId, orderName, npcPositions[randNumOfPosition][1], npcPositions[randNumOfPosition][2], npcPositions[randNumOfPosition][3], npcPositions[randNumOfPosition][4], orderTime, pickupFoodTime, asd})
        end
    end
    setElementData(localPlayer, "foodDeliveryStarted", true)
    pedCreation()
    triggerServerEvent("foodToPlayer", localPlayer, localPlayer, true)
    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Meg kaptad a rendeléseid ("..color.. (#ordersFood) .." db#FFFFFF)", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Rakd bele a szállítmányt a járművedbe! (Bal kattintás a kocsira!)", 255, 255, 255, true)
    addEventHandler("onClientRender", getRootElement(), drawHeater)
    addEventHandler("onClientClick", getRootElement(), clickHeater)
end

function pedCreation()
    for k,v in pairs(ordersFood) do 
        pedTable[k] = createPed(v[2], v[4], v[5], v[6], v[7])
        setElementFrozen(pedTable[k], true)
        setElementData(pedTable[k], "ped:name", v[1])
        setElementData(pedTable[k], "deliveredPed", true)
        --setElementData(pedTable[k], "isDelivered", false)
        setElementData(pedTable[k], "idTable", {v[3], v[1], v[8], v[9], v[10], k})
        blipTable[k] = createBlip(v[4], v[5], v[6], 3)
        setElementData(blipTable[k], "blip:name", k .. ".: ".. v[1] .. " - ".. v[3])
    end
end


function vehicleClick(button, state)
    if exports["oJob"]:getJobPanelState() then 
        if button == "left" and state == "down" then 
            -- if core:isInSlot(sx*0.4 + 6/myX*sx, sy*0.642, sx*0.2 - 12/myX*sx, sy*0.05) then 
            local Px,Py,Pw,Ph = unpack(exports["oJob"]:getJobVehicleButtonPos("pick/dropVehicle"))
            local ex,ey,ew,eh = unpack(exports["oJob"]:getJobVehicleButtonPos("exit"))
            if core:isInSlot(ex,ey,ew,eh) then 
                if isPedInVehicle(localPlayer) then 
                    setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
                else
                    setElementFrozen(localPlayer, false)
                end
                exports["oJob"]:destroyVehicleRequestPanel(true)
            end            
            if core:isInSlot(Px,Py,Pw,Ph) then 
                if not getElementData(localPlayer, "jobVeh:ownedJobVeh") then
                    triggerServerEvent("vehicleRequest", localPlayer, localPlayer)
                else 
                    triggerServerEvent("vehicleDestroy", localPlayer, localPlayer, getElementData(localPlayer, "jobVeh:ownedJobVeh"))
                end
            end
        end
    end
end

function clickHeater(button,state, absX, absY, worldX, worldY, worldZ, clickElement)
    if button == "right" and state == "down" then 
        if isElement(clickElement) and getElementType(clickElement) == "ped" then 
            if getElementData(clickElement, "deliveredPed") then 
				local px, py, pz = getElementPosition(localPlayer)
				local pedX,pedY,pedZ = getElementPosition(clickElement)
                if getDistanceBetweenPoints3D(px, py, pz,pedX,pedY,pedZ)  < 2 then
                    if foodInHand and selectedTable then
                        if selectedTable[3] == getElementData(clickElement, "idTable")[1] then
                            if not selectedTable[10] then
                                selectedTable[10] = true
                                setTimer(function()
                                    outputChatBox(getPlayerName(localPlayer):gsub("_", " ").." mondja: Jónapot, meghoztam az ételt amit rendelt", 255,255,255,true)
                                    setTimer(function()
                                        setPedAnimation(clickElement, "GHANDS", "gsign1", 2000)
                                        local theTime = getRealTime().timestamp
                                        local ido = theTime-((selectedTable[8]*60)+selectedTable[9])
                                        local bonus = 0
                                        if ido < 0 then 
                                            outputChatBox(getElementData(clickElement, "idTable")[2].." mondja: Köszönöm még meleg!", 255,255,255,true)
                                            bonus = math.random(10,20)
                                        else 
                                            outputChatBox(getElementData(clickElement, "idTable")[2].." mondja: Köszönöm, hát ez már kihült ezért nem kap borravalót!", 255,255,255,true)
                                        end
                                        setTimer(function()
                                            setPedAnimation(clickElement, "DEALER","DEALER_DEAL",3000,false,false,false,false)
                                            setPedAnimation(localPlayer, "DEALER","DEALER_DEAL",3000,false,false,false,false)
                                            randomSalary = math.random(100, 250)
                                            outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Sikeresen kiszállítottad az ételt!", 255, 255, 255, true)
                                            if ido < 0 then 
                                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Fizetséged: ".. randomSalary .."$", 255, 255, 255, true)
                                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Borravaló: ".. bonus .."$", 255, 255, 255, true)
                                            else 
                                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Fizetséged: ".. randomSalary .."$", 255, 255, 255, true)
                                            end
                                            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")+randomSalary+bonus)
                                            selectedTableId = false
                                            table.remove(ordersFood, getElementData(clickElement, "idTable")[6])
                                            selectedTable = {}
                                            foodInHand = false
                                            triggerServerEvent("foodBagToPlayer", localPlayer, localPlayer, false) 
                                            setTimer(function()
                                                destroyElement(blipTable[getElementData(clickElement, "idTable")[6]])
                                                destroyElement(pedTable[getElementData(clickElement, "idTable")[6]])
                                                
                                            end, 3500,1)
                                            if #ordersFood == 0 then 
                                                for pk,pv in pairs(pedTable) do
                                                    destroyElement(v)
                                                end
                                                for bk,bv in pairs(blipTable) do
                                                    destroyElement(v)
                                                end
                                                setElementData(deliveredCars, "packageTable", false)
                                                setElementData(localPlayer, "foodDeliveryStarted", false)
                                                deliveredCars = false
                                                pedTable = {}
                                                blipTable = {}
                                                outputChatBox("", 255, 255, 255, true)
                                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Kiszállítottad az összes ételt!", 255, 255, 255, true)
                                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Ha szeretnéd folytatni a munkát menj vissza az étterembe és vegyél fel újabb megrendeléseket!", 255, 255, 255, true)
                                            end
                                        end, 1500, 1)
                                    end, 2000, 1)
                                end, 1000, 1)
                            end
                        else 
                            outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Nem megfelelő szállítmány!", 255, 255, 255, true)
                        end
                    else 
                        outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Nincs a kezedben semmi!", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Túl messze vagy!", 255, 255, 255, true)
                end
            end
        end
    end
    if button == "left" and state == "down" then 
        if isElement(clickElement) and getElementType(clickElement) == "vehicle" then 
            if getElementData(clickElement, "isJobVeh") then 
                if getElementData(localPlayer, "jobVeh:ownedJobVeh") == clickElement then 
                    if getElementData(localPlayer, "foodDeliveryStarted") then 
                        if not getElementData(clickElement, "packageTable") then
                            if not isPedInVehicle(localPlayer) then
                                triggerServerEvent("foodToPlayer", localPlayer, localPlayer, false)
                                triggerServerEvent("liftUpAnimation", localPlayer, localPlayer)
                                setElementData(clickElement, "packageTable", ordersFood)
                                deliveredCars = clickElement
                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Sikeresen beleraktál ".. #ordersFood.." db megrendelést a járművedbe!", 255, 255, 255, true)
                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Ha ki szeretnéd venni az adott ételt akkor kattints a melegentartóban listázott névre!", 255, 255, 255, true)
                            else 
                                outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Járműben ülve nem tudod belerakni!", 255, 255, 255, true)  
                            end
                        end
                    else 
                        outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Előbb vedd fel az ételeket az étteremben!", 255, 255, 255, true)
                    end
                else 
                    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Ez nem a te munkajárműved!", 255, 255, 255, true)
                end
            end
        end
        if isElement(deliveredCars) then
            local px, py, pz = getElementPosition(localPlayer)
            local vehX,vehY,vehZ = getElementPosition(deliveredCars)
            if getDistanceBetweenPoints3D(px, py, pz,vehX,vehY,vehZ)  < 2 then
                if getElementData(deliveredCars, "packageTable") then
                    if not isPedInVehicle(localPlayer) then
                        local startY = hintY2 + resp(30 + 10)
                        for i, data in pairs(ordersFood) do 
                            --local data = ordersFood[i]
                            if data then 
                                if not data[10] then
                                    if core:isInSlot(hintX2 + 2.5, startY, hintW-5, 20) then
                                        if not foodInHand then 
                                            exports["oChat"]:sendLocalMeAction("kivesz egy ételt a melegentartóból (".. data[3] ..") .")
                                            selectedTable = ordersFood[i]
                                            selectedTableId = i
                                            foodInHand = true
                                            triggerServerEvent("foodBagToPlayer", localPlayer, localPlayer, true)
                                        elseif foodInHand and selectedTable[3] == ordersFood[i][3] then
                                            exports["oChat"]:sendLocalMeAction("vissza rak egy ételt a melegentartóból (".. data[3] ..") .")
                                            selectedTable = {}
                                            selectedTableId = false
                                            foodInHand = false
                                            triggerServerEvent("foodBagToPlayer", localPlayer, localPlayer, false) 
                                        end
                                    end
                                    startY = startY + resp(25)
                                end
                            end
                        end
                    else 
                        outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Járműben ülve nem tudod kivenni!", 255, 255, 255, true)
                    end
                else 
                    outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."A járművedben nincs semmi!", 255, 255, 255, true)
                end
            end
        end
    end 
end

local values = 100
local selectRoute = 1
function drawHeater()
    dxDrawRectangle(hintX2-2, hintY2-2, hintW2+4, hintH2+4, tocolor(30,30,30,150))
    dxDrawRectangle(hintX2, hintY2, hintW2, hintH2, tocolor(30,30,30,255))
    dxDrawRectangle(hintX2, hintY2, hintW2, 30, tocolor(0,0,0,50))
    dxDrawText("Melegentartó", hintX2, hintY2, hintX2 + hintW2, hintY2 +resp(30+5), tocolor(255,255,255,255),resp(0.95),fonts["bebasneue-15"], "center", "center", false, false, false, true)
    local startY = hintY2 + resp(30 + 10)
   
    for i, data in pairs(ordersFood) do 
        --local data = ordersFood[i]
        if data then 
            if not data[10] then
                local theTime = getRealTime().timestamp
                local ido = theTime-((data[8]*60)+data[9])
                local coloring = ""
                h,m,s = secondsToMinutes(string.gsub(ido, "-",""))
                if ido < 0 then
                    coloring = "#7cc576"
                elseif ido > 0 then
                    coloring = "#F75252"
                end
                if ido < 0 then 
                    dxDrawText(data[1] .. "-"..color ..data[3] .. "#FFFFFF | "..coloring.. string.format("%.2i:%.2i:%.2i",h,m,s) .. "#FFFFFF", hintX2+resp(5), startY, 0, 0, tocolor(255,255,255,255),resp(0.85),fonts["bebasneue-15"], "left", "top", false, false, false, true)
                else
                    dxDrawText(data[1] .."-"..color ..data[3] .. "#FFFFFF |#F75252 0:00:00#FFFFFF", hintX2+resp(5), startY, 0, 0, tocolor(255,255,255,255),resp(0.85),fonts["bebasneue-15"], "left", "top", false, false, false, true)
                end
                if selectedTableId == i then 
                    dxDrawRectangle(hintX2 + 2.5, startY, hintW-5, 20, tocolor(r,g,b, 50))
                end
                --dxDrawBar(hintX2+resp(10)+dxGetTextWidth(data["name"] .. " | " ..data["status"] .. " min", resp(0.85), fonts["bebasneue-15"]),startY + resp(5), 120, 10, 2, tocolor(hr, hg, hb, 255), data["status"], "Heating", tocolor(247, 82, 82,50))
            end
            startY = startY + resp(25)
        end
    end
end

function minutesToHours(minutes)
	local totalMin = tonumber(minutes)
	if totalMin then
		local hours = math.floor(totalMin/60)
		local minutes = totalMin - hours*60
		local sec = totalMin - hours*60
		if hours and minutes then
			return hours,minutes,sec
		else
			return 0,0,0
		end
	end
end

function secondsToMinutes(seconds)
	local totalSec = tonumber(seconds)
	if totalSec then
		local seconds = math.fmod(math.floor(totalSec), 60)
		local minutes = math.fmod(math.floor(totalSec/60), 60)
		if seconds and minutes then
			return 0,minutes,seconds
		end
	end
end

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		
		if min > 0 then table.insert( results, min .. ( min == 1 and "" or "" ) ) end
		if sec > 0 then table.insert( results, sec .. ( sec == 1 and "" or "" ) ) end
		
		return string.reverse ( table.concat ( results, ":" ):reverse():gsub(" ,", ":", 1 ) )
	end
	return ""
end
--generateOrders()