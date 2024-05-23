job = {
    leader = {
        ped = createPed(168, 2406.3291015625, -1509.6185302734, 24.006782531738, 82),
        col = createColSphere(2406.3422851563, -1508.9185791016, 24.006782531738, 1),
    },
    player = {
        jobid = 20,
        incol = 0,
    },
    
}
s = Vector2(guiGetScreenSize())
font = dxCreateFont ( 'assets/ui.ttf', 14)

function loadJob ()
	setElementData(job.leader.ped, 'ped:name', 'Cottage C. Aaron')
    setElementData(job.leader.ped, 'ped:prefix', 'Manager')
    setElementData(job.leader.ped, 'ped:icon', '')
    setElementData(job.leader.ped, 'job:foodc', true)
    setElementData(job.leader.col, 'col:foodc', true)
    setElementFrozen(job.leader.ped, true)
end
addEventHandler ( "onClientResourceStart", getRootElement(getThisResource()), loadJob )


function npcGodMode (target)
    if (getElementData(target,'job:foodc') or getElementData(source,'job:foodc')) then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerStealthKill", getRootElement(), npcGodMode)
addEventHandler ( "onClientPedDamage", getRootElement(), npcGodMode )

function onClientColShapeHit( element )
    if ( element == localPlayer ) then
        if (getElementData(source,'col:foodc')) then
            job.player.incol = 1
            outputChatBox('set')
        end
    end
end
addEventHandler("onClientColShapeHit", root, onClientColShapeHit)

function onClientColShapeLeave( element )
    if ( element == localPlayer ) then
        if (getElementData(source,'col:foodc')) then
            job.player.incol = 0
            outputChatBox('removed')
        end
    end
end
addEventHandler("onClientColShapeLeave", root, onClientColShapeLeave)


function render()
    if (job.player.incol > 0) then
        dxDrawText(settings.interaction, s.x * 0.5 - dxGetTextWidth(settings.interaction, 0.00052083333*s.x , font)/2, s.y * 0.9, _, _, tocolor(255,255,255,255), 0.00052083333*s.x, font, _, _,false,false,false,true)
        dxDrawRectangle(s.x/2 - s.x * 0.025 / 2, s.y * 0.85, s.x * 0.025, s.x * 0.025, tocolor(255, 255, 255,150))
        dxDrawRectangle(s.x/2 - s.x * 0.023 / 2, s.y * 0.85 + 0.001 * s.x, s.x * 0.023, s.x * 0.023, tocolor(255, 255, 255, 255))
        --dxDrawText('E', s.x * 0.5 - dxGetTextWidth('E', 0.00052083333*s.x , 'pricedown')/2, s.y * 0.86, s.x, s.y, tocolor(r,g,b,255), 0.00052083333*s.x, 'pricedown', 'left','top',false,false,false,true)
        dxDrawText('E', s.x * 0.5 - dxGetTextWidth('E', 0.00052083333*s.x , 'pricedown')/2, s.y * 0.86, s.x, s.y, tocolor(70,70,70,255), 0.00052083333*s.x, 'pricedown', 'left','top',false,false,false,true)
    end
end
addEventHandler ( "onClientRender", root, render )