local jobElements = {}


addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oJob_Cleaner" or getResourceName(res) == "oCustomMarker" or getResourceName(res) == "oInterface" or getResourceName(res) == "oInventory" or getResourceName(res) == "oChat" or getResourceName(res) == "oBone" or getResourceName(res) == "oJob" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        cmarker = exports.oCustomMarker
        --font = exports.oFont
        interface = exports.oInterface
        inventory = exports.oInventory
        chat = exports.oChat
        bone = exports.oBone
        job = exports.oJob
	end
end)

function createCleanerElements()
    jobElements["vehicle-marker"], jobElements["vehicle-blip"] = job:createJobVehicleRequest("Takarító", 440, {92.383476257324, -153.45216369629, 2.5781502723694}, {{115.49864959717, -155.42672729492, 1.578125, 270}, {115.48661804199, -167.41223144531, 1.578125, 270}}, 15)

    jobElements["job-ped"] = createPed(268, 90.406967163086, -161.94219970703, 2.59375, 238)
        setElementFrozen(jobElements["job-ped"], true)
        setElementData(jobElements["job-ped"], "ped:name", "Drake Montana")
        setElementData(jobElements["job-ped"], "ped:prefix", "Munkáltató")
end

function destroyAllJobElement()
    for k, v in pairs(jobElements) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end

    jobElements = {}
end
------------------------
local sx,sy = guiGetScreenSize()
local myX,myY = 1600, 900

local sX,sY,sZ = 1,1,1
local playerDimension = 0

local osszKosz = 0
local takaritottKosz =  0
local payment = 0
local spendTime = {0, 0}
local spendTimeTimer = false
local trashBag = false
local trashBag_Trash = 0

local maxTrashInBag = 3

local randomInterior = 0
local randomizeInterior = 0

local colbanvan = false
local amibenvancol = false

local fonts = {
    ["condensed-10"] = exports.oFont:getFont("condensed", 10),
    ["condensed-12"] = exports.oFont:getFont("condensed", 12),
    ["condensed-14"] = exports.oFont:getFont("condensed", 14),
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
    ["condensed-20"] = exports.oFont:getFont("condensed", 20),
}

local housemarker = false

local progressbar_datas = {"nan", 0}
local tick = getTickCount()

local createdTrashes = {}

local soundInPlay = false

local isFirstTalk = true
local inWork = false
local cleaning = false

function outputJobTips() 
    outputChatBox(core:getServerPrefix("server", "Takarító", 3).."A munka kezdéséhez menj el a takarító telephelyre, amit a térképen egy"..color.." narancssárga #fffffftáska ikonnal jelöltünk.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Takarító", 3).."A munka kezdéséhez beszélj a "..color.."munkáltatóddal #ffffffaki oda adja neked a kitakarítandó címet.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Takarító", 3).."Vedd fel a munkajárműved majd hajts a térképen jelölt címre. ", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Takarító", 3).."Menj be a házba és takarítsd fel a szemeteket. Ha gyorsan végzel a munkával még "..color.."bónuszt #ffffffis kapsz! ", 255, 255, 255, true)
end

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "char:job" then 
            if new == 1 then 
                outputJobTips()
                createCleanerElements()
            end

            if old == 1 then 
                destroyAllJobElement()
                destroyHouseMarker()
                inWork = false
                isFirstTalk = true

                triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)
            end
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "char:job") == 1 then 
        outputJobTips()
        createCleanerElements()
    end
end)

for i = 0, 4 do
    setInteriorFurnitureEnabled(i, true)
end

