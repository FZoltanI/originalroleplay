local billboard1 = createObject(2258,2240.63140625, -2221.4663085938, 14.546875,0,0,135)
local buildbill = createObject(2258,1661.3525390625,-1883.1697509766,14.1546875,0,0,180)
setElementData(billboard1,"dude_obj",true) 

local const = dxCreateTexture("portakabin.ws_finalbuild.png")


local fx = dxCreateShader( "billFX.fx" )
function loadTxds()
    for k,v in pairs(getElementsByType("object")) do 
        if getElementData(v,"dude_obj") then 
            dudeboard = engineLoadTXD("picture_frame_clip.txd")
            engineImportTXD(dudeboard,2258)
        end 
    end 

    dudebill = engineLoadTXD("vgsssignage02.txd")
    engineImportTXD(dudebill,8326)

    bill1 = engineLoadTXD("billbrdlawn.txd")
    engineImportTXD(bill1,5818)

    lottery = engineLoadTXD("lawnabv.txd")
    engineImportTXD(lottery,5813)

    aukcio = engineLoadTXD("sw_fact02alt.txd")
    engineImportTXD(aukcio,13065)

    --engineApplyShaderToWorldTexture(fx, "ws_finalbuild", plant)
    --engineApplyShaderToWorldTexture(fx, "?emap*", plant)
    --dxSetShaderValue (fx, "gTexture", const)

    engineApplyShaderToWorldTexture(fx, "ws_solarin")
    dxSetShaderValue (fx, "gTexture", dxCreateTexture("sw_fact01.ws_solarin.png"))

    engineApplyShaderToWorldTexture(fx, "5")
    dxSetShaderValue (fx, "gTexture", dxCreateTexture("5.png"))

    engineApplyShaderToWorldTexture(fx, "homies_2")
    dxSetShaderValue (fx, "gTexture", dxCreateTexture("szerelo.png"))
end 
addEventHandler("onClientResourceStart",resourceRoot,loadTxds)