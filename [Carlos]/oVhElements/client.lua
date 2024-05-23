addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oVhElements" or getResourceName(res) == "oVh_Map" then 
        for k, v in ipairs(getElementsByType("object", root, false)) do 
            if getElementModel(v) == 10756 or getElementModel(v) == 9106 then 
                setElementStreamable(v, false)
            end
        end
    end
end)

txd = engineLoadTXD( "files/elevator.txd", 16342 )
engineImportTXD(txd, 16342 )

dff = engineLoadDFF( "files/elevator.dff", 16342 )
engineReplaceModel(dff, 16342, true )

col = engineLoadCOL( "files/elevator.col" )
engineReplaceCOL ( col, 16342 )

local cols = {
    ["out_lift"] = {
        Vector3(1502.1920166016, -1808.3, 7.911),
        Vector3(1502.1920166016, -1808.3, 14.411770820618),
    },
}

function createCols()
    for k, v in ipairs(cols["out_lift"]) do 
        local col = createColTube(v.x, v.y, v.z-1, 1, 3)

        setElementData(col, "VH:Lift:OutCol", k)
    end
end
createCols()

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900
local panelType = 1
local core = exports.oCore
local color, r, g, b = core:getServerColor()

local activeLevel = 0

local fonts = {
    ["condensed-15"] = exports.oFont:getFont("condensed", 15), 
    ["condensed-20"] = exports.oFont:getFont("condensed", 20), 
}

local soundCol = createColCuboid(1499.4615478516, -1807.4, 6.8, 2.3, 2.3, 10)
local sound = playSound("files/music.mp3", true)
setSoundVolume(sound, 0)

-- / Car Lift / --
--[[local lift_level_1_out_col = createColSphere(1479.4643554688, -1798.0395507813, 29.6484375, 3)
local lift_level_2_out_col = createColSphere(1479.3875732422, -1780.1488037109, 14.421875, 3)
local carLift_in_col = createColCuboid(1476.5502929688, -1794.9567138672, 13.51428565979, 6, 11.5, 20)

local lift2ColLevel = 0]]
------------------

