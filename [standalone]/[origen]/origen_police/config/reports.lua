Config.Tags = {
    ['default'] = { -- The default tags of report if there isn't specific tags for a job
        "Altercation",
        "Firearms",
        "Open case",   -- Sames as translate "OpenCase"
        "Case closed",   -- Sames as translate "CaseClosed"
        "Null case",   -- Sames as translate "NullCase"
        "Crimes against animals",
        "Vial security felony",
        "Crimes against natural resources",
        "Crimes in documents, identifications or licenses",
        "Drugs",
        "Fib",
        "Quality report",
        "Homicide attempt",
        "Homicide attempt (police)",
        "Police operation",
        "Import robbery",
        "Vehicle theft",
        "Major robbery",
        "Minor robbery",
        "Kidnapping",
        "Kidnapping (police)", 
    },
    ['police'] = 'default', -- here is copying the default tags
    ['sheriff'] = 'default', -- here is copying the default tags
    ['ambulance'] = {
        "Medical emergency",
        "Medical date",
    }
}

-- DONT TOUCH ANYTHING BELOW THIS LINE
for k, v in pairs(Config.Tags) do
    if type(v) == 'string' then
        Config.Tags[k] = Config.Tags[v]
    end
end

Translations.ReportTags = Config.Tags