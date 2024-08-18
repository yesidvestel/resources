-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local seconds, minutes = 1000, 60000
Config = {}

-------------------------------------------------------------------
-- TO MODIFY NOTIFICATIONS TO YOUR OWN CUSTOM NOTIFICATIONS:-------
------ Navigate to wasabi_bridge/customize/cl_customize.lua -------
-------------------------------------------------------------------
Config.CheckForUpdates = true -- Check for updates? Who would not want to know updates!?

-- Language Options are
-- 'en' (English)
-- 'fr' (French)
-- 'cn' (Chinese Simplified)
-- 'tw' (Chinese Traditional)
-- 'de' (German)
-- 'it' (Italian)
-- 'jp' (Japanese)
-- 'ko' (Korean)
-- 'pl' (Polish)
-- 'pt' (Portuguese)
-- 'es' (Spanish)
-- 'hi' (Hindi)
-- 'nl' (Dutch)
-- 'da' (Danish)
-- 'cs' (Czech)
-- If you would like us to add a language, join our discord and create a ticket!
-- All locale strings can be found in /game/configuration/locales/
Config.Language = 'es'
Config.UIColor = '#e61f09' -- Can be 'red', 'blue', or a hex '#FF0000'
-- Config.DeathScreenEffects = true -- OBSOLETE RIGHT NOW

-- Which style do you want to use for death UI?(Current options: 1, 2, 3, 4, 5)
-- Check docs for examples of all types! https://docs.wasabiscripts.com
Config.DeathScreenType = 3
-- If you want to use the previous death screen(Draw text, not recommended) see docs

Config.ShowEMSCountOnDeath = true -- Show active ambulance count in death UI? (Gives count in death screen of all jobs active from Config.ambulanceJobs)
-- Note that Config.DeathScreenType 5 will show this information regardless of the setting above

Config.OldQBManagement = false -- If you are using QBCore and want to use the old QB Management system

Config.ambulanceJobs = {       -- Jobs that are considered ambulance jobs (If unsure, likely leave the way it is)
    'ambulance',               -- You must have a job with this name registered
    --'emt',             -- They will be treated just like EMS (Job menu, loctions access, etc)
    --'doctor',
    --'fire',
}

Config.MuteDeadPlayers = false -- If a player is dead, should he be muted?

-- Logs
Config.DeathLogs = true  -- Enable death logs via Discord webhook?(Set up in configuration/deathlogs.lua)
Config.ReviveLogs = true -- Enable admin revive logs via Discord webhook? (Linked specifically to admin revives / will not log ALL revives)
Config.LogIPs = true     -- If Config.DeathLogs/Config.ReviveLogs enabled, do you want to logs IP addresses as well?

-- Stretcher Settings
Config.EnableStretcher = true     -- Enable stretcher system?
Config.StretcherProp = 'wasabi_stretcher'
Config.StretcherKey = 38          -- Key to place the stretcher on the ground
Config.HoldingStretcherOffSet = { -- Offset for holding stretcher
    pos = { x = -0.032, y = -0.716, z = -1.269 },
    rot = { x = 16.489, y = 1.863, z = -1.3292 }
}
Config.OccupyingStretcherOffSet = { -- Offset for occupying stretcher
    pos = { x = 0.0, y = 0.0, z = 1.9 },
    rot = { x = 0.0, y = 0.0, z = 180.0 }
}



Config.BagProp = `xm_prop_x17_bag_med_01a`
Config.UseRadialMenu = false             -- Enable use of radial menu built in to ox_lib? (REQUIRES OX_LIB 3.0 OR HIGHER - Editable)
Config.EnableAnimReset = false           -- If your death animation does not run correctly, then enable this
Config.MobileMenu = {                    -- Enabling this will use menu rather than context menu!
    enabled = false,                     -- Use a mobile menu rather than context? (Use arrow keys to navigate menu rather than mouse)
    position =
    'bottom-right'                       -- Choose where menu is positioned. Options : 'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'
}
Config.ProgressCircle = true             -- Set to false to use a progress bar, set to true for progress circle(For checking in, diagnosing, etc)
Config.ProgressCircleLocation = 'bottom' -- Where you want the progress circle located (if enabled)
-- Choices: 'bottom' and 'middle'

