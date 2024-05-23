local skins = {
    -- Betöltésre kerülő skinek (írd be őket sorba)
    -- skinName: txd és dff file neve (legyen ugyan az), model: model
    {skinName = "213", model = 213}, 
    {skinName = "235", model = 235}, 
    {skinName = "249", model = 249}, 
    {skinName = "264", model = 264}, 
    {skinName = "278", model = 278}, 
    {skinName = "279", model = 279}, 
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
