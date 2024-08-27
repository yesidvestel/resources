-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

--- Skill Check
---@param data table Same/similiar data to the ox_lib skillCheck function. Subject to change.
---@return boolean
function WSB.skillCheck(data)
    -- Customize this logic with your own alert dialog UI or ox_lib
    -- data = {
    --     'difficulty' (string - either 'easy', 'medium', 'hard'),
    --     'skill' (string - the skill name),
    -- }
    --
    -- example data:
    -- data = { 'easy', 'medium', 'easy' }
    --
    -- This is simple example of a 3 step skill check with a sequence of easy, medium, easy.
    --
    -- (Basically follow the same as ox_lib skill check and transfer the options to your skill check system)]

    -- Remove under this to use your own skill check --

    local oxLib = GetResourceState('ox_lib')
    if oxLib ~= 'started' and oxLib ~= 'starting' then
        print(
            '^0[^3WARNING^0] ^1ox_lib^0 is not running, please ensure it is started before using ^wsb.skillCheck or customize!^0')
        return false
    end

    return exports.ox_lib:skillCheck(data)
end
