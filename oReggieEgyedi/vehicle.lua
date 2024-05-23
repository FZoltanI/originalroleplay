addEventHandler('onClientResourceStart', resourceRoot, 
function() 
	txd = engineLoadTXD ( "infernus.txd" )
	engineImportTXD ( txd, 491 )

	dff = engineLoadDFF ( "infernus.dff", 491 )
        engineReplaceModel ( dff, 491 )
end 
)