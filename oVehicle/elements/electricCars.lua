local toggleNeededGroups = {
    [40] = true, 
    [11] = true,
    [14] = true,
    [19] = true,
    [8] = true,
}

addEventHandler("onClientWorldSound", root, function(group, index)
    if getElementType(source) == "vehicle" then
        if electric_cars[getElementModel(source)] then 
            --print(group, index)

            if group == 19 and index == 40 then 
                return
            elseif toggleNeededGroups[group] then 
                cancelEvent()
            elseif group == 7 and index == 0 then 
                cancelEvent()
            elseif group == 16 and index == 0 then
                cancelEvent()
            elseif group == 16 and index == 1 then
                cancelEvent()
            elseif group == 13 and index == 0 then
                cancelEvent()
            elseif group == 13 and index == 1 then
                cancelEvent()
            elseif group == 15 and index == 0 then 
                cancelEvent()
            elseif group == 15 and index == 1 then 
                cancelEvent()
            else
                --print(group, index)
            end
        end
    end
end)