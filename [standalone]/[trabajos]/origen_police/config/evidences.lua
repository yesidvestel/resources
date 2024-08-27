Config.EvidenceSystem = true

Config.Evidences = {
    ["Shoot"] = {
        sprite = 41,
        color = { r = 255, g = 255, b = 100 },
        item = "evidence_a",
        anim = false,
    },
    ["Impact"] = {
        sprite = 6,
        color = { r = 255, g = 128, b = 0 },
        item = "evidence_n",
        anim = true,
    },
    ["BloodRest"] = {
        sprite = 20,
        color = { r = 225, g = 0, b = 0 },
        item = "evidence_r",
        anim = true,
    },
    ["NpcBlood"] = {
        sprite = 20,
        color = { r = 225, g = 0, b = 0 },
        item = "evidence_r",
        anim = true,
    },
    ["VehCrash"] = {
        sprite = 36,
        color = {},
        item = "evidence_b",
        anim = true,
    },
    ["Drug"] = {
        sprite = 20,
        color = { r = 0, g = 200, b = 0 },
        item = "evidence_v",
        anim = true,
    },
}

Config.Ammos = {
    ["AMMO_PISTOL"] = "9x19mm [BAJO]",
    ["AMMO_SMG"] = "9x19mm [BAJO]",
    ["AMMO_RIFLE"] = "7.62x51mm [MEDIO]",
    ["AMMO_MINIGUN"] = "7.62x51mm [MEDIO]",
    ["AMMO_SHOTGUN"] = "Cartucho cal. 12 [ALTO]",
    ["AMMO_SNIPER"] = "12.7x99mm [ALTO]",
    ["AMMO_SNIPER_REMOTE"] = "12.7x99mm [ALTO]",
    ["AMMO_GRENADELAUNCHER"] = "Explosivo",
    ["AMMO_RPG"] = "Explosivo",
    ["AMMO_FLARE"] = "Bengala",
}

