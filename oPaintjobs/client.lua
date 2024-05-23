local paintsjobs = {}
local core = exports.oCore

local shader_data = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

local textures = {
    --[[[545] = {
        dxCreateTexture("paintjobs/545/1.png"),
        dxCreateTexture("paintjobs/545/2.png"),
        dxCreateTexture("paintjobs/545/3.png"),
    },
    [411] = {
        dxCreateTexture("paintjobs/411/1.png"),
    },
    [602] = {
        dxCreateTexture("paintjobs/602/1.png"),
        dxCreateTexture("paintjobs/602/2.png"),
        dxCreateTexture("paintjobs/602/3.png"),
        dxCreateTexture("paintjobs/602/4.png"),
    },

    [426] = {
        dxCreateTexture("paintjobs/426/1.png"), 
        dxCreateTexture("paintjobs/426/2.png"), 
        dxCreateTexture("paintjobs/426/3.png"), 
    },

    [529] = {
        dxCreateTexture("paintjobs/529/1.png"), 
        dxCreateTexture("paintjobs/529/2.png"), 
        dxCreateTexture("paintjobs/529/3.png"), 
    },

    [445] = {
        dxCreateTexture("paintjobs/445/1.png"), 
        dxCreateTexture("paintjobs/445/2.png"), 
        dxCreateTexture("paintjobs/445/3.png"), 
        dxCreateTexture("paintjobs/445/4.png"), 
        dxCreateTexture("paintjobs/445/5.png"),
        dxCreateTexture("paintjobs/445/6.png"),
        dxCreateTexture("paintjobs/445/7.png"),
        dxCreateTexture("paintjobs/445/8.png"),
        dxCreateTexture("paintjobs/445/9.png"),
        dxCreateTexture("paintjobs/445/10.png"),
        dxCreateTexture("paintjobs/445/11.png"),
        dxCreateTexture("paintjobs/445/12.png"),
    },

    [451] = {
        dxCreateTexture("paintjobs/451/1.png"), 
        dxCreateTexture("paintjobs/451/2.png"), 
        dxCreateTexture("paintjobs/451/3.png"), 
        dxCreateTexture("paintjobs/451/4.png"),
    },

    [439] = {
        dxCreateTexture("paintjobs/439/1.png"), 
        dxCreateTexture("paintjobs/439/2.png"), 
        dxCreateTexture("paintjobs/439/3.png"), 
        dxCreateTexture("paintjobs/439/4.png"),
    },

    [483] = {
        dxCreateTexture("paintjobs/483/1.png"), 
        dxCreateTexture("paintjobs/483/2.png"), 
        dxCreateTexture("paintjobs/483/3.png"), 
    },

    [558] = {
        dxCreateTexture("paintjobs/558/1.png"), 
        dxCreateTexture("paintjobs/558/2.png"), 
        dxCreateTexture("paintjobs/558/3.png"), 
        dxCreateTexture("paintjobs/558/4.png"), 
        dxCreateTexture("paintjobs/558/5.png"), 
        dxCreateTexture("paintjobs/558/6.png"), 
        dxCreateTexture("paintjobs/558/7.png"), 
        dxCreateTexture("paintjobs/558/8.png"), 
        dxCreateTexture("paintjobs/558/9.png"), 
        dxCreateTexture("paintjobs/558/10.png"), 
    },

    [527] = {
        dxCreateTexture("paintjobs/527/1.png"), 
        dxCreateTexture("paintjobs/527/2.png"), 
        dxCreateTexture("paintjobs/527/3.png"), 
        dxCreateTexture("paintjobs/527/4.png"), 
    },
    
    [559] = {
        dxCreateTexture("paintjobs/559/1.png"), 
        dxCreateTexture("paintjobs/559/2.png"), 
        dxCreateTexture("paintjobs/559/3.png"), 
        dxCreateTexture("paintjobs/559/4.png"), 
        dxCreateTexture("paintjobs/559/5.png"), 
    },

    [536] = {
        dxCreateTexture("paintjobs/536/1.png"), 
        dxCreateTexture("paintjobs/536/2.png"), 
        dxCreateTexture("paintjobs/536/3.png"), 
        dxCreateTexture("paintjobs/536/4.png"), 
    },

    [534] = {
        dxCreateTexture("paintjobs/534/1.png"), 
        dxCreateTexture("paintjobs/534/2.png"), 
        dxCreateTexture("paintjobs/534/3.png"), 
        dxCreateTexture("paintjobs/534/4.png"), 
    },

    [562] = {
        dxCreateTexture("paintjobs/562/1.png"), 
        dxCreateTexture("paintjobs/562/2.png"), 
        dxCreateTexture("paintjobs/562/3.png"), 
    },

    [598] = {
        dxCreateTexture("paintjobs/598/1.png"), 
        dxCreateTexture("paintjobs/598/2.png"), 
        dxCreateTexture("paintjobs/598/3.png"), 
    },

    [599] = {
        dxCreateTexture("paintjobs/599/1.png"), 
        dxCreateTexture("paintjobs/599/2.png"),
        dxCreateTexture("paintjobs/599/3.png"), 
    },

    [597] = {
        dxCreateTexture("paintjobs/597/1.png"), 
        dxCreateTexture("paintjobs/597/2.png"), 
    },

    [596] = {
        dxCreateTexture("paintjobs/596/1.png"), 
    },

    [525] = {
        dxCreateTexture("paintjobs/525/1.png"), 
        dxCreateTexture("paintjobs/525/2.png"),
        dxCreateTexture("paintjobs/525/3.png"),  
    },

    [480] = {
        dxCreateTexture("paintjobs/480/1.png"), 
        dxCreateTexture("paintjobs/480/2.png"), 
        dxCreateTexture("paintjobs/480/3.png"), 
        dxCreateTexture("paintjobs/480/4.png"), 
        dxCreateTexture("paintjobs/480/5.png"), 
        dxCreateTexture("paintjobs/480/6.png"), 
        dxCreateTexture("paintjobs/480/7.png"), 
    },
    
    [560] = {
        dxCreateTexture("paintjobs/560/1.png"), 
        dxCreateTexture("paintjobs/560/2.png"), 
        dxCreateTexture("paintjobs/560/3.png"), 
        dxCreateTexture("paintjobs/560/4.png"), 
    },

    [540] = {
        dxCreateTexture("paintjobs/540/1.png"), 
        dxCreateTexture("paintjobs/540/2.png"), 
        dxCreateTexture("paintjobs/540/3.png"), 
        dxCreateTexture("paintjobs/540/4.png"), 
    },

    [579] = {
        dxCreateTexture("paintjobs/579/1.png"), 
        dxCreateTexture("paintjobs/579/2.png"), 
        dxCreateTexture("paintjobs/579/3.png"), 
    },

    [479] = {
        dxCreateTexture("paintjobs/479/1.png"), 
        dxCreateTexture("paintjobs/479/2.png"), 
        dxCreateTexture("paintjobs/479/3.png"), 
        dxCreateTexture("paintjobs/479/4.png"), 
        dxCreateTexture("paintjobs/479/5.png"), 
        dxCreateTexture("paintjobs/479/6.png"), 
        dxCreateTexture("paintjobs/479/7.png"), 
        dxCreateTexture("paintjobs/479/8.png"), 
    },]]
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	shader = dxCreateShader(shader_data,0,100,false, "vehicle")
end)

