function replaceModel()

    txd = engineLoadTXD( "comedbarrio1_la.txd", 3698 )
    engineImportTXD(txd, 3698 )
    
    dff = engineLoadDFF( "barrio3b_lae.dff", 3698 )
    engineReplaceModel(dff, 3698, true )

    txd = engineLoadTXD( "landlae2b.txd", 17645 )
    engineImportTXD(txd, 17645 )
    
    dff = engineLoadDFF( "lae2_ground12.dff", 17645 )
    engineReplaceModel(dff, 17645, true )
    
    txd = engineLoadTXD( "lae2roads.txd", 17640 )
    engineImportTXD(txd, 17640 )
    
    dff = engineLoadDFF( "lae2_roads32.dff", 17640 )
    engineReplaceModel(dff, 17640, true )
    
    
    end
    addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)