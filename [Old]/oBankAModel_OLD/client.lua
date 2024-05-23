function replaceModel()
  txd = engineLoadTXD( "goldbar.txd", 2835 )
  engineImportTXD(txd, 2835 )
  dff = engineLoadDFF( "goldbar.dff", 2835 )
  engineReplaceModel(dff, 2835 )
  
  txd = engineLoadTXD( "safedoor.txd", 17143)
  engineImportTXD(txd, 17143)
  dff = engineLoadDFF( "safedoor.dff")
  engineReplaceModel(dff, 17143 )
  col = engineLoadCOL("safedoor.col")
  engineReplaceCOL(col, 17143)

  engineSetModelLODDistance( 2835, 5000)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