addCommandHandler("setpj", function(cmd, num)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        local num = tonumber(num)
        local veh = getPedOccupiedVehicle(localPlayer)
        if not veh then return end
        if num then
            if not isElement(shader) then return end

                if fileExists("paintjobs/"..getElementModel(veh).."/"..num..".dds") then 
                    setElementData(veh, "veh:paintjob", num)

                    outputChatBox(core:getServerPrefix("green-dark", "Paintjob", 2).."Paintjob sikeresen megváltoztatva!", 255, 255, 255, true)
                    triggerServerEvent("paintjob > sendAdminLog", resourceRoot, getPedOccupiedVehicle(localPlayer))
                elseif num == 0 then 
                    setElementData(veh, "veh:paintjob", num)

                    outputChatBox(core:getServerPrefix("green-dark", "Paintjob", 2).."Paintjob sikeresen megváltoztatva!", 255, 255, 255, true)
                    triggerServerEvent("paintjob > sendAdminLog", resourceRoot, getPedOccupiedVehicle(localPlayer))
                else 
                    outputChatBox(core:getServerPrefix("red-dark", "Paintjob", 2).."Erre a járműre nincsen ilyen azonosítóval rendelkező paintjob!", 255, 255, 255, true)
                end
           
            --engineApplyShaderToWorldTexture(shader, "*")
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Num]", 255, 255, 255, true)
        end
    end
end)

local customTextures = {
    [426] = "*moket2*",
    [562] = "*remapelegybody128*",
    [598] = "*LAPD*",
    [490] = "*LAPD*",
    [451] = "*remap_F4087*",
    [559] = "*remap_supra92*",
    [536] = "*remap_coronet67*",
    [579] = "*remapsrt8*",
    [479] = "*remap_a45_body*",
    [597] = "*livery*",
    [527] = "*remap_quattro82*",
    [529] = "*remapgmc*",
    [525] = "*towlogo*",
    [416] = "*remapsprinterbody512*",
}

function applyPaintjobToVehicle(veh, id)
    if not id then return else id = tonumber(id) end

    if id == 0 then removePaintjobFromVehicle(veh) return end

    if not paintsjobs[veh] then paintsjobs[veh] = dxCreateShader(shader_data, 0, 100, false, "vehicle") end
    
    local model = getElementModel(veh)
    if fileExists("paintjobs/"..model.."/"..id..".dds") then
        if not textures[model] then 
            textures[model] = {}
        end

        if not textures[model][id] then 
            
                textures[model][id] = dxCreateTexture("paintjobs/"..model.."/"..id..".dds", "dxt1", true, "clamp")
                dxSetShaderValue(paintsjobs[veh], "tex", textures[model][id])
            --end
        end

        

        if customTextures[model] then 
            engineApplyShaderToWorldTexture(paintsjobs[veh], customTextures[model], veh)
        else
            engineApplyShaderToWorldTexture(paintsjobs[veh], "*remap*", veh)
        end

        
        destroyElement(textures[model][id])
        textures[model][id] = false
    end
end

function removePaintjobFromVehicle(veh)
    if paintsjobs[veh] then
        if isElement(paintsjobs[veh]) then 
            destroyElement(paintsjobs[veh])
        end
        paintsjobs[veh] = nil
    end
end

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if data == "veh:paintjob" then 
        if new > 0 then 
            if isElementStreamedIn(source) then
                applyPaintjobToVehicle(source, new)
            end
        else
            removePaintjobFromVehicle(source)
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    local pj = (getElementData(source, "veh:paintjob") or 0)
    if pj > 0 then 
        applyPaintjobToVehicle(source, pj)
    else
        removePaintjobFromVehicle(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    local pj = (getElementData(source, "veh:paintjob") or 0)
    if pj > 0 then 
        removePaintjobFromVehicle(source)
    else
        removePaintjobFromVehicle(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("vehicle", root, true)) do 
        local pj = (getElementData(v, "veh:paintjob") or 0)
        if pj > 0 then 
            applyPaintjobToVehicle(v, pj)
        else 
            removePaintjobFromVehicle(source)
        end 
    end
end)