Config.AmmoTypes = {
    ['weapon_pistol']                   = "AMMO_PISTOL",
    ['weapon_pistol_mk2']               = "AMMO_PISTOL",
    ['weapon_combatpistol']             = "AMMO_PISTOL",
    ['weapon_appistol']                 = "AMMO_PISTOL",
    ['weapon_pistol50']                 = "AMMO_PISTOL",
    ['weapon_snspistol']                = "AMMO_PISTOL",
    ['weapon_heavypistol']              = "AMMO_PISTOL",
    ['weapon_vintagepistol']            = "AMMO_PISTOL",
    ['weapon_flaregun']                 = "AMMO_FLARE",
    ['weapon_marksmanpistol']           = "AMMO_PISTOL",
    ['weapon_revolver']                 = "AMMO_PISTOL",
    ['weapon_revolver_mk2']             = "AMMO_PISTOL",
    ['weapon_doubleaction']             = "AMMO_PISTOL",
    ['weapon_snspistol_mk2']            = "AMMO_PISTOL",
    ['weapon_raypistol']                = "AMMO_PISTOL",
    ['weapon_ceramicpistol']            = "AMMO_PISTOL",
    ['weapon_navyrevolver']             = "AMMO_PISTOL",
    ['weapon_gadgetpistol']             = "AMMO_PISTOL",
    ['weapon_pistolxm3']			    = "AMMO_PISTOL",
    

    -- Submachine Guns
    ['weapon_microsmg']                 = "AMMO_SMG",
    ['weapon_smg']                      = "AMMO_SMG",
    ['weapon_smg_mk2']                  = "AMMO_SMG",
    ['weapon_assaultsmg']               = "AMMO_SMG",
    ['weapon_combatpdw']                = "AMMO_SMG",
    ['weapon_machinepistol']            = "AMMO_PISTOL",
    ['weapon_minismg']                  = "AMMO_SMG",
    ['weapon_raycarbine']               = "AMMO_SMG",

    -- Shotguns
    ['weapon_pumpshotgun']              = "AMMO_SHOTGUN",
    ['weapon_sawnoffshotgun']           = "AMMO_SHOTGUN",
    ['weapon_assaultshotgun']           = "AMMO_SHOTGUN",
    ['weapon_bullpupshotgun']           = "AMMO_SHOTGUN",
    ['weapon_musket']                   = "AMMO_SHOTGUN",
    ['weapon_heavyshotgun']             = "AMMO_SHOTGUN",
    ['weapon_dbshotgun']                = "AMMO_SHOTGUN",
    ['weapon_autoshotgun']              = "AMMO_SHOTGUN",
    ['weapon_pumpshotgun_mk2']          = "AMMO_SHOTGUN",
    ['weapon_combatshotgun']            = "AMMO_SHOTGUN",

    -- Assault Rifles
    ['weapon_assaultrifle']             = "AMMO_RIFLE",
    ['weapon_assaultrifle_mk2']         = "AMMO_RIFLE",
    ['weapon_carbinerifle']             = "AMMO_RIFLE",
    ['weapon_carbinerifle_mk2']         = "AMMO_RIFLE",
    ['weapon_advancedrifle']            = "AMMO_RIFLE",
    ['weapon_specialcarbine']           = "AMMO_RIFLE",
    ['weapon_bullpuprifle']             = "AMMO_RIFLE",
    ['weapon_compactrifle']             = "AMMO_RIFLE",
    ['weapon_specialcarbine_mk2']       = "AMMO_RIFLE",
    ['weapon_bullpuprifle_mk2']         = "AMMO_RIFLE",
    ['weapon_militaryrifle']            = "AMMO_RIFLE",

    -- Light Machine Guns
    ['weapon_mg']                       = "AMMO_MG",
    ['weapon_combatmg']                 = "AMMO_MG",
    ['weapon_gusenberg']                = "AMMO_MG",
    ['weapon_combatmg_mk2']             = "AMMO_MG",
    

    -- Sniper Rifles
    ['weapon_sniperrifle']              = "AMMO_SNIPER",
    ['weapon_heavysniper']              = "AMMO_SNIPER",
    ['weapon_marksmanrifle']            = "AMMO_SNIPER",
    ['weapon_remotesniper']             = "AMMO_SNIPER",
    ['weapon_heavysniper_mk2']          = "AMMO_SNIPER",
    ['weapon_marksmanrifle_mk2']        = "AMMO_SNIPER",

    -- Heavy Weapons
    ['weapon_rpg']                      = "AMMO_RPG",
    ['weapon_grenadelauncher']          = "AMMO_GRENADELAUNCHER",
    ['weapon_grenadelauncher_smoke']    = "AMMO_GRENADELAUNCHER",
    ['weapon_minigun']                  = "AMMO_MINIGUN",
    ['weapon_hominglauncher']           = "AMMO_STINGER",
    ['weapon_rayminigun']               = "AMMO_MINIGUN",

    -- Throwables
    ['weapon_grenade']                  = "AMMO_GRENADELAUNCHER",
    ['weapon_ball']                     = "AMMO_BALL",
    ['weapon_smokegrenade']             = "AMMO_GRENADELAUNCHER",
    ['weapon_flare']                    = "AMMO_FLARE",

    -- Miscellaneous
    ['weapon_petrolcan']                = "AMMO_PETROLCAN",
    ['weapon_hazardcan']                = "AMMO_PETROLCAN",
}

