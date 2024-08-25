local cachedProperties = {}

function GetCitizenProperties(citizenid)
    -- The excepted result should be an array with the name of the property may be as label to show in the UI
    -- Example: return {"Property 1", "Property 2"}
    local status, data = pcall(function()
        if cachedProperties[citizenid] and os.time() - cachedProperties[citizenid].time < 300 then
            return cachedProperties[citizenid].properties
        end
        local result = {}
        if Config.Framework == "qbcore" then
            result = MySQL.awaitQuery("SELECT label FROM apartments WHERE citizenid = @citizenid", {citizenid = citizenid}) 
        else
            result = MySQL.awaitQuery("SELECT name FROM owned_properties WHERE owner = @citizenid", {citizenid = citizenid})
        end
        cachedProperties[citizenid] = {time = os.time(), properties = result}
        return result
    end) 

    if status then
        local properties = {}
        for k, v in pairs(data) do
            table.insert(properties, v.name or v.label)
        end 
        return properties
    end
    return {}
end