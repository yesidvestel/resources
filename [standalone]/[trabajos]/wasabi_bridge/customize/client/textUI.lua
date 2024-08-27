-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

-- Customize this to customize text UI accross all Wasabi Scripts

-- Text UI
local textUI = false

-- Show text UI
function WSB.showTextUI(msg, options)
    -- Customize this logic with your own text UI or ox_lib
    -- msg = string, the message to display
    -- options = { -- Optional, data to pass to text UI system
    --     position = string - either 'right-center', 'left-center', 'top-center', or bottom-center,
    --     icon = string - icon name,
    --     iconColor = string - icon color,
    --     textColor = string - text color,
    --     backgroundColor = string - background color,
    --     iconAnimation = 'pulse', -- currently only pusle available
    -- }

    -- Remove under this to use your own text UI --
    ShowTextUI(msg, options)
    textUI = msg
    -- Remove above this if you are using your own menu system / want to use ox_lib

    --[[
    local oxLib = GetResourceState('ox_lib')
    if oxLib ~= 'started' and oxLib ~= 'starting' then
        print(
            '^0[^3WARNING^0] ^1ox_lib^0 is not running, please ensure it is started before using ^wsb.showTextUI or use default!^0')
        return
    end
    exports.ox_lib:showTextUI(msg)
    textUI = msg
    ]]
end

-- Hide text UI
function WSB.hideTextUI()
    -- Remove under this to use your own text UI --
    HideTextUI()
    textUI = false
    -- Remove above this if you are using your own menu system / want to use ox_lib

    --[[
    local oxLib = GetResourceState('ox_lib')
    if oxLib ~= 'started' and oxLib ~= 'starting' then
        print(
            '^0[^3WARNING^0] ^1ox_lib^0 is not running, please ensure it is started before using ^wsb.showTextUI or use default!^0')
        return
    end
    exports.ox_lib:hideTextUI()
    textUI = false
    ]]
end

-- Checking for text UI
function WSB.isTextUIOpen()
    return textUI and true or false, textUI or false
end
