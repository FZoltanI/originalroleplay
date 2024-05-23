txd = engineLoadTXD( "snegovik1.txd", 203 )
engineImportTXD(txd, 203 )
dff = engineLoadDFF( "snegovik1.dff", 203 )
engineReplaceModel(dff, 203, true )