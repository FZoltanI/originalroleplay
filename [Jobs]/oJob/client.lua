local sx,sy = guiGetScreenSize()
local myX, myY = 1768, 992

local imgA = 0
local animState = 1
local animState2 = 1
local tick = getTickCount()
local tick2 = getTickCount()

local showing = false

local jobped = createPed(227, 1480.9075927734,-1784.9136962891,18.734375, 0)
setElementData(jobped,"job->jobped",true)
setElementData(jobped,"ped:name","Munkáltató")
setElementFrozen(jobped, true)

local jobped2 = createPed(227, 1222.1196289063, 244.37243652344, 19.546894073486, 240)
setElementData(jobped2,"job->jobped",true)
setElementData(jobped2,"ped:name","Munkáltató")
setElementFrozen(jobped2, true)

local bR,bG,bB = 255,255,255

local selectedsor = 0
local selected = false

local jobinfo = 0

local fonts = {
    ["menu-large"] = exports.oFont:getFont("condensed",15,false),
    ["menu-medium"] = exports.oFont:getFont("condensed",11,false),
    ["menu-small"] = exports.oFont:getFont("condensed",9,false),
}

local work_pointer = 0

local pA = 0
local pA2 = 0

local closeing = false 

local activeped = false 

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oJob" then  
        core = exports.oCore
        color = core:getServerColor()
        info = exports.oInfobox
        font = exports.oFont
	end
end)

