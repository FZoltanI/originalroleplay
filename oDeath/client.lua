local bloodTimer
local effectTick = getTickCount()
local deathSound = false
local deathTime = {0, 0}
local deathTimeTimer = false
local deathPed = false
local timers = {}

local ifp

local fonts = {
    ["condensed-55"] = exports.oFont:getFont("condensed", 55),
    ["condensed-10"] = exports.oFont:getFont("condensed", 10),
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
}

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900
local alpha = 0

addEventHandler("onClientResourceStart", resourceRoot, function()
    ifp = engineLoadIFP("files/sleep.ifp", "OriginalRoleplay") -- Idlestance_fat

    local hp = getElementHealth(localPlayer)
    if hp <= anim_start_hp then 
        if hp == 0 then 
            startDeath()
            triggerServerEvent("startDeath > onServer", resourceRoot)
        else
            addEventHandler("onClientRender", root, renderBloodBar)
            triggerServerEvent("startAnim->OnServer", resourceRoot)
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(theKey, oldValue, newValue)
    if source == localPlayer then 
        if theKey == "char:health" then 
            if newValue <= anim_start_hp and newValue > 0 and oldValue > anim_start_hp then 
                triggerServerEvent("startAnim->OnServer", resourceRoot)
                addEventHandler("onClientRender", root, renderBloodBar)
            end
        end

        if theKey == "char:blood" then
            if newValue == 100 then 
                if not isTimer(bloodTimer) then 
                    bloodTimer = setTimer(function() 
                        setElementData(localPlayer, "char:blood", getElementData(localPlayer, "char:blood") - 1 )
                        --outputChatBox(getElementData(localPlayer, "char:blood"))

                        --[[if getElementData(localPlayer, "char:blood") % 5 == 0 then 
                            triggerServerEvent("death > sync > blood", resourceRoot, getElementData(localPlayer, "char:blood"))
                        end]]

                        if getElementData(localPlayer, "char:blood") <= 0 then 
                            killTimer(bloodTimer) 
                            setElementHealth(localPlayer, 0)
                            setElementData(localPlayer, "char:health", 0)
                            triggerServerEvent("animEnd->onServer", resourceRoot)
                            --removeEventHandler("onClientRender", root, renderBloodBar)
                            bloodTimer = false 
                        end
                    end, 6000, 0 )
                end
            end
        end
    end
end)

function startDeath()
    deathTime = {10, 0}
    exports.oInterface:toggleHud(true)
    showChat(false)

    setCameraShakeLevel(0)
    setCameraTarget(localPlayer, localPlayer)

    local playerPos = Vector3(getElementPosition(localPlayer))
    smoothMoveCamera(playerPos.x, playerPos.y, playerPos.z, playerPos.x, playerPos.y, playerPos.z, playerPos.x, playerPos.y, playerPos.z+200, playerPos.x, playerPos.y, playerPos.z, 20000)

    createInjuredRoom()

    timers[1] = setTimer(function()
        showChat(false)
        exports.oInterface:toggleHud(true)
        fadeCamera(false, 10)

        timers[2] = setTimer(function()
            deathPed = createPed(getElementModel(localPlayer), 1162.2408447266, -1348.3260498047, -25.659616851807)
            setElementFrozen(deathPed, true)
            setElementCollisionsEnabled(deathPed, false)
            setPedAnimation(deathPed, "OriginalRoleplay", "Idlestance_fat", -1, true, false)
            setCameraMatrix(1165.1435546875,-1350.7779541016,-24.198799133301,1164.2950439453,-1350.3818359375,-24.549697875977)

            fadeCamera(true, 10)

            setElementDimension(deathPed, 1)
            setElementDimension(localPlayer, 1)

            deathSound = playSound("files/hearthbeat.mp3", true)
            setSoundSpeed(deathSound, 0.5)
            setSoundVolume(deathSound, 9)
            
            timers[3] = setTimer( function() 
                effectTick = getTickCount()
                addEventHandler("onClientRender", root, renderDiedEffect) 

                deathTimeTimer = setTimer(function()
                    if deathTime[2] == 0 then 
                        deathTime[1] = deathTime[1] - 1 
                        deathTime[2] = 59
                    else
                        deathTime[2] = deathTime[2] - 1
    
                        if deathTime[1] == 0 and deathTime[2] == 0 then 
                            if isTimer(deathTimeTimer) then 
                                killTimer(deathTimeTimer)
                            end 
                            stopDeath()
                            triggerServerEvent("respawnPlayer", resourceRoot)
                        end
                    end
                end, 1000, 0)
            end, 5000, 1)
        end, 10000, 1)
    end, 10000, 1)
