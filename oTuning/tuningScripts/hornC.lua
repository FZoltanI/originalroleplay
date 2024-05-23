local lastHorn = 0
local hossz = 0
function key(button,state)
    if getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
        if button == "h" and state then 
            if not isChatBoxInputActive() then
                if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:customHorn") or 0) > 0 then
                    cancelEvent()
                    if lastHorn + hossz < getTickCount() then
                        if isCursorShowing() then return end
                        lastHorn = getTickCount()

                        local tempsound = playSound("files/sounds/horns/"..getElementData(getPedOccupiedVehicle(localPlayer), "veh:customHorn")..".mp3")
                        setSoundVolume(tempsound, 0)

                        hossz = getSoundLength(tempsound) * 1000

                        destroyElement(tempsound)

                        triggerServerEvent("horn > playVehicleHornSound", resourceRoot, getPedOccupiedVehicle(localPlayer), getElementData(getPedOccupiedVehicle(localPlayer), "veh:customHorn"))
                    end
                end
            end
        end
    end
end
addEventHandler("onClientKey", root, key)


addEvent("horn > playVehicleHornSoundClient", true)
addEventHandler("horn > playVehicleHornSoundClient", root, function(veh, horn)
    if isElementStreamedIn(veh) then
        local x, y, z = getElementPosition(veh)

        local sound = playSound3D("files/sounds/horns/"..horn..".mp3", x, y, z, false)
        setSoundMaxDistance(sound, 40)
        setSoundVolume(sound, 1.5)
        attachElements(sound, veh)
    end
end)