addEventHandler("onClientVehicleDamage", resourceRoot, function(attacker, weapon, loss)
    if source == getPedOccupiedVehicle( localPlayer ) then 
        if getElementData(source, "fogocska:elkapo") then
            if (getElementData(attacker, "fogocska:uldozott") or false) then
                triggerServerEvent("fogocska > elkapas", resourceRoot, attacker)
            end
        end
    end
end)