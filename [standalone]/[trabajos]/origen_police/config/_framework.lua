Config = {}

Config.Framework = "auto" -- The name of the framework: auto | esx | qbcore | ...
Config.MySQLSystem = "oxmysql" -- icmysql, oxmysql
Config.DatabaseStructureCheck = true -- If you want the script to check the tables structure to check if you're missing some columns
Config.CustomNotify = false -- If you want to use your own notify system set this to true and edit the code in origen_police/custom/client/client.lua
Config.Language = "es" -- core(take the language of the core configured in the server.cfg) | en | es | fr | it
Config.autoSetItems = true -- To add items automaticly via exports ['qb-core']:AddItems
Config.VoiceSystem = "pma-voice" -- pma-voice, saltychat(IN DEVELOPMENT, ISSUES ARE EXPECTED, NO SUPPORT FOR THIS YET)
Config.fixQS = false -- false to use the framework metadata system only availabel for ESX 
Config.Inventory = "qb-inventory" -- auto(detect the resource) | origen_inventory | qb-inventory | new-qb-inventory | qs-inventory | ox_inventory | ls-inventory | codem-inventory | core_inventory
Config.OxLibMenu = true -- Use ox_lib context menu
Config.RecieveAlwaysAlerts = true -- if it is false, the alert first will be send to the dispatch if it's open, if it's closed the alert will be send to the mini dispatch, if it's true the alert will be send to the dispatch and mini dispatch at the same time
Config.DispatchRedirect = false -- If it's true the alerts first will be send to the dispatch, then the dispatch manager will redirect the alert to other units, if it's false the alerts will be send directly to all the units
Config.Debug = true -- Enable or disable debug mode, this include the prints that you are going to see in F8 and Server Consolle
Config.PoliceJobName = "police" -- You can change this to your police job name, some people use lspd, sheriff as job name
Config.Clothing = "auto" -- auto(detect the resource) | illenium-appearance, qb-clothing, fivem-appearance, esx_skin, codem-appearance
Config.Phone = "default" -- auto(detect the resource) | default | qs-smartphone | qs-smartphone-pro | lb-phone
Config.NeedRadioForDispatch = true -- True: only players with radio will have access to dispatch, False: all players will have access to dispatch
Config.EvidenceDrawDistance = 20.0 -- The distance that the evidence will be drawn
Config.ShootAlert = true -- Enable shoot alert
Config.ConfiscateSystem = true -- To enable or disable the confiscate system
Config.AutoSetCriminalClothe = true -- To enable or disable the auto set criminal clothes when player is in jail
Config.DisplayPlateOnVehicleAlerts = true -- To enable or disable the display of the plate in the vehicle alerts
Config.ShowCurrentStreet = true -- Show at the top of the screen the current street that the police is in
Config.ChangeMinimapSize = true -- Allows resizing of the minimap 
Config.HeatMapAlerts = true -- Enable or disable the heat map alerts in the dispatch
Config.CheckVersions = true -- Check if there's a new version of the script

-- NO TOQUES ARRIBA;

exports("GetConfig", function(key)
    return Config[key]
end)

function debuger(...)
    if Config.Debug then
        print ('[^5Origen Police^0]', ...)
    end
end

if Config.Framework == "auto" then
    Config.Framework = GetResourceState("qb-core") == "started" and "qbcore" or "esx"
end

Config.Translations = Translations
Config.LogsTranslations = LogsTranslations
MySQL = {}

if Config.Language == "core" then 
    Config.Language = GetConvar(Config.Framework == "esx" and "esx:locale" or "qb_locale", "en"):lower()
    -- check if contain "-" and get the first part
    if Config.Language:find("-") then
        Config.Language = Config.Language:sub(1, Config.Language:find("-") - 1)
    end

    if Config.Language ~= "en" and Config.Language ~= "es" and Config.Language ~= "fr" and Config.Language ~= "it" then
        Config.Language = "en"
    end
end

local supportedInventories = {
    {name = "origen_inventory", resource = "origen_inventory", upperVersion=nil},
    {name = "qb-inventory", resource = "qb-inventory", upperVersion=nil},
    {name = "new-qb-inventory", resource = "qb-inventory", upperVersion={2, 0, 0}},
    {name = "qs-inventory", resource = "qs-inventory", upperVersion=nil},
    {name = "ox_inventory", resource = "ox_inventory", upperVersion=nil},
    {name = "ls-inventory", resource = "ls-inventory", upperVersion=nil},
    {name = "codem-inventory", resource = "codem-inventory", upperVersion=nil},
    {name = "core_inventory", resource = "core_inventory", upperVersion=nil},
}

local supportedClothings = {
    {name = "illenium-appearance", resource = "illenium-appearance", upperVersion=nil},
    {name = "qb-clothing", resource = "qb-clothing", upperVersion=nil},
    {name = "fivem-appearance", resource = "fivem-appearance", upperVersion=nil},
    {name = "esx_skin", resource = "esx_skin", upperVersion=nil},
    {name = "codem-appearance", resource = "codem-appearance", upperVersion=nil},
}

local supportedPhones = {
    {name = "qs-smartphone", resource = "qs-smartphone", upperVersion=nil},
    {name = "qs-smartphone-pro", resource = "qs-smartphone-pro", upperVersion=nil},
    {name = "lb-phone", resource = "lb-phone", upperVersion=nil},
}

local function checkResource(configKey, supportedResources, defaultValue)
    for _, v in pairs(supportedResources) do
        if GetResourceState(v.resource) == "started" then
            if v.upperVersion then
                local version = GetResourceMetadata(v.resource, "version", 0)
                local versionTable = {}
                for w in string.gmatch(version, "%d+") do
                    table.insert(versionTable, tonumber(w))
                end
                if versionTable[1] >= v.upperVersion[1] and versionTable[2] >= v.upperVersion[2] and versionTable[3] >= v.upperVersion[3] then
                    Config[configKey] = v.name
                    return
                end
            else
                Config[configKey] = v.name
                return
            end
        end
    end
    if defaultValue then
        Config[configKey] = defaultValue
    else
        print("^1[Origen Police]^0 Couldn't find any supported " .. configKey .. " system, please set it manually in config/_framework.lua")
    end
end

if Config.Inventory == "auto" then 
    checkResource("Inventory", supportedInventories)
end

if Config.Clothing == "auto" then 
    checkResource("Clothing", supportedClothings)
end

if Config.Phone == "auto" then 
    checkResource("Phone", supportedPhones)
end