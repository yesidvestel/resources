function getQueryAndDefaultPhone(phoneType)
    local query, defaultPhone = nil, 'XXXXXXXX'
    if phoneType == 'default' then
        query = "SELECT phone_number FROM users WHERE identifier = ?"
    elseif phoneType == 'qs-smartphone' then
        query = "SELECT charinfo FROM users WHERE identifier = ?"
    elseif phoneType == 'lb-phone' then 
        query = "SELECT phone_number FROM phone_phones WHERE id = ?"
    else
        -- Add custom phone number handling
        return
    end
    return query, defaultPhone
end