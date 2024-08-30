Config = {}

Config.Framework = 'auto' -- auto, qbcore, esx

Config.MySQLSystem = 'oxmysql' -- oxmysql or icmysql

Config.Language = 'es'

Config.Debug = true

Config.Command = {
    cmd = 'managementquests',
    description = 'Open quests management',
    permission = 'god',
}

Config.DatabaseStructureCheck = true

Config.CheckVersions = true

Config.CustomNotify = false

Config.Inventory = 'auto' -- origen_inventory, qb-inventory, qs-inventory, ox_inventory

Config.CustomTimeMision = 24 -- In hours

Config.BetaMode = false  -- dont touch!!!!!!

---------------------------------------------------------
--DO NOT TOUCH THIS IF YOU DONT KNOW WHAT YOU ARE DOING--
---------------------------------------------------------

if Config.Framework == 'auto' then
    Config.Framework = GetResourceState('qb-core') ~= 'missing' and 'qbcore' or 'esx'
end

if Config.Inventory == 'auto' then
    local availableInventorys = {'origen_inventory', 'qs-inventory', 'ox_inventory', 'qb-inventory'}
    local inventory = 'none'
    for _, resource in ipairs(availableInventorys) do
        if GetResourceState(resource) == 'starting' or GetResourceState(resource) == 'started' then
            inventory = resource
            break
        end
    end
    Config.Inventory = inventory
end


function debuger(...)
    if Config.Debug then
        print ('[^6Origen Quests^0]', ...)
    end
end

exports('GetConfig', function(key)
    return Config[key]
end)


Config.Translations = Translations
Config.LogsTranslations = LogsTranslations
MySQL = {}