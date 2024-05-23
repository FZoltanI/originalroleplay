--panel 

local myPets = {}

local fontsScript = exports.oFont
local font = fontsScript:getFont("condensed", 14)

local sx,sy = guiGetScreenSize()
local menuAnimationTick,menuState = getTickCount(),false
local menuAnimationTick2,menuState2 = getTickCount(),false
local menuAnimationTick3,menuState3 = getTickCount(),false

local alphaTick = getTickCount()
local alpha = 0
local alpha2 = 0
local count = 0
local maxshow = 13 
local scrolvalue = 0
local selectedRow;
local click = false
local textHossz = 0
local loadingActive,loadingCounter = true,0

local sellPanel = false

function renderPanel()

    if menuState then
        alpha,alpha2,alpha3 = interpolateBetween(alpha, 0, 0, 255, 1, 100, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
        alpha4 = interpolateBetween(0, 0, 0, 100, 0, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")

    else 
        alpha,alpha2,alpha3 = interpolateBetween(255, 1, 100, 0, 0, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
        alpha4 = interpolateBetween(100, 0, 0, 0, 0, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
    end

    core:drawWindow(sx*0.29, sy*0.15,sx*0.425, sy*0.65, "Saját Állataid", alpha2)
    --dxDrawRectangle(sx*0.29, sy*0.15,sx*0.425, sy*0.65,tocolor(56,52,68,255))
    dxDrawText("#"..(count), sx*0.71 - 1, sy*0.1625 + 1,_,_, tocolor(0, 0, 0, alpha), 0.00035*sx, font, "right", "center",false,false,false,true)
    dxDrawText("#ffffff##e3721f"..(count), sx*0.71, sy*0.1625,_,_, tocolor(255, 255, 255, alpha), 0.00035*sx, font, "right", "center",false,false,false,true)

     
    if loadingActive then 
        loadingCounter = loadingCounter + 5
        --dxDrawCircle(sx*0.5,sy*0.45, 25 , 1, loadingCounter, tocolor(227, 114, 31,alpha), tocolor(255,255,255,0), 1024)
        dxDrawImage(sx*0.475,sy*0.398,sx*0.05,sy*0.09,"files/loading.png",loadingCounter,0,0,tocolor(227, 114, 31,alpha))

        dxDrawText("Petek betöltése..", sx*0.525 - 1, sy*0.5 + 1,_,_, tocolor(0, 0, 0, alpha), 0.00035*sx, font, "right", "center",false,false,false,true)
        dxDrawText("Petek betöltése..", sx*0.525, sy*0.5,_,_, tocolor(255, 255, 255, alpha), 0.00035*sx, font, "right", "center",false,false,false,true)
    else 
        if not sellPanel then 
            if count > 0 then 
                dxDrawRectangle(sx*0.295, sy*0.189,sx*0.2, sy*0.6, tocolor(20, 20, 20, alpha))
                dxDrawRectangle(sx*0.2975, sy*0.75,sx*0.195, sy*0.035, tocolor(40, 40, 40, alpha))
                dxDrawText((count).."/"..maxPet, sx*0.49 - 1, sy*0.768 + 1,_,_, tocolor(0, 0, 0, alpha), 0.0005*sx, font, "right", "center",false,false,false,true)
                dxDrawText("#e3721f"..(count).."#ffffff/"..maxPet, sx*0.49, sy*0.768,_,_, tocolor(255, 255, 255, alpha), 0.0005*sx, font, "right", "center",false,false,false,true)
                dxDrawText("+ Slot Vásárlása (100PP)", sx*0.299 - 1, sy*0.769 + 1,_,_, tocolor(0,0,0, alpha), 0.0005*sx, font, "left", "center",false,false,false,true)
                dxDrawText("#e3721f+#ffffff Slot Vásárlása #6eacf0(100PP)", sx*0.299, sy*0.769,_,_, tocolor(255,255,255, alpha), 0.0005*sx, font, "left", "center",false,false,false,true)
                --dxDrawText("100PP", sx*0.35 - 1, sy*0.757 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "left", "center",false,false,false,true)
                --dxDrawText("#6eacf0100PP", sx*0.35, sy*0.757,_,_, tocolor(255,255,255, alpha), 0.0003*sx, font, "left", "center",false,false,false,true)
            else 
                dxDrawText("Még nincsen egy állatod se!", sx*0.505, sy*0.37,_,_, tocolor(255,255,255, alpha), 0.0005*sx, font, "center", "center",false,false,false,true)
                dxDrawText("Látogass el a #e3721fplázába#ffffff és a #e3721fkisállat kereskedőnél#ffffff válassz egy neked tetsző állatot.\nHa megvetted itt fogod őt/őket megtalálni!", sx*0.505, sy*0.4,_,_, tocolor(255,255,255, alpha), 0.00035*sx, font, "center", "center",false,false,false,true)

            end 

            local pet = 0
            for k,v in pairs(myPets) do 
                pet = pet + 1
                if pet <= maxshow and (pet > scrolvalue) then 
                dxDrawRectangle(sx*0.2975, sy*0.195+ sy*0.04*(pet - scrolvalue - 1),sx*0.195, sy*0.035, tocolor(40, 40, 40, alpha))
                
                if selectedRow == pet then 
                    dxDrawRectangle(sx*0.491, sy*0.195+ sy*0.04*(pet - scrolvalue - 1),sx*0.001, sy*0.035, tocolor(227, 114, 31, 250))
                    dxDrawRectangle(sx*0.2975, sy*0.195+ sy*0.04*(pet - scrolvalue - 1),sx*0.195, sy*0.035, tocolor(227, 114, 31, 50))

                    local name = v[3]
                    local coloredname = v[3]
                    if v[5] <= 0 then 
                        name = v[3].." [HALOTT]"
                        coloredname = v[3].." #6b6b6b[HALOTT]"
                    elseif v[5] < 20 then 
                        name = v[3].." [SÉRÜLT]"
                        coloredname = v[3].." #c92a2a[SÉRÜLT]"
                    end 

                    dxDrawText(name,sx*0.6 - 1, sy*0.2125 + 1,_,_, tocolor(0,0,0, alpha), 0.00055*sx, font, "center", "center",false,false,false,true)
                    dxDrawText(coloredname,sx*0.6, sy*0.2125,_,_, tocolor(255,255,255, alpha), 0.00055*sx, font, "center", "center",false,false,false,true)

                    dxDrawText(getDogCastByID(v[4]),sx*0.6 - 1, sy*0.229 + 1,_,_, tocolor(0, 0, 0, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)
                    dxDrawText(getDogCastByID(v[4]),sx*0.6, sy*0.229,_,_, tocolor(145, 145, 145, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)

                    dxDrawText("Kedvenc étel: "..getDogBestFoodByID(v[9]),sx*0.605 - 1, sy*0.46 + 1,_,_, tocolor(0, 0, 0, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)
                    dxDrawText("Kedvenc étel: "..getDogBestFoodByID(v[9]),sx*0.605, sy*0.46,_,_, tocolor(145, 145, 145, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)


                    dxDrawRectangle(sx*0.53, sy*0.47,sx*0.07,sy*0.02,tocolor(25,25,25,alpha))
                    dxDrawRectangle(sx*0.5318, sy*0.4725,sx*0.0665*v[5]/100,sy*0.0155,tocolor(235, 54, 54,alpha3))

                    dxDrawText("♥",sx*0.5325 - 1, sy*0.48 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "left", "center",false,false,false,true)
                    dxDrawText("♥",sx*0.5325, sy*0.48,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "left", "center",false,false,false,true)
                    dxDrawText(math.floor(v[5]).."%",sx*0.595 - 1, sy*0.48 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)
                    dxDrawText(math.floor(v[5]).."%",sx*0.595, sy*0.48,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)


                    dxDrawRectangle(sx*0.61, sy*0.47,sx*0.07,sy*0.02,tocolor(25,25,25,alpha))
                    dxDrawRectangle(sx*0.6118, sy*0.4725,sx*0.0665*v[7]/100,sy*0.0155,tocolor(35, 124, 219,alpha3))

                    dxDrawImage(sx*0.6075 - 1, sy*0.465 + 1,sx*0.015,sy*0.03,"files/glass.png",0,0,0,tocolor(0,0,0,alpha))
                    dxDrawImage(sx*0.6075, sy*0.465,sx*0.015,sy*0.03,"files/glass.png",0,0,0,tocolor(255,255,255,alpha))
                    dxDrawText(math.floor(v[7]).."%",sx*0.675 - 1, sy*0.48 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)
                    dxDrawText(math.floor(v[7]).."%",sx*0.675, sy*0.48,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)


                    dxDrawRectangle(sx*0.53, sy*0.5,sx*0.15,sy*0.02,tocolor(25,25,25,alpha))
                    dxDrawRectangle(sx*0.5318, sy*0.50225,sx*0.147*v[6]/100,sy*0.0155,tocolor(186, 106, 48,alpha4))
                    dxDrawImage(sx*0.53 - 1, sy*0.498 + 1,sx*0.012,sy*0.025,"files/bone.png",0,0,0,tocolor(0,0,0,alpha))
                    dxDrawImage(sx*0.53, sy*0.498,sx*0.012,sy*0.025,"files/bone.png",0,0,0,tocolor(255,255,255,alpha))

                    dxDrawText(math.floor(v[6]).."%",sx*0.675 - 1, sy*0.51 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)
                    dxDrawText(math.floor(v[6]).."%",sx*0.675, sy*0.51,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)

                    exports.oCore:dxDrawButton(sx*0.55, sy*0.75,sx*0.05,sy*0.025,121, 242, 126,alpha4, "Spawn", tocolor(255, 255, 255, alpha), 0.0003*sx, font, false, tocolor(0, 0, 0, alpha3))
                    exports.oCore:dxDrawButton(sx*0.62, sy*0.75,sx*0.05,sy*0.025,245, 81, 81,alpha4, "Despawn", tocolor(255, 255, 255, alpha), 0.0003*sx, font, false, tocolor(0, 0, 0, alpha3))

                    exports.oCore:dxDrawButton(sx*0.585, sy*0.65,sx*0.05,sy*0.025,245, 81, 81,alpha, "Újraélesztés", tocolor(255, 255, 255, alpha), 0.0003*sx, font, false, tocolor(0, 0, 0, alpha3))
                    dxDrawText("Ennek a műveletnek az ára 250PP",sx*0.61 - 1, sy*0.685 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)
                    dxDrawText("Ennek a műveletnek az ára #6eacf0250PP",sx*0.61, sy*0.685,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)


                    newName = exports.oCore:getEditboxText("petName") or ""
                    textHossz = string.len(newName)

                    dxDrawText(textHossz.."/15",sx*0.678 - 1, sy*0.543 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)
                    dxDrawText(textHossz.."/15",sx*0.678, sy*0.543,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)


                    dxDrawText("Átnevezés",sx*0.556 - 1, sy*0.545 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)
                    dxDrawText("Átnevezés",sx*0.556, sy*0.545,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "right", "center",false,false,false,true)

                    exports.oCore:dxDrawButton(sx*0.65, sy*0.59,sx*0.03,sy*0.025,227, 114, 31,alpha4, "Vásárlás", tocolor(255, 255, 255, alpha), 0.0003*sx, font, false, tocolor(0, 0, 0, alpha3))
                    dxDrawText("Ennek a műveletnek az ára 100PP",sx*0.573 - 1, sy*0.597 + 1,_,_, tocolor(0,0,0, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)
                    dxDrawText("Ennek a műveletnek az ára #6eacf0100PP",sx*0.573, sy*0.597,_,_, tocolor(240,240,240, alpha), 0.0003*sx, font, "center", "center",false,false,false,true)

                    dxDrawImage(sx*0.695 - 1, sy*0.2 + 1,sx*0.0125,sy*0.025,"files/sell.png",0,0,0,tocolor(0,0,0,alpha))
                    dxDrawImage(sx*0.695, sy*0.2,sx*0.0125,sy*0.025,"files/sell.png",0,0,0,tocolor(255,255,255,alpha))


                end

                dxDrawText("#"..v[1],sx*0.299 - 1, sy*0.2125+ sy*0.04*(pet - scrolvalue - 1) + 1,_,_, tocolor(0, 0, 0, alpha), 0.0005*sx, font, "left", "center",false,false,false,true)
                dxDrawText("#ffffff##e3721f"..v[1],sx*0.299, sy*0.2125+ sy*0.04*(pet - scrolvalue - 1),_,_, tocolor(0, 0, 0, alpha), 0.0005*sx, font, "left", "center",false,false,false,true)

                dxDrawText(v[3],sx*0.485 - 1, sy*0.2125+ sy*0.04*(pet - scrolvalue - 1) + 1,_,_, tocolor(0,0,0, alpha), 0.0005*sx, font, "right", "center",false,false,false,true)
                dxDrawText(v[3],sx*0.485, sy*0.2125+ sy*0.04*(pet - scrolvalue - 1),_,_, tocolor(255,255,255, alpha), 0.0005*sx, font, "right", "center",false,false,false,true)


                end 
            end 

        else 
        
            core:drawWindow(sx*0.4, sy*0.45, sx*0.2, sy*0.15, "Állat eladás", alpha2)
            dxDrawRectangle(sx*0.4035, sy*0.48, sx*0.1925, sy*0.03, tocolor(27, 27, 27, (alpha-55)))
            dxDrawRectangle(sx*0.4035, sy*0.515, sx*0.1925, sy*0.03, tocolor(27, 27, 27, (alpha-55)))



            core:dxDrawButton(sx*0.407, sy*0.56, sx*0.09, sy*0.03, 76, 173, 88, alpha4, "Eladás", tocolor(255, 255, 255, alpha), 0.0004*sx, font, true, tocolor(0, 0, 0, alpha3))
            core:dxDrawButton(sx*0.5025, sy*0.56, sx*0.09, sy*0.03, 189, 49, 49, alpha4, "Mégsem", tocolor(255, 255, 255, alpha), 0.0004*sx, font, true, tocolor(0, 0, 0, alpha3))
        end 

    end 


end 

-- vásárló
local trader;
local dogPrice;
local dogState;
local dogName;
local dogID;
local dogModelID;

function renderBuyPanel()
    if not menuState == false then
        alpha,alpha2 = interpolateBetween(alpha, 0, 0, 255, 150, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
    else 
        alpha,alpha2 = interpolateBetween(255, 150, 0, 0, 0, 0, (getTickCount() - menuAnimationTick)/1000, "InOutQuad")
    end

    core:drawWindow(sx*0.4, sy*0.45, sx*0.2, sy*0.15, "Állat vétel", 1)
    dxDrawText(getPlayerName(trader).." el akar adni neked egy állatot!!\nFajtája: "..getDogCastByID(dogModelID).."\nÁra: "..dogPrice.."$",sx*0.5 - 1, sy*0.51 + 1,_,_, tocolor(0,0,0, 255), 0.00035*sx, font, "center", "center",false,false,false,true)
    dxDrawText(getPlayerName(trader).." el akar adni neked egy állatot!!\nFajtája: "..getDogCastByID(dogModelID).."\nÁra: #7cc576"..dogPrice.."$",sx*0.5, sy*0.51,_,_, tocolor(240,240,240, 255), 0.00035*sx, font, "center", "center",false,false,false,true)

    core:dxDrawButton(sx*0.407, sy*0.56, sx*0.09, sy*0.03, 76, 173, 88, 150, "Elfogadás", tocolor(255, 255, 255, 255), 0.0004*sx, font, true, tocolor(0, 0, 0, 100))
    core:dxDrawButton(sx*0.5025, sy*0.56, sx*0.09, sy*0.03, 189, 49, 49, 150, "Mégsem", tocolor(255, 255, 255, 255), 0.0004*sx, font, true, tocolor(0, 0, 0, 100))
end 

local buyPanel = false

local BuyerCount = 0
function makeBuy(player, price, id,modelID)
    addEventHandler("onClientRender",root,renderBuyPanel)
    for k,v in pairs(myPets) do 
        BuyerCount = BuyerCount + 1 
    end 

    if inPanel then 
        removeEventHandler("onClientRender",root,renderPanel)
    end 

    trader = player
    dogPrice = price 
    dogID = id 
    dogModelID = modelID
    buyPanel = true

    checkTimer = setTimer(function()
        if exports.oCore:getDistance(localPlayer, trader) > 7 then 
            dismissTrade()
            exports.oInfobox:outputInfoBox("Túl messzire mentél a kiválasztott játékostól így a vásárlás megszakadt!","error")
        end
    end, 150, 0)
end 
addEvent("makeBuy",true)
addEventHandler("makeBuy",root,makeBuy)

function dismissTrade()
    removeEventHandler("onClientRender",root,renderBuyPanel)
    triggerServerEvent("dismissBuyPanel",resourceRoot,trader)

    trader = nil
    dogPrice = nil 
    dogID = nil 
    dogModelID = nil
    buyPanel = false

    killTimer(checkTimer)
end 



function acceptTrade()
    if getElementData(localPlayer,"char:maxPets") <= BuyerCount then return exports.oInfobox:outputInfoBox("Nincs elegendő slotod a vásárláshoz!","error") end
    if getElementData(localPlayer,"char:money") < tonumber(dogPrice) then return exports.oInfobox:outputInfoBox("Nincs nálad elég pénz a vásárláshoz ("..tonumber(dogPrice).."$)","error") end

    removeEventHandler("onClientRender",root,renderBuyPanel)
    triggerServerEvent("succesTrade",resourceRoot,trader,localPlayer,dogID,dogPrice)
    trader = nil
    dogPrice = nil 
    dogID = nil 
    dogModelID = nil
    buyPanel = false
    killTimer(checkTimer)

    setTimer(function()
        BuyerCount = 0
    end,150,1)
end 

--

local firstClick = true
local petID;
local buySpam = false


function panelClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if inPanel then 
        if button == "left" and state == "down" then 
            local petClick = 0
            for k,v in pairs(myPets) do 
                petClick = petClick + 1
                if petClick <= maxshow and (petClick > scrolvalue) then 
                    if isInSlot(sx*0.2975, sy*0.195+ sy*0.04*(petClick - scrolvalue - 1),sx*0.195, sy*0.035) then 

                        selectedRow = petClick
                        click = true
                        petID = v[1]

                        triggerServerEvent("syncMyPets",resourceRoot,localPlayer)

                            if firstClick then 
                                ped = createPed(v[4],0,0,0)
                                priew = exports.oPreview:createObjectPreview(ped,0,0,120,sx*0.528,sy*0.11,sx*0.15,sy*0.3,false,true)
                                editBox = exports.oCore:createEditbox(sx*0.53, sy*0.55,sx*0.15,sy*0.04, "petName", "Kedvenced Új Neve", "text", true, {20, 20, 20, 255}, 0.3,15)

                                firstClick = false 
                            else 
                                setElementModel(ped,v[4])
                            end 
                    end 
                end
            end 

            if isInSlot(sx*0.65, sy*0.59,sx*0.03,sy*0.025) then 
                newName = exports.oCore:getEditboxText("petName")
                textHossz = string.len(newName)

                if getElementData(localPlayer,"char:pp") < 100 then return exports.oInfobox:outputInfoBox("Nincs elegendő ppd! (100PP)","error") end

                if textHossz > 2 then 
                    if not buySpam then 
                        myPets[petID][3] = newName
                        triggerServerEvent("changePetName",resourceRoot,petID,newName)
                        triggerServerEvent("takePetPP",resourceRoot,localPlayer,100)
                        exports.oCore:setEditboxText("petName","")
                        buySpam = true 

                        setTimer(function()
                            buySpam = false
                        end,500,1)
                    end 
                else 
                    exports.oInfobox:outputInfoBox("Túl rövid a név! (Minimum 2 karakter)","error")

                end 
            elseif isInSlot(sx*0.55, sy*0.75,sx*0.05,sy*0.025) then 
                if not getElementData(localPlayer,"hasSummonedPet") then 
                    if not buySpam then 
                        triggerServerEvent("summonPet",localPlayer,localPlayer,petID)
                        makePetSound(petID)


                        setTimer(function()
                            local animalElement = getElementData(localPlayer,"char:avaliblePet")
                            if isElement(animalElement) then
                                local currentTask = getElementData(animalElement, "ped.task.1")
                                if not currentTask then
                                    setPedTask(animalElement, {"walkFollowElement", localPlayer, 3})
                                    exports.oInfobox:outputInfoBox("Sikeresen lehívtad az állatod,részletek a chatboxban!","success")
                                    outputChatBox("#e3721f[Kisállat]#ffffff Sikeresen lehívtad a peted, további funkciókat rá kattintva érhetsz el!",255,255,255,true)
                                end
                            end
                        end,1000,1)

                        buySpam = true 

                        setTimer(function()
                            buySpam = false
                        end,500,1)
                    end 
                end 
            elseif isInSlot(sx*0.62, sy*0.75,sx*0.05,sy*0.025) then 
                if getElementData(localPlayer,"hasSummonedPet") then 
                    if not buySpam then 

                        triggerServerEvent("desummonPet",localPlayer,localPlayer,petID)
                        exports.oInfobox:outputInfoBox("Sikeresen visszahívtad az állatod!","success")

                        buySpam = true 

                        setTimer(function()
                            buySpam = false
                        end,500,1)
                    end 
                end 
            elseif isInSlot(sx*0.585, sy*0.65,sx*0.05,sy*0.025) then 
                if myPets[petID][5] > 0 then return exports.oInfobox:outputInfoBox("Ez az állat nem halott!!","error") end
                if getElementData(localPlayer,"char:pp") < 250 then return exports.oInfobox:outputInfoBox("Nincs elegendő ppd! (250PP)","error") end

                    if not buySpam then 
                        myPets[petID][5] = 100
                        triggerServerEvent("reHealPet",resourceRoot,localPlayer,petID)
                        triggerServerEvent("takePetPP",resourceRoot,localPlayer,250)
                        buySpam = true 

                        setTimer(function()
                            buySpam = false
                        end,500,1)
                    end 
                
            elseif isInSlot(sx*0.695, sy*0.2,sx*0.0125,sy*0.025) then 
                sellPanel = true 
                selectedRow = nil
                exports.oPreview:destroyObjectPreview(priew)
                exports.oCore:deleteEditbox("petName")

                if ped then destroyElement(ped) end

                playerEditBox = exports.oCore:createEditbox(sx*0.4035, sy*0.48, sx*0.1925, sy*0.03, "playerName", "Játékos ID-je:", "text", true, {35, 35, 35, 200}, 0.3,30)
                priceEditBox = exports.oCore:createEditbox(sx*0.4035, sy*0.515, sx*0.1925, sy*0.03, "price", "Ára:", "text", true, {35, 35, 35, 200}, 0.3,15)
            elseif isInSlot(sx*0.5025, sy*0.56, sx*0.09, sy*0.03) then 
                if sellPanel then 
                    sellPanel = false 
                    exports.oCore:deleteEditbox("playerName")
                    exports.oCore:deleteEditbox("price")
                    firstClick = true
                end 
            elseif isInSlot(sx*0.407, sy*0.56, sx*0.09, sy*0.03) then 
                if sellPanel then 
                    local target = false
                    player = exports.oCore:getEditboxText("playerName")
                    price = exports.oCore:getEditboxText("price")
                    target = core:getPlayerFromPartialName(localPlayer, tonumber(player))    
                    local px,py,pz = getElementPosition(localPlayer)
                    local tx,ty,tz = getElementPosition(target)

                    if not tonumber(player) then return exports.oInfobox:outputInfoBox("Csak szám adható meg ID-nek.","error") end
                    if not tonumber(price) then return exports.oInfobox:outputInfoBox("Csak szám adható meg árnak.","error") end
                    if target == localPlayer then return exports.oInfobox:outputInfoBox("Magadnak nem adhatod el!","error") end
                    if exports.oCore:getDistance(localPlayer, target) > 7 then return exports.oInfobox:outputInfoBox("Túl messze vagy a kiválasztott játékostól!","error") end
                    exports.oInfobox:outputInfoBox("Sikeresen elküldted "..getPlayerName(target).."-nak/nek az ajánlatod!","success")
                    triggerServerEvent("sellPetPanel",resourceRoot,target,price,myPets[petID][3],petID)
                    closePanel()
                end 
            elseif isInSlot(sx*0.2975, sy*0.75,sx*0.07, sy*0.035) then 
                    if getElementData(localPlayer,"char:pp") < 100 then return exports.oInfobox:outputInfoBox("Nincs elegendő ppd! (100PP)","error") end
                    triggerServerEvent("takePetPP",resourceRoot,localPlayer,100)
                    setElementData(localPlayer,"char:maxPets",getElementData(localPlayer,"char:maxPets") + 1)
                    maxPet = getElementData(localPlayer,"char:maxPets")
                    exports.oInfobox:outputInfoBox("Sikeres pet slot bővítés, részletek a chatboxban!","success")

                    outputChatBox("#e3721f[Kisállat - Slot]#ffffff Sikeresen vásároltál egy kisállat slotot, jelenlegi slotjaid száma #e3721f("..maxPet..")",255,255,255,true)
            end 



        end 
    elseif buyPanel then 
        if button == "left" and state == "down" then 
            if isInSlot(sx*0.5025, sy*0.56, sx*0.09, sy*0.03) then 
                dismissTrade()
            elseif isInSlot(sx*0.407, sy*0.56, sx*0.09, sy*0.03) then
                acceptTrade()
            end 
        end
    end 
end
addEventHandler ( "onClientClick", root, panelClick )

function start()
    setElementData(root,"hasSummonedPet",false)
    triggerServerEvent("syncMyPets",resourceRoot,localPlayer)
end 
addEventHandler("onClientResourceStart",resourceRoot,start)

function stop()
    exports.oCore:deleteEditbox("petName")
    exports.oCore:deleteEditbox("playerName")
    exports.oCore:deleteEditbox("price")

end 
addEventHandler("onClientResourceStop",resourceRoot,stop)

function getMyPets(id,owner,name,type,health,hunger,thirsty,summoned,bestFood)
    myPets[id] = {id,owner,name,type,health,hunger,thirsty,summoned,bestFood}
end 
addEvent("getMyPets", true) 
addEventHandler("getMyPets", root, getMyPets)

function openPanel()
    if getElementData(localPlayer,"user:loggedin") then 
    if inPanel then return closePanel() end 
    if getPedOccupiedVehicle(localPlayer) then return end

        setTimer(function()
            countPets()
        end,100,1)
        triggerServerEvent("syncMyPets",resourceRoot,localPlayer)
        menuState = true 
        menuAnimationTick = getTickCount()
        addEventHandler("onClientRender",root,renderPanel)
        bindKey("backspace","down",closePanel)
        exports.oInterface:toggleHud(true)
        showChat(false)
        inPanel = true
        maxPet = getElementData(localPlayer,"char:maxPets")

        loadingTimer = setTimer(function()
            loadingActive = false
        end,2000,1)
    end 
end 

function closePanel()

    menuState = false 
    menuAnimationTick = getTickCount()
    if priew then exports.oPreview:destroyObjectPreview(priew) end
    exports.oCore:deleteEditbox("petName")
    if ped then destroyElement(ped) end

    setTimer(function()
        unbindKey("backspace","down",closePanel)
        removeEventHandler("onClientRender",root,renderPanel)
        exports.oInterface:toggleHud(false)
        showChat(true)
        selectedRow = nil
        inPanel = false
        firstClick = true
        count = 0

        if sellPanel then 
            sellPanel = false 
            exports.oCore:deleteEditbox("playerName")
            exports.oCore:deleteEditbox("price")
            firstClick = true
        end 

        if loadingActive then killTimer(loadingTimer) end 
        loadingActive = true
        loadingCounter = 0
    end,1000,1)

end 

bindKey("F4","down",openPanel)

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end
end

addEventHandler("onClientKey", getRootElement(), function(button, press)
  if press and inPanel then
    if isCursorShowing() then
        if button == "mouse_wheel_up" then
          if scrolvaule > 0  then
            scrolvaule = scrolvaule -1
            maxshow = maxshow -1
          end
        elseif button == "mouse_wheel_down" then
          if maxshow < #count then
            scrolvaule = scrolvaule +1
            maxshow = maxshow +1
          end
        end
      end
  end
end)

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function fixClientTable(id)
    myPets[id] = nil
end 
addEvent("fixTable",true)
addEventHandler("fixTable",root,fixClientTable)

function countPets()
    for k,v in pairs(myPets) do 
        count = count + 1
    end 
    setElementData(localPlayer,"ownedPet",count)
end

function setPetIdleClient(pet,value,player)
    triggerServerEvent("setDogIdle",player,pet,value,player)
end 
--shoppanel 

local shopPed = createPed(73,shopX,shopY,shopZ,sRot)
setElementData(shopPed, "ped:prefix","Állatkereskedő")
setElementData(shopPed,"ped:name","Jack Anders")

local dogs = {{269,6000},{270,6000},{271,6000},{300,6000},{311,6000},{293,6000},{1,6000}}

local maxshow2 = 13 
local scrolvalue2 = 0

local shopPanel = false
local selectedRow2 = 1



function renderShopPanel()

    
    if menuState2 then
        Shopalpha,Shopalpha2,Shopalpha3 = interpolateBetween(0, 0, 0, 255, 1, 100, (getTickCount() - menuAnimationTick2)/1000, "InOutQuad")
        Shopalpha4,Shopalpha5 = interpolateBetween(0, 0, 0, 150, 200, 0, (getTickCount() - menuAnimationTick2)/1000, "InOutQuad")

    else 
        Shopalpha,Shopalpha2,Shopalpha3 = interpolateBetween(255, 1, 100, 0, 0, 0, (getTickCount() - menuAnimationTick2)/1000, "InOutQuad")
        Shopalpha4,Shopalpha5 = interpolateBetween(150, 200, 0, 0, 0, 0, (getTickCount() - menuAnimationTick2)/1000, "InOutQuad")
    end

    core:drawWindow(sx*0.31, sy*0.3,sx*0.35, sy*0.33, "Állatkereskedés", Shopalpha2)
    dxDrawRectangle(sx*0.315, sy*0.33,sx*0.2, sy*0.287,tocolor(25,25,25,Shopalpha))

    local shopPet = 0
    local drawCount = 0
    for k,v in pairs(dogs) do 
        shopPet = shopPet + 1
        drawCount = shopPet/2
        if shopPet <= maxshow2 and (shopPet > scrolvalue2) then 
           -- dxDrawRectangle(sx*0.3175, sy*0.335 + sy*0.08*((shopPet/2) - scrolvalue2 - 1),sx*0.195, sy*0.035, tocolor(40, 40, 40, Shopalpha5))

            dxDrawRectangle(sx*0.3175, sy*0.335 + sy*0.04*(shopPet - scrolvalue2 - 1),sx*0.195, sy*0.035, tocolor(40, 40, 40, Shopalpha))

            dxDrawText(getDogCastByID(v[1]),sx*0.32 - 1, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1) + 1,_,_, tocolor(0,0,0, Shopalpha), 0.00055*sx, font, "left", "center",false,false,false,true)
            dxDrawText(getDogCastByID(v[1]),sx*0.32, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1),_,_, tocolor(255,255,255, Shopalpha), 0.00055*sx, font, "left", "center",false,false,false,true)

            dxDrawText(v[2].."PP",sx*0.51 - 1, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1) + 1,_,_, tocolor(0, 0, 0, Shopalpha), 0.00055*sx, font, "right", "center",false,false,false,true)
            dxDrawText(v[2].."PP",sx*0.51, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1),_,_, tocolor(110, 172, 240, Shopalpha), 0.00055*sx, font, "right", "center",false,false,false,true)

            if selectedRow2 == shopPet then 
                dxDrawRectangle(sx*0.3175, sy*0.335 + sy*0.04*(shopPet - scrolvalue2 - 1),sx*0.195, sy*0.035, tocolor(227, 114, 31, Shopalpha3))
                dxDrawRectangle(sx*0.512, sy*0.335 + sy*0.04*(shopPet - scrolvalue2 - 1),sx*0.001, sy*0.035, tocolor(227, 114, 31, Shopalpha))
                dxDrawText(getDogCastByID(v[1]),sx*0.32 - 1, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1) + 1,_,_, tocolor(0,0,0, Shopalpha), 0.00055*sx, font, "left", "center",false,false,false,true)
                dxDrawText(getDogCastByID(v[1]),sx*0.32, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1),_,_, tocolor(255,255,255, Shopalpha), 0.00055*sx, font, "left", "center",false,false,false,true)
    
                dxDrawText(v[2].."PP",sx*0.51 - 1, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1) + 1,_,_, tocolor(0, 0, 0, Shopalpha), 0.00055*sx, font, "right", "center",false,false,false,true)
                dxDrawText(v[2].."PP",sx*0.51, sy*0.352 + sy*0.0405*(shopPet - scrolvalue2 - 1),_,_, tocolor(110, 172, 240, Shopalpha), 0.00055*sx, font, "right", "center",false,false,false,true)

                exports.oCore:dxDrawButton(sx*0.53,sy*0.57,sx*0.11,sy*0.02,121, 242, 126,Shopalpha4, "Vásárlás", tocolor(255, 255, 255, Shopalpha), 0.0003*sx, font, false, tocolor(0, 0, 0, 100))
                exports.oCore:dxDrawButton(sx*0.53,sy*0.596,sx*0.11,sy*0.02,189, 49, 49, Shopalpha4, "Kilépés", tocolor(255, 255, 255, Shopalpha), 0.0003*sx, font, false, tocolor(0, 0, 0, 100))

            end

        end 
    end 
end 

function openShopPanel()
    menuState2 = true
    menuAnimationTick2 = getTickCount()

    addEventHandler("onClientRender",root,renderShopPanel)
    countPets()
    shopPanel = true  

    setTimer(function()
    customShopPet = createPed(dogs[selectedRow2][1],0,0,0)
    shopPW = exports.oPreview:createObjectPreview(customShopPet,0,0,120,sx*0.51,sy*0.21,sx*0.15,sy*0.3,false,true)
    shopName = exports.oCore:createEditbox(sx*0.53,sy*0.525,sx*0.11,sy*0.04, "shopName", "Add meg a nevét", "text", true, {20, 20, 20, 255}, 0.3,15)
    end,1000,1)

    dist = setTimer(function()
        x,y,z = shopX,shopY,shopZ
        px,py,pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)

        if distance >= 5 then 
            closeShopPanel()
        end 
    end,500,0)
end 

function closeShopPanel()
    menuState2 = false
    menuAnimationTick2 = getTickCount()
    exports.oPreview:destroyObjectPreview(shopPW)
    exports.oCore:deleteEditbox("shopName")
    if customShopPet then destroyElement(customShopPet) end
    killTimer(dist)
    setTimer(function()
        removeEventHandler("onClientRender",root,renderShopPanel)
        shopPanel = false 
        selectedRow2 = 1
    end,1000,1)
end 

function panelClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if clickedElement == shopPed then 
        if not shopPanel then openShopPanel() end
    end 

    if shopPanel then 
        if button == "left" and state == "down" then 
            local shopPet = 0
            for k,v in pairs(dogs) do 
                shopPet = shopPet + 1
                if shopPet <= maxshow2 and (shopPet > scrolvalue2) then 
                    if isInSlot(sx*0.3175, sy*0.335 + sy*0.04*(shopPet - scrolvalue2 - 1),sx*0.195, sy*0.035) then 
                        selectedRow2 = shopPet
                        setElementModel(customShopPet,dogs[selectedRow2][1])
                    end 
                end 
            end 

            if isInSlot(sx*0.53,sy*0.57,sx*0.11,sy*0.02) then 
                local pp = getElementData(localPlayer,"char:pp") 
                local petName = exports.oCore:getEditboxText("shopName")

                local badWords = {{"fasz"},{"Fasz"},{"FASZ"},{"geci"},{"Geci"},{"GECI"},{"asd"},{"Asd"},{"ASD"},{"pöcs"},{"Pöcs"},{"PÖCS"},{"noki"},{"Noki"},{"NOKI"},{"szar"},{"Szar"},{"SZAR"},{"pina"},{"Pina"},{"PINA"},{"szerver"},{"Szerver"},{"SZERVER"},{"punci"},{"Punci"},{"PUNCI"},{"paul"},{"Paul"},{"PAUL"},{"carlos"},{"Carlos"},{"CARLOS"},{"áron"},{"Áron"},{"ÁRON"},{"kondor"},{"Kondor"},{"KONDOR"},{"dominik"},{"Dominik"},{"DOMINIK"}}

                for k,v in pairs(badWords) do
                    if string.find(petName,badWords[k][1]) then 
                        exports.oInfobox:outputInfoBox("Ezt a nevet gondold át mégegyszer!","error")
                        return
                    end 
                end 
                --if string.find(petName,"fasz") or string.find(petName,"geci") or string.find(petName,"asd") or string.find(petName,"Fasz") or string.find(petName,"pöcs") or string.find(petName,"noki") or string.find(petName,"szar") or string.find(petName,"Geci") or string.find(petName,"Asd") or string.find(petName,"Noki") or string.find(petName,"pina") or string.find(petName,"Pina") then return exports.oInfobox:outputInfoBox("Ezt a nevet gondold át mégegyszer!","error") end
                if pp < dogs[selectedRow2][2] then return exports.oInfobox:outputInfoBox("Nincs elég prémiumpontod a vásárláshoz! ("..dogs[selectedRow2][2].."PP)","error") end 
                if petName == "" then return exports.oInfobox:outputInfoBox("Valahogyan el kell nevezned az állatod vásárlás előtt!","error") end  
                if getElementData(localPlayer,"char:maxPets") <= getElementData(localPlayer,"ownedPet") then return exports.oInfobox:outputInfoBox("Nincs elegendő slotod a vásárláshoz!","error") end

                triggerServerEvent("takePetPP",localPlayer,localPlayer,dogs[selectedRow2][2])
                outputChatBox("#e3721f[Kisállatkereskedés]#ffffff Sikeresen vásároltál egy állatot #6eacf0"..dogs[selectedRow2][2].."#ffffff PP ért!",255,255,255,true)
                outputChatBox("#e3721f[Kisállatkereskedés]#ffffff Érdemes erről a chatboxról egy printscreent csinálnod ha későbbiekben valamiért bizonyítanod kell a vásárlást!",255,255,255,true)
                triggerServerEvent("makePet",localPlayer,getElementData(localPlayer,"user:id"),petName,dogs[selectedRow2][1])
                exports.oInfobox:outputInfoBox("Sikeres vásárlás, részletek a chatboxban!","success")
                closeShopPanel()
            elseif isInSlot(sx*0.53,sy*0.596,sx*0.11,sy*0.02) then 
                closeShopPanel()
            end 
        end 
    end 
end
addEventHandler ( "onClientClick", root, panelClick )

-- rehealpets

local maxshow3 = 6 
local scrolvalue3 = 0

local healPanel = false
local minigameActive = false
local healPets = {}

function renderHealPanel()
    if not minigameActive then     
        if menuState3 then
            healeralpha,healeralpha2,healeralpha3 = interpolateBetween(0, 0, 0, 255, 1, 150, (getTickCount() - menuAnimationTick3)/1000, "InOutQuad")
    
        else 
            healeralpha,healeralpha2,healeralpha3 = interpolateBetween(255, 1, 150, 0, 0, 0, (getTickCount() - menuAnimationTick3)/1000, "InOutQuad")
        end

        core:drawWindow(sx*0.38, sy*0.28,sx*0.21, sy*0.361, "Állatorvos", healeralpha2)
        dxDrawRectangle(sx*0.385, sy*0.308,sx*0.2, sy*0.287,tocolor(25,25,25,healeralpha))

        local healPet = 0
        for k,v in pairs(healPets) do 
            healPet = healPet + 1
            if healPet <= maxshow3 and (healPet > scrolvalue3) then 
                if v[5] <= 0 then 
                    dxDrawRectangle(sx*0.3875, sy*0.315 + sy*0.04*(healPet - scrolvalue3 - 1),sx*0.195, sy*0.035, tocolor(40, 40, 40, healeralpha))
                    dxDrawText(v[3].." [HALOTT]",sx*0.39 - 1, sy*0.3325 + sy*0.04*(healPet - scrolvalue3 - 1) + 1,_,_, tocolor(0,0,0, healeralpha), 0.00055*sx, font, "left", "center",false,false,false,true)
                    dxDrawText(v[3].." #6b6b6b[HALOTT]",sx*0.39, sy*0.3325 + sy*0.04*(healPet - scrolvalue3 - 1),_,_, tocolor(255,255,255, healeralpha), 0.00055*sx, font, "left", "center",false,false,false,true)
                    exports.oCore:dxDrawButton(sx*0.53,sy*0.3225 + sy*0.04*(healPet - scrolvalue3 - 1),sx*0.05,sy*0.02,121, 242, 126,healeralpha3, "Vásárlás", tocolor(255, 255, 255, healeralpha), 0.0003*sx, font, false, tocolor(0, 0, 0, 100))

                end
            end 
        end 
        dxDrawText("A vásárlás elindít egy minigamet, a játék\nsikerének megfelelően történik az újraélesztés.\nAz újraélesztés ára 60000$!",sx*0.3875 - 1, sy*0.616 + 1,_,_, tocolor(0,0,0, healeralpha), 0.0003*sx, font, "left", "center",false,false,false,true)
        dxDrawText("A vásárlás elindít egy #e3721fminigamet#ffffff, a játék\nsikerének megfelelően történik az újraélesztés.\nAz újraélesztés ára #79f27e60000$!",sx*0.3875, sy*0.616,_,_, tocolor(255,255,255, healeralpha), 0.0003*sx, font, "left", "center",false,false,false,true)

        exports.oCore:dxDrawButton(sx*0.535,sy*0.615,sx*0.05,sy*0.02,189, 49, 49, healeralpha3, "Kilépés", tocolor(255, 255, 255, healeralpha), 0.0003*sx, font, false, tocolor(0, 0, 0, 100))
    end 
end 

local healer;

function openHealPanel()

    for k,v in pairs(myPets) do 
        if v[5] <= 0 then 
            healPets[v[1]] = {v[1],v[2],v[3],v[4],v[5],v[6],v[7]}
        end
    end 
    menuAnimationTick3 = getTickCount()
    menuState3 = true

    triggerServerEvent("syncMyPets",resourceRoot,localPlayer)

    addEventHandler("onClientRender",root,renderHealPanel)
    healPanel = true

    dist = setTimer(function()
        x,y,z = getElementPosition(healer)
        px,py,pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)

        if distance >= 5 then 
            closeHealPanel()
        end 
    end,500,0)
end 

function getHealer()
    for k,v in pairs(getElementsByType("ped")) do 
        if getElementData(v,"rehealPed") then 
            healer = v
        end 
    end 
end 
addEventHandler("onClientResourceStart",resourceRoot,getHealer)

function closeHealPanel()
    menuAnimationTick3 = getTickCount()
    menuState3 = false

    setTimer(function()
        removeEventHandler("onClientRender",root,renderHealPanel)
        healPanel = false
        unbindKey("backspace","down",closeHealPanel)

        for k,v in pairs(healPets) do 
            healPets[v[1]] = nil 
        end 

        killTimer(dist)
    end,1000,1)
end 

function HealpanelClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if (clickedElement) then 
        if button == "right" and state == "down" then 
            if getElementData(clickedElement,"rehealPed") then 
                if not healPanel then openHealPanel() end 
                bindKey("backspace","down",closeHealPanel)
            end 
        end
    end 

    if healPanel and not minigameActive then 
        if button == "left" and state == "down" then 
            local healPet = 0
            for k,v in pairs(healPets) do 
                healPet = healPet + 1
                if healPet <= maxshow3 and (healPet > scrolvalue3) then 
                    if v[5] <= 0 then 
                        if isInSlot(sx*0.53,sy*0.3225 + sy*0.04*(healPet - scrolvalue3 - 1),sx*0.05,sy*0.02) then 
                            price = 60000
                            if getElementData(localPlayer,"char:money") < price then return exports.oInfobox:outputInfoBox("Nincs nálad elég pénz! ("..price.."$)","error") end

                                petID = v[1]
                                createMinigame(1, 8, 18000,"successMinigame","unsuccessMinigame",petID,price)
                                minigameActive = true 

                        end 
                    end 
                end 
            end 

            if isInSlot(sx*0.535,sy*0.615,sx*0.05,sy*0.02) then 
                closeHealPanel()
            end
        end 
    end 
end
addEventHandler ( "onClientClick", root, HealpanelClick )

function makePetSound(petID)
    local type = getAnimalType(myPets[petID][4])

    if type == "Kutya" then 
        playSound("files/wuff.mp3",false)
    elseif type == "Disznó" then 
        playSound("files/pig.mp3",false)
    end 
end 


-- functions 
function dxDrawRing (posX, posY, radius, width, startAngle, amount, color, postGUI, absoluteAmount, anglesPerLine)
	if (type (posX) ~= "number") or (type (posY) ~= "number") or (type (startAngle) ~= "number") or (type (amount) ~= "number") then
		return false
	end
	
	if absoluteAmount then
		stopAngle = amount + startAngle
	else
		stopAngle = (amount * 360) + startAngle
	end
	
	anglesPerLine = type (anglesPerLine) == "number" and anglesPerLine or 1
	radius = type (radius) == "number" and radius or 50
	width = type (width) == "number" and width or 5
	color = color or tocolor (255, 255, 255, 255)
	postGUI = type (postGUI) == "boolean" and postGUI or false
	absoluteAmount = type (absoluteAmount) == "boolean" and absoluteAmount or false
	
	for i = startAngle, stopAngle, anglesPerLine do
		local startX = math.cos (math.rad (i)) * (radius - width)
		local startY = math.sin (math.rad (i)) * (radius - width)
		local endX = math.cos (math.rad (i)) * (radius + width)
		local endY = math.sin (math.rad (i)) * (radius + width)
		dxDrawLine (startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI)
	end
	return math.floor ((stopAngle - startAngle)/anglesPerLine)
end

addEventHandler("onClientResourceStart",getResourceRootElement(),
	function ()
		addEventHandler("onClientPreRender",root,cycleNPCs)
	end,
true, "high+999999")


function stopAllNPCActions(npc)
	stopNPCWalkingActions(npc)
	stopNPCWeaponActions(npc)

	setPedControlState(npc,"vehicle_fire",false)
	setPedControlState(npc,"vehicle_secondary_fire",false)
	setPedControlState(npc,"steer_forward",false)
	setPedControlState(npc,"steer_back",false)
	setPedControlState(npc,"horn",false)
	setPedControlState(npc,"handbrake",false)
end

function stopNPCWalkingActions(npc)
	setPedControlState(npc,"forwards",false)
	setPedControlState(npc,"sprint",false)
	setPedControlState(npc,"walk",false)
end

function stopNPCWeaponActions(npc)
	setPedControlState(npc,"aim_weapon",false)
	setPedControlState(npc,"fire",false)
end

function makeNPCWalkToPos(npc,x,y)
	local px,py = getElementPosition(npc)
	setPedCameraRotation(npc,math.deg(math.atan2(x-px,y-py)))
	setPedControlState(npc,"forwards",true)
	local speed = getNPCWalkSpeed(npc)
	setPedControlState(npc,"walk",speed == "walk")
	setPedControlState(npc,"sprint",
		speed == "sprint" or
		speed == "sprintfast" and not getPedControlState(npc,"sprint")
	)
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
	local x,y,z = getElementPosition(npc)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty = p1*x1+p2*x2,p1*y1+p2*y2
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/math.pi*2+off/len
	local destx,desty = getPosFromBend(p2*math.pi*0.5,x0,y0,x1,y1,x2,y2)
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCShootAtPos(npc,x,y,z)
	local sx,sy,sz = getElementPosition(npc)
	x,y,z = x-sx,y-sy,z-sz
	local yx,yy,yz = 0,0,1
	local xx,xy,xz = yy*z-yz*y,yz*x-yx*z,yx*y-yy*x
	yx,yy,yz = y*xz-z*xy,z*xx-x*xz,x*xy-y*xx
	local inacc = 1-(getNPCWeaponAccuracy(npc) or 0.5)
	local ticks = getTickCount()
	local xmult = inacc*math.sin(ticks*0.01 )*1000/math.sqrt(xx*xx+xy*xy+xz*xz)
	local ymult = inacc*math.cos(ticks*0.011)*1000/math.sqrt(yx*yx+yy*yy+yz*yz)
	local mult = 1000/math.sqrt(x*x+y*y+z*z)
	xx,xy,xz = xx*xmult,xy*xmult,xz*xmult
	yx,yy,yz = yx*ymult,yy*ymult,yz*ymult
	x,y,z = x*mult,y*mult,z*mult
	
	setPedAimTarget(npc,sx+xx+yx+x,sy+xy+yy+y,sz+xz+yz+z)
	if isPedInVehicle(npc) then
		setPedControlState(npc,"vehicle_fire",not getPedControlState(npc,"vehicle_fire"))
	else
		setPedControlState(npc,"aim_weapon",true)
		setPedControlState(npc,"fire",not getPedControlState(npc,"fire"))
	end
end

function makeNPCShootAtElement(npc,target)
	local x,y,z = getElementPosition(target)
	local vx,vy,vz = getElementVelocity(target)
	local tgtype = getElementType(target)
	if tgtype == "ped" or tgtype == "player" then
		x,y,z = getPedBonePosition(target,3)
		local vehicle = getPedOccupiedVehicle(target)
		if vehicle then
			vx,vy,vz = getElementVelocity(vehicle)
		end
	end
	vx,vy,vz = vx*6,vy*6,vz*6
	makeNPCShootAtPos(npc,x+vx,y+vy,z+vz)
end

performTask = {}

function performTask.walkToPos(npc,task)
	if isPedInVehicle(npc) then return true end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y = getElementPosition(npc)
	local distx,disty = destx-x,desty-y
	local dist = distx*distx+disty*disty
	local dest_dist = task[5]
	if dist < dest_dist*dest_dist then return true end
	makeNPCWalkToPos(npc,destx,desty)
end

function performTask.walkAlongLine(npc,task)
	if isPedInVehicle(npc) then return true end
	local x1,y1,z1,x2,y2,z2 = task[2],task[3],task[4],task[5],task[6],task[7]
	local off,enddist = task[8],task[9]
	local x,y,z = getElementPosition(npc)
	local pos = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if pos >= 1-enddist/len then return true end
	makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
end

function performTask.walkAroundBend(npc,task)
	if isPedInVehicle(npc) then return true end
	local x0,y0 = task[2],task[3]
	local x1,y1,z1 = task[4],task[5],task[6]
	local x2,y2,z2 = task[7],task[8],task[9]
	local off,enddist = task[10],task[11]
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local angle = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)+enddist/len
	if angle >= math.pi*0.5 then return true end
	makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
