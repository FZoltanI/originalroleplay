local asd = 1000

local sx, sy = guiGetScreenSize()

addEventHandler("onClientPreRender",getRootElement(),function(dTime)
    if getElementData(localPlayer,"player:bag") then 
        if getPedMoveState(localPlayer) == "forwards" or getPedMoveState(localPlayer) == "backwards" or  getPedMoveState(localPlayer) == "left" or  getPedMoveState(localPlayer) == "right" then 
            setElementData(localPlayer,"player:bagmove",true);
        else 
            setElementData(localPlayer,"player:bagmove",false);
        end
    else 
        setElementData(localPlayer,"player:bagmove",true);
    end 
end)

addEventHandler("onClientRender", root, function()
    if getElementData(localPlayer, "player:bagBAG") then 
        --dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 255))
    end
end)

function _getTime()
    local times = {30000,60000,90000,120000};
    randomNum = math.random(1,4);
    return times[randomNum]
end

setTimer(function()
    asd = _getTime()
end,asd,0)

function attachBag(attacker,element)
    if exports["oInventory"]:hasItem(141) then 
        if exports.oDashboard:isPlayerFactionTypeMember({4, 5}) then 
            triggerServerEvent("attachBag",element,attacker,element)
        else 
            exports["oInfobox"]:outputInfoBox("Számodra ez nem engedélyezett.","error")
        end 
    else 
        exports["oInfobox"]:outputInfoBox("Nincs nálad erre alkalmas item!","error")
    end
end 

function deattachBag(attacker,element)
    triggerServerEvent("deattachBag",element,attacker,element)
end 