businesses = {
    stores = {
    {x = 2006.27063, y = -2405.48657, z = 13.54688, rx = 0, ry = 0, rz= 0, name = 'Törös Áron'},
    },
    industries = {},
    types = {
        { name = 'Farm', description = 'Itt kistesű áronokat vagy buzát tenyészthetsz, but same things', price = { money = 20000, pp = 1500}},
        { name = 'Vágóhíd', description = 'Álltkak feldolgozasko', price = { money = 30000, pp = 2000}},
        { name = 'Fa feldolgozó', description = 'Fa feldolgozás és termékek készitése', price = { money = 50000, pp = 3000}},
    },
}


function loadScript()
--assd

end


function loadIndustries()
    --asda
end

function createIndustrie(id, x, y, z, rx, ry, rz, owner, type, content)
    if (id and x and y and z and rx and ry and rz and owner) then
        if (owner == 0) then
            businesses.industries[id] = {
                baseObject = createObject(settings.objects.industri, x, y, z, rx, ry+24, rz),
                id = id,
                owner = owner,
                marker = createMarker ( x, y, z, "cylinder", 0.7, settings.marker.forsale.r, settings.marker.forsale.g, settings.marker.forsale.b,  150 ),
                content = {},
                loaderbay = createColSphere ( x , y, z, 3)
            }
            attachElements(businesses.industries[id].marker,businesses.industries[id].baseObject, 3, 12.8, -1.2, 0, -24)
            attachElements(businesses.industries[id].loaderbay,businesses.industries[id].baseObject, -2, 0, -2, 0, 0, 50)
        else
            businesses.industries[id] = {
                baseObject = createObject(settings.objects.industri, x, y, z, rx, ry+24, rz),
                id = id,
                owner = owner,
                marker = createMarker ( x, y, z, "cylinder", 0.7, settings.marker.owned.r, settings.marker.owned.g, settings.marker.owned.b,  150 ),
                content = content,
                loaderbay = createColSphere ( x , y, z, 3)
            }
            attachElements(businesses.industries[id].marker,businesses.industries[id].baseObject, 3, 12.8, -1.2, 0, -24)
            attachElements(businesses.industries[id].loaderbay,businesses.industries[id].baseObject, -2, 0, -2, 0, 0, 50)
        end
    end
end

createIndustrie(1, 2383.4150390625, -642.40307617188, 128.55747833252, 0, 0, -90, 1, 0, '{}')