Config.policeCanTreat = {
    enabled = true, -- Police can treat patients?
    jobs = {        -- Police / other jobs
        'police',
        --    'sheriff',
    }
}

-- Enabled keys while dead and while on stretcher
-- https://docs.fivem.net/docs/game-references/controls/
Config.EnabledKeys = {
    dead = { -- while dead
        1,   -- Camera Pan(Mouse)
        2,   -- Camera Tilt(Mouse)
        38,  -- E Key
        46,  -- E Key
        47,  -- G Key
        245, -- T Key
        --249 -- N Key (default key to speak while dead)
    },

    stretcher = { -- while alive on stretcher
        1,        -- Camera Pan(Mouse)
        2,        -- Camera Tilt(Mouse)
        245,      -- T Key
        249       -- N Key (default key to speak while dead)
    },

    revive = { -- while reviving
        249    -- N Key (default key to speak while dead)
    }
}

-- Ambulances and their offsets for placing stretcher within vehicle
Config.AmbulanceOffsets = {
    ['ambulance'] = {            -- Vehicle model name
        trunkAsBackDoor = false, -- If the back doors are the trunk, if they are doors then set as false
        --    pos = { x = -0.26, y = -1.3, z = 0.3 }, -- Offset position
        --    rot = { x = -1.3, y = 0.0, z = 360.0 } -- Rotation
        pos = { x = 0.15, y = -3.0, z = 0.00 },
        rot = { x = -1.3, y = 0.0, z = 90.0 }
    },

    ['20ramambo'] = {           -- Rednecks generic 2020 ambulance
        trunkAsBackDoor = true, -- If the back doors are the trunk, if they are doors then set as false
        pos = { x = 0.0, y = -3.0, z = 1.0 },
        rot = { x = -1.3, y = 0.0, z = 360.0 }
    },

    ['ec135'] = {
        trunkAsBackDoor = false, -- If the back doors are the trunk, if they are doors then set as false
        pos = { x = -0.26, y = -0.6, z = -0.1 },
        rot = { x = -1.3, y = 0.0, z = 360.0 }
    }
}

Config.GPSBlips = {
    enabled = true,     -- Enabled?
    item = false,        -- Item required? Note: You have to use it then
    sprites = {
        none = 1,        -- Blip for when not in a vehicle
        car = 56,        -- Blip for when in vehicles
        bike = 226,      -- Blip for when on bikes
        boat = 427,      -- Blip for when in boats
        helicopter = 43, -- Blip for when in helicopters
        plane = 307,     -- Blip for when in planes
    },
    settings = {
        color = 3,
        scale = 0.75,
        short = false,
        category = 7
    }
}

-- Position for the draw Text while you are dead
--[[Config.MessagePosition = {
    respawn = { x = 0.5, y = 0.8 },
    bleedout = { x = 0.5, y = 0.8 },
    distress = { x = 0.5, y = 0.86 },
}]]
-- This is obsolete now, if you wish to use 3D text while dead still, see https://docs.wasabiscripts.com

-- Dead animation
Config.DeathAnimation = {
    anim = 'mini@cpr@char_b@cpr_def',
    lib = 'cpr_pumpchest_idle'
}

