function replaceModel()
  
  --épület
  
  txd = engineLoadTXD( "Island1.txd", 10101 )
  engineImportTXD(txd, 10101 )
  dff = engineLoadDFF( "Island1_1.dff", 10101 )
  engineReplaceModel(dff, 10101, true )
  col = engineLoadCOL( "Island1_1.col" )
  engineReplaceCOL ( col, 10101 )

  txd = engineLoadTXD( "Island1.txd", 10195 )
  engineImportTXD(txd, 10195 )
  dff = engineLoadDFF( "Island1_2.dff",10195 )
  engineReplaceModel(dff, 10195, true )
  col = engineLoadCOL( "Island1_2.col" )
  engineReplaceCOL ( col, 10195 )

  txd = engineLoadTXD( "Island1.txd", 9925 )
  engineImportTXD(txd, 9925 )
  dff = engineLoadDFF( "Island1_3.dff", 9925 )
  engineReplaceModel(dff, 9925, true )
  col = engineLoadCOL( "Island1_3.col" )
  engineReplaceCOL ( col, 9925 )

  
  
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
engineSetModelLODDistance(10101, 1000)

setLowLODElement(createObject(10101, 584.09240722656,-2447.9760742188,2.00867462158), createObject(10101, 584.09240722656,-2447.9760742188,2.00867462158))
createObject(9925, 584.09240722656,-2447.9760742188,2.000867462158)
--createObject(10195, 584.09240722656,-2447.9760742188,3.500867462158, 0, 0, -90)