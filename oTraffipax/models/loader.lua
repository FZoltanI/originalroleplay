txd = engineLoadTXD( "models/fix.txd")
engineImportTXD(txd, 17097 )
dff = engineLoadDFF( "models/fix.dff")
engineReplaceModel(dff, 17097, true )
col = engineLoadCOL("models/fix.col")
engineReplaceCOL(col, 17097)

txd = engineLoadTXD( "models/3leg.txd")
engineImportTXD(txd, 17094 )
dff = engineLoadDFF( "models/3leg.dff")
engineReplaceModel(dff, 17094, true )
col = engineLoadCOL("models/3leg.col")
engineReplaceCOL(col, 17094)

txd = engineLoadTXD( "models/veda.txd")
engineImportTXD(txd, 17093 )
dff = engineLoadDFF( "models/veda.dff")
engineReplaceModel(dff, 17093, true )
col = engineLoadCOL( "models/veda.col")
engineReplaceCOL(col, 17093)