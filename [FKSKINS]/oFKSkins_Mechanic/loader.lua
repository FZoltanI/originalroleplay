local skins = {
    -- Betöltésre kerülő skinek (írd be őket sorba)
    -- skinName: txd és dff file neve (legyen ugyan az), model: model
    {skinName = "253", model = 253}, 
    {skinName = "305", model = 305}, 
    {skinName = "309", model = 309}, 
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
