for k, v in ipairs(getElementsByType("player")) do 
    setElementData(v, "jobVeh:ownedJobVeh", false)
end

function createJobVehicle(modelID, datas, owner, script, destroyTime)
    local jobveh = createVehicle(modelID, unpack(datas))

    local max = exports.oVehicle:getVehicleMaxFuel(modelID)
    setElementData(jobveh, "veh:maxFuel", max)
    setElementData(jobveh, "veh:fuel", max)
    setElementData(jobveh, "veh:distanceToOilChange", 15000)
    setElementData(jobveh, "veh:traveledDistance", 0)

    setElementData(jobveh, "jobVeh:owner", owner)
    setElementData(jobveh, "jobVeh:createdScript", script)
    setElementData(jobveh, "isJobVeh", true)
    setElementData(jobveh, "jobVeh:destroyTime", (destroyTime or 30))

    setElementData(owner, "jobVeh:ownedJobVeh", jobveh)

    warpPedIntoVehicle(owner, jobveh)

    return jobveh
end
addEvent("job > createJobVehicle", true)
addEventHandler("job > createJobVehicle", resourceRoot, createJobVehicle)

function destoryJobVehicle(owner, veh)
    local jobveh

    if not veh then 
        jobveh = getElementData(owner, "jobVeh:ownedJobVeh", jobveh)    
    else
        jobveh = veh
    end

    if getElementData(jobveh, "jobVeh:createdScript") == "Költöztető" then 
        if getElementData(jobveh, "transporter:furnitures") then 
            for k, v in pairs(getElementData(jobveh, "transporter:furnitures")) do 
                destroyElement(v)
            end
        end
    end

    destroyElement(jobveh)
    setElementData(owner, "jobVeh:ownedJobVeh", false)
end
addEvent("job > destoryJobVehicle", true)
addEventHandler("job > destoryJobVehicle", resourceRoot, destoryJobVehicle)

addCommandHandler("delthiscar", function(player, cmd)
    if getElementData(player, "user:admin") >= 6 then 
        local occpuied = getPedOccupiedVehicle(player)

        if occpuied then 
            if getElementData(occpuied, "isJobVeh") then 
                destroyElement(occpuied)
            end
        end
    end
end)

addEvent("job > destroyPlayerJobVeh", true)
addEventHandler("job > destroyPlayerJobVeh", resourceRoot, function()
    destoryJobVehicle(client)
end)

addEventHandler("onPlayerQuit", root, function()
    if getElementData(source, "jobVeh:ownedJobVeh") then 
        destoryJobVehicle(source, getElementData(source, "jobVeh:ownedJobVeh"))
    end
end)