end

function performTask.walkFollowElement(npc,task)
	if isPedInVehicle(npc) then return true end
	local followed,mindist = task[2],task[3]
	if not isElement(followed) then return true end
	local x,y = getElementPosition(npc)
	local fx,fy = getElementPosition(followed)
	local dx,dy = fx-x,fy-y
	if dx*dx+dy*dy > mindist*mindist then
		makeNPCWalkToPos(npc,fx,fy)
	else
		stopAllNPCActions(npc)
	end
end

function performTask.shootPoint(npc,task)
	local x,y,z = task[2],task[3],task[4]
	makeNPCShootAtPos(npc,x,y,z)
end

function performTask.shootElement(npc,task)
	local target = task[2]
	if not isElement(target) then return true end
	makeNPCShootAtElement(npc,target)
end

function performTask.killPed(npc,task)
	if isPedInVehicle(npc) then return true end
	local target,shootdist,followdist = task[2],task[3],task[4]
	if not isElement(target) or isPedDead(target) then return true end

	local x,y,z = getElementPosition(npc)
	local tx,ty,tz = getElementPosition(target)
	local dx,dy = tx-x,ty-y
	local distsq = dx*dx+dy*dy

	if distsq < shootdist*shootdist then
		makeNPCShootAtElement(npc,target)
		setPedRotation(npc,-math.deg(math.atan2(dx,dy)))
	else
		stopNPCWeaponActions(npc)
	end
	if distsq > followdist*followdist then
		makeNPCWalkToPos(npc,tx,ty)
	else
		stopNPCWalkingActions(npc)
	end

	return false
