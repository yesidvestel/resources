--if GetResourceState("origen_police") == "started" or GetResourceState("origen_ilegal") == "started" then return end

RadioConfig = {}

RadioConfig.DefaultKey = "LMENU"

RadioConfig.Anims = {
    { Dict = "random@arrests", Anim = "generic_radio_chatter" },
    { Dict = "cellphone@str", Anim = "cellphone_call_listen_a" }
}

RadioConfig.Whisper = {
    ["hablar-central"] = {"central"},
    ["esp-asig"] = {"esperando-asignacion"},
    ["hablar-comi"] = {"comisaria"},
    ["hablar-tacs"] = {"tac-01", "tac-02", "tac-03", "tac-04"},
    ["hablar-ems"] = {"mando-safd"},
    ["hablar-sapd"] = {}
}

function ParseFrecID(frec)
    local id = string.gsub(frec, "%s", "_"):lower()

    id = string.gsub(id, "á", "a")
    id = string.gsub(id, "é", "e")
    id = string.gsub(id, "í", "i")
    id = string.gsub(id, "ó", "o")
    id = string.gsub(id, "ú", "u")
    id = string.gsub(id, "ñ", "n")

    return id
end