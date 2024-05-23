local inWork = false

local pC1x, pC1y, pC1z, pC2x, pC2y, pC2z
local talk_text
local talking_timers = {}

--[[for k, v in ipairs(newspaperPeds) do 
    createPed(1, v[1], v[2], v[3], v[4])
    createBlip(v[1], v[2], v[3], 1)
end]]

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oJob_Newspaper" or getResourceName(res) == "oInterface" or getResourceName(res) == "oInventory" or getResourceName(res) == "oChat" then 
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        cmarker = exports.oCustomMarker
        font = exports.oFont
        interface = exports.oInterface
        inventory = exports.oInventory
        chat = exports.oChat
    end

    if getResourceName(res) == "oJob_Newspaper" then 
        setElementData(localPlayer, "job->haveJobVehicle", false)

        if getElementData(localPlayer, "char:job") == 5 then 
            createNewspaperMarkers()
    
            outputJobTips()
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(key, old, new) 
    if source == localPlayer then 
        if key == "char:job" then 
            if old == 5 then 
                destroyNewspaperMarkers()
                destroyAllPed()

                removeEventHandler("onClientRender", root, renderPlayerBag)
                bagShowing = false
                inWork = false
                
                if inventory:hasItem(149, 1) then 
                    inventory:takeItem(149)
                end 

                triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)
            end

            if new == 5 then 
                createNewspaperMarkers()

                outputJobTips()
            end
        end
    end
end)

function outputJobTips() 
    outputChatBox(core:getServerPrefix("server", "Újságos", 3).."A munka kezdéséhez menj el az újságos telephelyre, amit a térképen egy"..color.." narancssárga #fffffftáska ikonnal jelöltünk.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Újságos", 3).."A munka kezdéséhez beszélj a "..color.."munkáltatóddal #ffffffaki egy papíron odadja neked a rendeléseket.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Újságos", 3).."Vásárold meg a szükséges újságokat a "..color.."narancssárga #ffffffmarkerban, majd vedd el a munkajárműved a #2289c9kék #ffffffmarkerban.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Újságos", 3).."Hord ki az újságokat a megadott címekre, amelyeket a térképen #60bf60zöld #ffffffx-el jelöltünk.", 255, 255, 255, true)
end

function createNewspaperMarkers()
    biciklimarker = cmarker:createCustomMarker(2458.2690429688,-48.254585266113,26.484375, 4.0, 67, 205, 239, 255, "bike", "rectangle")
    ujsagosmarker = cmarker:createCustomMarker(2456.4663085938,-43.928997039795,26.72500038147, 3.0, 232, 149, 81, 255, "newspaper", "circle")

    meloblip = createBlip(bossPed.pos.x, bossPed.pos.y, bossPed.pos.z, 11)
    setElementData(meloblip, "blip:name", "Újságos")

    munkaltato = createPed(15, bossPed.pos.x, bossPed.pos.y, bossPed.pos.z, 101)
    setElementFrozen(munkaltato, true)
    setElementData(munkaltato, "ped:name", "Taylor White")
    setElementData(munkaltato, "ped:prefix", "Munkáltató")
end

function destroyNewspaperMarkers()
    if biciklimarker then 
        destroyElement(biciklimarker)
    end

    if ujsagosmarker then 
        destroyElement(ujsagosmarker)
    end

    if meloblip then 
        destroyElement(meloblip)
    end

    if isElement(munkaltato) then 
        destroyElement(munkaltato)
    end
end

--------------------------------------

local sx,sy = guiGetScreenSize()
local myX,myY = 1768,992

local jarmufelvevo = false
local rendelesekShowing = false
local newspaperBuy = false

local fonts = {
    ["roboto-1"] = font:getFont("roboto-light",16,false),
    ["roboto-2"] = font:getFont("roboto-light",12,false),
    ["condensed-15"] = font:getFont("condensed", 15, false),
    ["condensed-20"] = font:getFont("condensed", 20, false),
    ["condensed-40"] = font:getFont("condensed", 40, false),
    ["handwrite-1"] = font:getFont("desyrel", 15, false),
}

local rendelesek = {}

local ownedNewspapers = {0, 0, 0, 0, 0, 0}

local pA = 0

