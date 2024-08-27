-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

-- Modify this with whatever progress bar/circle/both you want

---Displays a running progress based on its type.
---@param type "progressBar" | "progressCircle"
---@param data table Same data as used in ox_lib progress bar/circle. Subject to change.
---@return boolean
function WSB.progressUI(data, type)
    -- Replace this with your own progress bar/circle system

    -- Fill in example here of progressUI parameters when utilizing

    -- Use NUI Events and such here for built-in progress bar/circle


    local oxLib = GetResourceState('ox_lib')
    if oxLib ~= 'started' and oxLib ~= 'starting' then
        print('^0[^3WARNING^0] ^1ox_lib^0 is not running, please ensure it is started before using ^wsb.progressUI or use default!^0')
        return false
    end
    if type == 'progressBar' then
        return exports.ox_lib:progressBar(data)
    else
        return exports.ox_lib:progressCircle(data)
    end
end
