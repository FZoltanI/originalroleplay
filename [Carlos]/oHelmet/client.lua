txd = engineLoadTXD( "helmets/texture.txd", 3243 )
engineImportTXD(txd, 3243 )
dff = engineLoadDFF( "helmets/green.dff", 3243 )
engineReplaceModel(dff, 3243, true )

function createHelmet() 
    local obj = createObject(3243, 0, 0, 0)
    setElementCollisionsEnabled(obj, false)

    exports.oBone:attachElementToBone(obj, localPlayer, 1, 0, 0.01, 0, 0, 270, 0)
end
createHelmet()
addCommandHandler("helmet", createHelmet)