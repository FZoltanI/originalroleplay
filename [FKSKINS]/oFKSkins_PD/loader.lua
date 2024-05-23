local skins = {
    -- Betöltésre kerülő skinek (írd be őket sorba)
    -- skinName: txd és dff file neve (legyen ugyan az), model: model
    {skinName = "113", model = 113}, 
    {skinName = "114", model = 114}, 
    {skinName = "115", model = 115}, 
    {skinName = "132", model = 132}, 
    {skinName = "244", model = 244}, 
    {skinName = "245", model = 245}, 
    {skinName = "246", model = 246}, 
    {skinName = "252", model = 252}, 
    {skinName = "256", model = 256}, 
    {skinName = "257", model = 257}, 

    --swat

    --{skinName = "285", model = 285},  -- CRASHELTET CSAK MODELL CSERE UTÁN ÍRD VISSZA
    --{skinName = "287", model = 287}, 
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
