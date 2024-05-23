function createBicycles()
    for k, v in ipairs(bicyclePositions) do 
        local bicycle = createVehicle(510, v[1], v[2], v[3], 0, 0, v[4])
        setElementFrozen(bicycle, true)
        setVehicleColor(bicycle, r, g, b)

        setElementData(bicycle, "isSharedBicycle", true)
    end
end
createBicycles()