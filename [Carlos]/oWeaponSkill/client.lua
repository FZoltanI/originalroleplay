local targetObj = false
local inMoveing = false

local moveLeft = true

local successful = 0
local allShots = 0
local headShots = 0

local time = {0, 0}
local timeCounter = false

local core = exports.oCore
local color, r, g, b = core:getServerColor()
local infobox = exports.oInfobox

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oWeaponSkill" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        infobox = exports.oInfobox
	end
end)

local skillingWeapon = {}

local distanceCheckNeeded = false

local weaponSkillingPed = createPed(287, 288.74069213867, -30.748559951782, 1001.515625, 218)
setElementDimension(weaponSkillingPed, dimensionID)
setElementInterior(weaponSkillingPed, interiorID)
setElementFrozen(weaponSkillingPed, true)
setElementData(weaponSkillingPed, "ped:name", "Robin Huff")
setElementData(weaponSkillingPed, "ped:prefix", "Lövész Gyakorlat")
setPedAnimation(weaponSkillingPed, "cop_ambient", "coplook_loop", -1, true, false, false)

function createRandomTarget()
    local x, y, z = unpack(createdPositions[math.random(#createdPositions)])
    targetObj = createObject(creatableObjects[math.random(#creatableObjects)], x, y, z)
    setElementInterior(targetObj, interiorID)
    setElementDimension(targetObj, 9999 + getElementData(localPlayer, "char:id"))

    setObjectBreakable(targetObj, false)

    if math.random(1, 2) == 1 then 
        moveLeft = not moveLeft
    end
end

function moveTargetObj()
    if isElement(targetObj) then 
        local x, y, z = getElementPosition(targetObj)
        if moveLeft then 
            if x < 299 then
                setElementPosition(targetObj, x+movePerTick, y, z)
            else
                moveLeft = false 
            end
        else
            if x > 285 then
                setElementPosition(targetObj, x-movePerTick, y, z)
            else
                moveLeft = true
            end
        end
    end
end

function onClientWeaponFire(weapon, ammo, clip, x, y, z, hitElement)
    allShots = allShots + 1
    if hitElement == targetObj then 
        successful = successful + 1
        destroyElement(targetObj)

        if z > 1002.9 then 
            headShots = headShots + 1
        end

        if successful == 15 then 
            outputChatBox(" ")
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Végeztél a lőgyakorlattal! ", 255, 255, 255, true)
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Fegyver: #e64c4c"..skillingWeapon[1].."#ffffff.", 255, 255, 255, true)
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Találatok: #e64c4c"..successful.."#ffffffdb.", 255, 255, 255, true)
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Fejlövések: #e64c4c"..headShots.."#ffffffdb.", 255, 255, 255, true)
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Összes lövés: #e64c4c"..allShots.."#ffffffdb.", 255, 255, 255, true)
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Idő: #e64c4c"..string.format("%02d:%02d", time[1], time[2]).."#ffffff.", 255, 255, 255, true)
            outputChatBox(" ")

            local skillPoints = 0 

            if time[1] == 0 and time[2] < 25 then 
                skillPoints = skillPoints + 1
            end

            skillPoints = skillPoints + math.floor(successful/allShots*10)

            skillPoints = skillPoints + (headShots)
            
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."A gyakorlatban #e64c4c"..skillPoints.."#ffffffdb skill pontot szereztél.", 255, 255, 255, true)

            triggerServerEvent("weaponSkill > updatePlayerWeaponStat", resourceRoot, skillingWeapon[2], math.min(getPedStat(localPlayer, skillingWeapon[2])+skillPoints, 1000))
            setElementPosition(localPlayer, 286.11422729492, -30.518243789673, 1001.515625)
            setElementDimension(localPlayer, dimensionID)

            if isTimer(timeCounter) then killTimer(timeCounter) end

            removeEventHandler("onClientPlayerWeaponFire", root, onClientWeaponFire)
            removeEventHandler("onClientPreRender", root, moveTargetObj)
            removeEventHandler("onClientRender", root, renderShootInfos)
            removeEventHandler("onClientKey", root, keyShootInfos)
            setElementFrozen(localPlayer, false)
            setElementData(localPlayer, "inWeaponSkilling", false)
        else
            createRandomTarget()
        end
    end
end

function startTimeCounting()
    timeCounter = setTimer(function()
        time[2] = time[2] + 1 

        if time[2] == 60 then 
            time[1] = time[1] + 1
            time[2] = 0
        end
    end, 1000, 0)
end

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local panelTick = getTickCount()
local panelAnimation = "open"
local panelShowing = false

local fonts = {
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
    ["bebasneue-17"] = exports.oFont:getFont("bebasneue", 17),
    ["bebasneue-55"] = exports.oFont:getFont("bebasneue", 100),
}


local counterTick = getTickCount()
local counterNumber = 3
function renderCounter()
    local scale = interpolateBetween(0.1, 0, 0, 1, 0, 0, (getTickCount()-counterTick)/1000, "InOutQuad")
    dxDrawText(counterNumber, 0, 0, sx, sy, tocolor(255, 255, 255, 150), scale/myX*sx, fonts["bebasneue-55"], "center", "center")
    dxDrawText(counterNumber, 0, 0, sx, sy, tocolor(255, 255, 255, 255), scale-0.1/myX*sx, fonts["bebasneue-55"], "center", "center")

    if scale == 1 then 
        counterTick = getTickCount()

        if type(counterNumber) == "number" then 
            counterNumber = counterNumber - 1
        else
            removeEventHandler("onClientRender", root, renderCounter)
            createRandomTarget()        
            startTimeCounting()
            addEventHandler("onClientRender", root, renderShootInfos)
            addEventHandler("onClientKey", root, keyShootInfos)
        end

        if counterNumber == 0 then 
            counterNumber = "Shoot!"
        end
    end
end

function renderShootInfos()
    core:dxDrawShadowedText("Találat: "..color..successful.."db #ffffff| Fejlövés: "..color..headShots.."db #ffffff| Eltelt idő: "..color..string.format("%02d:%02d", time[1], time[2]).." #ffffff| Összes lövés: "..color..allShots.."#ffffffdb", 0, 0, sx, sy*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)

    if core:isInSlot(sx*0.45, sy*0.05, sx*0.1, sy*0.03) then
        core:dxDrawRoundedRectangle(sx*0.45, sy*0.05, sx*0.1, sy*0.03, tocolor(212, 59, 49, 255))
    else
        core:dxDrawRoundedRectangle(sx*0.45, sy*0.05, sx*0.1, sy*0.03, tocolor(212, 59, 49, 200))
    end

    core:dxDrawShadowedText("Lőtér elhagyása", sx*0.45, sy*0.05, sx*0.45+sx*0.1, sy*0.05+sy*0.03, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.7/myX*sx, fonts["condensed-15"], "center", "center")
end

function keyShootInfos(key, state)
    if key == "mouse1" and state then 
        if core:isInSlot(sx*0.45, sy*0.05, sx*0.1, sy*0.03) then
            outputChatBox(" ")
            outputChatBox(core:getServerPrefix("server", "Lőtér", 2).."Mivel idő előtt elhagytad a lőteret így nem kapsz egyetlen skill pontot sem! ", 255, 255, 255, true)
            outputChatBox(" ")   

            setElementPosition(localPlayer, 286.11422729492, -30.518243789673, 1001.515625)
            setElementDimension(localPlayer, dimensionID)            

            if isTimer(timeCounter) then killTimer(timeCounter) end

            removeEventHandler("onClientPlayerWeaponFire", root, onClientWeaponFire)
            removeEventHandler("onClientPreRender", root, moveTargetObj)
            removeEventHandler("onClientRender", root, renderShootInfos)
            removeEventHandler("onClientKey", root, keyShootInfos)
            setElementFrozen(localPlayer, false)
            setElementData(localPlayer, "inWeaponSkilling", false)
            triggerServerEvent("weaponSkill > takePlayerAllWeapon", resourceRoot)

            if isElement(targetObj) then destroyElement(targetObj) end
        end
    end
end


function warpPedIntoShooting()
    local pos = Vector3(unpack(shootPositions[math.random(#shootPositions)]))

    setElementPosition(localPlayer, pos.x, pos.y, pos.z)
    setElementDimension(localPlayer,  9999 + getElementData(localPlayer, "char:id"))
    setElementFrozen(localPlayer, true)
    setElementRotation(localPlayer, 0, 0, 0)

    successful = 0
    allShots = 0
    headShots = 0

    time = {0, 0}

    counterNumber = 3
    counterTick = getTickCount()
    addEventHandler("onClientRender", root, renderCounter)
    addEventHandler("onClientPlayerWeaponFire", root, onClientWeaponFire)
    addEventHandler("onClientPreRender", root, moveTargetObj)
    setElementData(localPlayer, "inWeaponSkilling", true)
end

local panelAlpha = 0 
function renderStatPanel()
    if panelAnimation == "open" then 
        panelAlpha = interpolateBetween(panelAlpha, 0, 0, 1, 0, 0, (getTickCount()-panelTick)/500, "Linear")
    else
        panelAlpha = interpolateBetween(panelAlpha, 0, 0, 0, 0, 0, (getTickCount()-panelTick)/500, "Linear")
    end

    if distanceCheckNeeded then 
        if core:getDistance(localPlayer, weaponSkillingPed) > 3 then 
            showPanel()
        end

        if getKeyState("backspace") then 
            showPanel()
        end
    end

    dxDrawRectangle(sx*0.4, sy*0.3, sx*0.2, sy*0.463, tocolor(35, 35, 35, 255*panelAlpha))
    dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.3+2/myY*sy, sx*0.2-4/myX*sx, sy*0.05, tocolor(30, 30, 30, 255*panelAlpha))
    dxDrawText("Fegyver Skillek", sx*0.4+2/myX*sx, sy*0.3+2/myY*sy, sx*0.4+2/myX*sx+sx*0.2-4/myX*sx, sy*0.3+2/myY*sy+sy*0.05, tocolor(255, 255, 255, 255*panelAlpha), 1/myX*sx, fonts["bebasneue-17"], "center", "center")

    local startY = sy*0.355
    for i = 1, #weaponStats do 
        local alpha = 255 

        if i % 2 == 0 then 
            alpha = 180
        end

        dxDrawRectangle(sx*0.4+2/myX*sx, startY, sx*0.2-4/myX*sx, sy*0.035, tocolor(30, 30, 30, alpha*panelAlpha))
        dxDrawRectangle(sx*0.4+2/myX*sx, startY, sx*0.001, sy*0.035, tocolor(r, g, b, alpha*panelAlpha))

        if weaponStats[i] then 
            local stat = getPedStat(localPlayer, weaponStats[i][2])

            dxDrawText(color.."("..stat.."/1000) #ffffff"..weaponStats[i][1], sx*0.4+10/myX*sx, startY, sx*0.4+10/myX*sx+sx*0.1, startY+sy*0.02, tocolor(255, 255, 255, 255*panelAlpha), 0.6/myX*sx, fonts["condensed-15"], "left", "center", false, false, false, true)

            dxDrawRectangle(sx*0.4+10/myX*sx, startY+sx*0.012, sx*0.2-15/myX*sx, sy*0.01, tocolor(40, 40, 40, 210*panelAlpha))

            dxDrawRectangle(sx*0.4+10/myX*sx, startY+sx*0.012, (sx*0.2-15/myX*sx)*stat/1000, sy*0.01, tocolor(r, g, b, 210*panelAlpha))

            dxDrawImage(sx*0.4+13/myX*sx+dxGetTextWidth(weaponStats[i][1].." ("..stat.."/1000)", 0.6/myX*sx, fonts["condensed-15"]), startY+6/myY*sy, 6/myX*sx, 6/myY*sy, "files/arrow.png", 180, 0, 0, tocolor(67, 161, 85, 255*panelAlpha))
            dxDrawRectangle(sx*0.4+18/myX*sx+dxGetTextWidth(weaponStats[i][1].." ("..stat.."/1000)", 0.6/myX*sx, fonts["condensed-15"]), startY+3/myY*sy, dxGetTextWidth(weaponStats[i][3].."$", 0.6/myX*sx, fonts["condensed-15"]), sy*0.013, tocolor(67, 161, 85, 255*panelAlpha))
            dxDrawText(weaponStats[i][3].."$", sx*0.4+18/myX*sx+dxGetTextWidth(weaponStats[i][1].." ("..stat.."/1000)", 0.6/myX*sx, fonts["condensed-15"]), startY+3/myY*sy, sx*0.4+18/myX*sx+dxGetTextWidth(weaponStats[i][1].." ("..stat.."/1000)", 0.6/myX*sx, fonts["condensed-15"])+dxGetTextWidth(weaponStats[i][3].."$", 0.6/myX*sx, fonts["condensed-15"]), startY+3/myY*sy+sy*0.013, tocolor(255, 255, 255, 255*panelAlpha), 0.45/myX*sx, fonts["condensed-15"], "center", "center")
       
            if core:isInSlot(sx*0.557, startY+3/myY*sy, sx*0.04, sy*0.013) then
                dxDrawRectangle(sx*0.557, startY+3/myY*sy, sx*0.04, sy*0.013, tocolor(r, g, b, 220*panelAlpha))
            else
                dxDrawRectangle(sx*0.557, startY+3/myY*sy, sx*0.04, sy*0.013, tocolor(r, g, b, 150*panelAlpha))
            end

            core:dxDrawShadowedText("Skillezés", sx*0.557, startY+3/myY*sy, sx*0.557+sx*0.04, startY+3/myY*sy+sy*0.013, tocolor(255, 255, 255, 255*panelAlpha), tocolor(0, 0, 0, 255*panelAlpha), 0.48/myX*sx, fonts["condensed-15"], "center", "center")
        end

        startY = startY + sy*0.037
    end
end

function keyStatPanel(key, state)
    if key == "mouse1" and state then 
        local startY = sy*0.355
        for i = 1, #weaponStats do 
            if weaponStats[i] then
                if core:isInSlot(sx*0.557, startY+3/myY*sy, sx*0.04, sy*0.013) then
                    if getElementData(localPlayer, "char:money") >= weaponStats[i][3] then 
                        skillingWeapon = weaponStats[i]
                        warpPedIntoShooting()
                        showPanel()

                        triggerServerEvent("weaponSkill > giveWeaponToPlayer", resourceRoot, weaponStats[i][4])
                        triggerServerEvent("weaponSkill > setPlayerMoney", resourceRoot, getElementData(localPlayer, "char:money")-weaponStats[i][3])
                        infobox:outputInfoBox("Sikeresen megkezdted a lőgyakorlatot!", "success")
                    else
                        infobox:outputInfoBox("Nincs elég pénzed a lőgyakorlat megkezdéséhez!", "error")
                    end
                end
            end

            startY = startY + sy*0.037
        end
    end
end

function showPanel()
    if panelShowing then 
        panelShowing = false
        distanceCheckNeeded = false
        removeEventHandler("onClientKey", root, keyStatPanel)
        panelTick = getTickCount()
        panelAnimation = "close"
        setTimer(function() 
            removeEventHandler("onClientRender", root, renderStatPanel)
        end, 500, 1)
    else
        distanceCheckNeeded = true
        panelShowing = true
        panelTick = getTickCount()
        panelAnimation = "open"
        addEventHandler("onClientKey", root, keyStatPanel)
        addEventHandler("onClientRender", root, renderStatPanel)
    end
end

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end

local lastClick = 0
addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element == weaponSkillingPed then 
            if core:getDistance(localPlayer, element) < 3 then 
                if lastClick + 500 < getTickCount() then
                    showPanel()
                    lastClick = getTickCount()
                end
            end
        end
    end
end)