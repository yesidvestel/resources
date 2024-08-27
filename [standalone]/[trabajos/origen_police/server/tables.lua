FW_CreateCallback("origen_police:callback:GetPoliceTables", function(source, cb)
    cb(Tables)
end)

FW_CreateCallback("origen_police:callback:GetPublicTables", function(source, cb)
    cb(Public)
end)