local robbedPed = false 
local dangerLevel = 1
local dangerLevelTick = getTickCount()
local dangerLevelState = 1

local robTimer = false

local robbedMoney = 0

setTimer(function()
    local target = getPedTarget(localPlayer) or false 

    if not target then return end 

    if getElementType(target) == "ped" then 
        if getElementData(target, "shop:isRobbable") then 
            if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then 
                local weapon = getPedWeapon(localPlayer)

                if weapon >= 22 and weapon <= 38 then 
                    if not robbedPed then 
                        if core:getDistance(localPlayer, target) < 4 then 
                            local allowed = exports.oDashboard:isPlayerFactionTypeMember({4, 5}) 

                            if exports.oDashboard:isPlayerFactionTypeMember({1}) then 
                                allowed = false
                            end

                            if allowed then 
                                if exports.oDashboard:getOnlineFactionTypeMemberCount({1}) >= 2 then
                                    setElementData(target, "shop:isRobbable", false)
                                    setElementData(target, "shop:robbableMoney", math.random(1500, 15000))
                                    setElementData(target, "shop:defRobbableMoney", getElementData(target, "shop:robbableMoney"))

                                    robbedMoney = 0
                                    robbedPed = target
                                    addEventHandler("onClientRender", root, renderRobInfos)
                                    dangerLevel = 1
                                    dangerLevelTick = getTickCount()
                                    dangerLevelState = 1

                                    triggerServerEvent("shoprob > startShopRob", resourceRoot, robbedPed)

                                    robTimer = setTimer(function()
                                        local money = getElementData(robbedPed, "shop:robbableMoney")

                                        if core:getDistance(localPlayer, robbedPed) > 5 then 
                                            endShopRob()
                                            return
                                        end

                                        if getElementData(robbedPed, "shop:robbableMoney") > 0 then 
                                            local randMoney = math.random(100, 500)

                                            if money - randMoney < 0 then 
                                                randMoney = money 
                                            end

                                            robbedMoney = robbedMoney + randMoney 

                                            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")+randMoney)
                                            setElementData(robbedPed, "shop:robbableMoney", getElementData(robbedPed, "shop:robbableMoney")-randMoney)
                                        else
                                            endShopRob()
                                        end 
                                    end, 2500, 0)
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Boltrablás", 2).."Minimum "..color.."2db #ffffffrendvédelmi tagnak online kell lennie ahhoz, hogy elkezdhesd a boltrablást.", 255, 255, 255, true)
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Boltrablás", 2).."A boltot csak illegális frakció tagjaként tudod kirabolni!", 255, 255, 255, true)
                            end
                        end
                    end
                end
            end
        end
    end
end, 1000, 0)

function renderRobInfos()

    local targetNow = getPedTarget(localPlayer) or false

    if targetNow == robbedPed then 
        if dangerLevelState == 2 then 
            dangerLevelTick = getTickCount()
        end
        dangerLevelState = 1
    else
        if dangerLevelState == 1 then 
            dangerLevelTick = getTickCount()
        end
        dangerLevelState = 2     
    end

    if dangerLevelState == 1 then 
        dangerLevel = interpolateBetween(dangerLevel, 0, 0, 1, 0, 0, (getTickCount() - dangerLevelTick)/500000, "Linear")
    elseif dangerLevelState == 2 then
        dangerLevel = interpolateBetween(dangerLevel, 0, 0, 0, 0, 0, (getTickCount() - dangerLevelTick)/500000, "Linear")
    end

    dxDrawRectangle(sx*0.855, sy*0.96, sx*0.14, sy*0.015, tocolor(30, 30, 30, 255))
    dxDrawRectangle(sx*0.855+2/myX*sx, sy*0.96+2/myY*sy, sx*0.14-4/myX*sx, sy*0.015-4/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.855+2/myX*sx, sy*0.96+2/myY*sy, (sx*0.14-4/myX*sx)*dangerLevel, sy*0.015-4/myY*sy, tocolor(r, g, b, 255))

    core:dxDrawShadowedText(robbedMoney.."$#ffffff/"..getElementData(robbedPed, "shop:defRobbableMoney").."$", sx*0.855, sy*0.9, sx*0.855+sx*0.14, sy*0.9+sy*0.055, tocolor(r, g, b, 255), tocolor(0, 0, 0, 255), 0.8/myX*sx, fonts["bebasneue-25"], "right", "bottom", false, false, false, true)

    if dangerLevel < 0.01 then 
        endShopRob()
    end
end

function endShopRob()
    if isTimer(robTimer) then killTimer(robTimer) end 
    removeEventHandler("onClientRender", root, renderRobInfos)
    triggerServerEvent("shoprob > endShopRob", resourceRoot, robbedPed)
    robbedPed = false
end

local robSounds = {}
addEventHandler("onClientElementDataChange", resourceRoot, function(data, old, new)
    if data == "shop:inRob" then 
        if new then 
            local x, y, z = getElementPosition(source)
            robSounds[source] = playSound3D("files/alarm.wav", x, y, z, true)

            setSoundMaxDistance(robSounds[source], 75)
            setSoundVolume(robSounds[source], 2.5)
        else
            if isElement(robSounds[source]) then 
                destroyElement(robSounds[source])
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    if getElementData(source, "shop:inRob") then 
        if not isElement(robSounds[source]) then 
            local x, y, z = getElementPosition(source)
            robSounds[source] = playSound3D("files/alarm.mp3", x, y, z, true)

            setSoundMaxDistance(robSounds[source], 75)
            setSoundVolume(robSounds[source], 2.5)
        end
    end
end)