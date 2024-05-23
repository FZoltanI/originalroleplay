local core = exports.oCore
local font = exports.oFont

local lastAction = false
local brake, brakeRe = false

local sound = false

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992
local panelX, panelY = sx*0.5, sy*0.6
local panelW, panelH = sx*0.2, sy*0.06
local menuArrowRot = 0

local panelInMove = false

local menuAnimationTick, menuAnimationType = getTickCount(), "open" 

local fonts = {
    ["tesla-15"] = dxCreateFont("files/TESLA.ttf", 15),
    ["condensed-15"] = font:getFont("condensed", 15),
}

infobox = exports.oInfobox

local lineEnded = false

local debugMode = false

local inTurn = 0
local normalTempomatSpeed = 1

addEventHandler("onClientRender", root, function()
    if getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1 then
        local veh = getPedOccupiedVehicle(localPlayer)

        if availableTeslas[getElementModel(veh)] then
            --local startX, startY, startZ = getElementPosition(veh) 

            local assistState = getElementData(veh, "tesla:assist:state")
            local lineFollow = getElementData(veh, "tesla:assist:lineFollow")

            local distanceCheckAuto = getElementData(veh, "tesla:assist:distanceCheck:auto")
            local distanceCheckDis = getElementData(veh, "tesla:assist:ditanceCheck:dis") or 20

            local tempomat = getElementData(veh, "tempomat")
            local tempomat_speed = getElementData(veh, "tempomat.speed")
            local speed_sync = getElementData(veh, "tesla:assist:speedSync")

            if inTurn == 1 then 
                normalTempomatSpeed = getElementData(veh, "tempomat.speed")
            end

            local leftInd, rightInd = 0, 0

            if inTurn then 
                setElementData(veh, "tempomat.speed", math.floor(normalTempomatSpeed * inTurn))
            end

            if getVehicleEngineState(veh) then 
                if assistState then 
                    local startX, startY, startZ = core:getPositionFromElementOffset(veh, 0, 2.5, 0)

                    local dangerCount = 0

                    local checkDistance = 20 

                    if distanceCheckAuto then 
                    
                        local disX, disY, disZ = core:getPositionFromElementOffset(veh, 0, 5, -1.5)
                        local hit, hitX, hitY, hitZ, _, _, _, _, material = processLineOfSight(startX, startY, startZ,  disX, disY, disZ)
                        --print(material or 10)

                        if (material or 10) >= 10 then 
                            checkDistance = materialDistanceCheck[material] or 7
                        end

                        dxDrawLine3D(startX, startY, startZ,  disX, disY, disZ, tocolor(0, 170, 255), 2)

                        local highX, highY, highZ = core:getPositionFromElementOffset(veh, 0, 2.5, 5)
                        dxDrawLine3D(startX, startY, startZ, highX, highY, highZ, tocolor(0, 0, 255), 2)

                        if not isLineOfSightClear(startX, startY, startZ, highX, highY, highZ) then 
                            checkDistance = math.min(checkDistance, 7)
                        end

                        local rX, rY, rZ = core:getPositionFromElementOffset(veh, 4, 2.5, 0)
                        local lX, lY, lZ = core:getPositionFromElementOffset(veh, -4, 2.5, 0)

                        if debugMode then
                            dxDrawLine3D(startX, startY, startZ, rX, rY, rZ, tocolor(0, 0, 255), 2)
                            dxDrawLine3D(startX, startY, startZ, lX, lY, lZ, tocolor(0, 0, 255), 2)
                        end

                        if (not isLineOfSightClear(startX, startY, startZ, lX, lY, lZ)) and (not isLineOfSightClear(startX, startY, startZ, rX, rY, rZ)) then 
                            checkDistance = math.min(checkDistance, 7)
                            --print("szűk")
                        end

                        if getPedControlState(localPlayer, "vehicle_left") or getPedControlState(localPlayer, "vehicle_right") then 
                            checkDistance = math.min(checkDistance, 12)
                            --print("kanyar")
                        end

                    else
                        checkDistance = distanceCheckDis
                    end

                    --A

                    for i = 1, 20 do 
                        local endX, endY, endZ 
                        
                        if i <= 10 then 
                            endX, endY, endZ  = core:getPositionFromElementOffset(veh, (i-1)*0.25, checkDistance, 0.5)
                        else
                            endX, endY, endZ  = core:getPositionFromElementOffset(veh, 0-(i-10)*0.25, checkDistance, 0.5)
                        end

                        --local hit, hitX, hitY, hitZ, _, _, _, _, material = processLineOfSight(startX, startY, startZ, endX, endY, endZ)


                        if isLineOfSightClear(startX, startY, startZ, endX, endY, endZ) then 
                            if debugMode then
                                dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(0, 255, 0, 255), 2)
                            end
                        else
                            if debugMode then
                                --if (material > 0 and material < 10) then 
                                  --  dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(0, 255, 0, 255), 2)
                                --else

                                  

                                    dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(255, 0, 0, 255), 2)
                                    
                                --end
                            end

                            dangerCount = dangerCount + 1

                            if i <= 5 then 
                                rightInd = rightInd + 1
                            end

                            if i >= 15 then 
                                leftInd = leftInd + 1
                            end
                        end
                    end

                    if dangerCount >= 15 then 
                        leftInd = 0
                        rightInd = 0
                    end

                    --[[ -- B
                    for i = 1, 10 do 
                        local endX, endY, endZ 
                        
                        if i <= 10 then 
                            startX, startY, startZ = core:getPositionFromElementOffset(veh, 1-(i-1)*0.25, 2, 0)
                            endX, endY, endZ  = core:getPositionFromElementOffset(veh, 1-(i-1)*0.25, checkDistance, 0.5)
                        else
                            --endX, endY, endZ  = core:getPositionFromElementOffset(veh, 0-(i-10)*0.25, checkDistance, 0.5)
                        end

                        if isLineOfSightClear(startX, startY, startZ, endX, endY, endZ) then 
                            dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(0, 255, 0, 255), 2)
                        else
                            dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(255, 0, 0, 255), 2)
                            dangerCount = dangerCount + 1
                        end
                    end]]
                    --print(dangerCount)

                    if not isVehicleReversing(veh) then 
                        if dangerCount >= 11 then 

                            if not lastAction then 
                                brake = getTickCount()
                                brakeRe = true
                            end

                            lastAction = true 
                            setPedControlState(localPlayer, "handbrake", true)
                            setPedControlState(localPlayer, "brake_reverse", true)
                            setPedControlState(localPlayer, "accelerate", false)

                            if not isElement(sound) then 
                                sound = playSound("files/tesla_w.wav")
                            end


                            if brake + 300 > getTickCount() then            
                                if brakeRe then 
                                    brakeRe = false 
                                    setVehicleEngineState(veh, true)
                                end
                            else
                                --setVehicleEngineState(veh, false)
                                --setElementData(veh, "veh:engine", false)
                            end

                            --if dangerCount >= 20 then 
                              --  if getElementData(veh, "tesla:assist:lineFollow") then 
                                --    setElementData(veh, "tesla:assist:lineFollow", false)
                                  --  infobox:outputInfoBox("Az önvezetés leoldva!", "warning")
                                --end
                            --end
                        else
                            if lastAction then 
                                lastAction = false
                                setPedControlState(localPlayer, "handbrake", false)
                                setPedControlState(localPlayer, "brake_reverse", false)

                                if isElement(sound) then destroyElement(sound) end
                            end
                        end
                    else
                        if lastAction then 
                            lastAction = false
                            setPedControlState(localPlayer, "handbrake", false)
                            setPedControlState(localPlayer, "brake_reverse", false)

                            if isElement(sound) then destroyElement(sound) end
                        end
                    end
                end

                if lineFollow then 
                    if getElementData(veh, "gpsDestination") then
                        local cols = {}
                        local colCount = 0
                        for k, v in ipairs(getElementsByType("colshape")) do 
                            if getElementData(v, "gps:col") then 
                                cols[v] = core:getDistance(v, localPlayer)
                                colCount = colCount + 1
                            end
                        end

                        if colCount > 1 then 
                            local posDistance, farDistanceMultiplier, farDistanceMultiplier2 = 4, 3, 5


                            local startX, startY, startZ = core:getPositionFromElementOffset(veh, posDistance, 8, 0)
                            local rX, rY, rZ = core:getPositionFromElementOffset(veh, posDistance, 8, 10)

                            local startX2, startY2, startZ2 = core:getPositionFromElementOffset(veh, -posDistance, 8, 0)
                            local rX2, rY2, rZ2 = core:getPositionFromElementOffset(veh, -posDistance, 8, 10)

                            local startX3, startY3, startZ3 = core:getPositionFromElementOffset(veh, posDistance*farDistanceMultiplier, 8, 0)
                            local rX3, rY3, rZ3 = core:getPositionFromElementOffset(veh, posDistance*farDistanceMultiplier, 8, 10)

                            local startX4, startY4, startZ4 = core:getPositionFromElementOffset(veh, -posDistance*farDistanceMultiplier, 8, 0)
                            local rX4, rY4, rZ4 = core:getPositionFromElementOffset(veh, -posDistance*farDistanceMultiplier, 8, 10)

                            local startX5, startY5, startZ5 = core:getPositionFromElementOffset(veh, posDistance*farDistanceMultiplier2, 8, 0)
                            local rX5, rY5, rZ5 = core:getPositionFromElementOffset(veh, posDistance*farDistanceMultiplier2, 8, 10)

                            local startX6, startY6, startZ6 = core:getPositionFromElementOffset(veh, -posDistance*farDistanceMultiplier2, 8, 0)
                            local rX6, rY6, rZ6 = core:getPositionFromElementOffset(veh, -posDistance*farDistanceMultiplier2, 8, 10)

                            if debugMode then
                                dxDrawLine3D(startX, startY, startZ, rX, rY, rZ, tocolor(0, 255, 100), 10)
                                dxDrawLine3D(startX2, startY2, startZ2, rX2, rY2, rZ2, tocolor(0, 255, 100), 10)

                                dxDrawLine3D(startX3, startY3, startZ3, rX3, rY3, rZ3, tocolor(0, 255, 100), 10)
                                dxDrawLine3D(startX4, startY4, startZ4, rX4, rY4, rZ4, tocolor(0, 255, 100), 10)

                                dxDrawLine3D(startX5, startY5, startZ5, rX5, rY5, rZ5, tocolor(0, 255, 100), 10)
                                dxDrawLine3D(startX6, startY6, startZ6, rX6, rY6, rZ6, tocolor(0, 255, 100), 10)
                            end

                            local right, left = isInsideColShape(getLowest(cols), startX, startY, startZ), isInsideColShape(getLowest(cols), startX2, startY2, startZ2)
                            local rightF, leftF = isInsideColShape(getLowest(cols), startX3, startY3, startZ3), isInsideColShape(getLowest(cols), startX4, startY4, startZ4)
                            local rightF2, leftF2 = isInsideColShape(getLowest(cols), startX5, startY5, startZ5), isInsideColShape(getLowest(cols), startX6, startY6, startZ6)

                            if (left == true and right == false) or (rightInd > 0) then 
                                if inTurn == 1 then
                                    setControlState(localPlayer, "vehicle_left", true)
                                    setControlState(localPlayer, "vehicle_right", false)
                                    inTurn = 0.95
                                    normalTempomatSpeed = tempomat_speed
                                end
                            elseif (left == false and right == true) or (leftInd > 0) then 
                                if inTurn == 1 then
                                    setControlState(localPlayer, "vehicle_left", false)
                                    setControlState(localPlayer, "vehicle_right", true)
                                    inTurn = 0.95
                                    normalTempomatSpeed = tempomat_speed
                                end
                            elseif leftF == true and rightF == false then 
                                if inTurn == 1 then
                                    setControlState(localPlayer, "vehicle_left", true)
                                    setControlState(localPlayer, "vehicle_right", false)
                                    inTurn = 0.5
                                    normalTempomatSpeed = tempomat_speed
                                end
                            elseif leftF == false and rightF == true then 
                                if inTurn == 1 then
                                    setControlState(localPlayer, "vehicle_left", false)
                                    setControlState(localPlayer, "vehicle_right", true)
                                    inTurn = 0.5
                                    normalTempomatSpeed = tempomat_speed
                                end
                            elseif leftF2 == true and rightF2 == false then 
                                if inTurn == 1 then
                                    setControlState(localPlayer, "vehicle_left", true)
                                    setControlState(localPlayer, "vehicle_right", false)
                                    inTurn = 0.25
                                    normalTempomatSpeed = tempomat_speed
                                end
                            elseif leftF2 == false and rightF2 == true then 
                                if inTurn == 1 then
                                    setControlState(localPlayer, "vehicle_left", false)
                                    setControlState(localPlayer, "vehicle_right", true)
                                    inTurn = 0.25
                                    normalTempomatSpeed = tempomat_speed
                                end
                            else
                                if inTurn < 1 then
                                    setControlState(localPlayer, "vehicle_right", false)
                                    setControlState(localPlayer, "vehicle_left", false)
                                    setElementData(veh, "tempomat.speed", normalTempomatSpeed)
                                    inTurn = 1
                                end
                            end

                            lineEnded = false
                        else
                            if not lineEnded then
                                setTimer(function()
                                    setControlState(localPlayer, "vehicle_right", false)
                                    setControlState(localPlayer, "vehicle_left", false)
    
                                    setPedControlState(localPlayer, "handbrake", true)
                                    setPedControlState(localPlayer, "brake_reverse", true)
                                    setPedControlState(localPlayer, "accelerate", false)
    
                                    setElementData(veh, "tempomat", false)
    
                                    setTimer(function()
                                        setPedControlState(localPlayer, "handbrake", false)
                                        setPedControlState(localPlayer, "brake_reverse", false)
                                    end, 1000, 1)
                                end, 1000, 1)
                            end

                            lineEnded = true
                        end
                    end 
                end
            end

            if menuAnimationType == "open" then 
                panelH, menuArrowRot = interpolateBetween(panelH, menuArrowRot, 0, sy*0.3, 180, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
            else
                panelH, menuArrowRot = interpolateBetween(panelH, menuArrowRot, 0, sy*0.06, 0, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
            end

            dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(30, 30, 30, 200))
            dxDrawRectangle(panelX + 2/myX*sx, panelY + 2/myY*sy, panelW - 4/myX*sx, panelH - 4/myY*sy, tocolor(35, 35, 35, 255))
            dxDrawImage(panelX + 6/myX*sx, panelY + 6/myY*sy, 482/myX*sx*0.1, 480/myY*sy*0.1, "files/tesla.png")
            --dxDrawRectangle(panelX + 58/myX*sx, panelY + 6/myY*sy, sx*0.1, sy*0.03)
            dxDrawText("TESLA", panelX + 58/myX*sx, panelY + 6/myY*sy, panelX + 58/myX*sx+sx*0.1, panelY + 6/myY*sy+sy*0.03, tocolor(232, 33, 39, 255), 0.8/myX*sx, fonts["tesla-15"], "left", "center")
            dxDrawText("DRIVE ASSIST BETA", panelX + 60/myX*sx, panelY + 26/myY*sy, panelX + 60/myX*sx+sx*0.1, panelY + 26/myY*sy+sy*0.03, tocolor(255, 255, 255, 200), 0.6/myX*sx, fonts["tesla-15"], "left", "center")
            
            if core:isInSlot(panelX + panelW - 45/myX*sx, panelY + 16/myY*sy, 25/myX*sx, 25/myY*sy) then 
                dxDrawImage(panelX + panelW - 45/myX*sx, panelY + 16/myY*sy, 25/myX*sx, 25/myY*sy, "files/arrow.png", menuArrowRot, 0, 0, tocolor(255, 255, 255, 200))
            else
                dxDrawImage(panelX + panelW - 45/myX*sx, panelY + 16/myY*sy, 25/myX*sx, 25/myY*sy, "files/arrow.png", menuArrowRot, 0, 0, tocolor(255, 255, 255, 100))
            end

            if panelH > sy*0.25 then 
                dxDrawRectangle(panelX + 6/myX*sx, panelY + panelH - 37/myY*sy, sx*0.07, sy*0.03, tocolor(28, 28, 28, 255))

                dxDrawText("Security Drive", panelX + 6/myX*sx, panelY + panelH - 60/myY*sy, panelX + 6/myX*sx + sx*0.07, panelY + panelH - 60/myY*sy + sy*0.03, tocolor(255, 255, 255, 200), 0.6/myX*sx, fonts["condensed-15"], "center", "center")
                if distanceCheckAuto then 
                    dxDrawText("AUTO", panelX + 6/myX*sx, panelY + panelH - 37/myY*sy, panelX + 6/myX*sx + sx*0.07, panelY + panelH - 37/myY*sy + sy*0.03, tocolor(255, 255, 255, 200), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
                else
                    if core:isInSlot(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy, sx*0.01, sy*0.015) then 
                        dxDrawRectangle(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy + 2/myY*sy, sx*0.01 - 1/myX*sx, sy*0.015 - 2/myY*sy, tocolor(232, 33, 39, 200))
                    else
                        dxDrawRectangle(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy + 2/myY*sy, sx*0.01 - 1/myX*sx, sy*0.015 - 2/myY*sy, tocolor(232, 33, 39, 100))
                    end
                    dxDrawImage(panelX + 6/myX*sx + sx*0.06 + 3/myX*sx, panelY + panelH - 37/myY*sy + 3.5/myY*sy, 10/myX*sx, 10/myY*sy, "files/plus.png", 0, 0, 0, tocolor(255, 255, 255, 200))

                    if core:isInSlot(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy + sy*0.015, sx*0.01, sy*0.015) then 
                        dxDrawRectangle(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy + sy*0.015, sx*0.01 - 1/myX*sx, sy*0.015 - 2/myY*sy, tocolor(232, 33, 39, 200))
                    else
                        dxDrawRectangle(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy + sy*0.015, sx*0.01 - 1/myX*sx, sy*0.015 - 2/myY*sy, tocolor(232, 33, 39, 100))
                    end

                    dxDrawImage(panelX + 6/myX*sx + sx*0.06 + 3/myX*sx, panelY + panelH - 37/myY*sy + sy*0.015+ 6/myY*sy, 10/myX*sx, 10/myY*sy, "files/minus.png", 0, 0, 0, tocolor(255, 255, 255, 200))

                    dxDrawText(distanceCheckDis, panelX + 6/myX*sx, panelY + panelH - 37/myY*sy, panelX + 6/myX*sx + sx*0.07, panelY + panelH - 37/myY*sy + sy*0.03, tocolor(255, 255, 255, 200), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
                end

                dxDrawRectangle(panelX + 135/myX*sx, panelY + panelH - 60/myY*sy, 53/myX*sx, 53/myY*sy, tocolor(28, 28, 28, 255))

                if assistState then 
                    dxDrawText("ON", panelX + 135/myX*sx, panelY + panelH - 60/myY*sy, panelX + 135/myX*sx + 53/myX*sx, panelY + panelH - 60/myY*sy + 53/myY*sy, tocolor(232, 33, 39, 255), 1/myX*sx, fonts["condensed-15"], "center", "center")
                else
                    dxDrawText("OFF", panelX + 135/myX*sx, panelY + panelH - 60/myY*sy, panelX + 135/myX*sx + 53/myX*sx, panelY + panelH - 60/myY*sy + 53/myY*sy, tocolor(232, 33, 39, 255), 1/myX*sx, fonts["condensed-15"], "center", "center")
                end

                dxDrawText("Auto Drive", panelX + 200/myX*sx, panelY + panelH - 60/myY*sy, panelX + 220/myX*sx + sx*0.07, panelY + panelH - 60/myY*sy + sy*0.03, tocolor(255, 255, 255, 200), 0.6/myX*sx, fonts["condensed-15"], "center", "center")
                dxDrawRectangle(panelX + 193/myX*sx, panelY + panelH - 37/myY*sy, sx*0.087, sy*0.03, tocolor(28, 28, 28, 255))
                if lineFollow then 
                    dxDrawText("ON", panelX + 193/myX*sx, panelY + panelH - 37/myY*sy, panelX + 193/myX*sx + sx*0.087, panelY + panelH - 37/myY*sy + sy*0.03, tocolor(232, 33, 39, 255), 0.9/myX*sx, fonts["condensed-15"], "center", "center")
                else
                    dxDrawText("OFF", panelX + 193/myX*sx, panelY + panelH - 37/myY*sy, panelX + 193/myX*sx + sx*0.087, panelY + panelH - 37/myY*sy + sy*0.03, tocolor(232, 33, 39, 255), 0.9/myX*sx, fonts["condensed-15"], "center", "center")
                end

                dxDrawText("Tempomat", panelX, panelY + 60/myY*sy, panelX + panelW, panelY + 60/myY*sy + sy*0.03, tocolor(255, 255, 255, 200), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
                dxDrawRectangle(panelX + 6/myX*sx, panelY + 90/myY*sy, panelW - 12/myX*sx, 53/myY*sy, tocolor(28, 28, 28, 255))

                dxDrawRectangle(panelX + 6/myX*sx, panelY + 147/myY*sy, panelW - 12/myX*sx, 30/myY*sy, tocolor(28, 28, 28, 255))

                if speed_sync then
                    dxDrawText("Sync Speed Limit: " .. "#e82127ON", panelX + 6/myX*sx, panelY + 147/myY*sy, panelX + 6/myX*sx + panelW - 12/myX*sx, panelY + 147/myY*sy + 30/myY*sy, tocolor(255, 255, 255), 0.7/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)
                else
                    dxDrawText("Sync Speed Limit: " .. "#e82127OFF", panelX + 6/myX*sx, panelY + 147/myY*sy, panelX + 6/myX*sx + panelW - 12/myX*sx, panelY + 147/myY*sy + 30/myY*sy, tocolor(255, 255, 255), 0.7/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)
                end

                if tempomat then 
                    dxDrawText(tempomat_speed.."#ffffffkm/h", panelX + 6/myX*sx, panelY + 90/myY*sy, panelX + 6/myX*sx + panelW - 12/myX*sx, panelY + 90/myY*sy+53/myY*sy, tocolor(232, 33, 39), 1/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)

                    if core:isInSlot(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy, 30/myX*sx, 24/myY*sy) then 
                        dxDrawRectangle(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy, 30/myX*sx, 24/myY*sy, tocolor(232, 33, 39, 200))
                    else
                        dxDrawRectangle(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy, 30/myX*sx, 24/myY*sy, tocolor(232, 33, 39, 100))
                    end
    
                    if core:isInSlot(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy + 24/myY*sy, 30/myX*sx, 24/myY*sy) then 
                        dxDrawRectangle(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy + 24/myY*sy, 30/myX*sx, 24/myY*sy, tocolor(232, 33, 39, 200))
                    else
                        dxDrawRectangle(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy + 24/myY*sy, 30/myX*sx, 24/myY*sy, tocolor(232, 33, 39, 100))
                    end
    
                    dxDrawImage(panelX + panelW - 28/myX*sx, panelY + 92/myY*sy + 35/myY*sy, 10/myX*sx, 10/myY*sy, "files/minus.png", 0, 0, 0, tocolor(255, 255, 255, 200))
                    dxDrawImage(panelX + panelW - 28/myX*sx, panelY + 92/myY*sy + 6/myY*sy, 10/myX*sx, 10/myY*sy, "files/plus.png", 0, 0, 0, tocolor(255, 255, 255, 200))
                else
                    dxDrawText("OFF", panelX + 6/myX*sx, panelY + 90/myY*sy, panelX + 6/myX*sx + panelW - 12/myX*sx, panelY + 90/myY*sy+53/myY*sy, tocolor(232, 33, 39), 1/myX*sx, fonts["condensed-15"], "center", "center")
                end
            end

            if panelInMove then 
                if isCursorShowing() then
                    local x, y = getCursorPosition()
                    x, y = sx * x, sy * y 

                    panelX, panelY = x - panelInMove[1], y - panelInMove[2]
                else
                    panelInMove = false
                end
            end
        end
    end
end)

function getLowest(table)
    local low = math.huge
    local index

    for i, v in pairs(table) do
        if v < low then
            low = v
            index = i
        end
    end

    return index
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse1" and state then
        if getPedOccupiedVehicleSeat(localPlayer) == 0 then
            local veh = getPedOccupiedVehicle(localPlayer)

            if availableTeslas[getElementModel(veh)] then
                --local startX, startY, startZ = getElementPosition(veh)

                if core:isInSlot(panelX, panelY, panelW, sy*0.06) then
                    local x, y = getCursorPosition()
                    x, y = sx * x, sy * y 
            
                    panelInMove = {x - panelX, y - panelY}
                end

                local assistState = getElementData(veh, "tesla:assist:state") 
                local lineFollow = getElementData(veh, "tesla:assist:lineFollow")

                local distanceCheckAuto = getElementData(veh, "tesla:assist:distanceCheck:auto")
                local distanceCheckDis = getElementData(veh, "tesla:assist:ditanceCheck:dis") or 20

                local tempomat = getElementData(veh, "tempomat")
                local tempomat_speed = getElementData(veh, "tempomat.speed")
                local speed_sync = getElementData(veh, "tesla:assist:speedSync")

                if core:isInSlot(panelX + panelW - 45/myX*sx, panelY + 16/myY*sy, 25/myX*sx, 25/myY*sy) then 
                    if menuAnimationType == "open" then 
                        menuAnimationType = "close"
                    else
                        menuAnimationType = "open"
                    end

                    menuAnimationTick = getTickCount()
                end

                if panelH > sy*0.25 then 
                    if distanceCheckAuto then 
                        if core:isInSlot(panelX + 6/myX*sx, panelY + panelH - 37/myY*sy, sx*0.07, sy*0.03) then
                            setElementData(veh, "tesla:assist:distanceCheck:auto", not distanceCheckAuto)
                        end
                    else
                        if core:isInSlot(panelX + 6/myX*sx, panelY + panelH - 37/myY*sy, sx*0.06, sy*0.03) then
                            setElementData(veh, "tesla:assist:distanceCheck:auto", not distanceCheckAuto)
                        end

                        if core:isInSlot(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy, sx*0.01, sy*0.015) then 
                            if distanceCheckDis < 25 then 
                                setElementData(veh, "tesla:assist:ditanceCheck:dis", distanceCheckDis + 1)
                            end
                        end

                        if core:isInSlot(panelX + 6/myX*sx + sx*0.06, panelY + panelH - 37/myY*sy + sy*0.015, sx*0.01, sy*0.015) then 
                            if distanceCheckDis > 5 then 
                                setElementData(veh, "tesla:assist:ditanceCheck:dis", distanceCheckDis - 1)
                            end
                        end
                    end

                    if core:isInSlot(panelX + 135/myX*sx, panelY + panelH - 60/myY*sy, 53/myX*sx, 53/myY*sy) then 
                        setElementData(veh, "tesla:assist:state", not assistState)
                        setPedControlState(localPlayer, "handbrake", false)
                        setPedControlState(localPlayer, "brake_reverse", false)

                    end

                    if core:isInSlot(panelX + 193/myX*sx, panelY + panelH - 37/myY*sy, sx*0.087, sy*0.03) then 
                        setElementData(veh, "tesla:assist:lineFollow", not lineFollow)
                    end

                    if core:isInSlot(panelX + 6/myX*sx, panelY + 90/myY*sy, panelW - 60/myX*sx, 53/myY*sy) then
                        if tempomat then 
                            setElementData(veh, "tempomat", false)
                        else
                            setElementData(veh, "tempomat", true)
                        end
                    end

                    if tempomat then         
                        if core:isInSlot(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy, 30/myX*sx, 24/myY*sy) then -- plus
                            setElementData(veh, "tempomat.speed", math.min(tempomat_speed + 2, 999))
                        end
        
                        if core:isInSlot(panelX + panelW - 38/myX*sx, panelY + 92/myY*sy + 24/myY*sy, 30/myX*sx, 24/myY*sy) then -- minus
                            setElementData(veh, "tempomat.speed", math.max(tempomat_speed - 2, 0))
                        end
                    end

                    if core:isInSlot(panelX + 6/myX*sx, panelY + 147/myY*sy, panelW - 12/myX*sx, 30/myY*sy) then 
                        setElementData(veh, "tesla:assist:speedSync", not speed_sync)
                    end
                end
            end
        end
    elseif key == "mouse1" and not state then 
        panelInMove = false
    end
end)

function isVehicleReversing(theVehicle)
    local getMatrix = getElementMatrix (theVehicle)
    local getVelocity = Vector3 (getElementVelocity(theVehicle))
    local getVectorDirection = (getVelocity.x * getMatrix[2][1]) + (getVelocity.y * getMatrix[2][2]) + (getVelocity.z * getMatrix[2][3]) 
    if (getVectorDirection >= 0) then
        return false
    end
    return true
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if exports.oJSON:loadDataFromJSONFile("teslaDriveAssist", false) then 
        panelX, panelY = unpack(fromJSON(exports.oJSON:loadDataFromJSONFile("teslaDriveAssist", false)))
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    exports.oJSON:saveDataToJSONFile(toJSON({panelX, panelY}), "teslaDriveAssist", false)
end)

addEventHandler("onClientColShapeHit", root, function(player, mdim)
    if isElement(source) then
        if getElementData(source, "TrafficCol:speedlimit") then
            if player == localPlayer and mdim then 
                local occupiedveh = getPedOccupiedVehicle(localPlayer)
                if occupiedveh then 
                    if availableTeslas[getElementModel(occupiedveh)] then 
                        if getElementData(occupiedveh, "tesla:assist:speedSync") then 
                            if getElementData(occupiedveh, "tempomat") then 
                                setElementData(occupiedveh, "tempomat.speed",  getElementData(source, "TrafficCol:speedlimit")) 
                            end
                        end
                    end
                end
            end
        end
    end
end)