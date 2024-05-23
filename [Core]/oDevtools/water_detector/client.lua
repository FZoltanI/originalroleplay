local scripts = {}
local count = {}


addEvent("sendResources", true)
addEventHandler("sendResources", root, function(scripts)    
    for k, v in pairs(scripts) do
        local thisResourceDynamicRoot = getResourceDynamicElementRoot(getResourceFromName(v))

        local water = 0
        for k, v in ipairs(getElementsByType( 'water', thisResourceDynamicRoot )) do 
            water = water + 1
        end

        if water > 0 then 
            count[v] = water
        end
    end

    print(toJSON(count))
end)