local sx, sy = guiGetScreenSize() 
local myX, myY = 1600, 900 

local moveing = false 

local panelX, panelY, panelW, panelH = sx*0.4, sy*0.35, sx*0.2, sy*0.3
local clickX, clickY

local VEH3D
local prev 
local VEH_Model
local occupiedVehicle

local openTimer

local show = false


local fonts = {
    ["condensed-15"] = font:getFont("condensed", 12),
}

function renderPanel()
    --dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(40, 40, 40, 240))
   -- dxDrawRectangle(panelX, panelY, panelW, sy*0.03)
    --dxDrawText("Ajtók kezelése", panelX, panelY, panelX+panelW, panelY+sy*0.03, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-15"], "center", "center")

    ---dxDrawLine(0, sy*0.5, sx, sy*0.5)
    --dxDrawLine(sx*0.5, 0, sx*0.5, sy)

    if vehicle_doors[VEH_Model] then 
        for k, v in pairs(vehicle_doors[VEH_Model]) do 
            if core:isInSlot(sx*v.posX, sy*v.posY, circleSize/myX*sx, circleSize/myY*sy) then 
                dxDrawImage(sx*v.posX, sy*v.posY, circleSize/myX*sx, circleSize/myY*sy, "files/circle_1.png")
            else
                dxDrawImage(sx*v.posX, sy*v.posY, circleSize/myX*sx, circleSize/myY*sy, "files/circle_0.png")
            end
        end
    end
end

local componentStates = {}

function panelKey(key, state) 
    if key == "mouse1" then 
        if state then 
            if vehicle_doors[VEH_Model] then 
                for k, v in pairs(vehicle_doors[VEH_Model]) do 
                    if core:isInSlot(sx*v.posX, sy*v.posY, circleSize/myX*sx, circleSize/myY*sy) then 
                        if not isTimer(openTimer) then 
                            openTimer = setTimer(function() 
                                if isTimer(openTimer) then 
                                    killTimer(openTimer)
                                end
                            end, 500, 1)

                            local clickedComponent = false

                            if components[v.type] then 
                                clickedComponent = components[v.type]
                            end

                            if not componentStates[VEH_Model] then 
                                table.insert(componentStates, VEH_Model, {false, false, false, false, false, false})
                            end

                            if clickedComponent then 
                                if not getElementData(occupiedVehicle, "veh:locked") then 
                                    if not componentStates[VEH_Model][clickedComponent] then 
                                        setVehicleDoorOpenRatio(VEH3D, clickedComponent, 2, 400)
                                        triggerServerEvent("cveh > setDoorState", resourceRoot, occupiedVehicle, clickedComponent, 2)
                                        componentStates[VEH_Model][clickedComponent] = true
                                    else
                                        setVehicleDoorOpenRatio(VEH3D, clickedComponent, 0, 400)
                                        triggerServerEvent("cveh > setDoorState", resourceRoot, occupiedVehicle, clickedComponent, 0)
                                        componentStates[VEH_Model][clickedComponent] = false
                                    end
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "CVEH", 2).."Az ajtók be vannak zárva!", 255, 255, 255, true)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function openPanel()
    show = true
    occupiedVehicle = getPedOccupiedVehicle(localPlayer)
    VEH_Model = getElementModel(occupiedVehicle)

    if vehicle_doors[VEH_Model] then 
        addEventHandler("onClientRender", root, renderPanel)
        addEventHandler("onClientKey", root, panelKey)
        
        VEH3D = createVehicle(VEH_Model, 0, 0, 0)

        occupiedColor = {getVehicleColor(occupiedVehicle)}
        setVehicleColor(VEH3D, occupiedColor[1], occupiedColor[2], occupiedColor[3], occupiedColor[4], occupiedColor[5], occupiedColor[6])

        prev = preview:createObjectPreview(VEH3D, 90, 0, 0, panelX, panelY, panelW, panelH, false, true, true)
    end
end

function closePanel() 
    show = false
    occupiedVehicle = false
    VEH_Model = false

    removeEventHandler("onClientRender", root, renderPanel)
    removeEventHandler("onClientKey", root, panelKey)

    preview:destroyObjectPreview(prev)
    setTimer(function() destroyElement(VEH3D) end, 200, 1)
end

addCommandHandler("cveh", function() 
    if show then 
        closePanel()
    else
        if getPedOccupiedVehicle(localPlayer) then 
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                openPanel()
            end
        end
    end
end)

addEventHandler("onClientVehicleStartExit", root, function(player)
    if show then 
        if player == localPlayer then 
            closePanel()
        end
    end
end)