
local trailerX,trailerY,trailerZ = 0, 0, 0
local trailerRotX,trailerRotY,trailerRotZ = 0, 0, 0
local vehX,vehY,vehZ = 0, 0, 0
local vehRotX,vehRotY,vehRotZ = 0, 0, 0
local tick = getTickCount()
addEventHandler("onClientRender",getRootElement(), function()
    for k,v in ipairs(getElementsByType("vehicle")) do 
        if getElementData(v, "isTrailer") then 
            trailerX,trailerY,trailerZ = getElementPosition(v)
            trailerRotX,trailerRotY,trailerRotZ = getElementPosition(v)
        end
        if getElementData(v, "isVeh") then 
            vehX,vehY,vehZ = getElementPosition(v)
            vehRotX,vehRotY,vehRotZ = getElementPosition(v)
        end
        posX,posY,posZ = interpolateBetween(trailerX,trailerY,trailerZ, vehX,vehY-5,trailerZ, (getTickCount() - tick)/1000, "Linear")
        rotX,rotY,rotZ = interpolateBetween(trailerRotX,trailerRotY,trailerRotZ, vehRotX,vehRotY,vehRotZ, (getTickCount() - tick)/1000, "Linear")
        if getElementData(v, "isTrailer") then 
            setElementPosition(v, posX,posY,posZ)
            setElementRotation(v, 0,0,rotZ)
        end
    end
end)