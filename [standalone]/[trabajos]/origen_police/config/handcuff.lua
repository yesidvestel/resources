Config.HandCuff = {
    SkillCheck = {
        enabled = false, -- Enable a skillcheck to make target handcuffing to give the a chance to escape
        WaitChance = 3500, -- The time that have to escape
        func = function()
            if not lib then 
                return print("^1[ERROR] ^0Oxlib not found, please make sure that you have it and the fxmanifest oxlib line is uncommented.")
            end
            return lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}}, {'w', 'a', 's', 'd'})
        end
    }
}