local paintsjobs = {}

local modelsByWeaponID = {
    [4] = 335,
    [22] = 346,
    [23] = 347,
    [24] = 348,
    [25] = 349,
    [26] = 350,
    [27] = 351,
    [28] = 352,
    [29] = 353,
    [32] = 372,
    [30] = 355,
    [34] = 358,
    [31] = 356,
}

local weaponSkins = {
    [335] = { -- knife
        remapLayer = "*kabar*",
        textures = {
            dxCreateTexture("knife/1.png"),
            dxCreateTexture("knife/2.png"),
            dxCreateTexture("knife/3.png"),
            dxCreateTexture("knife/4.png"),
            dxCreateTexture("knife/5.png"),
            dxCreateTexture("knife/6.png"),
        },
    },

    [348] = { -- deagle
        remapLayer = "*deagle*",
        textures = {
            dxCreateTexture("deagle/1.png"),
            dxCreateTexture("deagle/2.png"),
            dxCreateTexture("deagle/3.png"),
        },
    },

    [352] = { -- uzi
        remapLayer = "*9MM_C*",
        textures = {
            dxCreateTexture("uzi/1.png"),
            dxCreateTexture("uzi/2.png"),
            dxCreateTexture("uzi/3.png"),
            dxCreateTexture("uzi/4.png"),
        },
    },

    [353] = { -- p90
        remapLayer = "*p90TEX*",
        textures = {
            dxCreateTexture("p90/1.png"),
            dxCreateTexture("p90/2.png"),
            dxCreateTexture("p90/3.png"),
            dxCreateTexture("p90/4.png"),
            dxCreateTexture("p90/5.png"),
            dxCreateTexture("p90/6.png"),
            dxCreateTexture("p90/7.png"),
            dxCreateTexture("p90/8.png"),
            dxCreateTexture("p90/9.png"),
        },
    },

    [372] = { -- TEC9
        remapLayer = "*gun*",
        textures = {
            dxCreateTexture("tec/1.png"),
            dxCreateTexture("tec/2.png"),
            dxCreateTexture("tec/3.png"),
            dxCreateTexture("tec/4.png"),
        },
    },

    [355] = { -- AK47
        remapLayer = "*ak*",
        textures = {
            dxCreateTexture("ak/1.png"),
            dxCreateTexture("ak/2.png"),
            dxCreateTexture("ak/3.png"),
            dxCreateTexture("ak/4.png"),
            dxCreateTexture("ak/5.png"),
            dxCreateTexture("ak/6.png"),
            dxCreateTexture("ak/7.png"),
        },
    },

    [358] = { -- Sniper
        remapLayer = "*Bodybyaudi*",
        textures = {
            dxCreateTexture("sniper/1.png"),
            dxCreateTexture("sniper/2.png"),
        },
    },

    [356] = { -- m4
        remapLayer = "*1stpersonassualtcarbine*",
        textures = {
            dxCreateTexture("m4/1.png"),
            dxCreateTexture("m4/2.png"),
            dxCreateTexture("m4/3.png"),
            dxCreateTexture("m4/4.png"),
            dxCreateTexture("m4/5.png"),
            dxCreateTexture("m4/6.png"),
            dxCreateTexture("m4/7.png"),
            dxCreateTexture("m4/8.png"),
        },
    },
}

function applySkinForWeapon(weapon, id, isOBJ)
    if not id then return else id = tonumber(id) end

    local model = 0

    if isOBJ == true then
        model = getElementModel(weapon)

        if id == 0 then removeSkinFromWeapon(weapon) return end

        paintsjobs[weapon] = dxCreateShader("texturechanger.fx", 0, 100, false, "object")
    else
        model = modelsByWeaponID[getPlayerWeapon(weapon)] or 0
        if paintsjobs[weapon] then
            if id == 0 then

                if not model == 342 then
                  engineRemoveShaderFromWorldTexture(paintsjobs[weapon],  weaponSkins[model].remapLayer, weapon)
                end
                
                return
            end
        end
        paintsjobs[weapon] = dxCreateShader("texturechanger.fx", 0, 100, false, "ped")
    end

    if not weaponSkins[model] then return end

    if weaponSkins[model].textures[id] then
        dxSetShaderValue(paintsjobs[weapon], "TEXTURE", weaponSkins[model].textures[id])
        engineApplyShaderToWorldTexture(paintsjobs[weapon], weaponSkins[model].remapLayer, weapon)
    end
end

function removeSkinFromWeapon(wep, isOBJ, layer)
    if paintsjobs[wep] then
        local model = 0

        if isOBJ == true then
            model = getElementModel(wep)
            if weaponSkins[model] then
                engineRemoveShaderFromWorldTexture(paintsjobs[wep], weaponSkins[model].remapLayer, wep)
            end
        else
            --outputChatBox("asd")
            engineRemoveShaderFromWorldTexture(paintsjobs[wep],layer, wep)
        end
    end
end

addEventHandler("onClientElementStreamIn", root, function()
    local id = getElementData(source, "weapon:skinid") or 0

    if id > 0 then
        if getElementType(source) == "player" then
            applySkinForWeapon(source, id, false)
        else
            applySkinForWeapon(source, id, true)
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    local pj = (getElementData(source, "weapon:skinid") or 0)
    if pj > 0 then
        removeSkinFromWeapon(source, true)
    else
        removeSkinFromWeapon(source, true)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("object", root, true)) do
        local pj = (getElementData(v, "weapon:skinid") or 0)
        if pj > 0 then
            applySkinForWeapon(v, pj, true)
        else
            removeSkinFromWeapon(source, true)
        end
    end

    for k, v in ipairs(getElementsByType("player", root, true)) do
        local pj = (getElementData(v, "weapon:skinid") or 0)
        if pj > 0 then
            applySkinForWeapon(v, pj, false)
        else
            removeSkinFromWeapon(source, false)
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if data == "weapon:skinid" then
        if new >= 0 then
            if isElementStreamedIn(source) then
                applySkinForWeapon(source, new, false)
            end
        end
    end
end)
