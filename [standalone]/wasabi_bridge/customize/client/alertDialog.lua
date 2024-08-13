-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

--- Alert Dialog
---@param data table
function WSB.alertDialog(data)
    -- Customize this logic with your own alert dialog UI or ox_lib
    -- data = {
    --     header = alert title/header
    --     content = string of contents (markdown supported)
    --     centered = true/false, (center the content)
    --     cancel = true/false (show cancel button)
    --     color = color of the alert (hex)
    -- }
    --
    -- example data:
    -- data = {
    --     header = 'Alert',
    --     content = 'This is an alert!',
    --     centered = true,
    --     cancel = true,
    --     color = '#ff0000'
    -- }
    --
    -- (Basically follow the same as ox_lib menu system and transfer the options to your alert system)]

    -- Remove below this if you are using your own menu system / want to use ox_lib

    AlertDialog(data)

    -- Remove above this to use your own alert dialog or ox_lib

    --[[
    local oxLib = GetResourceState('ox_lib')
    if oxLib ~= 'started' and oxLib ~= 'starting' then
        print(
            '^0[^3WARNING^0] ^1ox_lib^0 is not running, please ensure it is started before using ^wsb.inputDialog or use default!^0')
        return
    end
    return exports.ox_lib:alertDialog(data)]]
end