end

function stopDeath()
    setCameraTarget(localPlayer, localPlayer)
    setElementDimension(localPlayer, 0)
    destroyInjuredRoom()

    if isElement(deathSound) then 
        destroyElement(deathSound)
    end

    for k, v in pairs(timers) do 
        if isTimer(v) then 
            killTimer(v)
        end
    end

    exports.oInterface:toggleHud(false)

    if isElement(deathPed) then 
        destroyElement(deathPed)
    end
    showChat(true)

    removeEventHandler("onClientRender", root, renderDiedEffect) 

    if isTimer(deathTimeTimer) then 
        killTimer(deathTimeTimer)
    end
    fadeCamera(true)

    removeCamHandler()
end

addEvent("endDeath", true)
addEventHandler("endDeath", root, function() 
    fadeCamera(true)
    stopDeath()
end)

addEventHandler("onClientPlayerWasted", localPlayer, function(killer, weapon, bodypart, stealth)
    setTimer( function() 
        if getElementData(localPlayer, "user:loggedin") then 
            if getElementData(localPlayer, "playerInAnim") then 
                triggerServerEvent("animEnd->onServer", resourceRoot)
            end
            showChat(false)
            exports.oInterface:toggleHud(true)
            setCameraShakeLevel(0)
            damageText = "Ismeretlen"
            if stealth then 
                damageText = "elvágták a torkát"
            else
                damageText = "Ismeretlen"
            end

            triggerServerEvent("startDeath > onServer", resourceRoot, localPlayer, damageText)
            startDeath()
        end
    end, 500, 1)
end)

function renderDiedEffect() 
    alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - effectTick) / 1000, "Linear")
    dxDrawRectangle(0, 0, sx, sy, tocolor(30, 30, 30, 220*alpha))
    dxDrawImage(0, 0, sx, sy, "files/sotet.png", 0, 0, 0, tocolor(30, 30, 30, 255*alpha))

    local min, sec = deathTime[1], deathTime[2]
    if min < 10 then 
        min = "0"..min
    end

    if sec < 10 then 
        sec = "0"..sec 
    end
    dxDrawText(min..":"..sec, 0, 0, sx, sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-55"], "center", "center")
end

function renderBloodBar()
    local blood = getElementData(localPlayer, "char:blood") or 100

    dxDrawRectangle(sx*0.45, sy*0.89, sx*0.1, sy*0.04, tocolor(30, 30, 30, 200))
    core:dxDrawShadowedText("Vérszinted: "..blood.."%", sx*0.4+2.5/myX*sx, sy*0.9+3/myY*sy, sx*0.4+2.5/myX*sx+sx*0.2-5/myX*sx, sy*0.9+3/myY*sy+sy*0.02-6/myY*sy, tocolor(227, 59, 59, 255), tocolor(0, 0, 0, 255), 0.75/myX*sx, fonts["condensed-15"], "center", "center")
end

addEvent("endAnim->onClient", true)
addEventHandler("endAnim->onClient", resourceRoot, function()
    removeEventHandler("onClientRender", root, renderBloodBar)
    if isTimer(bloodTimer) then 
        killTimer(bloodTimer)
    end
end)

-- / Usefull / --
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
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
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

local injuredRoom = {}
function createInjuredRoom()
    for k, v in ipairs(injured_room) do 
        local obj = createObject(v.obj, v.pos.x, v.pos.y, v.pos.z, v.rotX, v.rotY, v.rotZ)
        setObjectScale(obj, v.scale)
        setElementDoubleSided(obj, true)
        setElementStreamable(obj, false)
        setElementDimension(obj, 1)
        table.insert(injuredRoom, obj)
    end
end

function destroyInjuredRoom()
    for k, v in ipairs(injuredRoom) do 
        destroyElement(v)
    end
    injuredRoom = {}
end

-- Commands
exports.oAdmin:addAdminCMD("ahelp", 2, "Játékos újraélesztése")
exports.oAdmin:addAdminCMD("asegit", 2, "Játékos újraélesztése")

 -- betegség rendszer
local rainTimer = false
local notBuilding = false
local warningCounter = 0

local warningTimer = false

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()), function()
	rainTimer = setTimer(checkRain, 1*60*1000, 1)
end)