end

local attackDistance = 10

function addPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		local lastTask = getElementData(pedElement, "ped.lastTask")
		if not lastTask then
			lastTask = 1
			setElementData(pedElement, "ped.thisTask", 1)
		else
			lastTask = lastTask + 1
		end
		setElementData(pedElement, "ped.task." .. lastTask, selectedTask)
		setElementData(pedElement, "ped.lastTask", lastTask)
		return true
	else
		return false
	end
end

function clearPedTasks(pedElement)
	if isElement(pedElement) then
		local thisTask = getElementData(pedElement, "ped.thisTask")
		if thisTask then
		
			local lastTask = getElementData(pedElement, "ped.lastTask")
			for currentTask = thisTask, lastTask do
				--removeElementData(pedElement,"ped.task." .. currentTask)
				setElementData(pedElement, "ped.task." .. currentTask, nil)
			end

			--removeElementData(pedElement, "ped.thisTask")
			setElementData(pedElement, "ped.thisTask", nil)
			--removeElementData(pedElement, "ped.lastTask")
			setElementData(pedElement, "ped.lastTask", nil)
			return true
		end
	else
		return false
	end
end

function setPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		clearPedTasks(pedElement)
		setElementData(pedElement, "ped.task.1", selectedTask)
		setElementData(pedElement, "ped.thisTask", 1)
		setElementData(pedElement, "ped.lastTask", 1)
		return true
	else
		return false
	end
