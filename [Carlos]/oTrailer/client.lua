local x, y, z = getVehicleModelDummyPosition(402, "trailer_attach")
print(x, y, z)
setVehicleModelDummyPosition(400, "trailer_attach", 2, 4, 2)

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, obj)
    if getPedOccupiedVehicle(localPlayer) then 
        if key == "right" and state == "up" then 
            if obj then 
                if getElementModel(obj) == 607 or getElementModel(obj) == 606 then 
                    triggerServerEvent("trailer > attachTrailerToVeh", resourceRoot, getPedOccupiedVehicle(localPlayer), obj)
                    setElementData(getPedOccupiedVehicle(localPlayer), "veh:trailer", obj)
                elseif getElementModel(obj) == 471 then 
                    if getElementData(getPedOccupiedVehicle(localPlayer), "veh:trailer") then 
                        triggerServerEvent("trailer > attachVehToTrailer", resourceRoot, obj, getElementData(getPedOccupiedVehicle(localPlayer), "veh:trailer"))
                    end
                end
            end
        end
    end
end)