addEventHandler("onClientElementDataChange", localPlayer, function(theKey, oldValue, newValue)
	if getElementType(source) == "player" then
		if theKey == "user:loggedin" and newValue then
			rainTimer = setTimer(checkRain, 1*60*1000, 1)
		elseif theKey == "user:aduty" then 
			if not getElementData(source, theKey) then
				rainTimer = setTimer(checkRain, 1*60*1000, 1)
			end
        elseif theKey == "char:raincoat" then 
            if not getElementData(source, theKey) then
				rainTimer = setTimer(checkRain, 1*60*1000, 1)
			end
		end
	end
end)

function checkRain()
    if getRainLevel() > 0 then
        if getElementData(localPlayer, "adminJail.IsAdminJail") then 
			if isTimer(rainTimer) then 
				killTimer(rainTimer)
				rainTimer = nil
			end
			rainTimer = setTimer(checkRain, 1*60*1000,1)
			return
		end		
		if getElementData(localPlayer,"pd:jail") then 
			if isTimer(rainTimer) then 
				killTimer(rainTimer)
				rainTimer = nil
			end
			rainTimer = setTimer(checkRain, 1*60*1000,1)
			return
		end
		if isTimer(rainTimer) then 
			killTimer(rainTimer)
			rainTimer = nil
		end
		if getElementData(localPlayer, "user:aduty") then 
			return
		end
        if getElementData(localPlayer, "char:raincoat") then 
            return
        end

        local x,y,z = getElementPosition(localPlayer)
        notBuilding = not isLineOfSightClear(x,y,z,x,y,z+50, true, false, false, true, false)
        if not notBuilding then 
            --print("megfázás")
            rainTimer = setTimer(checkRain, 1*60*1000,1)
            if getElementData(localPlayer, "char:sick") <= 100 then 
                setElementData(localPlayer, "char:sick", getElementData(localPlayer, "char:sick") + 1)
                if getElementData(localPlayer, "char:sick") >= 50 then 
                    if isTimer(warningTimer) then return end
                    outputChatBox(exports["oCore"]:getServerPrefix("server", "OriginalRoleplay", 1).."Meg betegedtél, keress fel egy orvost!", 255, 255, 255, true)
				    exports.oInfobox:outputInfoBox("Meg betegedtél, keress fel egy orvost!", "warning")
                    warningTimer = setTimer(function() end, 5*60*1000, 1)
                end
            else 
                warningCounter = warningCounter + 1
                if warningCounter < 10 then
                    outputChatBox(exports["oCore"]:getServerPrefix("server", "OriginalRoleplay", 1).."Meg betegedtél, keress fel egy orvost 10 perced van hogy kezeljenek!", 255, 255, 255, true)
				    exports.oInfobox:outputInfoBox("Meg betegedtél, keress fel egy orvost 10 perced van hogy kezeljenek!", "warning")
                else 
                    setElementHealth(localPlayer, 0)
                    setElementData(localPlayer,"char:health", 0)
                    setElementData(localPlayer, "customDeath", "betegség")
                    setElementData(localPlayer,"char:sick", 100, true)
                    rainTimer = setTimer(checkRain, 1*60*1000,1)
                end
            end
        else
        --    print("nincs megfázás")
            rainTimer = setTimer(checkRain, 5000,1)
        end
    end
end

addEventHandler("onClientElementDataChange",root,function(key,old,new)
    if source == localPlayer then
        if key == "char:bones" then 
            local bones = getElementData(source,key)
            for k,v in pairs(bones) do 

                if k == "l_leg" then
                    if v == 2 then 
                        lleg[source] = true
                    else 
                        lleg[source] = false 
                    end 
                end 

                if k == "r_leg" then 
                    if v == 2 then 
                        rleg[source] = true 
                    else 
                        rleg[source] = false 
                    end 
                end 

                    if rleg[source] == true and lleg[source] == true then 
                        toggleControl(source,"walk",false) 
                        toggleControl(source,"sprint",false) 
                        toggleControl(source,"jump",false) 
                        toggleControl(source,"forwards",false) 
                        toggleControl(source,"backwards",false) 
                        toggleControl(source,"left",false) 
                        toggleControl(source,"right",false) 
                    else 
                        toggleControl(source,"walk",true) 
                        toggleControl(source,"sprint",true) 
                        toggleControl(source,"jump",true) 
                        toggleControl(source,"forwards",true) 
                        toggleControl(source,"backwards",true) 
                        toggleControl(source,"left",true) 
                        toggleControl(source,"right",true) 
                    end 

            end
        end 
    end
end)
