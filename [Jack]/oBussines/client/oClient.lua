function loadModel() 
    col_floors = engineLoadCOL ( "assets/model/industri.col" )
    engineReplaceCOL ( col_floors, settings.objects.industri )
    txd_floors = engineLoadTXD ( "assets/model/industri.txd" )
    engineImportTXD ( txd_floors, settings.objects.industri )
    dff_floors = engineLoadDFF ( "assets/model/industri.dff" )
    engineReplaceModel ( dff_floors, settings.objects.industri )
end
addEventHandler ( "onClientResourceStart", resourceRoot, loadModel)