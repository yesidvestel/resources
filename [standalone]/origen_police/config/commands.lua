Config.Commands = {

    -- Police Cad
    OpenPoliceCad = {
        cmd = 'pcad', -- command for open the police cad
        description = Config.Translations.OpenPoliceCad, -- description for the command
        key = '', -- key for open the police cad
        item = 'police_cad', -- item for open the police cad
    },

    -- Radar
    VehicleRadar = { -- key for open the vehicle radar
        cmd = 'alpr',
        description = Config.Translations.VehicleRadar,
        key = 'NUMPAD5'
    },
    LockRadar = { -- key for lock the radar
        cmd = 'balpr',
        description = Config.Translations.LockRadar,
        key = 'NUMPAD8',
    },
    MoveRadar = { -- key for move the radar
        cmd = 'moveralpr',
        description = Config.Translations.MoveRadar,
        key = 'NUMPAD4',
    },

    -- Dispatch
    NextAlert = { -- key for go to the next alert in the mini dispatch
        cmd = 'nxtalert',
        description = Config.Translations.NextAlert,
        key = 'RIGHT',
    },
    PreviousAlert = { -- key for go to the previous alert in the mini dispatch
        cmd = 'prvalert',
        description = Config.Translations.PreviousAlert,
        key = 'LEFT',
    },
    AcceptAlert = { -- key for accept the alert in the mini dispatch and marke into the map
        key = 'O',
    },
    DeleteAlert = { -- key for decline the alert in the mini dispatch
        key = 'I',
    },
    OpenMiniDispatch = { -- key for open the mini dispatch
        key = 'U',
    },

    -- K9
    K9Menu = { -- key for open the K9 menu
        cmd = 'k9',
        description = Config.Translations.K9Menu,
        key = 'K',
    },

    -- Sirens
    SirensKey = { -- key for activate sirens
        cmd = 'sirens',
        description = Config.Translations.SirensKey,
        key = 'COMMA',
    },
    LightsSirens = { -- key for activate lights
        cmd = 'lights',
        description = Config.Translations.LightsSirens,
        key = 'Q',
    },
    
    -- Interactions 
    HandCuff = { -- key for handcuff
        description = Config.Translations.HandCuff,
        key = '',
    },
    QRR = { -- key for QRR
        description = Config.Translations.QRR,
        key = '',
    },
    Ten20 = { -- key for 10-20
        description = Config.Translations.Ten20,
        key = '',
    },
    Tackle = { -- key for tackle
        description = Config.Translations.Tackle,
        key = '',
    },
    VehicleInto = { -- key for set ped into the vehicle
        description = Config.Translations.VehicleInto,
        key = '',
    },

    -- Force
    ForceVehicle = {  -- The name of the command to force vehicles, this is going to force the vehicle and send alert to on duty
        cmd = 'force',
    },

    -- Quick access menu
    QuickAccess = { -- key for open the right menu
        cmd = 'quickaccess',
        description = Config.Translations.QuickAccess,
        key = 'F7',
    },

    -- Minimap
    Minimap = { -- key for set the minmap to police mode
        cmd = 'policeminmap',
        description = Config.Translations.Minimap,
        key = '',
    },

    -- Radio
    TalkRadio = { -- key for talk on your radio
        description = Config.Translations.TalkRadio,
        key = 'LMENU',
    },

    ChangeRadioAnim = { -- commands for change the radio animation
        cmd = 'animradio',
    },

    TalkMegaphone = { -- key for talk in the megaphone
        key = 246, -- DEFUALT KEY: Y - https://docs.fivem.net/docs/game-references/controls/
    },

    -- Alerts
    CustomCommandAlert = {
        ["911"] = {
            jobCategory = "police",
            triggerEvent = "origen_police:client:onPlayerCall911",
        },
        ["911ems"] = {
            jobCategory = "ambulance",
            triggerEvent = "origen_police:client:onPlayerCall911ems",
        },
    }
}