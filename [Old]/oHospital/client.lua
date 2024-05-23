function replaceModel()
  
  --épület
  
  txd = engineLoadTXD( "hosp.txd", 16134 )
  engineImportTXD(txd, 16134 )
  dff = engineLoadDFF( "hosp.dff", 16134 )
  engineReplaceModel(dff, 16134, true )
  col = engineLoadCOL( "hosp.col" )
  engineReplaceCOL ( col, 16134 )

  
  
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

createObject(16134, 1156.7442626953, -1310.6484375, -12.77478313446)