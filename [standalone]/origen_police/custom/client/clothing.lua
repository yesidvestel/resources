function OpenClothing(stationName)
    if Config.Clothing == "illenium-appearance" or Config.Clothing == "fivem-appearance" then
        local Player = FW_GetPlayerData(false)
        local retval = {}
        for k, v in pairs(Config.Outfits[GetGender()]) do
            local added = false
            if v.grades == nil then
                table.insert(retval, v)
            else
                local canBeAdded1 = false
                local canBeAdded2 = false
                local canBeAdded3 = false
                for z, u in pairs(v.grades) do 
                    if u == Player.job.grade.level then
                        canBeAdded1 = true
                    end
                end
                for z, u in pairs(v.job) do 
                    if u == Player.job.name then
                        canBeAdded2 = true
                    end
                end
                for z, u in pairs(v.maps) do
                    if u == stationName then
                        canBeAdded3 = true
                    end
                end
                if canBeAdded1 and canBeAdded2 and canBeAdded3 then
                    table.insert(retval, v)
                    added = true
                end
            end
        end
        if #retval == 0 then
            debuger("No outfits available for job: "..Player.job.name..", grade: "..Player.job.grade.level.." and map: "..stationName..".")
            debuger("To fix this, add an outfit to the config file with the correct job, grade and map.")
            return
        end
        TriggerEvent(Config.Clothing..":client:openJobOutfitsMenu", retval)
        return
    elseif Config.Clothing == "qb-clothing" then
        local Player = FW_GetPlayerData(false)
        exports["qb-clothing"]:getOutfits(Player.job.grade.level, Config.Outfits)
        return
    elseif Config.Clothing == "codem-appearance" then
        exports['codem-appearance']:OpenMenu("job")
        return
    end
    TriggerEvent('esx_skin:openRestrictedMenu', nil, nil, {
        'tshirt_1', 'tshirt_2',
		'torso_1', 'torso_2',
		'decals_1', 'decals_2',
		'arms',	'arms_2',
		'pants_1', 'pants_2',
		'shoes_1', 'shoes_2',
        'bags_1', 'bags_2',
		'chain_1', 'chain_2',
		'helmet_1', 'helmet_2',
		'glasses_1', 'glasses_2',
		'watches_1', 'watches_2'
    })
end

function SetCriminalClothes(gender, PlayerData)
    if gender then
        local ped = PlayerPedId()
        if type(PlayerData.metadata.criminalclothe) == "table" then
            if Config.Clothing == "qb-clothing" then
                TriggerEvent("qb-clothing:client:loadOutfit", {
                    outfitData = PlayerData.metadata.criminalclothe
                })
            elseif Config.Clothing == "illenium-appearance" then
                exports["illenium-appearance"]:setPedAppearance(ped, PlayerData.metadata.criminalclothe)
            elseif Config.Clothing == "fivem-appearance" then
                exports["fivem-appearance"]:setPedAppearance(ped, PlayerData.metadata.criminalclothe)
            end
            TriggerServerEvent("origen_police:SetMetaData", "criminalclothe", 0)
            ShowNotification(Config.Translations.ChangedCloth)
        else
            if Public.CriminalClothe and Public.CriminalClothe[gender] then
                if Config.Clothing == "qb-clothing" then
                    local skin = {}
                    local success, result = pcall(function()
                        skin = exports["qb-clothing"]:GetSkinData()
                    end)
                    if not success then
                        return debuger("[^1ERROR^0] The export (GetSkinData) does not exist in your qb-clothing resource.")
                    end
                    TriggerServerEvent("origen_police:SetMetaData", "criminalclothe", skin)
                    TriggerEvent("qb-clothing:client:loadOutfit", {
                        outfitData = Public.CriminalClothe[gender]
                    })
                elseif Config.Clothing == "illenium-appearance" then
                    TriggerServerEvent("origen_police:SetMetaData", "criminalclothe", exports["illenium-appearance"]:getPedAppearance(ped))
                    exports["illenium-appearance"]:setPedAppearance(ped, Public.CriminalClothe[gender])
                elseif Config.Clothing == "fivem-appearance" then 
                    TriggerServerEvent("origen_police:SetMetaData", "criminalclothe", exports["fivem-appearance"]:getPedAppearance(ped))
                    exports["fivem-appearance"]:setPedAppearance(ped, Public.CriminalClothe[gender])
                end

                ShowNotification(Config.Translations.ChangedCloth)
            else
                ShowNotification(Config.Translations.NoFederalClothAvailable)
            end
        end
    else
        ShowNotification(Config.Translations.PedCantChangeCloth)
    end
end