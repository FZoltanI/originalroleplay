function replaceModels()
  txd = engineLoadTXD( "ak47/ak47.txd", 355 )
  engineImportTXD(txd, 355 )
  dff = engineLoadDFF( "ak47/ak47.dff", 355 )
  engineReplaceModel(dff, 355, true )

  txd = engineLoadTXD( "desert_eagle/desert_eagle.txd", 348 )
  engineImportTXD(txd, 348 )
  dff = engineLoadDFF( "desert_eagle/desert_eagle.dff", 348 )
  engineReplaceModel(dff, 348, true )

  txd = engineLoadTXD( "uzi/uzi.txd", 352 )
  engineImportTXD(txd, 352 )
  dff = engineLoadDFF( "uzi/uzi.dff", 352 )
  engineReplaceModel(dff, 352, true )

  txd = engineLoadTXD( "sniper/sniper.txd", 358 )
  engineImportTXD(txd, 358 )
  dff = engineLoadDFF( "sniper/sniper.dff", 358 )
  engineReplaceModel(dff, 358, true )

  txd = engineLoadTXD( "mp5/mp5.txd", 353 )
  engineImportTXD(txd, 353 )
  dff = engineLoadDFF( "mp5/mp5.dff", 353 )
  engineReplaceModel(dff, 353, true )

  txd = engineLoadTXD( "shotgun/shotgun.txd", 349 )
  engineImportTXD(txd, 349 )
  dff = engineLoadDFF( "shotgun/shotgun.dff", 349 )
  engineReplaceModel(dff, 349, true )

  txd = engineLoadTXD( "taser/taser.txd", 347 )
  engineImportTXD(txd, 347 )
  dff = engineLoadDFF( "taser/taser.dff", 347 )
  engineReplaceModel(dff, 347, true )

  txd = engineLoadTXD( "knife/knife.txd", 335 )
  engineImportTXD(txd, 335 )
  dff = engineLoadDFF( "knife/knife.dff", 335 )
  engineReplaceModel(dff, 335, true )
  
  txd = engineLoadTXD( "m4/m4.txd", 356 )
  engineImportTXD(txd, 356 )
  dff = engineLoadDFF( "m4/m4.dff", 356 )
  engineReplaceModel(dff, 356, true )

  txd = engineLoadTXD( "tec9/tec9.txd", 372 )
  engineImportTXD(txd, 372 )
  dff = engineLoadDFF( "tec9/tec9.dff", 372 )
  engineReplaceModel(dff, 372, true )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModels)