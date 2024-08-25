Commands = {
    givebusiness = { -- perms to create one business /command id-player business-type
        cmd = 'givebusiness', -- example: /givebusiness 1 shop
        description = Lang.command.givebuss,
        perms = 'mod'
    },
    createbusiness = { -- create business need givebusiness first /command
        cmd = 'createbusiness',-- example: /create
        description = Lang.command.createbuss
    },
    removebusiness = { -- hire employed  -- /command id-player
        cmd = 'removebusiness', --example: /removebusiness 3 
        description = Lang.command.removebuss,
        perms = 'mod'
    },
    deletebusiness = { -- remove business /command job
        cmd = 'deletebusiness', --example: /deletebusiness origen
        description = Lang.command.deletebuss,
        perms = 'mod'
    },
    additemsbusiness = { -- addd business  /command job item price level
        cmd = 'additemsbusiness', --example: /additemsbusiness origen tosti 10 0
        description = Lang.command.allow_buss,
        perms = 'mod'
    },
    removeitemsbusiness = { -- remove business /command job item
        cmd = 'removeitemsbusiness',  --example: /removeitemsbusiness origen tosti
        description = Lang.command.allow_remove_buss,
        perms = 'mod'
    },
    givebusinesscar = { -- give car business /command job vehicle
        cmd = 'givebusinesscar', --example: /givebusinesscar origen sultan
        description = Lang.command.givebusinesscar,
        perms = 'mod'
    },
    removebusinesscar = { -- remove car business /command job plate
        cmd = 'removebusinesscar', --example: /removebusinesscar origen ORIGEN0001
        description = Lang.command.removebusinesscar,
        perms = 'mod'
    },

    business = { --check your business and duty state
        cmd = 'business', --example: /business
        description = Lang.command.business
    }


}