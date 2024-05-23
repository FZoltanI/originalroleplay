local infobox = exports.oInfobox

addEventHandler ("onClientPlayerDamage", root, function(attacker, weapon, bodypart,loss)
    if source == localPlayer then 
        if not getElementData(source, "user:aduty") then 
            local bones = getElementData(localPlayer, "char:bones") or {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0}

            if weapon == 54 then 
                bodypart = 7
            end
            --outputChatBox(loss)
            if bodypart == 7 or bodypart == 8 then 
                if loss > 15 then
                    if bones["l_leg"] == 0 then 
                        bones["l_leg"] = 1 
                        infobox:outputInfoBox("Megzúzódott a bal lábad!", "warning") 
                        lastInteraction = getTickCount()
                        inFightWithCar = false
                    elseif bones["l_leg"] == 1 then 
                        bones["l_leg"] = 2
                        infobox:outputInfoBox("Eltört a bal lábad!", "warning") 
                        lastInteraction = getTickCount()
                        inFightWithCar = false
                    elseif bones["l_leg"] == 2 then 
                        if bones["r_leg"] == 0 then 
                            bones["r_leg"] = 1 
                            infobox:outputInfoBox("Megzúzódott a jobb lábad!", "warning")
                            lastInteraction = getTickCount()
                            inFightWithCar = false
                        elseif bones["r_leg"] == 1 then 
                            bones["r_leg"] = 2
                            infobox:outputInfoBox("Eltört a jobb lábad!", "warning")
                            lastInteraction = getTickCount()
                            inFightWithCar = false
                        end
                    end
                end
            elseif bodypart == 5 or bodypart == 6 then 
                if loss > 15 then
                    if bones["l_arm"] == 0 then 
                        bones["l_arm"] = 1 
                        infobox:outputInfoBox("Megzúzódott a bal kezed!", "warning") 
                        lastInteraction = getTickCount()
                        inFightWithCar = false
                    elseif bones["l_arm"] == 1 then 
                        bones["l_arm"] = 2
                        infobox:outputInfoBox("Eltört a bal kezed!", "warning") 
                        lastInteraction = getTickCount()
                        inFightWithCar = false
                    elseif bones["l_arm"] == 2 then 
                        if bones["r_arm"] == 0 then 
                            bones["r_arm"] = 1 
                            infobox:outputInfoBox("Megzúzódott a jobb kezed!", "warning")
                            lastInteraction = getTickCount()
                            inFightWithCar = false
                        elseif bones["r_arm"] == 1 then 
                            bones["r_arm"] = 2
                            infobox:outputInfoBox("Eltört a jobb kezed!", "warning")
                            lastInteraction = getTickCount()
                            inFightWithCar = false
                        end
                    end
                end
            end

            setElementData(localPlayer, "char:bones", bones)
        end
    end
end)

local lastInteraction = 0

local inFightWithCar = false

local hp = {0, 0}


--[[
setTimer(function() 
    local target = getPedTarget(localPlayer) 

    if not isElement(target) then 
        target = getNearestVehicle(localPlayer, 3) 
    end
      
    if inFightWithCar then 
        if target then
            hp[2] = getElementHealth(target)  
        end

       -- print(hp[1], hp[2])
        if isElement(target) then
            if getElementType(target) == "vehicle" then
                if hp[1] ~= hp[2] then 
                    if (lastInteraction + 1000) < getTickCount() then 
                        local playerPos = Vector3(getElementPosition(localPlayer))
                        local vehPos = Vector3(getElementPosition(target))

                        local bones = getElementData(localPlayer, "char:bones") or {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0}
                        --print(playerPos.z, vehPos.z+0.5)
                        if playerPos.z < vehPos.z + 0.5 then
                            --outputChatBox("kéz")

                            if bones["l_arm"] == 0 then 
                                bones["l_arm"] = 1 
                                infobox:outputInfoBox("Megzúzódott a bal kezed!", "warning") 
                                lastInteraction = getTickCount()
                                inFightWithCar = false
                            elseif bones["l_arm"] == 1 then 
                                bones["l_arm"] = 2
                                infobox:outputInfoBox("Eltört a bal kezed!", "warning") 
                                lastInteraction = getTickCount()
                                inFightWithCar = false
                            elseif bones["l_arm"] == 2 then 
                                if bones["r_arm"] == 0 then 
                                    bones["r_arm"] = 1 
                                    infobox:outputInfoBox("Megzúzódott a jobb kezed!", "warning")
                                    lastInteraction = getTickCount()
                                    inFightWithCar = false
                                elseif bones["r_arm"] == 1 then 
                                    bones["r_arm"] = 2
                                    infobox:outputInfoBox("Eltört a jobb kezed!", "warning")
                                    lastInteraction = getTickCount()
                                    inFightWithCar = false
                                end
                            end
                        else
                            if bones["l_leg"] == 0 then 
                                bones["l_leg"] = 1 
                                infobox:outputInfoBox("Megzúzódott a bal lábad!", "warning") 
                                lastInteraction = getTickCount()
                                inFightWithCar = false
                            elseif bones["l_leg"] == 1 then 
                                bones["l_leg"] = 2
                                infobox:outputInfoBox("Eltört a bal lábad!", "warning") 
                                lastInteraction = getTickCount()
                                inFightWithCar = false
                            elseif bones["l_leg"] == 2 then 
                                if bones["r_leg"] == 0 then 
                                    bones["r_leg"] = 1 
                                    infobox:outputInfoBox("Megzúzódott a jobb lábad!", "warning")
                                    lastInteraction = getTickCount()
                                    inFightWithCar = false
                                elseif bones["r_leg"] == 1 then 
                                    bones["r_leg"] = 2
                                    infobox:outputInfoBox("Eltört a jobb lábad!", "warning")
                                    lastInteraction = getTickCount()
                                    inFightWithCar = false
                                end
                            end
                        end

                        hp[1] = hp[2]
                        inFightWithCar = false
                        setElementData(localPlayer, "char:bones", bones)
                        return
                    end
                end
            end
        end
    end

    for i = 0, 5 do 
        local task, _, _, _ = getPedTask(localPlayer, tostring("secondary"), i)
        task = tostring(task)

        if string.lower(task) == string.lower("TASK_SIMPLE_FIGHT") then 
            if target then 
                if getElementType(target) == "vehicle" then 
                    if getPedWeapon(localPlayer) == 0 then 
                        inFightWithCar = true
                        hp[1] = getElementHealth(target)    
                    end
                end
            end
        end     
    end
end, 700, 0)
]]--


