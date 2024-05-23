local licensePed = {}
local licenseVehicle = {}

addEvent("createLicenseVeh",true)
addEventHandler("createLicenseVeh", getRootElement(), function()
    --exports["oVehicle"]:destroyTemporaryVehicle(source)
    --565, 1338.2071533203,-865.81329345703,39.3102684021, -0, 0, 180
    licenseVehicle[source] = createVehicle(565,1338.2071533203,-865.81329345703,39.3102684021, -0, 0, 180)
    licensePed[source] = createPed(187, 1338.2071533203,-865.81329345703,39.3102684021)
    setElementData(licensePed[source],"ped:name","Carlos Johanson");
    setElementData(licensePed[source],"ped:prefix","Oktató");
    local max = exports.oVehicle:getVehicleMaxFuel(565)
    setElementData(licenseVehicle[source], "veh:maxFuel", max)
    setElementData(licenseVehicle[source], "veh:distanceToOilChange", 15000)
    
    setElementData(licenseVehicle[source], "veh:fuel", max)
    setElementData(licenseVehicle[source], "veh:traveledDistance", math.random(100000,300000))
    setElementData(licenseVehicle[source], "veh:owner", 0)
    setElementData(licenseVehicle[source], "veh:engine", true)
    setElementData(licenseVehicle[source], "veh:locked", true)
    setVehicleLocked(licenseVehicle[source], true)
    --setElementData(licenseVehicle[source], "veh:distanceToOilChange", 0)
    warpPedIntoVehicle(source, licenseVehicle[source])
    
    setElementData(licenseVehicle[source], "licenseCar:owner", source)
    setElementData(licenseVehicle[source], "isLicenseCar", true)
    setElementData(licenseVehicle[source], "licenseCar:destroyTime", 10)
    warpPedIntoVehicle(licensePed[source] , licenseVehicle[source], 1)
    setElementData(licensePed[source],"vehicle:seatbeltState", true)
    setElementInterior(source, 0)
    setElementDimension(source, 0)
    triggerClientEvent(source, "createTrafficLine",source)
end)

addEventHandler("onPlayerQuit",getRootElement(), function()
    if licenseVehicle[source] then 
        if isElement(licenseVehicle[source]) then 
            destroyElement(licenseVehicle[source])
            destroyElement(licensePed[source])
            licenseVehicle[source] = nil
            licensePed[source] = nil
        end
    end
end)

addEvent("vehDestroyer", true)
addEventHandler("vehDestroyer", getRootElement(), function(player)
    if licenseVehicle[player] then 
        if isElement(licenseVehicle[player]) then 
            destroyElement(licenseVehicle[player])
            destroyElement(licensePed[source])
            licenseVehicle[player] = nil
            licensePed[source] = nil
        end
    end
end)

function addLicense(element)
    exports.oInventory:createLicense(element, 2) 
end 
addEvent("addLicense",true)
addEventHandler("addLicense",root,addLicense)