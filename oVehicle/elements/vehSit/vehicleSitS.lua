addEvent("vehicle > vehicleSit > sitDown", true)
addEventHandler("vehicle > vehicleSit > sitDown", resourceRoot, function(veh, offset, id)
    --print("asd")
    local px, py, pz = getElementPosition(client)
    local vehx, vehy, vehz = getElementPosition(veh)
    print(offset[4])
    setPedAnimation(client, "ped", "SEAT_idle", -1)
    attachElements(client, veh, offset[1], offset[2], offset[3] + 0.3, 0, 0, offset[4])
    
    setElementData(client, "veh:vehSit:attachDatas", {veh, offset, id})
    setElementData(client, "veh:vehSit:oldPosition", {vehx-px, vehy-py, vehz-pz})

    local usageTable = getElementData(veh, "veh:vehSit:usageTable") or {}
    usageTable[id] = client
    setElementData(veh, "veh:vehSit:usageTable", usageTable)
end)

addEvent("vehicle > vehicleSit > standUp", true)
addEventHandler("vehicle > vehicleSit > standUp", resourceRoot, function()
    print(getElementPosition(client, "veh:vehSit:oldPosition"))
    --local px, py, pz = unpack(getElementData(client, "veh:vehSit:oldPosition"))
    local veh, _, id = unpack(getElementData(client, "veh:vehSit:attachDatas"))

    --setElementAttachedOffsets(client, px, py, pz)

    detachElements(client, veh)
    setPedAnimation(client, "", "")

    local px, py, pz = getElementPosition(client)
    setElementPosition(client, px, py, pz + 0.5)

    setElementData(client, "veh:vehSit:attachDatas", false)
    setElementData(client, "veh:vehSit:oldPosition", false)

    usageTable = getElementData(veh, "veh:vehSit:usageTable") or {}
    usageTable[id] = false
    setElementData(veh, "veh:vehSit:usageTable", usageTable)
end)