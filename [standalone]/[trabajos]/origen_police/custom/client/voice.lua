function OverrideProximityRange(distance, bool)
    if Config.VoiceSystem == "pma-voice" then 
        if distance ~= nil then 
            exports["pma-voice"]:overrideProximityRange(distance, bool)
            return
        end
        exports["pma-voice"]:clearProximityOverride()
    end
end

function ToggleVoice(target, value, string)
    if Config.VoiceSystem == "pma-voice" then 
        exports["pma-voice"]:toggleVoice(target, value, string)
    end
end

function PlayerTargets(radioFreqs, freqName)
    if Config.VoiceSystem == "pma-voice" then 
        exports["pma-voice"]:playerTargets(radioFreqs)
    elseif Config.VoiceSystem == "saltychat" then
        exports["saltychat"]:SetRadioChanel(freqName or "", true)
    end
end

function SetRadioVolume(volume)
    if Config.VoiceSystem == "pma-voice" then 
        exports["pma-voice"]:setRadioVolume(volume)
    end
end

function CanTalk()
    -- Logic for checking if the player can talk in radio
    return true
end