local goggles = {}

function attachGoggle(player)
    goggles[player] = createObject(3070,0,0,0)
    exports.oBone:attachElementToBone(goggles[player],player,1,0,0.08,-0.04)
    setElementData(player,"char:goggleUser",true)
    setElementData(player,"char:goggleElement",goggles[player])
end 
addEvent("attachGoggle",true)
addEventHandler("attachGoggle",root,attachGoggle)

function detachGoggle(player)
    exports.oBone:detachElementFromBone (goggles[player])
    setElementData(player,"char:goggleElement",false)
    destroyElement(goggles[player])
    setElementData(player,"char:goggleUser",false)
end 
addEvent("detachGoggle",true)
addEventHandler("detachGoggle",root,detachGoggle)

function quitPlayer()
    if getElementData(source,"char:goggleUser") then 
        detachGoggle(source)
    end 
end 
addEventHandler ( "onPlayerQuit", root, quitPlayer )