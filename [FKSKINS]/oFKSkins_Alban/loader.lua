local skins = {
    -- Betöltésre kerülő skinek (írd be őket sorba)
    -- skinName: txd és dff file neve (legyen ugyan az), model: model
    {skinName = "199", model = 199},
    {skinName = "299", model = 299},
    {skinName = "303", model = 303},
    {skinName = "308", model = 308},
    {skinName = "312", model = 312},
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