addEventHandler("onClientMarkerHit", root,
    function(player,mdim)
        if player == localPlayer then 
            if mdim then
                if getElementData(source,"job->cleaner->cleanerMarker") then 
                    if getPedOccupiedVehicle(localPlayer) then return end 
                    
                    triggerServerEvent("job > newspaper > gotoInt", resourceRoot)

                    cleaning = false
                    setElementData(localPlayer,"job->cleaner->playerIsInterior",true)
                    playerDimension = getElementData(localPlayer,"user:id") or 20
                    playerDimension = 2000+playerDimension*3
                    sX,sY,sZ = getElementPosition(localPlayer)

                    randomizeInterior = math.random(#randinteriors)
                    setElementInterior(localPlayer, randinteriors[randomizeInterior][1])
                    setElementPosition(localPlayer,randinteriors[randomizeInterior][2],randinteriors[randomizeInterior][3],randinteriors[randomizeInterior][4])
                    setElementDimension(localPlayer, playerDimension)
                    
                    for i = 0, 4 do
                        setInteriorFurnitureEnabled(i, false)
                    end

                    createInteriorKoszok()

                    local trashBin = createObject(1343, interiorkoszok[randomizeInterior].bin.pos.x, interiorkoszok[randomizeInterior].bin.pos.y, interiorkoszok[randomizeInterior].bin.pos.z-0.5, 0, 0, interiorkoszok[randomizeInterior].bin.rot-180)
                    setObjectScale(trashBin, 0.8)
                    setElementData(trashBin, "cleaner:isTrashBin", true)
                    setElementDimension(trashBin, playerDimension)
                    setElementInterior(trashBin, randinteriors[randomizeInterior][1])

                    exitmarker = exports.oCustomMarker:createCustomMarker(randinteriors[randomizeInterior][2],randinteriors[randomizeInterior][3],randinteriors[randomizeInterior][4],1.5,205, 160, 232,255,"home")
                    setElementData(exitmarker,"job->cleaner->interiorExitMarker",true)
                    setElementInterior(exitmarker,randinteriors[randomizeInterior][1])
                    setElementDimension(exitmarker,playerDimension)

                    --outputChatBox(randomizeInterior.."randint")

                    addEventHandler("onClientRender", root, drawHouseInfo)
                    spendTimeTimer = setTimer(function()
                        spendTime[2] = spendTime[2] + 1

                        if spendTime[2] == 60 then 
                            spendTime[2] = 0 
                            spendTime[1] = spendTime[1] + 1
                        end
                    end, 1000, 0)

                    local playerpos = Vector3(getElementPosition(localPlayer))

                    trashBag = createObject(1264, playerpos.x, playerpos.y, playerpos.z)
                    setElementCollisionsEnabled(trashBag, false)
                    setElementInterior(trashBag, randinteriors[randomizeInterior][1])
                    setElementDimension(trashBag, playerDimension)

                    bone:attachElementToBone(trashBag, localPlayer, 11, 0.03, 0.02, 0.2, 180, 0, 0)

                    updateTrashBagSize()

                    addEventHandler("onClientRender", root, render3DIcons)

                    cleaning = false
                end 

                if getElementData(source,"job->cleaner->interiorExitMarker") then 
                    if osszKosz == takaritottKosz then 
                        if trashBag_Trash == 0 then 
                            warpPedOutOfInterior()
                            destroyHouseMarker()
                            destroyElement(trashBag)

                            for i = 0, 4 do
                                setInteriorFurnitureEnabled(i, true)
                            end

                            if isTimer(spendTimeTimer) then 
                                killTimer(spendTimeTimer)
                            end

                            outputChatBox(core:getServerPrefix("server", "Takarító", 2).."Mivel kitakarítottad a házat így fizetésül kaptál "..color..payment.."-$#fffffft!",255,255,255,true)

                            local neededTime = osszKosz*10
                            local myTime = (spendTime[1]*60+spendTime[2]) 

                            if myTime <= neededTime then 
                                local bonus = neededTime - myTime

                                bonus = bonus * 3
                                 
                                outputChatBox(" ")
                                outputChatBox(core:getServerPrefix("server", "Bónusz", 3).."A munkát az elvárt időnél hamarabb teljesítetted!", 255, 255, 255, true)
                                outputChatBox(core:getServerPrefix("server", "Bónusz", 3).."A bónusz összege "..color..bonus.."$#ffffff.", 255, 255, 255, true)
                                triggerServerEvent("cleaner > giveMoney", resourceRoot, payment+bonus)
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Bónusz", 3).."Sajnos nem sikerült a munkát az elvárt idő alatt befejezned, ezért nem kapsz bónuszt!", 255, 255, 255, true)
                                triggerServerEvent("cleaner > giveMoney", resourceRoot, payment)
                            end
                            payment = 0
                            destroyHouseMarker()

                            removeEventHandler("onClientRender", root, drawHouseInfo)
                            removeEventHandler("onClientRender", root, render3DIcons)
                            spendTime = {0, 0}

                            inWork = false 
                            outputChatBox(core:getServerPrefix("server", "Takarító", 2).."Ha folytatni szeretnéd a munkát, akkor menj vissza a munkáltatódhoz és kérj új címet, vagy ha nem, akkor add le a munkajárműved!",255,255,255,true)
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Takarító", 2).."Először ürítsd ki a szemeteszsákod!",255, 255, 255, true) 
                        end
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Takarító", 2).."Először takarítsd fel az összes szemetet!", 255, 255, 255, true)
                    end
                end
            end
        end
    end 
)

addEventHandler("onClientColShapeHit",getRootElement(),
    function(player, mdim)
        if player == localPlayer and mdim then 
            if getElementData(source,"job->cleaner->koszCol") then 
                colbanvan = true
                amibenvancol = source
                addEventHandler("onClientRender", root, interactionRender)
                addEventHandler("onClientRender", root, checkTrashPickup)
            end
        end
end)

addEventHandler("onClientColShapeLeave",getRootElement(),
    function(player, mdim)
        if player == localPlayer and mdim then 
            if getElementData(source,"job->cleaner->koszCol") then 
                colbanvan = false
                amibenvancol = false
                removeEventHandler("onClientRender", root, interactionRender)
                removeEventHandler("onClientRender", root, checkTrashPickup)
            end
        end
end)

local trashBar = {0, 0, getTickCount()}
function drawHouseInfo()
    dxDrawRectangle(sx*0.843, sy*0.95, sx*0.15, sy*0.035, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.843, sy*0.91, sx*0.15, sy*0.035, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.843, sy*0.87, sx*0.15, sy*0.035, tocolor(35, 35, 35, 255))

    dxDrawText("Szemetek: ", sx*0.848, sy*0.87, sx*0.848+sx*0.15, sy*0.87+sy*0.035, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-12"], "left", "center")
        dxDrawText(color..takaritottKosz.."#ffffff/"..osszKosz, sx*0.837, sy*0.87, sx*0.837+sx*0.15, sy*0.87+sy*0.035, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-12"], "right", "center", false, false, false, true)

    dxDrawText("Fizetésed: ", sx*0.848, sy*0.91, sx*0.848+sx*0.15, sy*0.91+sy*0.035, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-12"], "left", "center")
        dxDrawText("#64c25f"..payment.."#ffffff$", sx*0.837, sy*0.91, sx*0.837+sx*0.15, sy*0.91+sy*0.035, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-12"], "right", "center", false, false, false, true)

    dxDrawText("Eltelt idő: ", sx*0.848, sy*0.95, sx*0.848+sx*0.15, sy*0.95+sy*0.035, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-12"], "left", "center")

    local min, sec = spendTime[1], spendTime[2]

    if min < 10 then 
        min = "0"..min 
    end

    if sec < 10 then 
        sec = "0"..sec
    end

    dxDrawText(min..color..":#ffffff"..sec, sx*0.837, sy*0.95, sx*0.837+sx*0.15, sy*0.95+sy*0.035, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-12"], "right", "center", false, false, false, true)

    dxDrawRectangle(sx*0.825, sy*0.87, sx*0.015, sy*0.115, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.825+2/myX*sx, sy*0.87+2/myY*sy, sx*0.015-4/myX*sx, sy*0.115-4/myY*sy, tocolor(45, 45, 45, 255))

    local trashCount = interpolateBetween(trashBar[1]/maxTrashInBag, 0, 0, trashBar[2]/maxTrashInBag, 0, 0, (getTickCount()-trashBar[3])/300, "Linear")

    if trashCount > 1 then 
        trashCount = 1 
    end

    if trashCount > 0 then 
        dxDrawRectangle(sx*0.825+2/myX*sx, sy*0.87+2/myY*sy+sy*0.115-4/myY*sy, sx*0.015-4/myX*sx, 0-((sy*0.115)*trashCount)+4/myY*sy, tocolor(r, g, b, 200))
    end

    dxDrawImage(sx*0.802, sy*0.945, 35/myX*sx, 35/myY*sy, "files/trash.png", 0, 0, 0, tocolor(r, g, b, 255))
end

local lastClean = 0
function checkTrashPickup()
    if getKeyState("e") then 
        if lastClean + 1000 < getTickCount() then 
            if not cleaning then 
                removeEventHandler("onClientRender", root, checkTrashPickup)

                if trashBag_Trash < maxTrashInBag then 
                    setElementData(localPlayer, "job:cleaning", true)
                    lastClean = getTickCount()
                    cleaning = true

                    local level = getElementData(localPlayer,"job->level->cleaner") or 1
                    local cleaningTime = 6000 - (150*level)

                    setElementFrozen(localPlayer, true)
                    setPedAnimation(localPlayer, "COP_AMBIENT", "Copbrowse_loop", cleaningTime, true, false, false, false)

                    progressbar_datas = {"Szemét feltakarítása", cleaningTime}
                    progressBarAnimTick = getTickCount()
                    tick = getTickCount()
                    progressBarAnimType = "open"
                    addEventHandler("onClientRender", root, renderProgressBar)

                    soundInPlay = playSound("files/trash_to_bag.wav", true)

                    setTimer(function()
                        setElementData(localPlayer, "job:cleaning", false)

                        if isElement(soundInPlay) then 
                            destroyElement(soundInPlay)
                        end
                        progressBarAnimTick = getTickCount()
                        progressBarAnimType = "close"

                        setPedAnimation(localPlayer)
                        setElementFrozen(localPlayer, false)

                        --addCleaningXp()
                        if amibenvancol then 
                            chat:sendLocalMeAction("feltakarított egy szemetet")
                            for k, v in ipairs(createdTrashes) do 
                                if getElementData(v, "cleaner:obj:col") == amibenvancol then 
                                    table.remove(createdTrashes, k)
                                    break
                                end
                            end
                            destroyElement(getElementData(amibenvancol,"job->cleaner->colObj"))
                            destroyElement(amibenvancol)
                            colbanvan = false 
                            amibenvancol = false
                            takaritottKosz = takaritottKosz + 1

                            trashBar = {trashBag_Trash, trashBag_Trash+1, getTickCount()}
                            trashBag_Trash = trashBag_Trash + 1 
                            updateTrashBagSize()

                            local maradek = osszKosz - takaritottKosz

                            if job:isJobHasDoublePaymant(1) then 
                                local randpayment = (math.random(80, 120) * 2)
                                payment = payment + randpayment
                                outputChatBox(core:getServerPrefix("green-dark", "Takarító", 2).."Mivel feltakarítottad a szemetet így a fizetésed nőtt "..color..randpayment.."$-al#ffffff.", 255, 255, 255, true)
                            else
                                local randpayment = math.random(80, 120)
                                payment = payment + randpayment
                                outputChatBox(core:getServerPrefix("green-dark", "Takarító", 2).."Mivel feltakarítottad a szemetet így a fizetésed nőtt "..color..randpayment.."$-al#ffffff.", 255, 255, 255, true)
                            end

                            cleaning = false
                        end

                        removeEventHandler("onClientRender", root, interactionRender)

                        setTimer(function() removeEventHandler("onClientRender", root, renderProgressBar) end, 250, 1)
                    end, cleaningTime, 1)
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Takarító", 2).."Tele van a szemeteszsákod. Kiüríteni a bejárat melletti kukánál tudod.", 255, 255, 255, true)
                end
            end
        end
    end
end

local trashIcon = dxCreateTexture("files/trash.png")
local animTime = getTickCount()
function render3DIcons()
    for k,v in ipairs(createdTrashes) do 
        local mX,mY,mZ = getElementPosition(v)
        local mR, mG, mB = r, g, b
        mZ = mZ + 0.01

        if core:getDistance(localPlayer, v) < 60 then 
            local icon_alpha = interpolateBetween(1,0,0,0.7,0,0,(getTickCount() - animTime) / 4000, "CosineCurve")

            local position = 150

            dxDrawMaterialLine3D(mX, mY, mZ+0.9+0.5+(position/2500),mX, mY, mZ+0.9+(position/2500), trashIcon, 0.5, tocolor( mR, mG, mB, 250*icon_alpha))
        end
    end
end 

local progressBarAnimType = "open"
local progressBarAnimTick = getTickCount()
function renderProgressBar()
    local alpha
    
    if progressBarAnimType == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    end

    local line_height = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick)/progressbar_datas[2], "Linear")

    dxDrawRectangle(sx*0.4, sy*0.85, sx*0.2, sy*0.03, tocolor(40, 40, 40, 255*alpha))
    dxDrawRectangle(sx*0.401, sy*0.852, (sx*0.2-sx*0.002), sy*0.03-sy*0.004, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*0.401, sy*0.852, (sx*0.2-sx*0.002)*line_height, sy*0.03-sy*0.004, tocolor(r, g, b, 255*alpha))

    dxDrawText(progressbar_datas[1], sx*0.4, sy*0.85, sx*0.4+sx*0.2, sy*0.85+sy*0.03, tocolor(35, 35, 35, 255*alpha), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
end

function interactionRender()
    shadowedText("Az interakcióhoz nyomd meg az "..color.."[E] #ffffffgombot.", 0, sy*0.89, sx, sy*0.89+sy*0.05, tocolor(255, 255, 255, 255), 0.9/myX*sx, fonts["condensed-14"], "center", "center", false, false, false, true)
end

function renderVehiclePickup() 
    local munkakocsi = getElementData(localPlayer,"job->haveJobVehicle") or false 
    if munkakocsi then 
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
            shadowedText2("Munkajármű leadása",0, 0, sx, sy, 201, 73, 68, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        else
            shadowedText2("Munkajármű leadása",0, 0, sx, sy, 220, 220, 220, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        end
    else
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
            shadowedText2("Munkajármű felvétel",0, 0, sx, sy, 74, 145, 86, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        else
            shadowedText2("Munkajármű felvétel",0, 0, sx, sy, 220, 220, 220, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        end
    end
end

function vehicleKey(key, state)
    if state then 
        if key == "mouse1" then 
            local munkakocsi = getElementData(localPlayer,"job->haveJobVehicle") or false 

            if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
                if munkakocsi then 
                    killTimer(getElementData(source, "job->vehicleDelTimer"))
                    triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)
                else
                    triggerServerEvent("job->newspaper->makevehicle", resourceRoot)
                end
                removeEventHandler("onClientRender", root, renderVehiclePickup)
                removeEventHandler("onClientKey", root, vehicleKey)
            end
        end
    end
end

-- / Talk / --
local animation_tick = getTickCount()
local animation_state = "open"
local talk_text = {"nan", 1}
local inTalk = false

local pC1x, pC1y, pC1z, pC2x, pC2y, pC2z
function renderTalkPanel()
    local alpha 
    
    if animation_state == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    end

    dxDrawRectangle(0, sy*0.9, sx*0.5*alpha, sy*0.1, tocolor(30, 30, 30, 255*alpha))
    dxDrawRectangle(sx-sx*0.5*alpha, sy*0.9, sx/2, sy*0.1, tocolor(30, 30, 30, 255*alpha))

    if talk_text then 
        dxDrawText(color.."[Drake]: #dcdcdc"..texts[talk_text[1]][talk_text[2]], 0, sy*0.9, sx, sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)
    end
end

function startTalkAnimation() 
    setElementAlpha(localPlayer, 0)
    pC1x, pC1y, pC1z, pC2x, pC2y, pC2z = getCameraMatrix()

    local bossPedPos = Vector3(getElementPosition(jobElements["job-ped"]))

    smoothMoveCamera(pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, bossPedPos.x+3, bossPedPos.y, bossPedPos.z+0.6, bossPedPos.x, bossPedPos.y, bossPedPos.z+0.6, 1000)

    animation_state = "open"
    animation_tick = getTickCount() 
    addEventHandler("onClientRender", root, renderTalkPanel)

    setElementFrozen(localPlayer, true)

    showChat(false)
    interface:toggleHud(true)

    inTalk = true

    setTimer(function() 
        setElementData(localPlayer, "user:hideWeapon", true)
        bindKey("backspace", "up", stopTalkAnimation) 
    end, 1000, 1)
end

function stopTalkAnimation()
    setElementAlpha(localPlayer, 255)
    local bossPedPos = Vector3(getElementPosition(jobElements["job-ped"]))

    smoothMoveCamera(bossPedPos.x-3, bossPedPos.y, bossPedPos.z+0.6, bossPedPos.x, bossPedPos.y, bossPedPos.z+0.6, pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, 1000)

    animation_state = "close"
    animation_tick = getTickCount() 

    showChat(true)
    setPedAnimation(jobElements["job-ped"])
    interface:toggleHud(false)
    unbindKey("backspace", "up", stopTalkAnimation)

    setElementFrozen(localPlayer, false)

    killTalkingTimers() 

    inTalk = false

    setTimer(function() 
        setElementData(localPlayer, "user:hideWeapon", false)
        setCameraTarget(localPlayer, localPlayer) 
        inAnimation = false  
        removeEventHandler("onClientRender", root, renderTalkPanel) 
        talk_text = false 
        talking_timers = {}
    end, 1000, 1)
end

function killTalkingTimers()
    for k, v in ipairs(talking_timers) do 
        if isTimer(v) then 
            killTimer(v)
        end
    end

    talking_timers = {}
end

function talkingAnimation(text_group)
    talking_timers = {}
    local timer_time = 0

    setPedAnimation(jobElements["job-ped"], "GHANDS", "gsign5", -1, true, false, false, false)
    for k, v in ipairs(texts[text_group]) do 
        timer_time = timer_time + string.len(v)*text_wait

        if k == 1 then 
            talk_text = {text_group, 1}
        elseif k == #texts[text_group] then 
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1

                setTimer(function() 
                    talk_text = false 
                    setPedAnimation(jobElements["job-ped"])

                    isFirstTalk = false

                    stopTalkAnimation()
                    inWork = true

                    createHouseMarker()
                end, string.len(v)*text_wait, 1)
            end, timer_time,1)

            table.insert(talking_timers, #talking_timers+1, timer)
        else
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1
            end, timer_time,1)

            table.insert(talking_timers, #talking_timers+1, timer)
        end
    end
end
---------

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element then 
            if getElementData(element, "cleaner:isTrashBin") then 
                if core:getDistance(element, localPlayer) < 3 then 
                    if trashBag_Trash > 0 then 
                        trashBar = {trashBag_Trash, 0, getTickCount()}
                        trashBag_Trash = 0
                        updateTrashBagSize()
                        soundInPlay = playSound("files/trash_to_bin.wav", false)
                        setSoundVolume(soundInPlay, 1.5)
                        chat:sendLocalMeAction("kiürítette a szemeteszsákot")
                        outputChatBox(core:getServerPrefix("green-dark", "Takarító", 2).."Sikeresen kiürítetted a szemeteszsákodat.", 255, 255, 255, true)
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Takarító", 2).."Túl távol vagy!", 255, 255, 255, true)
                end
            end

            if element == jobElements["job-ped"] then 
                if core:getDistance(element, localPlayer) < 3 then 
                    if not inTalk then 
                        if not inWork then 
                            if isFirstTalk then 
                                talkingAnimation("start")
                                startTalkAnimation()
                            else
                                talkingAnimation("normal")
                                startTalkAnimation()
                            end
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Takarító", 2).."Jelenleg van kiosztott feladatod!", 255, 255, 255, true)
                        end
                    end
                end
            end
        end
    end
end)

--[[bindKey("e","up",
    function()
        if colbanvan then 

            if not cleaning then 
                if trashBag_Trash < maxTrashInBag then 

                    cleaning = true

                    local level = getElementData(localPlayer,"job->level->cleaner") or 1
                    local cleaningTime = 6000 - (150*level)

                    setElementFrozen(localPlayer, true)
                    setPedAnimation(localPlayer, "COP_AMBIENT", "Copbrowse_loop", cleaningTime, true, false, false, false)

                    progressbar_datas = {"Szemét feltakarítása", cleaningTime}
                    progressBarAnimTick = getTickCount()
                    tick = getTickCount()
                    progressBarAnimType = "open"
                    addEventHandler("onClientRender", root, renderProgressBar)

                    soundInPlay = playSound("files/trash_to_bag.wav", true)

                    setTimer(function()
                        if isElement(soundInPlay) then 
                            destroyElement(soundInPlay)
                        end
                        progressBarAnimTick = getTickCount()
                        progressBarAnimType = "close"

                        setPedAnimation(localPlayer)
                        setElementFrozen(localPlayer, false)

                        addCleaningXp()
                        if amibenvancol then 
                            chat:sendLocalMeAction("feltakarított egy szemetet")
                            for k, v in ipairs(createdTrashes) do 
                                if getElementData(v, "cleaner:obj:col") == amibenvancol then 
                                    table.remove(createdTrashes, k)
                                    break
                                end
                            end
                            destroyElement(getElementData(amibenvancol,"job->cleaner->colObj"))
                            destroyElement(amibenvancol)
                            colbanvan = false 
                            amibenvancol = false
                            takaritottKosz = takaritottKosz + 1

                            trashBar = {trashBag_Trash, trashBag_Trash+1, getTickCount()}
                            trashBag_Trash = trashBag_Trash + 1 
                            updateTrashBagSize()

                            local maradek = osszKosz - takaritottKosz

                            if job:isJobHasDoublePaymant(1) then 
                                payment = payment + 80
                                outputChatBox(core:getServerPrefix("green-dark", "Takarító", 2).."Mivel feltakarítottad a szemetet így a fizetésed nőtt"..color.." 80$-al#ffffff.", 255, 255, 255, true)
                            else
                                payment = payment + 40
                                outputChatBox(core:getServerPrefix("green-dark", "Takarító", 2).."Mivel feltakarítottad a szemetet így a fizetésed nőtt"..color.." 40$-al#ffffff.", 255, 255, 255, true)
                            end

                            cleaning = false
                        end

                        removeEventHandler("onClientRender", root, interactionRender)

                        setTimer(function() removeEventHandler("onClientRender", root, renderProgressBar) end, 250, 1)
                    end, cleaningTime, 1)
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Takarító", 2).."Tele van a szemeteszsákod. Kiüríteni a bejárat melletti kukánál tudod.", 255, 255, 255, true)
                end
            end
        end
    end 
)]]

function createInteriorKoszok()
    osszKosz = 0
    createdTrashes = {}
    for k, v in ipairs(interiorkoszok[randomizeInterior]) do 
        local randKoszObj = math.random(#trash_objects)
        
        local koszObj = createObject(trash_objects[randKoszObj][1], v[1], v[2], v[3]-trash_objects[randKoszObj][2], 0, 0, math.random(360))

        local col = createColTube(0, 0, 0, 1.2, 3.5)

        setElementData(col, "job->cleaner->koszCol", true)
        setElementData(col, "job->cleaner->colObj", koszObj)

        setElementData(koszObj, "cleaner:obj:col", col)

        attachElements(col, koszObj, 0, 0, -1)
        setElementDimension(col, playerDimension)
        setElementInterior(col, randinteriors[randomizeInterior][1])

        setElementData(koszObj, "job->cleaner->isKoszMarker", true)

        setElementInterior(koszObj, randinteriors[randomizeInterior][1])
        setElementDimension(koszObj, playerDimension)

        table.insert(createdTrashes, #createdTrashes+1, koszObj)

        osszKosz = osszKosz + 1
    end
end

function createHouseMarker()
    randomInterior = math.random(#housepositions)

    housemarker = exports.oCustomMarker:createCustomMarker(housepositions[randomInterior][1],housepositions[randomInterior][2],housepositions[randomInterior][3], 3.5, 205, 160, 232, 255, "home")

    houseBlip = createBlipAttachedTo(housemarker, 5)
    setElementData(houseBlip, "blip:name", "Kitakarítandó lakás")
    setElementData(housemarker,"job->cleaner->cleanerMarker",true)
end

function destroyHouseMarker()
    if isElement(housemarker) then 
        destroyElement(housemarker)
    end
    if isElement(houseBlip) then 
        destroyElement(houseBlip)
    end
    takaritottKosz = 0
end

function warpPedOutOfInterior()
    triggerServerEvent("job > newspaper > gotoOut", resourceRoot)
    setElementPosition(localPlayer,sX,sY,sZ)
    setElementInterior(localPlayer,0)
    setElementDimension(localPlayer,0)

    setElementData(localPlayer,"job->cleaner->playerIsInterior",false)
end

function addCleaningXp()
    local playerXp = getElementData(localPlayer, "job->level->cleaner->xp") or 0

    playerXp = playerXp + 1
    
    if playerXp == 30 then
        local level = getElementData(localPlayer, "job->level->cleaner") or 1
        if level < 10 then 
            playerXp = 0
            setElementData(localPlayer, "job->level->cleaner", level + 1)
            outputChatBox(core:getServerPrefix("server", "Takarító", 1).."Szintet léptél a "..color.."takarításban#ffffff! Új szinted: "..color..(level + 1).."#ffffff!",255, 255, 255, true)
            outputChatBox(color.."~Szintlépés: #ffffffMivel szintet léptél így hatékonyabb leszel a takarításban.", 255, 255, 255, true)
        end
    end 

    setElementData(localPlayer, "job->level->cleaner->xp", playerXp)
end

function updateTrashBagSize()
    setObjectScale(trashBag, 0.2 + (trashBag_Trash/10))

    bone:attachElementToBone(trashBag, localPlayer, 11, 0.03, 0.02, 0.2+(trashBag_Trash/20), 180, 0, 0)
end

addEventHandler("onClientResourceStop", resourceRoot, function()
    if isElement(jobElements["vehicle-marker"]) then 
        destroyElement(jobElements["vehicle-marker"])
    end

    if housemarker then 
        destroyElement(housemarker)
    end

    if getElementData(localPlayer,"job->cleaner->playerIsInterior") then 
        warpPedOutOfInterior()
    end

    setElementData(localPlayer, "job->haveJobVehicle", false)
end)

-----SmoothCamera
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then
		destroyElement(sm.object1)
		destroyElement(sm.object2)
		killTimer(timer1)
		killTimer(timer2)
		killTimer(timer3)
		removeEventHandler("onClientPreRender",root,camRender)
	end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(destroyElement,time,1,sm.object1)
	timer3 = setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

function shadowedText2(text,x,y,x2,y2,r,g,b,a,size,font,align1,align2) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y+1,x2+1,y2+1,tocolor(0,0,0,a),size,font,align1,align2,false,false,false,false)
    dxDrawText(text,x,y,x2,y2,tocolor(r,g,b,a),size,font,align1,align2,false,false,false,true)
end

local vehDestroyTimer
addEventHandler("onClientVehicleExit", root, function(player)
    if player == localPlayer then
        if getElementData(source, "cleaner:isJobVehicle") then 
            if source == getElementData(player, "job->jobVehicle") then 
                outputChatBox(core:getServerPrefix("red-dark", "Munkajármű", 3).."Mivel kiszálltál a munkajárművedből, így "..color.."15 #ffffffpercen belül törlésre kerül!", 255, 255, 255, true)
                vehDestroyTimer = setTimer(function()
                    triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)
                end, core:minToMilisec(15), 1)
            end
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player)
    if player == localPlayer then
        if getElementData(source, "cleaner:isJobVehicle") then 
            if source == getElementData(player, "job->jobVehicle") then 
                outputChatBox(core:getServerPrefix("green-dark", "Munkajármű", 3).."Mivel vissza szálltál a munkajárművedbe így nem kerül törlésre!", 255, 255, 255, true)
                
                if isTimer(vehDestroyTimer) then 
                    killTimer(vehDestroyTimer)
                end
            end
        end
    end
end)