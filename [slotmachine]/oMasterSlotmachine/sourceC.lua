local screenX, screenY = guiGetScreenSize()
local objectId = 2754

local core = false
local infobox = false
local font = false
local color, r, g, b = false
local serverColor, r, g, b= false

addEventHandler("onClientResourceStart",getRootElement(), function(startResource)
    if startResource == getThisResource() then 
        core = exports.oCore
        infobox = exports.oInfobox
        font = exports.oFont
        color, r, g, b = core:getServerColor()
        serverColor, r, g, b = core:getServerColor()
    elseif getResourceName(startResource) == "oCore" or getResourceName(startResource) == "oInfobox" or getResourceName(startResource) == "oFont" then 
        core = exports.oCore
        infobox = exports.oInfobox
        font = exports.oFont
        color, r, g, b = core:getServerColor()
        serverColor, r, g, b = core:getServerColor()
    end
end)

local createMachine = false
local type = false

addCommandHandler("createslotmachine", function(cmd, type)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if not type then 
            outputChatBox(core:getServerPrefix("server").."Használat: /".. cmd.." [Típus]", 0, 0, 0, true)
        else
            

            createMachine = createObject(objectId, 0, 0, 0)
            setElementCollisionsEnabled(createMachine, false)
            setElementAlpha(localPlayer, 0)
            type = tonumber(type)
            setElementData(createMachine, "idgType", type)
            addEventHandler("onClientRender",getRootElement(),renderMachinePlacement)
            setElementInterior(createMachine, getElementInterior(localPlayer))
            setElementDimension(createMachine, getElementDimension(localPlayer))
        end
    end
end)

function renderMachinePlacement()
    setElementPosition(createMachine, getElementPosition(localPlayer))
    rotX,rotY,rotZ = getElementRotation(localPlayer)
    setElementRotation(createMachine, rotX,rotY,rotZ)
    if getKeyState("lalt") then 
        removeEventHandler("onClientRender",getRootElement(), renderMachinePlacement)
        triggerServerEvent("placeMachine", localPlayer, localPlayer,objectId, getElementData(createMachine, "idgType"))
        destroyElement(createMachine)
        createMachine = false 
        setElementAlpha(localPlayer, 255)
        local px,py,pz = getElementPosition(localPlayer)
        setElementPosition(localPlayer, px,py+5,pz)
    end
end

addCommandHandler("delslotmachine",function(cmd, id)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if not id then 
            outputChatBox(core:getServerPrefix("server").."Használat: ".. cmd.." [ID]", 0, 0, 0, true);
        else
            triggerServerEvent("deleteMachine", localPlayer, localPlayer, id)
        end
    end
end)

addCommandHandler("nearbyslotmachines", function(cmd, distance)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if not distance then
            distance = 15 
        else 
            distance = tonumber(distance)
        end
        hex, r, g, b = exports.oCore:getServerColor()
        local count = 0
        local px,py,pz = getElementPosition(localPlayer)
        outputChatBox(core:getServerPrefix("server").."Közeledben lévő Slot gépek: (".. distance .." Yard)", 0, 0, 0, true);
        for k,v in ipairs(getElementsByType("object")) do 
            if getElementData(v, "slotMachine.isMachine") then 
                local tx,ty,tz = getElementPosition(v)
                if getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) <= distance then 
                    outputChatBox(hex.."*#FFFFFF Azonosító: "..hex.. getElementData(v, "slotMachine.Id") .."#FFFFFF | Távolság: "..hex..math.floor(getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz)) .. " Yard#FFFFFF | Típus: "..hex..typeName[getElementData(v, "slotMachine.type")], 255, 255, 255, true)
                    count = count + 1
                end
            end
        end
        if count == 0 then 
            outputChatBox(core:getServerPrefix("server").."Nincs a közeledben Slot gép (".. distance .." Yard)", 0, 0, 0, true);
        end
    end
end)