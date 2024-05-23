function createHifi(pos, rot, owner, ownerName, dim, int)
    local hifi = createObject(hifiObject, pos.x, pos.y, pos.z, 0, 0, rot)
   -- setObjectScale(hifi, 1.8)
    setElementCollisionsEnabled(hifi, true)

    setElementData(hifi, "isHifi", true)
    setElementData(hifi, "hifi:state", false)
    setElementData(hifi, "hifi:volume", 50)
    setElementData(hifi, "hifi:radioStation", 1)

    setElementData(hifi, "hifi:owner", owner)
    setElementData(hifi, "hifi:ownerName", ownerName)

    setElementData(hifi, "hifi:inVehicle", false)

    setElementDimension(hifi, dim)
    setElementInterior(hifi, int)

    local veh = exports.oVehicle:getNearestVehicle(hifi, 2)

    if veh then 
        if attachableVehicleModels[getElementModel(veh)] then 
            --local offsetX, offsetY, offsetZ = getOffsetFromXYZ(getElementMatrix(veh), pos)
            --print(offsetX, offsetY, offsetZ)
            attachRotationAdjusted(hifi, veh)
            setElementData(hifi, "hifi:inVehicle", true)
        end
    end
end

addEvent("hifi > setHifiState", true)
addEventHandler("hifi > setHifiState", resourceRoot, function(hifi, state)
    setElementData(hifi, "hifi:state", state)
end)

addEvent("hifi > setHifiVolume", true)
addEventHandler("hifi > setHifiVolume", resourceRoot, function(hifi, volume)
    setElementData(hifi, "hifi:volume", volume)
end)

addEvent("hifi > setHifiChannel", true)
addEventHandler("hifi > setHifiChannel", resourceRoot, function(hifi, channel)
    setElementData(hifi, "hifi:radioStation", channel)
end)

addEvent("hifi > pickupHifi", true)
addEventHandler("hifi > pickupHifi", resourceRoot, function(hifi)
    setElementData(hifi, "hifi:state", false)
    destroyElement(hifi)
    exports.oInventory:giveItem(client, 73, 1, 1, 0)
end)

createHifi(Vector3(1087.0842285156,-1797.4029541016,13.636709213257-1), 180, 88, "ASD", 0, 0)

-- Usefull

function attachRotationAdjusted ( from, to )
    -- Note: Objects being attached to ('to') should have at least two of their rotations set to zero
    --       Objects being attached ('from') should have at least one of their rotations set to zero
    -- Otherwise it will look all funny

    local frPosX, frPosY, frPosZ = getElementPosition( from )
    local frRotX, frRotY, frRotZ = getElementRotation( from )
    local toPosX, toPosY, toPosZ = getElementPosition( to )
    local toRotX, toRotY, toRotZ = getElementRotation( to )
    local offsetPosX = frPosX - toPosX
    local offsetPosY = frPosY - toPosY
    local offsetPosZ = frPosZ - toPosZ
    local offsetRotX = frRotX - toRotX
    local offsetRotY = frRotY - toRotY
    local offsetRotZ = frRotZ - toRotZ

    offsetPosX, offsetPosY, offsetPosZ = applyInverseRotation ( offsetPosX, offsetPosY, offsetPosZ, toRotX, toRotY, toRotZ )

    attachElements( from, to, offsetPosX, offsetPosY, offsetPosZ, offsetRotX, offsetRotY, offsetRotZ )
end

function applyInverseRotation ( x,y,z, rx,ry,rz )
    -- Degress to radians
    local DEG2RAD = (math.pi * 2) / 360
    rx = rx * DEG2RAD
    ry = ry * DEG2RAD
    rz = rz * DEG2RAD

    -- unrotate each axis
    local tempY = y
    y =  math.cos ( rx ) * tempY + math.sin ( rx ) * z
    z = -math.sin ( rx ) * tempY + math.cos ( rx ) * z

    local tempX = x
    x =  math.cos ( ry ) * tempX - math.sin ( ry ) * z
    z =  math.sin ( ry ) * tempX + math.cos ( ry ) * z

    tempX = x
    x =  math.cos ( rz ) * tempX + math.sin ( rz ) * y
    y = -math.sin ( rz ) * tempX + math.cos ( rz ) * y

    return x, y, z
end