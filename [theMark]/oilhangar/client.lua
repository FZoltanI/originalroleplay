function replaceModel()

dff = engineLoadDFF( "asd1.dff", 3816 )
engineReplaceModel(dff, 3816, true )

col = engineLoadCOL ( "asd1.col" )
engineReplaceCOL ( col, 3816 )

end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)


