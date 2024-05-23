local encoded = {}
local decoded = {}
local salt = "~>>ˇ~^˘°˛`_OriginalRP"

function encode(val)
    if not encoded[val] then
        local newVal = hash("sha512", salt .. val .. salt)
        local finalVal = hash("md5", salt .. newVal .. salt)
        
        encoded[val] = finalVal
    end
    
    local str = encoded[val]
    
    return str
end

function getTriggerName(res, str)
    local val
    
    if res then
        local resName = getResourceName(res)
        if resName then
            val = encode(str)
        end
    end
    
    return val
end