end


function cycleNPCs()
	local streamedPeds = {}
	for pednum,ped in ipairs(getElementsByType("ped",root,true)) do
		if getElementData(ped,"ped.isControllable") then
			streamedPeds[ped] = true
		end
	end
	for npc,streamedin in pairs(streamedPeds) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			while true do
				local thisTask = getElementData(npc,"ped.thisTask")
				if thisTask then
					local task = getElementData(npc,"ped.task."..thisTask)
					if task then
						if performTask[task[1]](npc,task) then
							clearPedTasks(npc)
						else
							break
						end
					else
						stopAllNPCActions(npc)
						break
					end
				else
					stopAllNPCActions(npc)
					break
				end
			end
		else
			stopAllNPCActions(npc)
		end
	end
end

function setNPCTaskToNext(npc)
	setElementData(
		npc,"ped.thisTask",
		getElementData(npc,"ped.thisTask")+1,
		true
	)
end

--dogmodells 

local models = {{"boxerdog",269},{"bpitbull",270},{"brownpitbull",271},{"bullterrier",300},{"dalmata",311},{"doberman",293},{"pig",9},{"siberianhusky",1}}

addEventHandler("onClientResourceStart",resourceRoot,function()
    for k,v in pairs(models) do 
        local txd = engineLoadTXD("files/pets/"..v[1]..".txd")
        engineImportTXD(txd, v[2])
        local dff = engineLoadDFF("files/pets/"..v[1]..".dff")
        engineReplaceModel(dff, v[2])
    end 
end)