function renderPanel()
    if panelType == 1 then 
        dxDrawRectangle(sx*0.875, sy*0.48, sx*0.12, sy*0.05, tocolor(40, 40, 40, 255))

        if core:isInSlot(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy) then 
            dxDrawRectangle(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy, tocolor(r, g, b, 150))
        else
            dxDrawRectangle(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy, tocolor(30, 30, 30, 255))
        end

        dxDrawText("Lift hívása", sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.875+3/myX*sx+sx*0.12-6/myX*sx, sy*0.48+3/myY*sy+sy*0.05-6/myY*sy, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
    elseif panelType == 2 then
        dxDrawRectangle(sx*0.945, sy*0.425, sx*0.05, sy*0.174, tocolor(40, 40, 40, 255))

        local starty = sy*0.425+3/myY*sy
        local kamuindex = 2
        for i = 1, 2 do
            if core:isInSlot(sx*0.945+3/myX*sx, starty, 74/myX*sx, 74/myY*sy) then 
                dxDrawRectangle(sx*0.945+3/myX*sx, starty, 74/myX*sx, 74/myY*sy, tocolor(r, g, b, 150))
            else
                dxDrawRectangle(sx*0.945+3/myX*sx, starty, 74/myX*sx, 74/myY*sy, tocolor(30, 30, 30, 255))
            end
            dxDrawText(kamuindex, sx*0.945+3/myX*sx, starty, sx*0.945+3/myX*sx+74/myX*sx, starty+74/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-20"], "center", "center")

            kamuindex = kamuindex - 1
            starty = starty + 77/myY*sy
        end
    elseif panelType == 3 then 
        dxDrawRectangle(sx*0.875, sy*0.48, sx*0.12, sy*0.05, tocolor(40, 40, 40, 255))

        if core:isInSlot(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy) then 
            dxDrawRectangle(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy, tocolor(r, g, b, 150))
        else
            dxDrawRectangle(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy, tocolor(30, 30, 30, 255))
        end

        dxDrawText("Járműlift hívása", sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.875+3/myX*sx+sx*0.12-6/myX*sx, sy*0.48+3/myY*sy+sy*0.05-6/myY*sy, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
    elseif panelType == 4 then 
        dxDrawRectangle(sx*0.875, sy*0.48, sx*0.12, sy*0.05, tocolor(40, 40, 40, 255))

        if core:isInSlot(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy) then 
            dxDrawRectangle(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy, tocolor(r, g, b, 150))
        else
            dxDrawRectangle(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy, tocolor(30, 30, 30, 255))
        end

        dxDrawText("Járműlift indítása", sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.875+3/myX*sx+sx*0.12-6/myX*sx, sy*0.48+3/myY*sy+sy*0.05-6/myY*sy, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-15"], "center", "center")
    end
end

function onKey(key, state)
    if state then 
        if key == "mouse1" then 
            if panelType == 1 then 
                if core:isInSlot(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy) then 
                    triggerServerEvent("VH > Lift > SetLevel", resourceRoot, activeLevel, 1)
                end
            elseif panelType == 2 then 
                local starty = sy*0.425+3/myY*sy
                local kamuindex = 2
                for i = 1, 2 do
                    if core:isInSlot(sx*0.945+3/myX*sx, starty, 74/myX*sx, 74/myY*sy) then 
                        triggerServerEvent("VH > Lift > SetLevel", resourceRoot, kamuindex, 2)
                        break
                    end
                    kamuindex = kamuindex - 1 
                    starty = starty + 77/myY*sy
                end
            elseif panelType == 3 then 
                if core:isInSlot(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy) then 
                    triggerServerEvent("VH > VehLift > SetLiftLevel", resourceRoot, lift2ColLevel)
                end
            elseif panelType == 4 then 
                if core:isInSlot(sx*0.875+3/myX*sx, sy*0.48+3/myY*sy, sx*0.12-6/myX*sx, sy*0.05-6/myY*sy) then 
                    triggerServerEvent("VH > VehLift > SetLiftLevel", resourceRoot, 99)
                end
            end
        end
    end
end

addEventHandler("onClientColShapeHit", root, function(element, mdim)
    if mdim then 
        if element == localPlayer then 
            if not isElement(source) then return end
            if getElementData(source, "VH:Lift:OutCol") then 
                activeLevel = getElementData(source, "VH:Lift:OutCol")
                panelType = 1
                addEventHandler("onClientRender", root, renderPanel)
                addEventHandler("onClientKey", root, onKey)
            elseif getElementData(source, "VH:Lift:inCol") then 
                panelType = 2
                addEventHandler("onClientRender", root, renderPanel)
                addEventHandler("onClientKey", root, onKey)
            elseif source == soundCol then 
                setSoundVolume(sound, 1)
            elseif source == lift_level_1_out_col then 
                if getPedOccupiedVehicle(localPlayer) then 
                    panelType = 3
                    lift2ColLevel = 2
                    addEventHandler("onClientRender", root, renderPanel)
                    addEventHandler("onClientKey", root, onKey)
                end
            elseif source == lift_level_2_out_col then 
                if getPedOccupiedVehicle(localPlayer) then 
                    panelType = 3
                    lift2ColLevel = 1
                    addEventHandler("onClientRender", root, renderPanel)
                    addEventHandler("onClientKey", root, onKey)
                end
            elseif source == carLift_in_col then
                if getPedOccupiedVehicle(localPlayer) then 
                    panelType = 4
                    addEventHandler("onClientRender", root, renderPanel)
                    addEventHandler("onClientKey", root, onKey)
                end
            end
        end
    end
end)

addEventHandler("onClientColShapeLeave", root, function(element, mdim)
    if mdim then 
        if element == localPlayer then 
            if getElementData(source, "VH:Lift:OutCol") then 
                activeLevel = 0
                removeEventHandler("onClientRender", root, renderPanel)
                removeEventHandler("onClientKey", root, onKey)
                panelType = 0
            elseif getElementData(source, "VH:Lift:inCol") then 
                removeEventHandler("onClientRender", root, renderPanel)
                removeEventHandler("onClientKey", root, onKey)
                panelType = 0
            elseif source == soundCol then 
                setSoundVolume(sound, 0)
            elseif source == lift_level_1_out_col then 
                removeEventHandler("onClientRender", root, renderPanel)
                removeEventHandler("onClientKey", root, onKey)
                panelType = 0
            elseif source == lift_level_2_out_col then 
                removeEventHandler("onClientRender", root, renderPanel)
                removeEventHandler("onClientKey", root, onKey)
                panelType = 0
            elseif source == carLift_in_col then
                removeEventHandler("onClientRender", root, renderPanel)
                removeEventHandler("onClientKey", root, onKey)
                panelType = 0
            end
        end
    end
end)