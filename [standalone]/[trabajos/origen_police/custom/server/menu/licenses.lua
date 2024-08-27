cachedLicenses = {}

function GetLicensesByIdentifier(cid)
    local status, data = pcall(function()
        if cachedLicenses[cid] and os.time() - cachedLicenses[cid].time < 300 then
            return cachedLicenses[cid].licenses
        end
        if Config.UseDefaultSystem then
            if Config.Framework == "esx" then 
                local result = MySQL.awaitQuery("SELECT ul.*, l.label FROM user_licenses AS ul INNER JOIN licenses AS l ON ul.type = l.type WHERE ul.owner = ?", {cid});
                local retval = {}
                for i = 1, #result do 
                    retval[i] = {
                        name = result[i].label,
                        type = result[i].type,
                        expire = Config.DefaultExpireTime
                    }
                end
                cachedLicenses[cid] = {time = os.time(), licenses = retval}
                return retval;
            elseif Config.Framework == "qbcore" then
                local licenses = {}
                local labels = Config.Licenses
                local Player = Framework.Functions.GetPlayerByCitizenId(cid)
                if Player then
                    for license, active in pairs(Player.PlayerData.metadata.licences) do
                        if active then
                            licenses[#licenses+1] = {
                                name = labels[license] or license,
                                type = license,
                                expire = Config.DefaultExpireTime
                            }
                        end
                    end
                else
                    Player = Framework.Functions.GetOfflinePlayerByCitizenId(cid)
                    if Player then
                        for license, active in pairs(Player.PlayerData.metadata.licences) do
                            if active then
                                licenses[#licenses+1] = {
                                    name = labels[license] or license,
                                    type = license,
                                    expire = Config.DefaultExpireTime
                                }
                            end
                        end
                    end
                end
                cachedLicenses[cid] = {time = os.time(), licenses = licenses}
                return licenses
            end
        else
            -- Add custom license handling
            return {}
        end
    end) 

    if status then
        return data
    end
    return {}
end

-- Only if you want to use your own system, make sure to disable Config.UseDefaultSystem of config/licenses.lua
function GetLicenses()
    return {}
end

function AddLicense(source, identifier, type, cb)

end

function RemoveLicense(source, identifier, type, cb)

end

exports('GetLicensesByIdentifier', GetLicensesByIdentifier)
exports('AddLicense', AddLicense)
exports('RemoveLicense', RemoveLicense)