local cache = {}
local state = {}
local beepTimer = {}

local timerForSpeedo = {}

function startIndex(veh, dName)
    if not veh then return end

    if not isTimer(cache[veh]) then
        local oldLight = getElementData(veh, "veh >> light")
        setElementData(veh, "oldLight", oldLight)
        local table = {}
        for i = 0,3 do
            local v = getVehicleLightState(veh, i)
            table[i] = v
        end
        setElementData(veh, "oldLightState", table)
        setVehicleOverrideLights(veh, 2)
        local state = false
        local num = 0
        if getElementData(veh, "veh >> light") then
            state = true
        end
        if state then
            num = 1
        end
        
        if not getElementData(veh, "vehindex_middle") then
            if getElementData(veh, "index_left") then
                if table[0] == 0 then
                    setVehicleLightState(veh, 0, num)
                end
                setVehicleLightState(veh, 3, num)
            else
                if getElementData(veh, "veh >> light") then
                    if getVehicleLightState(veh, 0) == 0 then
                        setVehicleLightState(veh, 0, 0)
                    end
                    if getVehicleLightState(veh, 3) == 0 then
                        setVehicleLightState(veh, 3, 0)
                    end
                else
                    setVehicleLightState(veh, 0, 1)
                    setVehicleLightState(veh, 3, 1)
                end
            end

            if getElementData(veh, "vehindex_right") then
                if table[1] == 0 then
                    setVehicleLightState(veh, 1, num)
                end
                setVehicleLightState(veh, 2, num)
            else
                if getElementData(veh, "veh >> light") then
                    if getVehicleLightState(veh, 1) == 0 then
                        setVehicleLightState(veh, 1, 0)
                    end
                    if getVehicleLightState(veh, 2) == 0 then
                        setVehicleLightState(veh, 2, 0)
                    end
                else
                    setVehicleLightState(veh, 1, 1)
                    setVehicleLightState(veh, 2, 1)
                end
            end
        end
        
        if getElementData(veh, "vehindex_middle") then
            if table[0] == 0 then
                setVehicleLightState(veh, 0, num)
            end
            setVehicleLightState(veh, 3, num)
            if table[1] == 0 then
                setVehicleLightState(veh, 1, num)
            end
            setVehicleLightState(veh, 2, num)
        end
        
        local controller = getVehicleController(veh)
        if controller then
            triggerClientEvent(controller, "index", controller, controller, veh)
        end

        state = not state
        local veh = veh
        cache[veh] = setTimer(
            function()
                if not isElement(veh) then
                    stopIndex(veh, dName)
                end
                local num = 0
                if state then
                    num = 1
                end
                
                if not getElementData(veh, "vehindex_middle") then
                    if getElementData(veh, "vehindex_left") then
                        if table[0] == 0 then
                            setVehicleLightState(veh, 0, num)
                        end
                        setVehicleLightState(veh, 3, num)
                    else
                        if getElementData(veh, "veh >> light") then
                            if getVehicleLightState(veh, 0) == 0 then
                                setVehicleLightState(veh, 0, 0)
                            end
                            if getVehicleLightState(veh, 3) == 0 then
                                setVehicleLightState(veh, 3, 0)
                            end
                        else
                            setVehicleLightState(veh, 0, 1)
                            setVehicleLightState(veh, 3, 1)
                        end
                    end

                    if getElementData(veh, "vehindex_right") then
                        if table[1] == 0 then
                            setVehicleLightState(veh, 1, num)
                        end
                        setVehicleLightState(veh, 2, num)
                    else
                        if getElementData(veh, "veh >> light") then
                            if getVehicleLightState(veh, 1) == 0 then
                                setVehicleLightState(veh, 1, 0)
                            end
                            if getVehicleLightState(veh, 2) == 0 then
                                setVehicleLightState(veh, 2, 0)
                            end
                        else
                            setVehicleLightState(veh, 1, 1)
                            setVehicleLightState(veh, 2, 1)
                        end
                    end
                end
                
                if getElementData(veh, "vehindex_middle") then
                    if table[0] == 0 then
                        setVehicleLightState(veh, 0, num)
                    end
                    setVehicleLightState(veh, 3, num)
                    if table[1] == 0 then
                        setVehicleLightState(veh, 1, num)
                    end
                    setVehicleLightState(veh, 2, num)
                end

                state = not state
            end, 667/2, 0
        )
        
        if isTimer(beepTimer[veh]) then killTimer (beepTimer) end
        
        beepTimer[veh] = setTimer(
            function()
                if isElement(veh) then
                    local controller = getVehicleController(veh)
                    if controller then
                        triggerClientEvent(controller, "index", controller, controller, veh)
                    end
                else
                    stopIndex(veh, dName)
                end
            end, 667, 0
        )
    end

    local amount = false 
    timerForSpeedo[veh] = setTimer(function()
        if not amount then 
            if isElement(veh) then 
                setElementData(veh,"i:active",true)
            end 
            amount = true
        else 
            if isElement(veh) then 
                setElementData(veh,"i:active",false)
            end
            amount = false
        end
    end,667/2,0)
end

local convertNameToNumber = {
    ["vehindex_left"] = 1,
    ["vehindex_right"] = 0,
}

function stopIndex(veh, dName)
    if not veh then return end
    if isTimer(cache[veh]) then
        killTimer(cache[veh])
        cache[veh] = nil
        local anotherLightState
        if dName ~= "vehindex_middle" then
            anotherLightState = getVehicleLightState(veh, convertNameToNumber[dName])
        end
        for i = 0,3 do
            setVehicleLightState(veh, i, 0)
        end
        local oldLight = getElementData(veh, "oldLight")
        setElementData(veh, "veh >> light", not oldLight)
        setElementData(veh, "veh >> light", oldLight)
        local table = getElementData(veh, "oldLightState") or {}
        if getElementData(veh, "veh >> light") then
            if dName ~= "vehindex_middle" then
                if anotherLightState == 1 then
                    local name = convertNameToNumber[dName]
                    table[name] = anotherLightState
                end
            end
        end
        for k,v in pairs(table) do
            setVehicleLightState(veh, k, v)
        end
        setElementData(veh, "oldLightState", nil)
    end
    if isTimer(beepTimer[veh]) then
        killTimer(beepTimer[veh])
        beepTimer[veh] = nul
    end

    killTimer(timerForSpeedo[veh])
end

addEventHandler("onElementDataChange", root,
    function(dName)
        if getElementType(source) == "vehicle" then
            if dName == "vehindex_left" or dName == "vehindex_right" then
                if getElementData(source, "vehindex_middle") then return end
                local value1 = getElementData(source, "vehindex_left")
                local value2 = getElementData(source, "vehindex_right")
                if value1 or value2 then
                    startIndex(source, dName)
                end
                if not value1 and not value2 then
                    stopIndex(source, dName)
                end
            elseif dName == "vehindex_middle" then
                local value = getElementData(source, "vehindex_middle")
                if value then
                    setElementData(source, "vehindex_middle", true)
                    if value1 then
                        setElementData(source, "vehindex_left", true)
                    end
                    if value2 then
                        setElementData(source, "vehindex_right", true)
                    end
                    startIndex(source, "vehindex_middle")
                else
                    stopIndex(source, "vehindex_middle")
                end
            end
        end
    end
)