function vehiclePunch(attacker, weapon, loss, x, y, z, tire)
    --outputChatBox("ad")
    --outputChatBox(getElementType(attacker))
    if attacker == localPlayer and weapon == 0 then
    --    outputChatBox("asd")
        if (getElementType(attacker) == 'player') then
            local playerPos = Vector3(getElementPosition(attacker))
            local vehPos = Vector3(getElementPosition(source))
            local bones = getElementData(attacker, "char:bones") or {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0}
           -- outputChatBox(playerPos.z .. " < " .. vehPos.z)
            if playerPos.z < vehPos.z + 0.1 then
                if bones["l_arm"] == 0 then 
                    bones["l_arm"] = 1 
                    infobox:outputInfoBox("Megzúzódott a bal kezed!", "warning") 
                elseif bones["l_arm"] == 1 then 
                    bones["l_arm"] = 2
                    infobox:outputInfoBox("Eltört a bal kezed!", "warning") 
                elseif bones["l_arm"] == 2 then 
                    if bones["r_arm"] == 0 then 
                        bones["r_arm"] = 1 
                        infobox:outputInfoBox("Megzúzódott a jobb kezed!", "warning")
                    elseif bones["r_arm"] == 1 then 
                        bones["r_arm"] = 2
                        infobox:outputInfoBox("Eltört a jobb kezed!", "warning")
                    end
                end
            else
                if bones["l_leg"] == 0 then 
                    bones["l_leg"] = 1 
                    infobox:outputInfoBox("Megzúzódott a bal lábad!", "warning") 
                elseif bones["l_leg"] == 1 then 
                    bones["l_leg"] = 2
                    infobox:outputInfoBox("Eltört a bal lábad!", "warning") 
                elseif bones["l_leg"] == 2 then 
                    if bones["r_leg"] == 0 then 
                        bones["r_leg"] = 1 
                        infobox:outputInfoBox("Megzúzódott a jobb lábad!", "warning")
                    elseif bones["r_leg"] == 1 then 
                        bones["r_leg"] = 2
                        infobox:outputInfoBox("Eltört a jobb lábad!", "warning")
                    end
                end
            end
            setElementData(attacker, "char:bones", bones)
        end
    end
end
addEventHandler("onClientVehicleDamage", root, vehiclePunch)

addEventHandler("onClientElementDataChange", getRootElement(), function(data, old, new)
    if source == localPlayer then 
        if data == "char:bones" then 
            local bones = new 

            local brokenParts = {0, 0, 0}

            for k, v in pairs(bones) do 
                if k == "r_arm" or k == "l_arm" then 
                    if v == 2 then 
                        brokenParts[1] = brokenParts[1] + 1
                    end
                end 

                if k == "r_leg" or k == "l_leg" then 
                    if v == 2 then 
                        brokenParts[2] = brokenParts[2] + 1
                        --outputChatBox( brokenParts[2])
                    end
                end
            end

            if brokenParts[1] == 1 then 
                toggleControl("aim_weapon", false)
            elseif brokenParts[1] == 2 then 
                toggleControl("fire", false)
                toggleControl("jump", false)
                toggleControl("aim_weapon", false)
            elseif brokenParts[1] == 0 then 
                toggleControl("fire", true)
                toggleControl("jump", true)
                toggleControl("aim_weapon", true)
            end

            if brokenParts[2] == 1 then 
                toggleControl("sprint", false)
                toggleControl("jump", false) 
                toggleControl("crouch", false) 
            elseif brokenParts[2] == 2 then  
                toggleControl("walk", false) 
                toggleControl("sprint", false)
                toggleControl("jump", false) 
                toggleControl("crouch", false) 
                toggleControl("group_control_forwards", false) 
                toggleControl("group_control_back", false) 
            elseif brokenParts[2] == 0 then 
                toggleControl("sprint", true)
                toggleControl("jump", true) 
                toggleControl("crouch", true) 
                toggleControl("walk", true) 
                toggleControl("group_control_forwards", true) 
                toggleControl("group_control_back", true) 
            end 
        end
    end
end)

function getNearestVehicle(player, distance)
	local tempTable = {}
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	
	return nearestVeh
end