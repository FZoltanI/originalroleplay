addEventHandler('onClientResourceStart', resourceRoot,
    function()
 
        local txd = engineLoadTXD('Files/3dmodel.txd',true)
        engineImportTXD(txd, 16209)
        engineImportTXD(txd1, 16208)
 
        local dff = engineLoadDFF('Files/3dmodel.dff', 0)
        engineReplaceModel(dff, 16209)
 
        local col = engineLoadCOL('Files/3dmodel.col')
        engineReplaceCOL(col, 16209)
        engineSetModelLODDistance(16209, 0)

        local dff = engineLoadDFF('Files/3dmodel1.dff', 0)
        engineReplaceModel(dff, 16208)
 
        local col = engineLoadCOL('Files/3dmodel1.col')
        engineReplaceCOL(col, 16208)
        engineSetModelLODDistance(16208, 0)

txd = engineLoadTXD ( "Files/cmodel.txd" )	engineImportTXD ( txd, 496 )

dff = engineLoadDFF ( "Files/cmodel.dff", 0 )   engineReplaceModel ( dff, 496 )
	end 
)

local obj1 = createObject(16209, 3882.9004, -2785.2002, -0.5)
setElementDoubleSided(obj1, true)
local obj2 = createObject(16208, 3879.7402, -2431.3398, -0.5, 0, 0, 0.374)
setElementDoubleSided(obj2, true)
setLowLODElement(obj1, createObject(16209, 3882.9004, -2785.2002, -0.5, 0, 0, 0, true))
setLowLODElement(obj2, createObject(16208, 3879.7402, -2431.3398, -0.5, 0, 0, 0.374, true))