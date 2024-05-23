txd = engineLoadTXD("dominik.txd")
engineImportTXD( txd, 310 )
dff = engineLoadDFF("dominik.dff")
engineReplaceModel(dff, 310)
