if GetResourceState(Config.MySQLSystem) ~= "started" then
    debuger("MySQL system called "..Config.MySQLSystem.." is not started. Are you sure that you have configured origen_quest/config/_framework.lua^0")
    return
end

if Config.MySQLSystem == "oxmysql" then 
    MySQL.insert = function(...)
        return exports.oxmysql:insert(...)
    end
    MySQL.awaitInsert = function(...)
        return exports.oxmysql:insert_async(...)
    end
    MySQL.prepare = function(...)
        return exports.oxmysql:prepare(...)
    end
    MySQL.awaitPrepare = function(...)
        return exports.oxmysql:prepare_async(...)
    end
    MySQL.query = function(...)
        return exports.oxmysql:query(...)
    end
    MySQL.awaitQuery = function(...)
        return exports.oxmysql:query_async(...)
    end
    MySQL.rawExec = function(...)
        return exports.oxmysql:rawExecute(...)
    end
    MySQL.awaitRawExec = function(...)
        return exports.oxmysql:rawExecute_async(...)
    end
    MySQL.scalar = function(...)
        return exports.oxmysql:scalar(...)
    end
    MySQL.awaitScalar = function(...)
        return exports.oxmysql:scalar_async(...)
    end
    MySQL.single = function(...)
        return exports.oxmysql:single(...)
    end
    MySQL.awaitSingle = function(...)
        return exports.oxmysql:single_async(...)
    end
    MySQL.transaction = function(...)
        return exports.oxmysql:transaction(...)
    end
    MySQL.awaitTransaction = function(...)
        return exports.oxmysql:transaction_async(...)
    end
    MySQL.update = function(...)
        return exports.oxmysql:update(...)
    end
    MySQL.awaitUpdate = function(...)
        return exports.oxmysql:update_async(...)
    end
elseif Config.MySQLSystem == "icmysql" then
    MySQL.insert = function(...)
        return exports.icmysql:Insert(...)
    end
    MySQL.awaitInsert = function(...)
        return exports.icmysql:AwaitInsert(...)
    end
    MySQL.prepare = function(...)
        return exports.icmysql:Prepare(...)
    end
    MySQL.awaitPrepare = function(...)
        return exports.icmysql:AwaitPrepare(...)
    end
    MySQL.query = function(...)
        return exports.icmysql:Query(...)
    end
    MySQL.awaitQuery = function(...)
        return exports.icmysql:AwaitQuery(...)
    end
    MySQL.rawExec = function(...)
        return exports.icmysql:Raw(...)
    end
    MySQL.awaitRawExec = function(...)
        return exports.icmysql:AwaitRaw(...)
    end
    MySQL.scalar = function(...)
        return exports.icmysql:Scalar(...)
    end
    MySQL.awaitScalar = function(...)
        return exports.icmysql:AwaitScalar(...)
    end
    MySQL.single = function(...)
        return exports.icmysql:Single(...)
    end
    MySQL.awaitSingle = function(...)
        return exports.icmysql:AwaitSingle(...)
    end
    MySQL.transaction = function(...)
        return exports.icmysql:Transaction(...)
    end
    MySQL.awaitTransaction = function(...)
        return exports.icmysql:AwaitTransaction(...)
    end
    MySQL.update = function(...)
        return exports.icmysql:Update(...)
    end
    MySQL.awaitUpdate = function(...)
        return exports.icmysql:AwaitUpdate(...)
    end
else
    debuger("MySQL system called "..Config.MySQLSystem.." is not supported right now.")
end

exports("MySQL", function()
    return MySQL
end)