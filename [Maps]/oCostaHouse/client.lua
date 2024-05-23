txd = engineLoadTXD( "CEhillhouse01.txd", 13755)
engineImportTXD(txd, 13755)

dff = engineLoadDFF( "CEhillhouse01.dff", 13755)
engineReplaceModel(dff, 13755, true )

col= engineLoadCOL ( "CEhillhouse01.col" )
engineReplaceCOL ( col, 13755)

--local obj = createObject(13755, 649.79,-1120.52,44.0391, 0, 0, 46)
--local LOD = createObject(9718, 649.79,-1120.52,44.0391, 0, 0, 0, true)
--setLowLODElement(obj, LOD)
--engineSetModelLODDistance(9718, 4000)