-- Knockout Feature (If you want players to be knocked out)
Config.KnockoutFeature = {
    enabled = false,           -- Enable knockout features? (player's can knock eachother out using fist fighting)
    healthForKnockout = 150,   -- At what HP will player knockout from fist fighting
    fistDamageModifier = 0.25, -- How much damage will fist cause? (1.0 is default, 0.5 is half as strong, etc)
    duration = 7 * seconds     -- Time to be knocked out when occurs?
}

-- Last Stand (2 Stage death)
Config.LastStand = true                -- Enable a 2 stage death. Where initially you can crawl around(Similiar to qb-ambulancejob)
Config.DisableLastStandCrawl = false   -- Disable crawling within last stand
Config.LastStandTickTime = 5 * seconds -- Everytime this time passes while in last stand,
----------------------------------------- a random amount(8-15) amount of health will be deducted to similuate bleeding out
Config.DisableHeadShotKill = false     -- When enabled, a player who is shot in the head will still go into last stand (Recommended to leave false)
Config.StayInVehicleOnDeath = true
-- Live injury
Config.EnableLiveInjury = true                             -- Enable live injury system?

Config.DamageDetectThreshold = { armour = 5, health = 10 } -- Damage threshold to detect injury (Default: {armour = 5, health = 10})

Config.BleedMultiplier = {
    shot = 2,    -- How much blood rate to loose when shot
    stabbed = 2, -- How much blood rate to loose when stabbed
    beat = 0,    -- How much blood rate to loose when beat
    burned = 0,  -- How much blood rate to loose when burned
}

Config.BypassInjuryWeapons = { -- Hashes placed in this table will bypass injury reasons
    `WEAPON_UNARMED`,
    `WEAPON_STUNGUN`,
    `WEAPON_DROWNING`,
    `WEAPON_DROWNING_IN_VEHICLE`,
    --  `WEAPON_FALL`,
}


Config.InjuryNotification = true                 -- Enable injury notification?
Config.InjuryNotificationFrequency = 1 * minutes -- How often to notify player of injury
Config.BlackoutEffect = false                    -- Enable blackout, Ragdoll caused by live injury

Config.DisableNoJumpInjury = false               -- Disable when being injured that you cant job on occasion
Config.EnablePainPills = true                    -- Enable pain pills? Used to aliviate injurys temporarily

Config.PainPills = {                             -- Add more as you please. The level field simulates the severity of the narcodic; exceed 10 and it could be deadly
    --  ['ITEM_NAME'] = { label = 'ITEM_LABEL', duration = SECONDS }
    ['morphine30'] = { label = 'Morphine 30MG', duration = 120, level = 9 },
    ['morphine15'] = { label = 'Morphine 15MG', duration = 50, level = 5 },
    ['perc30'] = { label = 'Percocet 30MG', duration = 60, level = 6 },
    ['perc10'] = { label = 'Percocet 10MG', duration = 45, level = 4 },
    ['perc5'] = { label = 'Percocet 5MG', duration = 30, level = 2 },
    ['vic10'] = { label = 'Vicodin 10MG', duration = 40, level = 3 },
    ['vic5'] = { label = 'Vicodin 5MG', duration = 20, level = 2 },

}

-- 3rd party scripts
Config.wasabi_crutch = { -- If you use wasabi_crutch:
    ------------------------------------------------------
    --             If you use wasabi_crutch             --
    -- https://store.wasabiscripts.com/category/2080869 --
    ------------------------------------------------------

    -- Crutch Settings
    crutchInMedbag = { -- Enabled? Item name? REQUIRES WASABI_CRUTCH
        enabled = false,
        item = 'crutch'
    },
    crutchInJobMenu = false, -- Crutch menu accessible from job menu if true. REQUIRES WASABI_CRUTCH
    crutchOnCheckIn = {      -- Place crutch for certain amount of time if they visit the hospital or bleedout REQUIRES WASABI_CRUTCH
        enabled = false,     -- Requires wasabi_crutch
        duration = 3         -- How long stuck with crutch after check-in(In minutes)
    },
    -- Chair settings
    chairInMedbag = { -- Enabled? Item name? REQUIRES WASABI_CRUTCH
        enabled = false,
        item = 'wheelchair'
    },
    chairInJobMenu = false -- Chair menu accessible from job menu if true. REQUIRES WASABI_CRUTCH
}

Config.EnviPrescriptions = {
    ---------------------------------------------------
    --       If you use Envi Prescriptions:          --
    -- https://envi-scripts.tebex.io/package/5604452 --
    ---------------------------------------------------
    enabled = false, -- Enable to add option for prescriptions to job menu
    minRank = 1      -- Minimum job level/grade to have this option available
}

Config.EnviMedic = {
    ---------------------------------------------------
    --       If you use Envi Medic:          --
    -- https://envi-scripts.tebex.io/package/5969648 --
    ---------------------------------------------------
    enabled = false -- Enable to make Envi-Medic to work with wasabi_ambulance
}

Config.mInsurance = {
    -----------------------------------
    --   If you use m-Insurance:     --
    -- https://marcinhu.tebex.io/    --
    -----------------------------------
    enabled = false,      -- Enable to allow for discount on insured patient
    checkInDiscount = 500 --The amount to deduct from the configured check-price if player has insurance
}

Config.phoneDistress = false        -- Options: 'gks' (GKS Phone - ESX ONLY) / 'qs' (qs-smartphone) / 'd-p' (d-phone) / 'lb' (lb-phone) WILL REPLACE BUILT IN DISPATCH WITH PHONE DISPATCH / Add additonal dispatch in client/cl_customize.lua
Config.customCarlock = false        -- If you use wasabi_carlock OR qb-carlock(Or want to add your own key system to wasabi_bridge/customize/cl_customize.lua)
Config.MythicHospital = false       -- If you use that old injury script by mythic. (Added per request to reset injuries on respawn)
Config.AdvancedParking = false      -- If you use AdvancedParking (Deletes vehicles with their exports)
Config.FuelSystem = false           -- 'legacy' (LegacyFuel) / 'ox' (ox_fuel) / 'default'

Config.jobMenu = 'F6'               -- Default job menu key
Config.billingSystem = false        -- Current options: 'esx' (For esx_billing) / 'qb' (For qbcore users) 'okok' (For okokBilling) / 'pefcl' (For NPWD billing system) (Easy to add more in editable client - SET TO false IF UNDESIRED) or of course false to disable
Config.targetSystem = true          -- Target system for targetting players, medbags, and stretcher(If disabled with replace with menus/3D text) (Compatible out of the box with qTarget, qb-target, and ox_target)

Config.RespawnTimer = 5 * minutes   -- Time before optional respawn
Config.BleedoutTimer = 20 * minutes -- Time before it forces respawn
Config.ChargeForRevive = {
    enabled = false,                -- Charge players to revive after the timer expires when they hold E to revive?
    cost = 500,                     -- Cost to revive if enabled
    payAccount = 'bank',            -- Account to pay from
    allowNegativeBalance = false    -- QB ONLY: Allow negative balance if player does not have enough money?
}

Config.removeItemsOnDeath = false -- Must have supported inventory or add function to sv_customize.lua OR add inventory to wasabi_bridge.
--Config.Inventory = 'ox'           -- NOW USES WSB.INVENTORY FUNCTION

Config.keepItemsOnDeath = {
    enabled = false,
    items = {
        'money',
        'phone'
    }
}
Config.AntiCombatLog = { --  When enabled will kill player who logged out while dead
    enabled = true,      --  enabled?
    notification = {
        enabled = true,  -- enabled notify of wrong-doings??
        title = 'Registrado mientras está muerto',
        desc = 'La última vez que te fuiste estaba muerto, ahora has regresado muerto.'
    }
}

Config.CompleteDeath = { --DOES NOT APPLY TO QBCORE --  When enabled players can no longer use their character after x deaths
    --DOES NOT APPLY TO QBCORE --  ONLY SUPPORTS esx_multicharacter / You can edit it in server/sv_customize.lua
    enabled = false,     -- enabled?
    maxDeaths = 100,     -- Max 255
}

Config.Bandages = {
    enabled = false,       -- Useable bandages? (Leave false if ox_inventory because they're built in)
    item = 'bandage',      -- YOU MUST ADD THIS ITEM TO YOUR ITEMS, IT DOES NOT COME IN INSTALLATION(COMES WITH QBCORE BY DEFAULT AS ITEM)
    hpRegen = 30,          -- Percentage of health it replenishes (30% by default)
    healBleed = false,     -- Heal bleed that is inflicted by injury system? (Requires injury system enabled)
    duration = 7 * seconds -- Time to use
}

Config.EMSItems = {
    revive = {
        item = 'defib', -- Item used for reviving
        remove = false  -- Remove item when using?
    },
    heal = {
        item = 'medikit',       -- Item used for healing
        duration = 5 * seconds, -- Time to use
        healBleed = true,       -- Heal bleed?
        remove = true           -- Remove item when using?
    },
    sedate = {
        item = 'sedative',      -- Item used to sedate players temporarily
        duration = 8 * seconds, -- Time sedative effects last
        remove = true           -- Remove item when using?
    },
    medbag = 'medbag',          -- Medbag item name used for getting supplies to treat patient
}

Config.ReviveRewards = {
    enabled = true,           -- Enable cash rewards for reviving
    paymentAccount = 'money', -- If you have old ESX 1.1 you may need to switch to 'cash'
    no_injury = 4000,         -- If above enabled, how much reward for fully treated patient with no injury in diagnosis
    burned = 3000,            -- How much if player is burned and revived without being treated
    beat = 2500,              -- So on, so forth
    stabbed = 2000,
    bleedout = 2000,          -- NEW
    shot = 1500,
}

Config.ReviveHealth = { -- How much health to deduct for those revived without proper treatment
    shot = 60,          -- Ex. If player is shot and revived without having the gunshots treated; they will respond with 60 health removed
    stabbed = 50,
    beat = 40,
    burned = 20
}

Config.ReviveTime = 12 * seconds   -- Time to revive player
Config.TreatmentTime = 9 * seconds -- Time to perform treatment
Config.DiagnoseTime = 7 * seconds  -- Time to diagnose patient

Config.TreatmentItems = {
    shot = 'tweezers',
    stabbed = 'suturekit',
    beat = 'icepack',
    burned = 'burncream'
}

Config.lowHealthAlert = {
    enabled = false,
    health = 140, -- Notify when at HP (200 full health / 100 is death)
    notification = {
        title = 'ATENCIÓN',
        description = 'Tienes mala salud. ¡Deberías ver a un médico pronto!'
    }
}

Config.EnableStandaloneCheckIns = false -- Enable stand-alone check-in locations? For grandmas, prisons, whatever
Config.StandaloneCheckIns = {

    Prison = {                                        -- Example, QB Prison check-in
        Ped = 's_m_m_scientist_01',                   -- Check in ped
        Coords = vec3(1729.03, 2563.33, 45.56 - 0.9), -- Coords of ped
        Distance = 4.85,                              -- Distance to show textUI (If target is not enabled below)
        Heading = 181.42,                             -- Heading of ped
        Cost = 5,                                     -- Cost of using hospital check-in. Set to false for free
        Duration = 15 * seconds,                      -- Time it takes to spend in hospital bed
        PayAccount = 'bank',                          -- Account dead player pays from to check-in
        Label = '[E] - Check In',                     -- label of text UI if target is not enabled below
        HotKey = 38,                                  -- Default: 38 (E) (If target below is not enabled)
        Target = {
            enabled = true,                           -- Enable Target? (Can be customized in wasabi_bridge/customize/cl_customize.lua the target system)
            label = 'Check In',
            coords = vec3(1729.03, 2563.33, 45.56),
            heading = 63.26,
            distance = 5.0,
            width = 2.0,
            length = 1.0,
            minZ = 43.28 - 0.9,
            maxZ = 43.28 + 0.9
        },
        DisableHospitalBeds = true,                                                          -- Disable hospital beds for check-in at this location?(Player will spend Duration checking in before respawning in RespawnNoBedLocation coords when set to true)
        RespawnNoBedLocation = { coords = vec3(1729.03, 2563.33, 45.56), heading = 339.02 }, -- Coords and heading of where to spawn player if DisableHospitalBeds is set to true or beds full
        HospitalBeds = {
            --              { coords = vec3(332.62, -587.17, 42.84+0.3), heading = 160.0 },
            { coords = vec3(317.67, -585.37, 42.84 + 0.3), heading = 160.0 },
        }
    },


}

Config.Locations = {
    Pillbox = {
        RespawnPoint = { -- When player dies and bleeds out; they will revive at nearest hospital; Define the coords of this hospital here.
            coords = vec3(317.8, -585.14, 44.2),
            heading = 332.22,
            -- Even if you have useCheckInInstead to true, you must still define these coords for finding closest hospital
            -- If you want to use check-in instead of respawning at this location(Otherwise will just spawn at the coords above)
            useCheckInInstead = true
        },

        Blip = {
            Enabled = true,
            Coords = vec3(324.15, -583.14, 44.20),
            Sprite = 61,
            Color = 2,
            Scale = 0.5,
            String = 'Clínica Vitalux'
        },

        clockInAndOut = {
            enabled = true,                       -- Enable clocking in and out at a set location? (If using ESX you must have a off duty job for Config.ambulanceJob with same grades - example in main _install_first directory)
            coords = vec3(312.92, -587.78, 38.33), -- Location of where to go on and off duty(If not using target)
            label = '[E] - Entrar o salir de servicio',        -- Text to display(If not using target)
            distance = 3.0,                        -- Distance to display text UI(If not using target)
            target = {
                enabled = false,                   -- If enabled, the location and distance above will be obsolete
                label = 'Entrar o salir de servicio',
                coords = vec3(312.92, -587.78, 38.33),
                heading = 337.07,
                width = 2.0,
                length = 1.0,
                minZ = 43.28 - 0.9,
                maxZ = 43.28 + 0.9
            }
        },
        -- Personal Locker. Supports inventories: ox_inventory, qb-inventory, and qs-inventory
        -- Custom inventories can easily be added in wasabi_bridge/inventories/
        PersonalLocker = {
            enabled = false,                        -- Enable personal locker(stash)
            jobLock = 'ambulance',                  -- Job lock?
            coords = vec(298.61, -598.28, 43.28),   -- Location of where to access personal locker (If target is disabled)
            label = '[E] - Acceso a casillero personal', -- Text to display(If not using target)
            maxWeight = 5000,                       -- Total Weight of the personalLocker
            slots = 30,                             -- Number of slots available in the Personal Locker
            distance = 2.0,                         -- Distance to display text UI(If not using target)
            target = {
                enabled = false,                    -- If enabled, the location and distance above will be obsolete
                label = 'Acceso a casillero personal',
                coords = vector3(283.27, -615.33, 43.38),
                heading = 70.18,
                width = 2.0,
                length = 1.0,
                minZ = 43.38 - 0.9,
                maxZ = 43.38 + 0.9
            }
        },
        

        BossMenu = {
            Enabled = true,                        -- Enabled boss menu?
            Coords = vec3(310.72, -569.84, 43.31), -- Location of boss menu (If not using target)
            Label = '[E] - Menú de acceso al jefe',      -- Text UI label string (If not using target)
            Distance = 2.5,                        -- Distance to allow access/prompt with text UI (If not using target)
            Target = {
                enabled = false,                   -- Enable Target? (Can be customized in wasabi_bridge/customize/cl_customize.lua the target system)
                label = 'Menú de acceso al jefe',
                coords = vec3(310.72, -569.84, 43.31),
                heading = 160.0,
                width = 2.0,
                length = 1.0,
                minZ = 43.21 - 0.9,
                maxZ = 43.21 + 0.9
            }
        },

        CheckIn = {                                      -- Hospital check-in
            Enabled = true,                              -- Enable ped and check-in area?
            Ped = 's_m_m_scientist_01',                  -- Check in ped
            Coords = vec3(304.47, -591.25, 44.19), -- Coords of ped
            Distance = 4.85,                             -- Distance to show textUI (If target is not enabled below)
            Heading = 63.26,                             -- Heading of ped
            Cost = 500,                                  -- Cost of using hospital check-in. Set to false for free
            Duration = 15 * seconds,                     -- Time it takes to spend in hospital bed
            MaxOnDuty = 3,                               -- If this amount or less you can use, otherwise it will tell you that EMS is avaliable(Set to false to always enable check-in)
            PayAccount = 'bank',                         -- Account dead player pays from to check-in
            PayHospital = false,                         -- Payments made to check-in go to the company society/account? (ex. 'society_ambulance' for ESX and 'ambulance' for QBCore or false for no)
            Label = '[E] - Check In',                    -- label of text UI if target is not enabled below
            HotKey = 38,                                 -- Default: 38 (E) (If target below is not enabled)
            Target = {
                enabled = true,                          -- Enable Target? (Can be customized in wasabi_bridge/customize/cl_customize.lua the target system)
                label = 'Check In',
                coords = vec3(304.47, -591.25, 44.19),
                heading = 63.26,
                distance = 5.0,
                width = 2.0,
                length = 1.0,
                minZ = 43.28 - 0.9,
                maxZ = 43.28 + 0.9
            },
            DisableHospitalBeds = false,                                                       -- Disable hospital beds for check-in at this location?(Player will spend Duration checking in before respawning in RespawnNoBedLocation when set to true)
            RespawnNoBedLocation = { coords = vec3(316.66, -581.3, 43.28), heading = 339.02 }, -- Coords and heading of where to spawn player if DisableHospitalBeds is set to true or beds are full
            HospitalBeds = {
                --              { coords = vec3(332.62, -587.17, 42.84+0.3), heading = 160.0 },
                { coords = vec3(317.67, -585.37, 42.84 + 0.3), heading = 160.0 },
                { coords = vec3(319.41, -581.04, 42.84 + 0.3), heading = 340.0 },
                { coords = vec3(314.47, -584.2, 42.84 + 0.3),  heading = 160.0 },
                { coords = vec3(313.93, -579.04, 42.84 + 0.3), heading = 340.0 },
                { coords = vec3(311.06, -582.96, 42.84 + 0.3), heading = 160.0 },
                { coords = vec3(307.72, -581.75, 42.84 + 0.3), heading = 160.0 },
                { coords = vec3(309.35, -577.38, 42.84 + 0.3), heading = 340.0 },
                { coords = vec3(361.36, -581.3, 42.83 + 0.3),  heading = 250.0 },
                { coords = vec3(359.54, -586.23, 42.84 + 0.3), heading = 250.0 },
                { coords = vec3(354.44, -600.19, 42.85 + 0.3), heading = 250.0 },
                { coords = vec3(324.26, -582.8, 42.84 + 0.3),  heading = 340.0 },
                -- Stock qb-ambulance hospital bed coords:
                --                { coords = vec3(353.1, -584.6, 43.11), heading = 152.08 },
                --                { coords = vec3(356.79, -585.86, 43.11), heading = 152.08 },
                --                { coords = vec3(354.12, -593.12, 43.1), heading = 336.32 },
                --                { coords = vec3(350.79, -591.8, 43.1), heading = 336.32 },
                --                { coords = vec3(346.99, -590.48, 43.1), heading = 336.32 },
                --                { coords = vec3(360.32, -587.19, 43.02), heading = 152.08 },
                --                { coords = vec3(349.82, -583.33, 43.02), heading = 152.08 },
                --                { coords = vec3(326.98, -576.17, 43.02), heading = 152.08 }
            }

        },

        Cloakroom = {
            Enabled = true,
            Coords = vec3(308.97, -586.25, 38.33), -- Coords of cloakroom
            Label = '[E] - Cambiarse de ropa',     -- String of text ui of cloakroom
            HotKey = 38,                        -- Default: 38 (E)
            Range = 1.5,                        -- Range away from coords you can use.
            Uniforms = {                        -- Uniform choices
                [1] = {                         -- Order it will display
                    label = 'Medic',            -- Name of outfit that will display in menu
                    minGrade = 0,               -- Min grade level that can access? Set to 0 or false for everyone to use
                    male = {                    -- Male variation
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 15, texture = 0 }, -- Torso
                            { component = 8,  drawable = 58, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 35, texture = 0 }, -- Pants
                            { component = 6,  drawable = 24, texture = 0 }, -- Shoes
                            { component = 3,  drawable = 15, texture = 0 }, -- Arms
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    },
                    female = {
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 15, texture = 0 }, -- Torso
                            { component = 8,  drawable = 58, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 35, texture = 0 }, -- Pants
                            { component = 6,  drawable = 24, texture = 0 }, -- Shoes
                            { component = 3,  drawable = 15, texture = 0 }, -- Arms
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    }
                },
                [2] = {
                    label = 'Doctor',
                    minGrade = 1, -- Min grade level that can access? Set to 0 or false for everyone to use
                    male = {
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 3,  drawable = 15, texture = 0 }, -- Torso
                            { component = 4,  drawable = 35, texture = 0 }, -- Pants
                            { component = 6,  drawable = 24, texture = 0 }, -- Shoes
                            { component = 8,  drawable = 58, texture = 0 }, -- Shirt
                            
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                            { component = 0, drawable = 2, texture = 0 }, -- Hats
                            { component = 1, drawable = 1, texture = 0 }, -- Glasses
                            { component = 2, drawable = 3, texture = 0 }, -- Ears
                            { component = 6, drawable = 1, texture = 0 }, -- Watches
                            { component = 7, drawable = 2, texture = 0 }  -- Bracelets
                        }
                    },
                    female = {
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 15, texture = 0 }, -- Torso
                            { component = 8,  drawable = 58, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 35, texture = 0 }, -- Pants
                            { component = 6,  drawable = 24, texture = 0 }, -- Shoes
                            { component = 3,  drawable = 15, texture = 0 }, -- Arms
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    }
                },
            }
        },

        MedicalSupplies = {                                                     -- EMS Shop for supplies
            Enabled = true,                                                     -- If set to false, rest of this table do not matter
            Ped = 's_m_m_doctor_01',                                            -- Ped to target
            Coords = vec3(306.63, -601.44, 43.28 - 0.95),                       -- Coords of ped/target
            Heading = 337.64,                                                   -- Heading of ped
            Supplies = {                                                        -- Supplies
                { item = 'medbag',     label = 'Medical Bag',   price = 1000 }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'medikit',    label = 'First-Aid Kit', price = 250 },
                { item = 'morphine30', label = 'Morphine 30MG', price = 100 },
                { item = 'morphine15', label = 'Morphine 15MG', price = 45 },
                { item = 'perc30',     label = 'Percocet 30MG', price = 60 },
                { item = 'perc10',     label = 'Percocet 10MG', price = 40 },
                { item = 'perc5',      label = 'Percocet 5MG',  price = 30 },
                { item = 'vic10',      label = 'Vicodin 10MG',  price = 30 },
                { item = 'vic5',       label = 'Vicodin 5MG',   price = 15 },
            }
        },

        Vehicles = {                                   -- Vehicle Garage
            Enabled = true,                            -- Enable? False if you have you're own way for medics to obtain vehicles.
            Zone = {
                coords = vec3(298.54, -606.79, 43.27), -- Area to prompt vehicle garage
                range = 5.5,                           -- Range it will prompt from coords above
                label = '[E] - Acceso al garaje',
                return_label = '[E] - Devolución del vehículo'
            },
            Spawn = {
                land = {
                    coords = vec3(296.16, -607.67, 43.25),
                    heading = 68.43
                },
                air = {
                    coords = vec3(351.24, -587.67, 74.55),
                    heading = 289.29
                }
            },
            Options = {
                [0] = {                    -- Job grade as table name
                    ['ambulance'] = {      -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Ambulance',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['dodgeems'] = {       -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Dodge Charger',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                },

                [1] = {
                    ['ambulance'] = {      -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Ambulance',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['dodgeems'] = {       -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Dodge Charger',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                },

                [2] = {
                    ['ambulance'] = {      -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Ambulance',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['dodgeems'] = {       -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Dodge Charger',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                }
            }
        },
    },
}

--[[ IMPORTANT THIS COULD BREAK SOMETHING ]]
--
Config.DisableDeathAnimation = false -- Really, really, REALLY do not recommend setting this to true and it was added per request


-- Don't touch the options between these comments unless there is reason --
Config.DisableSpawnManagerExecute = false -- If you experience issues with multicharacters or spawning, you can try setting this to true.
Config.CombatLogCheckWait = 3 * seconds -- If you experience anti combat-log without death NUI, try increasing by a second or two.
-- Don't touch the options between these comments unless there is reason --