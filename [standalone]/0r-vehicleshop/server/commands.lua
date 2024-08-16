if Config.FrameWork == "esx" then
    Koci.Framework.RegisterCommand("rentcontrol", "user", function(xPlayer, args, showError)
        local r = Koci.Server.CheckRemainingRentDay(xPlayer, args.plate)
        Koci.Server.SendNotify(xPlayer.source, "success", r.message)
    end, true, {
        help = "How many days left on your rental car ?",
        validate = true,
        arguments = {
            { name = "plate", help = "Vehicle plate text", type = "string" }
        }
    })

    Koci.Framework.RegisterCommand("rentextend", "user", function(xPlayer, args, showError)
        local r = Koci.Server.VehicleRentExtend(xPlayer, args.plate, args.day)
        Koci.Server.SendNotify(xPlayer.source, "success", r.message)
    end, true, {
        help = "Extend the rental day of your car <payment only bank>.",
        validate = true,
        arguments = {
            { name = "plate", help = "Vehicle plate text", type = "string" },
            { name = "day",   help = "Day <number>",       type = "number" }
        }
    })
elseif Config.FrameWork == "qb" then
    Koci.Framework.Commands.Add("rentcontrol", "How many days left on your rental car ?", {
        {
            name = "plate",
            help = "Vehicle plate text",
        }
    }, false, function(source, args)
        local src = source
        local xPlayer = Koci.Server.GetPlayerBySource(src)
        local r = Koci.Server.CheckRemainingRentDay(xPlayer, args[1])
        Koci.Server.SendNotify(src, "success", r.message)
    end)

    Koci.Framework.Commands.Add("rentextend", "Extend the rental day of your car <payment only bank>.", {
        { name = "plate", help = "Vehicle plate text" },
        { name = "day",   help = "Day <number>" }
    }, false, function(source, args)
        if not args[1] or not args[2] then return false end
        local src = source
        local xPlayer = Koci.Server.GetPlayerBySource(src)
        local r = Koci.Server.VehicleRentExtend(xPlayer, args[1], args[2])
        Koci.Server.SendNotify(src, "success", r.message)
    end)
end