function renderJobPanel()

    if not closeing then 
        if core:getDistance(localPlayer, activeped) > 3 then 
            closeing = true
            closePanel()
        end
    end

    if animState == 1 then 
        pA = interpolateBetween(pA,0,0,1,0,0,(getTickCount()-tick)/1000, "Linear")
    elseif animState == 2 then
        pA = interpolateBetween(pA,0,0,0,0,0,(getTickCount()-tick)/1000, "Linear")
    end

    dxDrawRectangle(sx*0.347,sy*0.325,sx*0.305,sy*0.34,tocolor(30,30,30,140*pA))
    dxDrawRectangle(sx*0.347 + 2/myX*sx, sy*0.325 + 2/myY*sy,sx*0.305 - 4/myX*sx,sy*0.34-4/myY*sy,tocolor(35,35,35,255*pA))
    dxDrawRectangle(sx*0.347 + 2/myX*sx, sy*0.325 + 2/myY*sy,sx*0.305 - 4/myX*sx, sy*0.02,tocolor(30,30,30,255*pA))
    dxDrawText("OriginalRoleplay - "..color.."Munkáltató", sx*0.347 + 2/myX*sx, sy*0.325 + 2/myY*sy, sx*0.347 + 2/myX*sx + sx*0.305 - 4/myX*sx, sy*0.325 + 2/myY*sy+sy*0.02, tocolor(255, 255, 255, 100*pA), 1, font:getFont("condensed", 9/myX*sx), "center", "center", false, false, false, true)

    if core:isInSlot(sx*0.64+ 2/myX*sx, sy*0.325 + 2/myY*sy,sx*0.01, sy*0.02) then
        if getKeyState("mouse1") then 
            if not closeing then 
                closeing = true
                closePanel()
            end
        end

        dxDrawText("", sx*0.347 + 2/myX*sx, sy*0.325 + 2/myY*sy, sx*0.347 + 2/myX*sx + sx*0.305 - 8/myX*sx, sy*0.325 + 2/myY*sy+sy*0.02, tocolor(255, 255, 255, 200*pA), 1, font:getFont("fontawesome2", 9/myX*sx), "right", "center", false, false, false, true)
    else
        dxDrawText("", sx*0.347 + 2/myX*sx, sy*0.325 + 2/myY*sy, sx*0.347 + 2/myX*sx + sx*0.305 - 8/myX*sx, sy*0.325 + 2/myY*sy+sy*0.02, tocolor(255, 255, 255, 100*pA), 1, font:getFont("fontawesome2", 9/myX*sx), "right", "center", false, false, false, true)
    end

    local newy1 = sy*0.35
    for i=1, 6 do 

        local barAlpha = 240 

        if i % 2 == 0 then 
            barAlpha = 140
        end

        dxDrawRectangle(sx*0.347 + 4/myX*sx, newy1, sx*0.305 - 15/myX*sx,sy*0.05,tocolor(30,30,30,barAlpha*pA))

        newx = interpolateBetween(0,0,0,0.3,0,0,(getTickCount()-tick2)/1000,"Linear")
        if jobs[i+work_pointer] then 
            dxDrawText(jobs[i+work_pointer][1],sx*0.352 + 50/myX*sx,newy1,sx*0.35+sx*0.2,newy1+sy*0.05,tocolor(220,220,220,255*pA),1,font:getFont("bebasneue", 15/myX*sx),"left","bottom")
            dxDrawText(jobs[i+work_pointer][5],sx*0.36 + 50/myX*sx,newy1 + sy*0.003,sx*0.35+sx*0.2,newy1+sy*0.047,tocolor(r, g, b,200*pA),1,font:getFont("condensed", 9/myX*sx),"left","top")
            dxDrawText("",sx*0.352 + 50/myX*sx,newy1 + sy*0.003,sx*0.35+sx*0.2,newy1+sy*0.047,tocolor(r, g, b,200*pA),1,font:getFont("fontawesome2", 9/myX*sx),"left","top")
            if jobs[i+work_pointer][7] then
                dxDrawText(jobs[i+work_pointer][6],sx*0.352,newy1,sx*0.35+sx*0.025,newy1+sy*0.05,tocolor(255, 255, 255,200*pA),1,font:getFont("fontawesome2", 15/myX*sx),"center","center")
            else 
                dxDrawImage(sx*0.354, newy1 + sy*0.005, 32/myX*sx, 32/myY*sy, jobs[i+work_pointer][8], 0, 0, 0, tocolor(255, 255, 255,200*pA))
            end

            if jobs[i+work_pointer][4] then 
                dxDrawText("2x-es fizetés",sx*0.355, newy1 + sy*0.003,sx*0.35+sx*0.305 - 38/myX*sx,newy1+sy*0.049,tocolor(65, 217, 136,200*pA),1,font:getFont("condensed", 9/myX*sx),"right","top")
                dxDrawText("",sx*0.355, newy1 + sy*0.003,sx*0.35+sx*0.305 - 20/myX*sx,newy1+sy*0.049,tocolor(65, 217, 136,200*pA),1,font:getFont("fontawesome2", 9/myX*sx),"right","top")
            else
                dxDrawText("Átlagos fizetés",sx*0.355, newy1 + sy*0.003,sx*0.35+sx*0.305 - 38/myX*sx,newy1+sy*0.049,tocolor(r, g, b,200*pA),1,font:getFont("condensed", 9/myX*sx),"right","top")
                dxDrawText("",sx*0.355, newy1 + sy*0.003,sx*0.35+sx*0.305 - 20/myX*sx,newy1+sy*0.049,tocolor(r, g, b,200*pA),1,font:getFont("fontawesome2", 9/myX*sx),"right","top")
            end

            if getElementData(localPlayer, "char:job") == i+work_pointer then 
                core:dxDrawButton(sx*0.595, newy1 + sy*0.0225, sx*0.05, sy*0.025, redR, redG, redB, 220*pA, "Felmondás", tocolor(255, 255, 255, 255*pA), 1, font:getFont("condensed", 9/myX*sx), true, tocolor(0, 0, 0, 100*pA))
            else
                core:dxDrawButton(sx*0.595, newy1 + sy*0.0225, sx*0.05, sy*0.025, r, g, b, 220*pA, "Felvétel", tocolor(255, 255, 255, 255*pA), 1, font:getFont("condensed", 9/myX*sx), true, tocolor(0, 0, 0, 100*pA))
            end
        end

        --[[if core:isInSlot(sx*0.565,sy*newy1+sy*0.005,22/myX*sx,22/myY*sy) then 
            dxDrawImage(sx*0.565,sy*newy1+sy*0.005,22/myX*sx,22/myY*sy,"files/info.png",0,0,0,tocolor(blueR,blueG,blueB,255*pA))
        else
            dxDrawImage(sx*0.565,sy*newy1+sy*0.005,22/myX*sx,22/myY*sy,"files/info.png",0,0,0,tocolor(220,220,220,255*pA))
        end]]

        newy1 = newy1 + sy*0.05 + 2/myY*sy
    end

    local lineHeight = math.min(6 / #jobs, 1) 

    dxDrawRectangle(sx*0.648, sy*0.35, sx*0.0015, sy*0.31, tocolor(r, g, b, 75*pA))
    dxDrawRectangle(sx*0.648, sy*0.35 + (sy*0.31 * (lineHeight * work_pointer / 6)), sx*0.0015, sy*0.31 * lineHeight, tocolor(r, g, b, 200*pA)) 

    --[[if animState2 == 1 then 
        pA2 = interpolateBetween(pA2,0,0,1,0,0,(getTickCount()-tick2)/1000, "Linear")
    elseif animState2 == 2 then 
        pA2 = interpolateBetween(pA2,0,0,0,0,0,(getTickCount()-tick2)/1000, "Linear")
    end

    if jobinfo > 0 then 

        dxDrawRectangle(sx*0.398,sy*0.62,sx*0.204,sy*0.1,tocolor(40,40,40,220*pA2))

        if fileExists("files/jobs/"..tostring(jobinfo)..".png") then 
            dxDrawImage(sx*0.4,sy*0.6225,150/myX*sx,85/myY*sy,"files/jobs/"..tostring(jobinfo)..".png",0,0,0,tocolor(255,255,255,255*pA2))
        else
            dxDrawRectangle(sx*0.4,sy*0.6225,150/myX*sx,85/myY*sy,tocolor(30,30,30,255*pA2))
            dxDrawText("Nincs kép! \n :(",sx*0.4,sy*0.6225,sx*0.4+150/myX*sx,sy*0.6225+85/myY*sy, tocolor(220, 220, 220, 255*pA2), 1/myX*sx, fonts["menu-large"], "center", "center")
        end

        dxDrawRectangle(sx*0.496,sy*0.6225,167/myX*sx,85/myY*sy,tocolor(30,30,30,220*pA2))
        dxDrawText(jobs[jobinfo][2],sx*0.496,sy*0.6225,sx*0.496+167/myX*sx,sy*0.6225+85/myY*sy, tocolor(220, 220, 220, 255*pA2), 1/myX*sx, fonts["menu-small"], "center", "center", false, true)
    end]]
end

bindKey("backspace","up",
    function()
        if showing then 
            if animState == 1 then 
                closePanel()
            end
        end
    end 
)

function closePanel()
    tick = getTickCount()
    tick2 = getTickCount()
    animState = 2 
    animState2 = 2
    setTimer(function() 
        removeEventHandler("onClientRender",root,renderJobPanel) 
        pA = 0 
        pA2 = 0
        jobinfo = 0
        showing = false 
        closeing = false
    end,1000,1)
end

function openPanel()
    closeing = false
    showing = true
    tick = getTickCount() 
    tick2 = getTickCount()
    animState = 1 
    animState2 = 1
    addEventHandler("onClientRender",root,renderJobPanel)
end

addEventHandler("onClientClick",root,
    function(key,state,_,_,_,_,_,element)
        if element and state == "up" and key == "right" then             
            if core:getDistance(localPlayer, element) < 3 then 
                if getElementData(element,"job->jobped") then 
                    if not showing then 
                        activeped = element
                        openPanel()
                    end
                end
            end
        end
    end 
)

addEventHandler("onClientKey",root,
    function(key,state)
        if state then 
            if showing then 
                if key == "mouse_wheel_down" then 
                    if core:isInSlot(sx*0.347,sy*0.325,sx*0.305,sy*0.34) then 
                        if jobs[work_pointer+7] then 
                            work_pointer = work_pointer + 1 
                            selectedsor = 0
                            animState2 = 2
                        end
                    end
                end

                if key == "mouse_wheel_up" then 
                    if core:isInSlot(sx*0.347,sy*0.325,sx*0.305,sy*0.34) then 
                        if work_pointer > 0 then 
                            work_pointer = work_pointer - 1 
                            selectedsor = 0
                            animState2 = 2
                        end
                    end
                end

                if key == "mouse1" then 
                    local newy1 = sy*0.35
                    for i = 1, 6 do  
                        
                        if getElementData(localPlayer, "char:job") == i+work_pointer then 

                            if core:isInSlot(sx*0.595, newy1 + sy*0.0225, sx*0.05, sy*0.025) then 
                                outputChatBox(core:getServerPrefix("server", "munka", 1).." Sikeresen felmondtál!", 255, 255, 255, true)
                                setElementData(localPlayer, "char:job", 0)
                            end
                
                        else
                
                            if core:isInSlot(sx*0.595, newy1 + sy*0.0225, sx*0.05, sy*0.025) then 
                                if jobs[i+work_pointer][3] then 
                                    local job = getElementData(localPlayer, "char:job") or 0
                                    if job == 0 then 
                                        outputChatBox(core:getServerPrefix("server", "munka", 1).." Sikeresen felvetted a(z) "..color..jobs[i+work_pointer][1].." #ffffffmunkát.", 255, 255, 255, true)
                                        setElementData(localPlayer, "char:job", i+work_pointer)
                                        closePanel()
                                    else
                                        info:outputInfoBox("Mielőtt felvennéd a munkát, fel kell mondanod az előző munkahelyeden!","error")
                                        outputChatBox(core:getServerPrefix("red-dark", "Job", 3).."Mielőtt felvennéd a munkát, fel kell mondanod az előző munkahelyeden!", 255, 255, 255, true)
                                    end
                                else
                                    info:outputInfoBox("Ez a munka jelenleg nem érhető el! ("..jobs[i+work_pointer][1]..")", "error")
                                    outputChatBox(core:getServerPrefix("red-dark", "Job", 3).."Ez a munka jelenleg nem érhető el "..color.."("..jobs[i+work_pointer][1]..")", 255, 255, 255, true)
                                end
                            end
                
                        end

                        --[[if core:isInSlot(sx*0.565,sy*newy1+sy*0.005,22/myX*sx,22/myY*sy) then 

                            tick2 = getTickCount()
                            if jobinfo == i + work_pointer then
                                if not (pA2 == 1) then 
                                    animState2 = 1
                                else
                                    animState2 = 2
                                end
                            else
                                animState2 = 1
                                jobinfo = i + work_pointer
                            end
                        end]]

                        newy1 = newy1 + sy*0.05 + 2/myY*sy

                    end
                end
            end
        end
    end 
)

local vehDestroyTimer = false
addEventHandler("onClientVehicleExit", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isJobVeh") then 
            if getElementData(source, "jobVeh:owner") == localPlayer then 
                info:outputInfoBox("Ha nem szállsz vissza a munkajárművedbe "..getElementData(source, "jobVeh:destroyTime").." percen belül, akkor a járműved törlésre kerül!", "warning")
                outputChatBox(core:getServerPrefix("red-dark", getElementData(source, "jobVeh:createdScript"), 2).."Ha nem szállsz vissza a munkajárművedbe "..core:getServerColor()..getElementData(source, "jobVeh:destroyTime").." #ffffffpercen belül, akkor a járműved törlésre kerül!", 255, 255, 255, true)
                vehDestroyTimer = setTimer(function()
                    triggerServerEvent("job > destroyPlayerJobVeh", resourceRoot)
                    outputChatBox("asd")
                end, core:minToMilisec(getElementData(source, "jobVeh:destroyTime")), 1)
            end
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isJobVeh") then 
            if getElementData(source, "jobVeh:owner") == localPlayer then 
                if isTimer(vehDestroyTimer) then 
                    killTimer(vehDestroyTimer)
                    info:outputInfoBox("Mivel időben visszaszálltál a munkajárművedbe, így az nem kerül törlésre!", "success")
                    outputChatBox(core:getServerPrefix("green-dark", getElementData(source, "jobVeh:createdScript"), 2).."Mivel időben visszaszálltál a munkajárművedbe, így az nem kerül törlésre!", 255, 255, 255, true)
                end
            end
        end
    end
end)



-- JOB VEHICLE REQUEST

local panel_icon, panel_jobname, panel_vehname, panel_jobvehid
local panel_vehElement 
local panel_alpha, panel_tick, panel_state = 0, 0, "open"
local panel_preview
local panel_vehicleSpawnPoints = {}
local panel_vehicleDestroyTime = 0

local created_jobVehicle_markers = {}

local panelState = false

local buttonPosition = {}



function renderJobVehicleCreatePanel()
    if panel_state == "open" then 
        panel_alpha = interpolateBetween(panel_alpha, 0, 0, 1, 0, 0, (getTickCount() - panel_tick)/500, "Linear")
    else
        panel_alpha = interpolateBetween(panel_alpha, 0, 0, 0, 0, 0, (getTickCount() - panel_tick)/500, "Linear")
    end

    dxDrawRectangle(sx*0.4, sy*0.3, sx*0.2, sy*0.4, tocolor(32, 32, 32, 100*panel_alpha))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.3 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.4 - 4/myY*sy, tocolor(35, 35, 35, 255*panel_alpha))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.3 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02, tocolor(30, 30, 30, 255*panel_alpha))
    dxDrawText(panel_jobname, sx*0.4 + 2/myX*sx, sy*0.3 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + 2/myY*sy + sy*0.02, tocolor(255, 255, 255, 150*panel_alpha), 1, font:getFont("condensed", 9/myX*sx), "right", "center")
    dxDrawText("OriginalRoleplay - "..color.."Munkajármű lekérés", sx*0.4 + 6/myX*sx, sy*0.3 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + 2/myY*sy + sy*0.02, tocolor(255, 255, 255, 150*panel_alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "center", false, false, false, true)

    if isElement(panel_vehElement) then 
        panel_vehname = exports.oVehicle:getModdedVehicleName(panel_vehElement)
    end

    dxDrawText(panel_vehname, sx*0.4 + 6/myX*sx, sy*0.3 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + 2/myY*sy + sy*0.258, tocolor(255, 255, 255, 50*panel_alpha), 1, font:getFont("bebasneue", 22/myX*sx), "center", "bottom", false, false, false, true)
    dxDrawText(panel_vehname, sx*0.4 + 6/myX*sx, sy*0.3 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + 2/myY*sy + sy*0.252, tocolor(255, 255, 255, 220*panel_alpha), 1, font:getFont("bebasneue", 17/myX*sx), "center", "bottom", false, false, false, true)

    if not getElementData(localPlayer, "jobVeh:ownedJobVeh") then
        core:dxDrawButton(sx*0.4 + 6/myX*sx, sy*0.585, sx*0.2 - 12/myX*sx, sy*0.05, r, g, b, 220*panel_alpha, "Munkajármű felvétele", tocolor(255, 255, 255, 255*panel_alpha), 1, font:getFont("condensed", 11/myX*sx), true, tocolor(0, 0, 0, 100*panel_alpha))
    else
        core:dxDrawButton(sx*0.4 + 6/myX*sx, sy*0.585, sx*0.2 - 12/myX*sx, sy*0.05, r, g, b, 220*panel_alpha, "Munkajármű leadása", tocolor(255, 255, 255, 255*panel_alpha), 1, font:getFont("condensed", 11/myX*sx), true, tocolor(0, 0, 0, 100*panel_alpha))
    end
    buttonPosition["pick/dropVehicle"] = {sx*0.4 + 6/myX*sx, sy*0.585, sx*0.2 - 12/myX*sx, sy*0.05}

    core:dxDrawButton(sx*0.4 + 6/myX*sx, sy*0.642, sx*0.2 - 12/myX*sx, sy*0.05, redR, redG, redB, 220*panel_alpha, "Mégsem", tocolor(255, 255, 255, 255*panel_alpha), 1, font:getFont("condensed", 11/myX*sx), true, tocolor(0, 0, 0, 100*panel_alpha))
    buttonPosition["exit"] = {sx*0.4 + 6/myX*sx, sy*0.642, sx*0.2 - 12/myX*sx, sy*0.05}
end

function getJobVehicleButtonPos(name)
    return buttonPosition[name]
end

function keyJobVehiclePanel(key, state)
    if key == "mouse1" and state == true then 
        if core:isInSlot(sx*0.4 + 6/myX*sx, sy*0.642, sx*0.2 - 12/myX*sx, sy*0.05) then 
            destroyVehicleRequestPanel()
        end

        if core:isInSlot(sx*0.4 + 6/myX*sx, sy*0.585, sx*0.2 - 12/myX*sx, sy*0.05) then 
            if not getElementData(localPlayer, "jobVeh:ownedJobVeh") then
                destroyVehicleRequestPanel()
                local random = math.random(#panel_vehicleSpawnPoints)
                triggerServerEvent("job > createJobVehicle", resourceRoot, panel_jobvehid, {panel_vehicleSpawnPoints[random][1], panel_vehicleSpawnPoints[random][2], panel_vehicleSpawnPoints[random][3], 0, 0, panel_vehicleSpawnPoints[random][4]}, localPlayer, panel_jobname, panel_vehicleDestroyTime)
                info:outputInfoBox("Sikeresen lekérted a munkajárművedet!", "success")
            else
                destroyVehicleRequestPanel()
                triggerServerEvent("job > destoryJobVehicle", resourceRoot, localPlayer, getElementData(localPlayer, "jobVeh:ownedJobVeh"))
                info:outputInfoBox("Sikeresen leadtad a munkajárművedet!", "success")
            end
        end
    end
end

function createVehicleRequestPanel(jobname, jobvehid, triggered)
    if panel_tick + 1000 > getTickCount() then return end 

    if jobname and  tonumber(jobvehid) then
        panel_icon, panel_jobname, panel_jobvehid = icon, jobname, jobvehid
        panel_alpha, panel_tick, panel_state = 0, getTickCount(), "open"
        addEventHandler("onClientRender", root, renderJobVehicleCreatePanel)
        if not triggered then
            addEventHandler("onClientKey", root, keyJobVehiclePanel)
        end
        if isElement(panel_vehElement) then 
            destroyElement(panel_vehElement) 
        end

        panel_vehElement = createVehicle(jobvehid, 0, 0, 500)
        --setElementAlpha()
        panel_preview = exports.oPreview:createObjectPreview(panel_vehElement, 0, 0, 140, sx*0.4 + 25/myX*sx, sy*0.3 + 25/myY*sy, sx*0.2 - 4/myX*sx, sy*0.18, false, true)
        exports.oPreview:setPositionOffsets(panel_preview, 0,0,0)
        panelState = true
    else
        outputDebugString("[Munkajármű lekérés]: Az adatok hibásan lettek megadva!", 1)
    end
end

function destroyVehicleRequestPanel(triggered)
    if panelState then
        panelState = false
        exports.oPreview:destroyObjectPreview(panel_preview)


        panel_tick, panel_state = getTickCount(), "close"
        if not triggered then
            removeEventHandler("onClientKey", root, keyJobVehiclePanel)
        end
        if isElement(panel_vehElement) then 
            destroyElement(panel_vehElement) 
        end

        setTimer(function()
            removeEventHandler("onClientRender", root, renderJobVehicleCreatePanel)
        end, 500, 1)
    end
end

function getJobPanelState()
    return panelState
end

function createJobVehicleRequest(jobName, jobVehID, markerDatas, spawnPoints, destroyTime, isBlip)
    --[[
        jobName: string - munka megnevezése
        jobVehID: number - munkajármű azonosítója
        markerDatas: table - Marker pozíicója {marker x, marker y, marker z}
        spawnPoints: table - Jármű létrehozás pozíció(k) {{spawn x, spawn y, spawn z, rot}, {spawn x, spawn y, spawn z, rot}, {spawn x, spawn y, spawn z, rot}, ...}
        destroyTime: int - munkajármű törlési ideje
        isBlip: boolean - true/false - ha true akkor nem kér blipet ha false akkor igen (Azért fordított mert lusta vagyok beleírni mindenhova xD)
    ]]

    if jobName and tonumber(jobVehID) and type(markerDatas) == "table" and type(spawnPoints) == "table" and tonumber(destroyTime) then

        for k, v in ipairs(created_jobVehicle_markers) do 
            if getElementData(v, "job:vehicleRequest:jobName") == jobName then 
                return 
            end
        end

        local markerX, markerY, markerZ = unpack(markerDatas)

        local marker = exports.oCustomMarker:createCustomMarker(markerX, markerY, markerZ, 5.0, 245, 167, 66, 200, "jobvehicle", "circle")
        local blip = "false"
        if not isBlip then 
            blip = createBlip(markerX, markerY, markerZ, 58)
            setElementData(blip, "blip:name", "Munkajármű")
            table.insert(created_jobVehicle_markers, marker)
        end
        
        setElementData(marker, "job:vehicleRequest:isJobRequestMarker", true)
        setElementData(marker, "job:vehicleRequest:jobName", jobName)
        setElementData(marker, "job:vehicleRequest:jobVehID", jobVehID)
        setElementData(marker, "job:vehicleRequest:spawnPoints", spawnPoints)
        setElementData(marker, "job:vehicleRequest:destroyTime", destroyTime)

        return marker, blip
    else
        outputDebugString("[Munkajármű lekérés]: Az adatok hibásan lettek megadva!", 1)
    end
end

addEventHandler("onClientMarkerHit", root, function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "job:vehicleRequest:isJobRequestMarker") then
            createVehicleRequestPanel(getElementData(source, "job:vehicleRequest:jobName"), getElementData(source, "job:vehicleRequest:jobVehID")) 
            panel_vehicleSpawnPoints = getElementData(source, "job:vehicleRequest:spawnPoints")
            panel_vehicleDestroyTime = getElementData(source, "job:vehicleRequest:destroyTime")
        end
    end
end)

addEventHandler("onClientMarkerLeave", root, function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "job:vehicleRequest:isJobRequestMarker") then
            destroyVehicleRequestPanel()
            panel_vehicleSpawnPoints = {}
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for k, v in ipairs(created_jobVehicle_markers) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
end)

local colTimer = false
addEventHandler("onClientElementDataChange", root, function(dataName, old, new) 
    if source == localPlayer then
        if dataName == "jobVeh:ownedJobVeh" then 
            if isElement(new) then 
                if isTimer(colTimer) then killTimer(colTimer) end 

                setElementAlpha(new, 150)

                setTimer(function()
                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        setElementCollidableWith(v, new, false)
                    end
                end, 1000, 14)

                colTimer = setTimer(function()
                    for k, v in ipairs(getElementsByType("vehicle")) do 
                        setElementCollidableWith(v, new, true)
                    end

                    setElementAlpha(new, 255)
                end, 15000, 0)
            else
                if isTimer(colTimer) then killTimer(colTimer) end 
            end
        end
    end
end)

