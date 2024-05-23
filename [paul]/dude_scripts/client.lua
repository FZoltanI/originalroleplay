local dudeConts = createObject(8326,1896.9706298828,-1409.4577392578,29.088912963867,0,0,90)
setElementData(dudeConts,"dude_obj",true) 

function loadTxds()
    for k,v in pairs(getElementsByType("vehicle")) do
        if getElementData(v,"car:dude") then
            utility = engineLoadTXD("files/utility.txd")
            engineImportTXD(utility,552)
        end
    end

end
addEventHandler("onClientResourceStart",resourceRoot,loadTxds)
