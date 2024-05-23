local numberplate = dxCreateTexture("files/numberplate.png", "dxt5")
local licenseFont = dxCreateFont("files/licenseplate.ttf", 20, false)
local size = 0.8
local updateTimer

local renderTarget = dxCreateRenderTarget(75, 75, true)

local isNumberplatesShowing = false

local renderedVehicles = {}

function renderNumberPlate()
    for k, v in pairs(renderedVehicles) do 
        if v then 
        --if core:getDistance(localPlayer, v) < 40 then 
            if getElementDimension(v[1]) == getElementDimension(localPlayer) then 
                if getElementInterior(v[1]) == getElementInterior(localPlayer) then 
                    if not (getPedOccupiedVehicle(localPlayer) == v[1]) then 
                        local pos = Vector3(getElementPosition(v[1]))

                        local x, y = getScreenFromWorldPosition(pos.x, pos.y, pos.z+1.5, 180)

                        local posx, posy, posz = getElementPosition(localPlayer)
                        if isLineOfSightClear(pos.x, pos.y, pos.z, posx, posy, posz, true, false, false) then
                            if x and y then

                                local dis = core:getDistance(v[1], localPlayer)

                                dis = 1 - (5/dis)

                                dis = 1 - dis

                                dis = math.min(dis, 1)

                                dxDrawRectangle(x - 74*dis, y +31*dis - (31/2*dis), 148*dis, 78*dis, tocolor(30, 30, 30, 150))
                                dxDrawImage(x - 70*dis, y +35*dis - (35/2*dis) + 2*dis, 140*dis, 70*dis, numberplate)
                                dxDrawText (getVehiclePlateText(v[1]), x - 70*dis, y +35*dis - (35/2*dis) + 12*dis, x - 70*dis + 140*dis, y +35*dis - (35/2*dis) + 12*dis + 70*dis, tocolor(28, 110, 217, 255), dis, licenseFont, "center", "center")        
                                
                                if getElementData(localPlayer, "user:aduty") then 

                                    dxDrawRectangle(x - 74*dis, y +95*dis, 148*dis, 20*dis, tocolor(30, 30, 30, 150))

                                    dxDrawText("ID: "..getElementData(v[1], "veh:id"), x - 74*dis, y +95*dis, x - 74*dis + 148*dis, y +95*dis + 20*dis, tocolor(240, 62, 62, 255), 0.5*dis, licenseFont, "center", "center")        
                                end
                            end
                        end
                    end
                end
            end
        --end
        end
    end
end

function startNumberplateRender()
    addEventHandler("onClientRender", root, renderNumberPlate)

    updateTimer = setTimer(function()
        for k, v in ipairs(getElementsByType("vehicle")) do 
            if getElementData(v, "veh:id") then 
                if core:getDistance(localPlayer, v) < 40 then 
                    if getElementDimension(v) == getElementDimension(localPlayer) then 
                        if getElementInterior(v) == getElementInterior(localPlayer) then 
                            --print(getElementData(v, "veh:id"))
                            if not renderedVehicles[getElementData(v, "veh:id")] then 
                                if renderedVehicles[getElementData(v, "veh:id")] == false then 
                                    --print(getElementData(v, "veh:id")..": insert")
                                    table.insert(renderedVehicles, getElementData(v, "veh:id"), {v, dxCreateRenderTarget(75, 75, true)})
                                else
                                    renderedVehicles[getElementData(v, "veh:id")] = {v, dxCreateRenderTarget(75, 75, true)}
                                end
                            else
                                --print(getElementData(v, "veh:id")..": update")
                                dxSetRenderTarget(renderedVehicles[getElementData(v, "veh:id")][2], true)
                                dxSetBlendMode("modulate_add") 
                                dxSetBlendMode("blend")
                                dxSetRenderTarget()         
                            end
                        end
                    end
                else
                    if renderedVehicles[getElementData(v, "veh:id")] then
                        --print("remove: "..getElementData(v, "veh:id"))
                        renderedVehicles[getElementData(v, "veh:id")] = false             
                    end
                end
            end
        end       
    end, 500, 0)
end

function stopNumberplateRender()
    removeEventHandler("onClientRender", root, renderNumberPlate)
    killTimer(updateTimer)
end

function toggleNumberplates()
    if getElementData(localPlayer, "user:loggedin") then 
        renderedVehicles = {}
        isNumberplatesShowing = not isNumberplatesShowing 

        if isNumberplatesShowing then 
            startNumberplateRender()
            outputChatBox(core:getServerPrefix("server", "Rendszám", 2).."A rendszámok megjelenítése bekapcsolva!", 255, 255, 255, true)
        else
            stopNumberplateRender()
            outputChatBox(core:getServerPrefix("server", "Rendszám", 2).."A rendszámok megjelenítése kikapcsolva!", 255, 255, 255, true)
        end
    end
end
bindKey("F10", "up", toggleNumberplates)