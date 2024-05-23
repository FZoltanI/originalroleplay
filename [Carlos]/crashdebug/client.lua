local sx, sy = guiGetScreenSize()
addEventHandler("onClientRender", root, function()
    local info = dxGetStatus( )
    local startY = sy*0.4
    for k, v in pairs( info ) do
        dxDrawText(k .. ": #eb7734".. tostring(v), sx*0.02, startY, _, _, tocolor(255, 255, 255, 255), 1, "default-bold", _, _, false, false, true, true)
        startY = startY + sy*0.02
    end
end)