-- minigame

local myX, myY = 1600, 900

local core = exports.oCore 
local color, r, g, b = core:getServerColor()

local fonts = {
    ["bebasneue-25"] = exports.oFont:getFont("bebasneue", 25),
}



local activeMinigame

local avaibleCharacters = {"A", "B", "C", "D", "E", "G", "H", "I", "Q", "F", "R", "T", "Z", 'Y'}

local minigameValues = {}

local lastRectangle = {0.5, 0.65, 0.03, 0.05}
lastRectangle[1] = math.random(440, 530)/1000
lastRectangle[2] = math.random(645, 785)/1000
lastRectangle[3] = math.random(20, 30)/1000
lastRectangle[4] = math.random(20, 30)/1000

local clickPlus = 0.02
local timeMinus = 0.0005

local oldX, oldY, oldW, oldH = 0, 0, 0, 0
local oldvalue = 0

local tick = getTickCount()
local tick2 = getTickCount()

local minigameMove = -0.2
local pointerPos = sx*0.5 - sx*0.01/2
local successPercent = 0

function renderMinigame()
    type, count, start, maxtime = activeMinigame[1], activeMinigame[2], activeMinigame[3], activeMinigame[4]

    if type == 1 then 
        dxDrawRectangle(sx/2-70/myX*sx/2, sy*0.77, 70/myX*sx, 70/myY*sy, tocolor(30, 30, 30, 255))

        dxDrawRectangle(sx/2-70/myX*sx/2, sy*0.77+70/myY*sy, 70/myX*sx, -70/myY*sy*minigameValues[2], tocolor(r, g, b, 100))

        dxDrawText(minigameValues[1], sx/2-70/myX*sx/2, sy*0.77, sx/2-70/myX*sx/2+70/myX*sx, sy*0.77+70/myY*sy, tocolor(r, g, b, 255), 1/myX*sx, fonts["bebasneue-25"], "center", "center")

        if getKeyState(string.lower(minigameValues[1])) then 
            if minigameValues[2] < 1 then 
                minigameValues[2] = minigameValues[2] + 0.015
            else 
                minigameValues[3] = minigameValues[3] + 1
                minigameValues[4] = getTickCount()

                if minigameValues[3] == count then 
                    endMinigame("successful")
                end

                minigameValues[2] = 0 
                minigameValues[1] = avaibleCharacters[math.random(#avaibleCharacters)]
            end
        else
            if minigameValues[2] > 0 then 
                minigameValues[2] = minigameValues[2] - 0.015
            end
        end

        core:dxDrawOutLine(sx/2-70/myX*sx/2, sy*0.77, 70/myX*sx, 70/myY*sy, tocolor(35, 35, 35, 255), 2)

        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.858, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))

        local lineWidth = 0 
        
        if minigameValues[3] >= 1 then 
            lineWidth = interpolateBetween((minigameValues[3]-1)/count, 0, 0, minigameValues[3]/count, 0, 0, (getTickCount()-minigameValues[4])/300, "InOutQuad")
        end

        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, (200/myX*sx-4/myX*sx)*lineWidth, 10/myY*sy-4/myY*sy, tocolor(r, g, b, 255))

        local time = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount()-start)/maxtime, "Linear")

        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.872, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.872+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.872+2/myY*sy, (200/myX*sx-4/myX*sx)*time, 10/myY*sy-4/myY*sy, tocolor(224, 70, 70, 255))

        if time <= 0.001 then 
            endMinigame("unseccessful")
        end

    elseif type == 2 then 
        local renderX, renderY, renderW, renderH
        if  oldX > 0 and oldX > 0 and oldY > 0 and oldW > 0 and oldH > 0 then 
            renderX, renderY = interpolateBetween(oldX, oldY, 0, lastRectangle[1], lastRectangle[2], 0, (getTickCount() - minigameValues[4])/250, "Linear")
            renderW, renderH = interpolateBetween(oldW, oldH, 0, lastRectangle[3], lastRectangle[4], 0, (getTickCount() - minigameValues[4])/250, "Linear")
        else
            renderX, renderY, renderW, renderH = lastRectangle[1], lastRectangle[2], lastRectangle[3], lastRectangle[4]
        end
    
        showCursor(true)
    
        local time = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount()-start)/maxtime, "Linear")

        if time > 0 then 
            time = time - timeMinus
        else
            endMinigame("unseccessful")
        end
    
        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.64, 200/myX*sx, 180/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+2/myX*sx, sy*0.64+2/myY*sy, 200/myX*sx-4/myX*sx, 180/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
    
        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.845, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.845+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
    
        local lineWidth = 0 
        
        if (minigameValues[3] or 0) >= 1 then 
            lineWidth = interpolateBetween((minigameValues[3]-1)/count, 0, 0, minigameValues[3]/count, 0, 0, (getTickCount()-minigameValues[4])/300, "InOutQuad")
        end

        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.845+2/myY*sy, (200/myX*sx-4/myX*sx)*lineWidth, 10/myY*sy-4/myY*sy, tocolor(r, g, b, 200))
    
        dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.858, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
        dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, (200/myX*sx-4/myX*sx)*time, 10/myY*sy-4/myY*sy, tocolor(224, 70, 70, 200))
    
        dxDrawRectangle(sx*renderX, sy*renderY, sx*renderW, sy*renderH, tocolor(33, 33, 33, 255))
    elseif type == 3 then 
        dxDrawRectangle(sx*0.4, sy*0.8, sx*0.2, sy*0.02, tocolor(35, 35, 35, 100))
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02 - 4/myY*sy, tocolor(35, 35, 35, 255))

        dxDrawImage(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 0, 0, 0, tocolor(242, 51, 51, 255))
        dxDrawImage(sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx - sx*0.035, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 180, 0, 0, tocolor(242, 51, 51, 255))

        dxDrawRectangle(pointerPos, sy*0.8 - 1/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
        dxDrawRectangle(pointerPos - 2/myX*sx, sy*0.8 - 3/myY*sy, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

        dxDrawRectangle(sx*0.4, sy*0.822, sx*0.2, sy*0.01, tocolor(35, 35, 35, 100))
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.01 - 4/myY*sy, tocolor(35, 35, 35, 255))

        if successPercent >= 100 then
            dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(r, g, b, 200))
        else
            dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(242, 51, 51, 200))
        end

        dxDrawRectangle(sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.822 + 2/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
        dxDrawRectangle((sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100) - 2/myX*sx, sy*0.822, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

        dxDrawText(math.floor(successPercent).."%", (sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100), sy*0.822, -sx*0.002, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 255), 1, exports.oFont:getFont("condensed", 10/myX*sx), "right", "bottom")

        if successPercent < 100 then
            successPercent = successPercent + activeMinigame[4]
        else
            endMinigame("successful")
        end

        if getKeyState("arrow_l") or getKeyState("a") then 
            minigameMove = minigameMove - math.random(3, 10) / 100
        elseif getKeyState("arrow_r") or getKeyState("d") then 
            minigameMove = minigameMove + math.random(3, 10) / 100
        else
            if minigameMove > 0 and minigameMove < 1.5 then
                minigameMove = 1.5 
            elseif minigameMove < 0 and minigameMove > -1.5 then 
                minigameMove = -1.5 
            end
        end

        pointerPos = pointerPos + minigameMove/myX*sx

        if pointerPos < sx*0.41 or pointerPos > sx*0.59 then 
            endMinigame("unseccessful")
        end
    end
end

function createMinigame(type, successCount, time, successEvent, unsuccessEvent,element,element)
    if activeMinigame then return false end
    activeMinigame = {type, successCount, getTickCount(), time, successEvent, unsuccessEvent,petID,money}

    if type == 1 then 
        minigameValues = {avaibleCharacters[math.random(#avaibleCharacters)], 0, 0, getTickCount()}
        addEventHandler("onClientKey", root, cancelKeys)

        outputChatBox(core:getServerPrefix("server", "Minigame", 2).."Tartsd lenyomva a képernyő közepén látható billentyűt.", 255, 255, 255, true)
    elseif type == 2 then 
        minigameValues = {"", 0, 0, getTickCount()}

        outputChatBox(core:getServerPrefix("server", "Minigame", 2).."Kattinst a szürke négyzetekre.", 255, 255, 255, true)
        addEventHandler("onClientKey", root, minigame2Keys)
    elseif type == 3 then 
        local values = {-0.3, -0.25, -0.2, -0.1, 0.1, 0.2, 0.25, 0.3}
        pointerPos = sx*0.5 - sx*0.01/2
        minigameMove = values[math.random(#values)]
        successPercent = 0
        minigameInProgress = true    

        if not activeMinigame[4] then 
            activeMinigame[4] = 0.05
        end
    end

    addEventHandler("onClientRender", root, renderMinigame)
end

function endMinigame(type)
    removeEventHandler("onClientRender", root, renderMinigame)

    if activeMinigame[1] == 1 then 
        removeEventHandler("onClientKey", root, cancelKeys)
    elseif activeMinigame[1] == 2 then 
        showCursor(false)
        removeEventHandler("onClientKey", root, minigame2Keys)
    end

    if type == "successful" then 

        triggerServerEvent("reHealPet",localPlayer,localPlayer,petID)
        minigameActive = false
        exports.oInfobox:outputInfoBox("Az állatorvos sikeresen újraélesztette a kisállatod! ("..price.."$)","success")
        triggerServerEvent("takePetMoney",localPlayer,localPlayer,price)
        healPets[petID] = nil 
        myPets[petID][5] = 100
        setTimer(function()
            closeHealPanel()
        end,100,1)

    elseif type == "unseccessful" then 
        local halfPrice = price/2
        exports.oInfobox:outputInfoBox("Sajnos nem sikerült a minigame így az állatorvos nem tudja feléleszteni az állatod az összeg fele így is levonásra kerűlt! ("..halfPrice.."$)","error")
        minigameActive = false
        triggerServerEvent("takePetMoney",localPlayer,localPlayer,price/2)

        setTimer(function()
            closeHealPanel()
        end,100,1)
    end

    activeMinigame = false
end

function cancelKeys()
    cancelEvent()
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

--destroy functions

addEventHandler("onClientResourceStop",resourceRoot,function()
    if getElementData(source ,"hasSummonedPet") then 
        local pet = getElementData(source ,"char:avaliblePet")
        local petID = getElementData(pet ,"pet:id")
        triggerServerEvent("desummonPet",source ,source ,petID)
        setElementData(source ,"hasSummonedPet",false)
    end 
end)

addEventHandler("onClientPlayerWasted",root,function()
    if getElementData(source ,"hasSummonedPet") then 
        local pet = getElementData(source ,"char:avaliblePet")
        local petID = getElementData(pet ,"pet:id")
        triggerServerEvent("desummonPet",source ,source ,petID)
        setElementData(source ,"hasSummonedPet",false)
        exports.oInfobox:outputInfoBox("Mivel meghaltál az állatod automatikusan visszahívásra kertült!","info")
    end 
end)