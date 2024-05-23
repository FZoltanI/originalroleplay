function replaceModel()

txd = engineLoadTXD( "imy_track_barrier.txd", 16271 )
engineImportTXD(txd, 16271 )

dff = engineLoadDFF( "imy_track_barrier.dff", 16271 )
engineReplaceModel(dff, 16271, true )

col = engineLoadCOL ( "imy_track_barrier.col" )
engineReplaceCOL ( col, 16271 )

end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)