Config.WeaponsLabels = {
    ['weapon_unarmed']                  = 'Fists',               
    ['weapon_dagger']                   = 'Dagger',          
    ['weapon_bat']                      = 'Bat',             
    ['weapon_bottle']                   = 'Broken Bottle',   
    ['weapon_crowbar']                  = 'Crowbar',         
    ['weapon_flashlight']               = 'Flashlight',      
    ['weapon_golfclub']                 = 'Golfclub',        
    ['weapon_hammer']                   = 'Hammer',          
    ['weapon_hatchet']                  = 'Hatchet',         
    ['weapon_knuckle']                  = 'Knuckle',         
    ['weapon_knife']                    = 'Knife',           
    ['weapon_machete']                  = 'Machete',         
    ['weapon_switchblade']              = 'Switchblade',     
    ['weapon_nightstick']               = 'Nightstick',      
    ['weapon_wrench']                   = 'Wrench',          
    ['weapon_battleaxe']                = 'Battle Axe',      
    ['weapon_poolcue']                  = 'Poolcue',         
    ['weapon_briefcase']                = 'Briefcase',       
    ['weapon_briefcase_02']             = 'Suitcase',        
    ['weapon_garbagebag']               = 'Garbage Bag',     
    ['weapon_handcuffs']                = 'Handcuffs',       
    ['weapon_bread']                    = 'Baquette',       
    ['weapon_stone_hatchet']            = 'Stone Hatchet',   
    ['weapon_candycane']			    = 'Candy Cane',			

    -- Handguns
    ['weapon_pistol']                   = 'Walther P99',               
    ['weapon_pistol_mk2']               = 'Pistol Mk II',              
    ['weapon_combatpistol']             = 'Combat Pistol',             
    ['weapon_appistol']                 = 'AP Pistol',                 
    ['weapon_stungun']                  = 'Taser',                     
    ['weapon_pistol50']                 = 'Pistol .50',                
    ['weapon_snspistol']                = 'SNS Pistol',                
    ['weapon_heavypistol']              = 'Heavy Pistol',              
    ['weapon_vintagepistol']            = 'Vintage Pistol',            
    ['weapon_flaregun']                 = 'Flare Gun',                 
    ['weapon_marksmanpistol']           = 'Marksman Pistol',           
    ['weapon_revolver']                 = 'Revolver',                  
    ['weapon_revolver_mk2']             = 'Violence',                 
    ['weapon_doubleaction']             = 'Double Action Revolver',   
    ['weapon_snspistol_mk2']            = 'SNS Pistol Mk II',         
    ['weapon_raypistol']                = 'Up-n-Atomizer',            
    ['weapon_ceramicpistol']            = 'Ceramic Pistol',           
    ['weapon_navyrevolver']             = 'Navy Revolver',            
    ['weapon_gadgetpistol']             = 'Perico Pistol',            
    ['weapon_pistolxm3']			    = 'Pistol XM3',

    -- Submachine Guns
    ['weapon_microsmg']                 = 'Micro SMG',                 
    ['weapon_smg']                      = 'SMG',                       
    ['weapon_smg_mk2']                  = 'SMG Mk II',                
    ['weapon_assaultsmg']               = 'Assault SMG',               
    ['weapon_combatpdw']                = 'Combat PDW',                
    ['weapon_machinepistol']            = 'Tec-9',                     
    ['weapon_minismg']                  = 'Mini SMG',                  
    ['weapon_raycarbine']               = 'Unholy Hellbringer',       

    -- Shotguns
    ['weapon_pumpshotgun']              = 'Pump Shotgun',              
    ['weapon_sawnoffshotgun']           = 'Sawn-off Shotgun',          
    ['weapon_assaultshotgun']           = 'Assault Shotgun',           
    ['weapon_bullpupshotgun']           = 'Bullpup Shotgun',           
    ['weapon_musket']                   = 'Musket',                    
    ['weapon_heavyshotgun']             = 'Heavy Shotgun',             
    ['weapon_dbshotgun']                = 'Double-barrel Shotgun',     
    ['weapon_autoshotgun']              = 'Auto Shotgun',              
    ['weapon_pumpshotgun_mk2']          = 'Pumpshotgun Mk II',        
    ['weapon_combatshotgun']            = 'Combat Shotgun',           

    -- Assault Rifles
    ['weapon_assaultrifle']             = 'Assault Rifle',             
    ['weapon_assaultrifle_mk2']         = 'Assault Rifle Mk II',      
    ['weapon_carbinerifle']             = 'Carbine Rifle',             
    ['weapon_carbinerifle_mk2']         = 'Carbine Rifle Mk II',      
    ['weapon_advancedrifle']            = 'Advanced Rifle',            
    ['weapon_specialcarbine']           = 'Special Carbine',           
    ['weapon_bullpuprifle']             = 'Bullpup Rifle',             
    ['weapon_compactrifle']             = 'Compact Rifle',             
    ['weapon_specialcarbine_mk2']       = 'Special Carbine Mk II',    
    ['weapon_bullpuprifle_mk2']         = 'Bullpup Rifle Mk II',      
    ['weapon_militaryrifle']            = 'Military Rifle',           

    -- Light Machine Guns
    ['weapon_mg']                       = 'Machinegun',                
    ['weapon_combatmg']                 = 'Combat MG',                 
    ['weapon_gusenberg']                = 'Thompson SMG',              
    ['weapon_combatmg_mk2']             = 'Combat MG Mk II',          

    -- Sniper Rifles
    ['weapon_sniperrifle']              = 'Sniper Rifle',              
    ['weapon_heavysniper']              = 'Heavy Sniper',              
    ['weapon_marksmanrifle']            = 'Marksman Rifle',            
    ['weapon_remotesniper']             = 'Remote Sniper',             
    ['weapon_heavysniper_mk2']          = 'Heavy Sniper Mk II',       
    ['weapon_marksmanrifle_mk2']        = 'Marksman Rifle Mk II',     

    -- Heavy Weapons
    ['weapon_rpg']                      = 'RPG',                       
    ['weapon_grenadelauncher']          = 'Grenade Launcher',          
    ['weapon_grenadelauncher_smoke']    = 'Smoke Grenade Launcher',    
    ['weapon_minigun']                  = 'Minigun',                 
    ['weapon_firework']                 = 'Firework Launcher',         
    ['weapon_railgun']                  = 'Railgun',                   
    ['weapon_railgunxm3']			    = 'Railgun XM3',				
    ['weapon_hominglauncher']           = 'Homing Launcher',           
    ['weapon_compactlauncher']          = 'Compact Launcher',          
    ['weapon_rayminigun']               = 'Widowmaker',               

    -- Throwables
    ['weapon_grenade']                  = 'Grenade',                  
    ['weapon_bzgas']                    = 'BZ Gas',                    
    ['weapon_molotov']                  = 'Molotov',                   
    ['weapon_stickybomb']               = 'C4',                        
    ['weapon_proxmine']                 = 'Proxmine Grenade',          
    ['weapon_snowball']                 = 'Snowball',                  
    ['weapon_pipebomb']                 = 'Pipe Bomb',                 
    ['weapon_ball']                     = 'Ball',                      
    ['weapon_smokegrenade']             = 'Smoke Grenade',             
    ['weapon_flare']                    = 'Flare pistol',              

    -- Miscellaneous
    ['weapon_petrolcan']                = 'Petrol Can',                
    ['weapon_fireextinguisher']         = 'Fire Extinguisher',         
    ['weapon_hazardcan']                = 'Hazardous Jerry Can',       
}

Config.WeaponSilencierBlockShootAlert = true -- If the weapon has a silencier, it will not trigger the shoot alert
Config.BlackListedUsersWeapons = { -- The list of weapons that will not be listed in the citizen profile
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
    "WEAPON_FIREEXTINGUISHER",
}

Config.BlackListedShootAlertWeapons = { -- The list of weapons that will not trigger the shoot alert   
    --"WEAPON_STUNGUN",
    --"WEAPON_FLAREGUN",
    --"WEAPON_FIREEXTINGUISHER",
}

Config.ShootAlertCooldown = 120000 -- Cooldown between each shoot alert
Config.SecondsToCool = 600 -- Cooldown to remove an evidence proof

-- DONT TOUCH BELOW
function IsWeaponBlacklisted(weaponName) 
    for i = 1, #Config.BlackListedShootAlertWeapons do
        if Config.BlackListedShootAlertWeapons[i]:lower() == weaponName:lower() then
            return true
        end
    end
    return false
end

function IsWeaponBlacklistedForProfile(weaponName) 
    for i = 1, #Config.BlackListedUsersWeapons do
        if Config.BlackListedUsersWeapons[i]:lower() == weaponName:lower() then
            return true
        end
    end
    return false
end