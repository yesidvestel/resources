Config.PermissionsType = 'licence' -- or licence ONLY CAN USE ONE

---@param If Config.PermissionsType = 'job' 
Config.Jobs = {
    'ambulance'
}

---@param If Config.PermissionsType = 'licence' 
Config.WhitelistedCreators = {
    "license:141d890765d2711fc128d4e2f06baf32c7faa8c7",
}

function CheckPlayerPermissions(id)
    local havePermissions = false
    if Config.PermissionsType == 'job' then ---@param For job permissions
        for o,p in ipairs(Config.Jobs) do
            print(p, PlayerJob(id))
            if p == PlayerJob(id) then 
                havePermissions = true
                break
            end
        end
    elseif Config.PermissionsType == 'licence' then 
        for o,p in ipairs(Config.WhitelistedCreators) do
            for k,v in ipairs(GetPlayerIdentifiers(id)) do
                if v == p then 
                    havePermissions = true
                    break
                end
            end
        end
    else 
        print('Bad config')
    end
    return havePermissions
end

