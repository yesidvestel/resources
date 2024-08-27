RadioConfig = {}

RadioConfig.Anims = {
    {
        Dict = "random@arrests",
        Anim = "generic_radio_chatter"
    },
    {
        Dict = "cellphone@str",
        Anim = "cellphone_call_listen_a",
        Prop = "prop_cs_hand_radio",
        PropBone = 57005,
        PropPlacement = {
            0.12,
            0.02,
            -0.02,
            20.0,
            70.0,
            130.0
        },
    },
    {
        Dict = "anim@male@holding_radio",
        Anim = "holding_radio_clip",
        Prop = "prop_cs_hand_radio",
        PropBone = 28422,
        PropPlacement = {
            0.0750,
            0.0230,
            -0.0230,
            -90.0000,
            0.0,
            -59.9999
        },
    },
}

function ParseFrecID(frec)
    local id = string.gsub(frec, "%s", "-"):lower()

    id = string.gsub(id, "á", "a")
    id = string.gsub(id, "é", "e")
    id = string.gsub(id, "í", "i")
    id = string.gsub(id, "ó", "o")
    id = string.gsub(id, "ú", "u")
    id = string.gsub(id, "ñ", "n")

    return id
end