function renderVehiclePickup() 
    local munkakocsi = getElementData(localPlayer,"job->haveJobVehicle") or false 
    if munkakocsi then 
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
            shadowedText("Munkajármű leadása",0, 0, sx, sy, 201, 73, 68, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        else
            shadowedText("Munkajármű leadása",0, 0, sx, sy, 220, 220, 220, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        end
    else
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
            shadowedText("Munkajármű felvétel",0, 0, sx, sy, 74, 145, 86, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        else
            shadowedText("Munkajármű felvétel",0, 0, sx, sy, 220, 220, 220, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        end
    end
end

function renderNewspaperBuy() 
    shadowedText("Újságok",sx*0.4,sy*0.35,sx*0.4+sx*0.2,sy*0.35+sy*0.02,220,220,220,255,1/myX*sx,fonts["condensed-15"],"center","center")
    dxDrawRectangle(sx*0.398,sy*0.377,sx*0.204,sy*0.241,tocolor(40,40,40,220))
    dxDrawImage(0+(200/myX*sx),0+(140/myY*sy),sx-(400/myX*sx),sy-(280/myY*sy),"files/logo.png",0,0,0,tocolor(255,255,255,50))

    local newy1 = 0.38
    for k, v in ipairs(newspapers) do 

        dxDrawRectangle(sx*0.4,sy*newy1, sx*0.2,sy*0.035,tocolor(30,30,30,240))

        dxDrawText(v[1]..color.." ("..v[2].."$)",sx*0.405,sy*newy1,sx*0.405+sx*0.2,sy*newy1+sy*0.035,tocolor(220,220,220,200),0.8/myX*sx,fonts["condensed-15"],"left","center", false, false, false, true)

        if core:isInSlot(sx*0.55,sy*newy1, sx*0.05, sy*0.035) then 
            dxDrawText("Vásárlás",sx*0.405,sy*newy1,sx*0.405+sx*0.192,sy*newy1+sy*0.035, tocolor(r,g,b,200),0.8/myX*sx,fonts["condensed-15"],"right","center", false, false, false, true)
        else
            dxDrawText("Vásárlás",sx*0.405,sy*newy1,sx*0.405+sx*0.192,sy*newy1+sy*0.035, tocolor(220,220,220,200),0.8/myX*sx,fonts["condensed-15"],"right","center", false, false, false, true)
        end

        newy1 = newy1 + 0.04
    end
end

local bagX, bagY = 0.885, 0.45
local fogasX, fogasY

local bagMoveing = false
local bagShowing = false

function renderPlayerBag()
    if bagMoveing then 
        if not isCursorShowing() then 
            bagMoveing = false
        end

        bagX, bagY = getCursorPosition()
        bagX, bagY = bagX + fogasX, bagY + fogasY
    end
    dxDrawRectangle(sx*bagX, sy*bagY, sx*0.11, sy*0.155, tocolor(40, 40, 40, 255))

    local startY = bagY + 0.003
    for k, v in ipairs(newspapers) do 
        dxDrawRectangle(sx*(bagX+0.0014), sy*startY, sx*0.107, sy*0.023, tocolor(30, 30, 30, 255))
        dxDrawText(v[1]..color.." ("..ownedNewspapers[k].."db)", sx*(bagX+0.0025), sy*startY, sx*(bagX+0.0025)+sx*0.107, sy*startY+sy*0.023, tocolor(255, 255, 255, 255), 0.7/myX*sx, fonts["condensed-15"], "left", "center", false, false, false, true)

        if core:isInSlot(sx*(bagX + 0.09), sy*startY, sx*0.02, sy*0.023) then 
            dxDrawText("-", sx*(bagX), sy*startY, sx*(bagX)+sx*0.107, sy*startY+sy*0.023, tocolor(191, 54, 54, 255), 0.7/myX*sx, fonts["condensed-40"], "right", "center", false, false, false, true)
        else
            dxDrawText("-", sx*(bagX), sy*startY, sx*(bagX)+sx*0.107, sy*startY+sy*0.023, tocolor(255, 255, 255, 255), 0.7/myX*sx, fonts["condensed-40"], "right", "center", false, false, false, true)
        end

        startY = startY + 0.025
    end
end

function renderNote() 
    dxDrawImage(sx*0.395, sy*0.363, 650*0.6/myX*sx, 453*0.6/myY*sy, "files/note.png")

    local newy1 = 0.397
    local renderDatas = 0

    for i = 1, #rendelesek do 
        if renderDatas <= 7 then
            dxDrawText(rendelesek[i][1].." ("..newspapers[rendelesek[i][2]][1]..")", sx*0.42, sy*newy1, _, _,tocolor(50, 96, 168, 255), 0.9/myX*sx, fonts["handwrite-1"], _, _, false, false, false, true)
            if rendelesek[i][3] then 
                local athuzas = 0.01
                dxDrawLine(sx*0.41, sy*(newy1+athuzas), sx*0.41+sx*0.15, sy*(newy1+athuzas), tocolor(50, 96, 168, 255), 3)
            end
            newy1 = newy1 + 0.03
            renderDatas = renderDatas + 1
        end
    end
end

local noteShowing = false
function showNote() 
    if noteShowing then 
        noteShowing = false 
        removeEventHandler("onClientRender", root, renderNote)
    else
        noteShowing = true
        addEventHandler("onClientRender", root, renderNote)
        exports.oChat:sendLocalMeAction("megnéz egy jegyzetet.")
    end
    playSound("files/license.wav")
end

addEventHandler("onClientKey",root,
    function(key,state)
        if state then 
            if jarmufelvevo then 
                if key == "mouse1" then 
                    local munkakocsi = getElementData(localPlayer,"job->haveJobVehicle") or false 

                    if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
                        if munkakocsi then 
                            jarmufelvevo = false
                            triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)
                            killTimer(getElementData(source, "job->vehicleDelTimer"))
                            outputChatBox(core:getServerPrefix("green-dark", "Munkajármű", 2).."Sikeresen leadtad a munkajárműved!", 255,255,255,true)

                            if inventory:hasItem(149, 1) then 
                                inventory:takeItem(149)
                            end 

                            rendelesek = {}
                            destroyAllPed()

                            showCursor(false)
                        else
                            jarmufelvevo = false
                            triggerServerEvent("job->newspaper->makevehicle", resourceRoot,localPlayer)
                            showCursor(false)
                        end
                    end 
                end
            end

            if key == "mouse1" then  
                if newspaperBuy then 
                    local newy1 = 0.38
                    for k, v in ipairs(newspapers) do 


                        if core:isInSlot(sx*0.55,sy*newy1, sx*0.05, sy*0.035) then 
                            if getElementData(localPlayer, "char:money") >= v[2] then 
                                if getPlayerAllNewspaper() < 6 then 
                                    outputChatBox(core:getServerPrefix("green-dark", "Újságos", 3).."Sikeresen vásároltál egy újságot "..color..v[2].."$#ffffff-ért. "..color.."("..v[1]..")", 255, 255, 255, true) 
                                    triggerServerEvent("job->newspaper->givemoney", resourceRoot, 2, v[2])

                                    ownedNewspapers[k] = ownedNewspapers[k] + 1
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Újságos", 3).."Nem fér el nállad több újság! "..color.."(6db)", 255, 255, 255, true) 
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Újságos", 3).."Nincs elegendő pénzed az újság megvásárlására! "..color.."("..v[2].."$)", 255, 255, 255, true) 
                            end
                            return
                        end

                        newy1 = newy1 + 0.04
                    end
                end
            end
        end

        if key == "mouse1" then 
            if bagShowing then 
                if core:isInSlot(sx*bagX, sy*bagY, sx*0.11, sy*0.155) then 
                    if state then 
                        bagMoveing = true

                        local cX, cY = getCursorPosition()
                        fogasX, fogasY = bagX - cX, bagY - cY
                    else
                        bagMoveing = false
                    end
                end

                local startY = bagY + 0.003
                for k, v in ipairs(newspapers) do 
                    if core:isInSlot(sx*(bagX + 0.09), sy*startY, sx*0.02, sy*0.023) then 
                        print("asd")
                        if state then 
                            if ownedNewspapers[k] >= 1 then 
                                ownedNewspapers[k] = ownedNewspapers[k] - 1 
                                chat:sendLocalMeAction("eldob egy újságot.")
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Újság", 3).."Ebből az újságból nincs nálad egy darab sem!", 255, 255, 255, true)
                            end
                        end
                    end

                    startY = startY + 0.025
                end
            end
        end
    end 
)

addEventHandler("onClientClick",root,
    function(key,state,_,_,_,_,_,element)
        if key == "right" and state == "up" and element then 
            if getElementData(element,"job->newspaper->isNewspaperPed") then 
                local pedID = getElementData(element,"job->newspaper->pedID")
                local rendeltUjsag = getElementData(element,"job->newspaper->rendeltUjsag")
                local ped = element

                if not getElementData(element,"job->newspaper->volt") then 
                    if core:getDistance(localPlayer, element) < 3  then 
                        if ownedNewspapers[rendeltUjsag] > 0 then
                            ownedNewspapers[rendeltUjsag] = ownedNewspapers[rendeltUjsag] - 1
                            rendelesek[pedID][3] = true 
        
                            setPedAnimation(ped,"ghands","gsign4",100,true,false,true,true)
                            setTimer(function()destroyElement(ped)end,15000,1)
        
                            local blipecske = getElementData(ped,"job->newspaper->blip")
                            destroyElement(blipecske)
                            local marker = getElementData(ped,"job->newspaper->marker")
                            destroyElement(marker)
        
                            local payment = (newspapers[rendeltUjsag][3])
                            if exports.oJob:isJobHasDoublePaymant(5) then 
                                payment = payment * 2
                            end

                            outputChatBox(core:getServerPrefix("green-dark", "Újságos", 3).."Sikeresen átadtad az újságot, ezért kaptál "..color..payment.."$-t#ffffff!",255,255,255,true) 
                            triggerServerEvent("job->newspaper->givemoney", resourceRoot, 1, payment)

                            setElementData(element,"job->newspaper->volt",true)

                            if isLastPed() then 
                                outputChatBox(core:getServerPrefix("server", "Újságos", 3).."Sikeresen leadtad az utolsó újságot is!", 255, 255, 255, true)
                                outputChatBox(core:getServerPrefix("server", "Újságos", 3).."Ha szeretnél tovább dolgozni, akkor beszélj újra a "..color.."munkáltatóddal#ffffff. Ha pedig be szeretnéd fejezni, akkor pedig add le a"..color.." munkajárművedet#ffffff.", 255, 255, 255, true)

                                removeEventHandler("onClientRender", root, renderPlayerBag)
                                bagShowing = false
                                inWork = false

                                rendelesek = {}
                                
                                if inventory:hasItem(149, 1) then 
                                    inventory:takeItem(149)
                                end 
                            end
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Újságos", 3).."Nincs nállad ilyen újság!"..color.." ("..newspapers[rendeltUjsag][1]..")",255,255,255,true) 
                        end
                    end
                end
            end

            if element == munkaltato then 
                if core:getDistance(localPlayer, element) < 3 then 
                    if not inWork then 
                        startTalkAnimation()
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Újságos", 3).."Már jelentkeztél a munkáltatónál a címekért!",255,255,255,true)
                    end
                end
            end
        end
    end 
)

function isLastPed()
    local last = true
    
    for k, v in ipairs(rendelesek) do 
        if not v[3] then 
            last = false 
            break
        end 
    end

    return last
end

function renderTalkPanel()
    local alpha 
    
    if animation_state == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    end

    dxDrawRectangle(0, sy*0.9, sx*0.5*alpha, sy*0.1, tocolor(30, 30, 30, 255*alpha))
    dxDrawRectangle(sx-sx*0.5*alpha, sy*0.9, sx/2, sy*0.1, tocolor(30, 30, 30, 255*alpha))

    if talk_text then 
        dxDrawText(color.."[Taylor]: #dcdcdc"..texts[talk_text[1]][talk_text[2]], 0, sy*0.9, sx, sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)
    end
end


function startTalkAnimation() 
    setElementAlpha(localPlayer, 0)
    pC1x, pC1y, pC1z, pC2x, pC2y, pC2z = getCameraMatrix()

    smoothMoveCamera(pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, bossPed.pos.x-3, bossPed.pos.y, bossPed.pos.z+0.6, bossPed.pos.x, bossPed.pos.y, bossPed.pos.z+0.6, 1000)

    animation_state = "open"
    animation_tick = getTickCount() 
    addEventHandler("onClientRender", root, renderTalkPanel)

    setElementFrozen(localPlayer, true)

    showChat(false)
    interface:toggleHud(true)

    setTimer(function() 
        setElementData(localPlayer, "user:hideWeapon", true)
        bindKey("backspace", "up", stopTalkAnimation) 
        talkingAnimation("job_start") 
    end, 1000, 1)
end

function stopTalkAnimation()
    setElementAlpha(localPlayer, 255)
    smoothMoveCamera(bossPed.pos.x-3, bossPed.pos.y, bossPed.pos.z+0.6, bossPed.pos.x, bossPed.pos.y, bossPed.pos.z+0.6, pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, 1000)

    animation_state = "close"
    animation_tick = getTickCount() 

    showChat(true)
    setPedAnimation(munkaltato)
    interface:toggleHud(false)
    unbindKey("backspace", "up", stopTalkAnimation)

    setElementFrozen(localPlayer, false)

    killTalkingTimers() 

    setTimer(function() 
        setElementData(localPlayer, "user:hideWeapon", false)
        setCameraTarget(localPlayer, localPlayer) 
        inAnimation = false  
        removeEventHandler("onClientRender", root, renderTalkPanel) 
        talk_text = false 
        talking_timers = {}
    end, 1000, 1)
end

function killTalkingTimers()
    for k, v in ipairs(talking_timers) do 
        if isTimer(v) then 
            killTimer(v)
        end
    end

    talking_timers = {}
end

function talkingAnimation(text_group)
    talking_timers = {}
    local timer_time = 0

    setPedAnimation(munkaltato, "GHANDS", "gsign5", -1, true, false, false, false)
    for k, v in ipairs(texts[text_group]) do 
        timer_time = timer_time + string.len(v)*text_wait

        if k == 1 then 
            talk_text = {text_group, 1}
        elseif k == #texts[text_group] then 
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1

                setTimer(function() 
                    talk_text = false 
                    setPedAnimation(munkaltato)
                    stopTalkAnimation()
                    createNewspaperPeds()

                    addEventHandler("onClientRender", root, renderPlayerBag)
                    bagShowing = true
                    inWork = true

                    if not inventory:hasItem(149, 1) then 
                        inventory:giveItem(149, 1, 1, 0)
                    end
                end, string.len(v)*text_wait, 1)
            end, timer_time,1)

            table.insert(talking_timers, #talking_timers+1, timer)
        else
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1
            end, timer_time,1)

            table.insert(talking_timers, #talking_timers+1, timer)
        end
    end
end

function getPlayerAllNewspaper()
    local osszes = 0
    for k,v in ipairs(ownedNewspapers) do 
        if v > 0 then 
            osszes = osszes + v 
        end
    end
    return osszes
end

function createNewspaperPeds()

    local newspaperPeds_cache = newspaperPeds

    local random = math.random(4,7)
    for i=1, random do
    	local nem = math.random(1,2)
    	local randskin = math.random(#ped_skins[nem])
        local randname = math.random(#ped_names[nem])
        
        local randomped = math.random(#newspaperPeds_cache)


        local ped = createPed(ped_skins[nem][randskin],newspaperPeds_cache[randomped][1],newspaperPeds_cache[randomped][2],newspaperPeds_cache[randomped][3],newspaperPeds_cache[randomped][4])
        local randomujsag = math.random(#newspapers)

        local blipecske = createBlipAttachedTo(ped,5)
        setElementData(blipecske, "blip:name", ped_names[nem][randname])
        local marker = createMarker(newspaperPeds_cache[randomped][1],newspaperPeds_cache[randomped][2],newspaperPeds_cache[randomped][3]+1.5,"arrow",0.3,r,g,b,150)

        setElementData(ped,"job->newspaper->pedID",i)
        setElementData(ped,"job->newspaper->isNewspaperPed",true)
        setElementData(ped,"job->newspaper->rendeltUjsag",randomujsag)
        setElementData(ped,"job->newspaper->blip",blipecske)
        setElementData(ped,"job->newspaper->marker",marker)
        setElementData(ped,"ped:name",ped_names[nem][randname])
        setElementData(ped,"job->newspaper->volt",false)
        setElementFrozen(ped,true)
    
        table.insert(rendelesek,#rendelesek+1,{ped_names[nem][randname],randomujsag,false})
        table.remove(newspaperPeds_cache,randomped)
    end
end

function destroyAllPed()
    for k,v in ipairs(getElementsByType("ped")) do 
        if getElementData(v,"job->newspaper->isNewspaperPed") then 
            destroyElement(getElementData(v,"job->newspaper->blip"))
            destroyElement(getElementData(v,"job->newspaper->marker"))
            destroyElement(v)
        end
    end
end

addEventHandler("onClientMarkerHit", root,
    function(player,mdim)
        if mdim then 
            if player == localPlayer then 
                if isElement(source) then
                    local sX,sY,sZ = getElementPosition(source)
                    local pX,pY,pZ = getElementPosition(localPlayer)

                    if core:getDistance(localPlayer, source) < 3 then
                        if source == biciklimarker then 
                            addEventHandler("onClientRender", root, renderVehiclePickup)
                            jarmufelvevo = true
                        end

                        if source == ujsagosmarker then 
                            if inWork then 
                                addEventHandler("onClientRender", root, renderNewspaperBuy)
                                newspaperBuy = true
                            else 
                                outputChatBox(core:getServerPrefix("red-dark", "Újságos", 3).."Először beszélj a munkáltatóddal!",255,255,255,true)
                            end
                        end
                    end
                end
            end 
        end
    end 
)

addEventHandler("onClientMarkerLeave",getRootElement(),
    function(player,mdim)
        if mdim then 
            if player == localPlayer then 
                if source == biciklimarker then 
                    removeEventHandler("onClientRender", root, renderVehiclePickup)
                    jarmufelvevo = false
                elseif source == ujsagosmarker then 
                    removeEventHandler("onClientRender", root, renderNewspaperBuy)
                    newspaperBuy = false
                end
            end 
        end
    end 
)

addEventHandler( "onClientResourceStop", resourceRoot,
    function (  )
        if biciklimarker then 
            destroyElement(biciklimarker)
        end
        if ujsagosmarker then 
            destroyElement(ujsagosmarker)
        end

        if inventory:hasItem(149, 1) then 
            inventory:takeItem(149)
        end 
    end
)

addEventHandler("onClientPlayerQuit", root, function() 
    if source == localPlayer then 
        triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)
    end
end)

addEventHandler("onClientVehicleExit", root, function(player) 
    if player == localPlayer then 
        if getElementData(source, "newspaper:isJobVehicle") then 
            if source == getElementData(localPlayer, "job->jobVehicle") then 
                outputChatBox(core:getServerPrefix("red-dark", "Munkajármű", 3).."Ha nem szállsz vissza a munkajárművedbe "..color.."5 #ffffffpercen belül, akkor az törlődik!", 255, 255, 255, true)

                local deltimer = setTimer(function() 
                    triggerServerEvent("job->newspaper->destroyPlayerJobVehicle", resourceRoot)

                    outputChatBox(core:getServerPrefix("red-dark", "Munkajármű", 3).."A munkajárműved törlésre került!", 255, 255, 255, true)
                end, core:minToMilisec(5), 1)

                setElementData(source, "job->vehicleDelTimer", deltimer)
            end
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player) 
    if player == localPlayer then 
        if getElementData(source, "newspaper:isJobVehicle") then 
            if source == getElementData(localPlayer, "job->jobVehicle") then 
                if isTimer(getElementData(source, "job->vehicleDelTimer")) then 
                    killTimer(getElementData(source, "job->vehicleDelTimer"))
                    setElementData(source, "job->vehicleDelTimer", false)
                end
                outputChatBox(core:getServerPrefix("green-dark", "Munkajármű", 3).."Mivel vissza szálltál a munkajárművedbe így az nem kerül törlésre!", 255, 255, 255, true)
            end
        end
    end
end)

function shadowedText(text,x,y,x2,y2,r,g,b,a,size,font,align1,align2) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y+1,x2+1,y2+1,tocolor(0,0,0,a),size,font,align1,align2,false,false,false,false)
    dxDrawText(text,x,y,x2,y2,tocolor(r,g,b,a),size,font,align1,align2,false,false,false,true)
end

-----SmoothCamera
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then
		destroyElement(sm.object1)
		destroyElement(sm.object2)
		killTimer(timer1)
		killTimer(timer2)
		killTimer(timer3)
		removeEventHandler("onClientPreRender",root,camRender)
	end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(destroyElement,time,1,sm.object1)
	timer3 = setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end