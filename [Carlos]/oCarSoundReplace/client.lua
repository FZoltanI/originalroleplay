
local sound = {}

function updateEngineSound() 
    local allVehicles = getElementsByType("vehicle") 
    for index, veh in ipairs (allVehicles) do 
        local model = getElementModel(veh) 
        if model then 
            if getVehicleEngineState(veh) then 
                if isElement(sound[veh]) then 
                    local gear = getVehicleCurrentGear ( veh ) or 1
                    local velocityX, velocityY, velocityZ = getElementVelocity(veh) 
                    local actualspeed = ((velocityX^2 + velocityY^2 + velocityZ^2)^(0.5)) * ((11 - gear) /20)
                    local mph = actualspeed * 70 * 111.847 
                    local minSoundSpeed = 0.25
                    local soundSpeed = mph/(1000+1000/minSoundSpeed) + minSoundSpeed  
                    setSoundSpeed (sound[veh], soundSpeed) 
                else
                    local x, y, z = getElementPosition(veh)
                    sound[veh] = playSound3D("sounds/grofo.mp3", x, y, z, true)
                    attachElements(sound[veh], veh)
                end 
                setSoundVolume(sound[veh], 1)
            else
                if isElement(sound[veh]) then
                    destroyElement(sound[veh])
                end
            end
        end 
    end 
end 
addEventHandler("onClientPreRender", root, updateEngineSound) 

setWorldSoundEnabled(5, true) 
setWorldSoundEnabled(19, true)

setWorldSoundEnabled(40, true) 
setWorldSoundEnabled(40, 2, true) 
setWorldSoundEnabled(40, 0, true) 
