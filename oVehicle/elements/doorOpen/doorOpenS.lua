addEvent("changeDoorState2", true)
addEventHandler("changeDoorState2", root,
    function(veh, num, oldState)
        setPedAnimation(source, "Ped", "CAR_open_LHS", 300, false, false, true, false)
        local oldState = not oldState
        local openRatio = 0
        if oldState then
            openRatio = 1
        end
        setVehicleDoorOpenRatio(veh, num, openRatio, 400)
end)