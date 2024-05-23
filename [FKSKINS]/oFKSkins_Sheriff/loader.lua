local skins = {
    -- Betöltésre kerülő skinek (írd be őket sorba)
    -- skinName: txd és dff file neve (legyen ugyan az), model: model
    {skinName = "102", model = 102}, 
    {skinName = "103", model = 103}, 
    {skinName = "104", model = 104}, 
    {skinName = "105", model = 105},
    {skinName = "106", model = 106},
    {skinName = "107", model = 107}, 
    {skinName = "108", model = 108},


    {skinName = "109", model = 109},
    {skinName = "110", model = 110},
    {skinName = "114", model = 114},
}

function loadSkins()
    for k, v in ipairs(skins) do
        txd = engineLoadTXD("skins/" .. v.skinName .. ".txd", v.model)
        engineImportTXD(txd, v.model)
        dff = engineLoadDFF("skins/" .. v.skinName .. ".dff", v.model)
        engineReplaceModel(dff, v.model, true)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadSkins)
