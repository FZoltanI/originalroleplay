TXD = engineLoadTXD( "1793.txd")
engineImportTXD( TXD, 1356)
DFF = engineLoadDFF( "1793.dff" )
engineReplaceModel( DFF, 1356)



