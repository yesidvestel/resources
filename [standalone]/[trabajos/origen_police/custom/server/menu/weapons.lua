local cachedWeapons = {}

function GetWeapons(citizenid, inventory)
    local status, retval = pcall(function()
        if cachedWeapons[citizenid] and os.time() - cachedWeapons[citizenid].time < 300 then
            return cachedWeapons[citizenid].weapons
        end
        local result = {}
        for k, v in pairs(inventory) do
            if v.type == "weapon" or string.find(v.name:lower(), "weapon") then
                local weaponData = GetItemMetadata(v)
                if IsWeaponBlacklistedForProfile(v.name:lower()) then
                    goto continue
                end
                result[#result + 1] = {
                    name = Config.WeaponsLabels[v.name:lower()] or v.name,
                    serie = weaponData.serie or weaponData.serial,
                }
            end
            ::continue::
        end
        cachedWeapons[citizenid] = {time = os.time(), weapons = result}
        return result
    end)

    if status then
        return retval
    else
        return {}
    end
end