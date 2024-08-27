local nationalityDetected = true
local cachedNationality = {}

function GetPlayerNationality(identifier)
    if not nationalityDetected then return 'XXXXXXXX' end
    local status, data = pcall(function()
        if not identifier then return 'XXXXXXXXX' end
        if cachedNationality[identifier] then
            return cachedNationality[identifier]
        end

        local data = MySQL.awaitPrepare("SELECT nationality FROM users WHERE identifier = ?", {identifier})
        cachedNationality[identifier] = data
        return data
    end)
    if not status then
        nationalityDetected = false
        return 'XXXXXXXX'
    end
    return data
end

exports("GetPlayerNationality", GetPlayerNationality)