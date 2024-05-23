local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local ped = createPed(158, -679.32580566406, 272.62777709961, 1.67848777771, 230)
setElementFrozen(ped, true)
setElementData(ped, "ped:name", "Carlos")
local colShape = createColTube(-679.32580566406, 272.62777709961, -2.67848777771, 2, 7)

local lastHit = 0

addEventHandler("onClientColShapeLeave", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if source == colShape then 
            removeEventHandler("onClientRender", root, renderEventPanel)
        end
    end
end)

local halak = {127, 128, 129, 130, 131, 132, 133, 134}

local lastMoneyGive = 0

local blip = createBlip(-794.673828125, 170.39044189453, 6.6994009017944, 55)
setElementData(blip, "blip:name", "Horgászverseny")

local music = playSound3D("https://streams.ilovemusic.de/iloveradio7.mp3", -778.42376708984, 189.17625427246, 3.2761869430542)
setSoundMaxDistance(music, 300)
setSoundVolume(music, 1)

local peds = {
    --{skin, x, y, z, rot, grup, anim},
    {138, -754.56207275391, 226.93240356445, 2.004376411438, 225, "DANCING", "dnce_m_a"},
    {139, -750.95788574219, 228.17469787598, 2.0089874267578, 151, "DANCING", "dnce_m_c"},
    {140, -752.47637939453, 221.28863220215, 2.42209815979, 0, "BEACH", "sitnwait_Loop_W"},
    {97, -755.33685302734, 223.83113098145, 2.1655731201172, 271, 'DANCING', 'dan_loop_a'},

    {138, -655.69116210938, 278.94525146484, 2.0152931213379, 72, "DANCING", "DAN_Down_A"},
    {97, -662.08404541016, 277.83071899414, 1.8944206237793, 271, "BEACH", "Lay_Bac_Loop"},
    {139, -656.50500488281, 276.01428222656, 2.2881698608398, 47, "BEACH", "sitnwait_Loop_W"},
    {140, -661.41802978516, 281.17120361328, 1.5836191177368, 243, 'DANCING', 'dnce_M_d'},


    {140, -776.1767578125, 216.83587646484, 0.59540252685547, 26,  "BEACH", "sitnwait_Loop_W"},
    {97, -775.23345947266, 217.74053344727, 0.97916793823242, 31, "BEACH", "Lay_Bac_Loop"},

    {138, -780.71746826172, 207.97105407715, 1.2211322784424, 214, 'GHANDS', 'gsign3'},
    {139, -780.25280761719, 207.23104858398, 1.3142585754395, 31, 'GHANDS', 'gsign5'},
}

for k, v in ipairs(peds) do 
    local ped = createPed(v[1], v[2], v[3], v[4], v[5])
    setElementFrozen(ped, true)
    setPedAnimation(ped, v[6], v[7], -1, true, false, false)
end

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if source == colShape then 
            addEventHandler("onClientRender", root, renderEventPanel)

            local selldItems = 0
            for k, v in ipairs(halak) do 
                local hasItem = {inventory:hasItem(v)}
                if hasItem[1] then 
                    local itemWeight = inventory:getItemWeight(hasItem[2].item) * hasItem[2].count

                    triggerServerEvent("deleteItem", localPlayer, localPlayer, hasItem[2], true)

                    local eventStat = getElementData(localPlayer, "fishing:eventStat") or 0

                    if eventStat + itemWeight > 100 then 
                        if lastMoneyGive + 10000 < getTickCount() then
                            lastMoneyGive = getTickCount()
                            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + pricePer100kg)
                            setElementData(localPlayer, "fishing:eventStat", (eventStat + itemWeight) - 100)
                            infobox:outputInfoBox("Mivel leadtál 100kg halat, így kaptál "..pricePer100kg.."$-t!", "success")
                            outputChatBox(" ")
                            outputChatBox(core:getServerPrefix("server", "Horgászverseny", 2).."Mivel leadtál "..color.."100kg #ffffffhalat, így kaptál "..color..pricePer100kg.."$#ffffff-t!", 255, 255, 255, true)
                            outputChatBox(" ")
                        end
                    else
                        setElementData(localPlayer, "fishing:eventStat", math.min(eventStat + itemWeight, 100))
                    end

                    selldItems = selldItems + 1
                end
            end

            if selldItems > 0 then
                infobox:outputInfoBox("Sikeresen leadtad a nálad lévő halakat!", "success")
            end
        end
    end
end)

function renderEventPanel()
    local eventStat = getElementData(localPlayer, "fishing:eventStat") or 0
    eventStat = math.floor(eventStat)
    local eventPercent = eventStat

    dxDrawRectangle(sx*0.4, sy*0.7, sx*0.2, sy*0.13, tocolor(35, 35, 35, 100))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.7 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.13 - 4/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.7 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02, tocolor(30, 30, 30, 255))
    dxDrawText("OriginalRoleplay - "..color.."Horgászfesztivál", sx*0.4 + 2/myX*sx, sy*0.7 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx, sy*0.7 + 2/myY*sy + sy*0.02, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 9/myX*sx), "center", "center", false, false, false, true)

    dxDrawRectangle(sx*0.4 + 2/myX*sx + sx*0.009, sy*0.76, sx*0.18, sy*0.03, tocolor(30, 30, 30, 255))
    dxDrawRectangle(sx*0.4 + 2/myX*sx + sx*0.009 + 2/myX*sx, sy*0.76 + 2/myY*sy, (sx*0.18 - 4/myX*sx), sy*0.03 - 4/myY*sy, tocolor(35, 35, 35, 150))

    dxDrawRectangle(sx*0.4 + 2/myX*sx + sx*0.009 + 2/myX*sx, sy*0.76 + 2/myY*sy, (sx*0.18 - 4/myX*sx) * (eventPercent/100), sy*0.03 - 4/myY*sy, tocolor(r, g, b, 200))

    dxDrawText(color.."100kg #ffffffhal = #85d463"..pricePer100kg.."$", sx*0.4 + 2/myX*sx, sy*0.7 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx, sy*0.7 + 2/myY*sy + sy*0.117, tocolor(255, 255, 255, 255), 1, font:getFont("bebasneue", 13/myX*sx), "center", "bottom", false, false, false, true)
    dxDrawText(color..eventStat.."#ffffff/100kg", sx*0.4 + 2/myX*sx, sy*0.7 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx, sy*0.7 + 2/myY*sy + sy*0.055, tocolor(255, 255, 255, 255), 1, font:getFont("bebasneue", 15/myX*sx), "center", "bottom", false, false, false, true)
    core:dxDrawShadowedText(eventPercent.."%", sx*0.4 + 2/myX*sx + sx*0.009, sy*0.76, sx*0.4 + 2/myX*sx + sx*0.009+sx*0.18, sy*0.76+sy*0.03, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 100), 1, font:getFont("condensed", 11/myX*sx), "center", "center")
end
