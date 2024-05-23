local sound = {}

function updateEngineSound() 
    local allVehicles = getElementsByType("vehicle") 
    for index, veh in ipairs (allVehicles) do 
        local model = getElementModel(veh) 
        if model == 555 or model == 558 or model == 587 then 
            if getVehicleEngineState(veh) then 
                if isElement(sound[veh]) then 
                    local gear = getVehicleCurrentGear ( veh ) or 1
                    local velocityX, velocityY, velocityZ = getElementVelocity(veh) 
                    local actualspeed = ((velocityX^2 + velocityY^2 + velocityZ^2)^(0.5)) * ((11 - gear) /10)
                    local mph = actualspeed * 20 * 111.847 
                    local minSoundSpeed = 0.15 
                    local soundSpeed = mph/(1000+1000/minSoundSpeed) + minSoundSpeed
                    setSoundSpeed (sound[veh], soundSpeed) 
                else
                    local x, y, z = getElementPosition(veh)
                    sound[veh] = playSound3D("sounds/engine.wav", x, y, z, true)
                    attachElements(sound[veh], veh)
                end 
            else
                if isElement(sound[veh]) then
                    destroyElement(sound[veh])
                end
            end
        end 
    end 
end 
addEventHandler("onClientPreRender", root, updateEngineSound) 

addEventHandler("OnClientVehicleEnter",root,function(p)
    local model = getElementModel(source) 
    if model == 555 or model == 558 or model == 587 then 
        setWorldSoundEnable(40, false)
    end 
end)

addEventHandler("OnClientVehicleExit",root,function(p)
    local model = getElementModel(source) 
    if model == 555 or model == 558 or model == 587 then 
        setWorldSoundEnable(40, true)
    end 
end)

function delSound(veh)
    if isElement(sound[veh]) then
        destroyElement(sound[veh])
    end
end 
addEvent("delSound",true)
addEventHandler("delSound",root,delSound)
