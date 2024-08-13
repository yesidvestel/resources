-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

-- Modify this to for how vehicle keys are added to your server (If applicable)

-- Add car keys
function WSB.giveCarKeys(plate, _model, _vehicle)
    if WSB.framework == 'qb' then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    else
        exports.wasabi_carlock:GiveKey(plate) -- Leave like this if using wasabi_carlock
    end
end

function WSB.removeCarKeys(plate, _model, _vehicle)
    -- Put remove key logic here
end
