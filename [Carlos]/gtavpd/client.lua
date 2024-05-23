function replaceModel()
  
  --épület
  
  txd = engineLoadTXD( "sapd.txd", 16134 )
  engineImportTXD(txd, 16134 )
  dff = engineLoadDFF( "sapd.dff", 16134 )
  engineReplaceModel(dff, 16134, true )
  col = engineLoadCOL( "sapd.col" )
  engineReplaceCOL ( col, 16134 )

  
  
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

createObject(16134, 1084.7779541016, -1797.1726074219, 114.2885055542)