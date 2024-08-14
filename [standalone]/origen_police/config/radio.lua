Config.Multifrec = {
    ["SOUTH UNITS"] = {
        "ADAM-10",
        "ADAM-20",
        "ADAM-30",
        "ADAM-40",
        "ADAM-50",
        "MARY-1",
        "MARY-2",
        "MARY-3",
        "UNION-10",
        "UNION-20",
        "UNION-30",
        "KING-10",
        "KING-20",
        "TOM-1",
        "PEGASO-10",
    },
    ["NORTH UNITS"] = {
        "ALPHA-10",
        "ALPHA-20",
        "ALPHA-30",
        "ALPHA-40",
        "ALPHA-50",
        "MIKE-1",
        "MIKE-2",
        "MIKE-3",
        "BRAVO-10",
        "BRAVO-20",
        "BRAVO-30",
        "CHARLIE-10",
        "CHARLIE-20",
        "FOXTROT-10",
        "AGUILA-10",
    },
    ["SPECIAL UNITS"] = {
        "Central",
        "Comisaria",
        "Esperando asignación",
        "TAC-01",
        "TAC-02",
        "TAC-03",
        "TAC-04",
        "DAVID-10",
        "DAVID-20",
        "DAVID-50",
        "UNIDAD-K9",
        "Oficina IAA",
        "Oficina Investigación",
    },
    ["EMS UNITS"] = {
        "Mando SAFD",
        "Unidad Bomberos 1",
        "Unidad Bomberos 2",
        "Unidad Bomberos 3",
        "Unidad EMS 1",
        "Unidad EMS 2",
        "Unidad EMS 3",
        "Hospital",
        "Parque de Bomberos"
    },
}

Config.ButtonsMultiFreq = {
    ["BROADCAST SAFD"] = {
        "EMS UNITS"
    },
    ["BROADCAST SAPD"] = {
        "SPECIAL UNITS", "NORTH UNITS", "SOUTH UNITS"
    }
}

Config.BindFreqs = {
    ["talk-to-central"] = {"central"},
    ["talk-waiting-assignment"] = {"esperando-asignacion"},
    ["talk-police-station"] = {"comisaria"},
    ["talk-tacs"] = {"tac-01", "tac-02", "tac-03", "tac-04"},
    ["broadcast-special-units"] = {"SPECIAL UNITS"}
}

Config.MegaphoneVoiceDist = 75.0 -- The distance that the voice of the megaphone will be heared

exports("GetPoliceRadioBinds", function()
    return Config.BindFreqs
end)

exports("GetPoliceRadioChannels", function()
    return Config.Multifrec
end)

exports("GetPoliceRadioButtons", function()
    return Config.ButtonsMultiFreq
end)

Config.RequestsTime = 10 -- Minutos

-- DONT TOUCH THIS

function GetCategoryFreqs(category)
    local list = Config.Multifrec[category]
    if not list then
        print("Category not found: " .. category .. " in Config.Multifrec") 
        return {}
    end
    local freqs = {}
    for k, v in pairs(list) do
        table.insert(freqs, v)
    end
    return freqs
end

local nextButtonMultiFreqUpdate = {}
for buttonName, categories in pairs(Config.ButtonsMultiFreq) do 
    for z, category in pairs(categories) do 
        for k, v in pairs(GetCategoryFreqs(category)) do
            if nextButtonMultiFreqUpdate[buttonName] == nil then
                nextButtonMultiFreqUpdate[buttonName] = {}
            end
            nextButtonMultiFreqUpdate[buttonName][#nextButtonMultiFreqUpdate[buttonName] + 1] = v
        end
    end
end

local newBindFreqs = {}
for button, freqs in pairs(Config.BindFreqs) do 
    for _, freq in pairs(freqs) do 
        if Config.Multifrec[freq] then
            for _, freq2 in pairs(Config.Multifrec[freq]) do 
                newBindFreqs[button] = newBindFreqs[button] or {}
                table.insert(newBindFreqs[button], freq2:lower())
            end
        else
            newBindFreqs[button] = newBindFreqs[button] or {}
            table.insert(newBindFreqs[button], freq)
        end
    end
end

for button, freqs in pairs(newBindFreqs) do 
    table.insert(Config.BindFreqs[button], freqs)
end

Config.ButtonsMultiFreq = nextButtonMultiFreqUpdate