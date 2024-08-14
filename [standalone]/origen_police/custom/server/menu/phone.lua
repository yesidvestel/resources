local cachedPhoneNumbers = {}

function GetPhoneFromIdentifier(identifier)
    local status, data = pcall(function()
        if not identifier then return 'XXXXXXXX' end
        if cachedPhoneNumbers[identifier] and os.time() - cachedPhoneNumbers[identifier].time < 300 then
            return cachedPhoneNumbers[identifier].phone
        end
        if Config.Framework == "esx" then
            if Config.Phone == "default" or Config.Phone == 'qs-smartphone' or Config.Phone == 'qs-smartphone-pro' then 
                local data = MySQL.awaitPrepare("SELECT phone_number FROM users WHERE identifier = ?", {identifier}) or 'XXXXXXXX'
                cachedPhoneNumbers[identifier] = {time = os.time(), phone = data}
                return data
            end
        elseif Config.Framework == "qbcore" then
            if Config.Phone == "default" or Config.Phone == 'qs-smartphone' or Config.Phone == 'qs-smartphone-pro' then 
                local data = MySQL.awaitPrepare("SELECT charinfo FROM players WHERE citizenid = ?", {identifier})
                cachedPhoneNumbers[identifier] = {time = os.time(), phone = data == nil and 'XXXXXXXX' or json.decode(data).phone}
                return data == nil and 'XXXXXXXX' or json.decode(data).phone    
            end
        else
            -- Add custom phone number handling
        end

        if Config.Phone == 'lb-phone' then 
            local data = MySQL.awaitPrepare("SELECT phone_number FROM phone_phones WHERE id = ?", {identifier})
            local phone = data or 'XXXXXXXX'
            cachedPhoneNumbers[identifier] = {time = os.time(), phone = phone}
            return phone
        else
            -- Add custom phone number handling
        end
    end) 

    if status then
        return data
    end
    return 'XXXXXXXX'
end

exports("GetPhoneFromIdentifier", GetPhoneFromIdentifier)