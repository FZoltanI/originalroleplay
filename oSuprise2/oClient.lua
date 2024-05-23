local postable = {}
effects = {}
id = 1

txd_floors = engineLoadTXD ( 'assets/'..settings.modelname..".txd" )
engineImportTXD ( txd_floors, 3781 )
dff_floors = engineLoadDFF ( 'assets/'..settings.modelname..".dff" )
engineReplaceModel ( dff_floors, 3781 )

local teszt = createObject(3781,1533.0506591797, -1348.6041259766, 328.67)
setObjectScale ( teszt, 0.3)

--12,20,38,62

local effectNames = {
    "blood_heli","boat_prop","camflash","carwashspray","cement","cloudfast","coke_puff","coke_trail","cigarette_smoke",
    "explosion_barrel","explosion_crate","explosion_door","exhale","explosion_fuel_car","explosion_large","explosion_medium",
    "explosion_molotov","explosion_small","explosion_tiny","extinguisher","flame","fire","fire_med","fire_large","flamethrower",
    "fire_bike","fire_car","gunflash","gunsmoke","insects","heli_dust","jetpack","jetthrust","nitro","molotov_flame",
    "overheat_car","overheat_car_electric","prt_blood","prt_boatsplash","prt_bubble","prt_cardebris","prt_collisionsmoke",
    "prt_glass","prt_gunshell","prt_sand","prt_sand2","prt_smokeII_3_expand","prt_smoke_huge","prt_spark","prt_spark_2",
    "prt_splash","prt_wake","prt_watersplash","prt_wheeldirt","petrolcan","puke","riot_smoke","spraycan","smoke30lit","smoke30m",
    "smoke50lit","shootlight","smoke_flare","tank_fire","teargas","teargasAD","tree_hit_fir","tree_hit_palm","vent","vent2",
    "water_hydrant","water_ripples","water_speed","water_splash","water_splash_big","water_splsh_sml","water_swim","waterfall_end",
    "water_fnt_tme","water_fountain","wallbust","WS_factorysmoke"
    }
    
    addCommandHandler("createEffect", function(_, effectIndex)
       effectIndex = tonumber(effectIndex)
       if effectIndex and type(effectIndex) == "number" then
          if effectIndex > 0 and effectIndex <= #effectNames then
             createEffect(effectNames[effectIndex], Vector3( getElementPosition( getLocalPlayer() ) ), 0, 0, 0)
          end
       end
    end)

function suprisePos()
    px,py,pz = getElementPosition(localPlayer)
    postable[id] = {x = px, y = py, z = pz}
    id = id + 1
end
addCommandHandler ( "suppos", suprisePos )

function tablePos()
    for k, v in ipairs(postable) do 
        outputChatBox('{ x = '..v.x..', y = '..v.y..', z = '..v.z..'},')
    end
end
addCommandHandler ( "tpos", tablePos )

addEventHandler( "onClientElementStreamIn", root,
    function ( )
        if ( getElementType( source ) == "object" ) then
            if (getElementData(source, 'obj:suprise') and getElementData(source,'obj:id')) then
                local id = tonumber(getElementData(source,'obj:id'))
                effects[id] = {
                    effect = createEffect('extinguisher', Vector3(getElementPosition(source)), 0,0,0),
                    object = createObject(3013,Vector3(getElementPosition(source))),
                }
                setObjectScale ( effects[id].object, 0.9)
                setElementData(effects[id].object, 'obj:supclick', true)
                setElementData(effects[id].object, 'obj:supid', id)
            end 
        end
    end
);

addEventHandler( "onClientElementStreamOut", root,
    function ( )
        if ( getElementType( source ) == "object" ) then
            if (getElementData(source, 'obj:suprise') and getElementData(source,'obj:id')) then
                local id = tonumber(getElementData(source,'obj:id'))
                destroyElement(effects[id].effect)
                destroyElement(effects[id].object)
            end 
        end
    end
);

addEventHandler ( "onClientClick", getRootElement(),
    function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
        if ( clickedElement and state == 'down' and button == 'left' ) then
            if getElementData(clickedElement,'obj:supclick') then
                outputChatBox('pickup doboz'..state..' button'..button)
            end
        end
    end
);
