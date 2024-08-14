function sendBill(source, data)
    local Player = FW_GetPlayer(source)
    local jobCategory = CanOpenTablet(Player.PlayerData.job.name)[2]
    local author = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " (" .. (Player.PlayerData.metadata.police_badge or "0000") .. ")"
    local title = Config.Translations.PoliceBill
    if jobCategory ~= "police" then
        title = "Bill from " .. jobCategory
    end

    local billid = MySQL.awaitInsert('INSERT INTO origen_police_bills (citizenid, title, concepts, price, job, author, months) VALUES (?, ?, ?, ?, ?, ?, ?)', {data.citizenid, title, json.encode(data.bills), data.price, Player.PlayerData.job.name, author, data.months})
    CreateLog({
        type = 'Bills',
        embed = {
            title = Config.LogsTranslations.AddBill.title,
            description = Config.LogsTranslations.AddBill.message:format(author, data.price, data.months, json.encode(data.bills, {indent = true})),
            color = 0x1B55BF,
        },
    })
    return {
        billid = billid,
        author = author,
        date = os.time() * 1000,
    }
end

function DeleteBill(source, data)
    local Player = FW_GetPlayer(source)

    if GetMinimunGrade(Player.PlayerData.job.name, "DeleteBill") > Player.PlayerData.job.grade.level then
        return false
    end
    return (MySQL.awaitQuery('DELETE FROM origen_police_bills WHERE id = ?', {data.billid}).affectedRows > 0)
end

function GetDebors(jobCategory)
    -- Excepted table structure:
    -- [
    --      {
    --          citizenid = "123456789",
    --          price = 1000,
    --          charinfo = "[{firstname: 'John', lastname: 'Doe'}]"}]", -- ONLY FOR QB
    --          firstname = "John", -- ONLY FOR ESX
    --          lastname = "Doe", -- ONLY FOR ESX
    --          image = "profile.png",
    --          totalprice = 3000,
    --      }
    -- ]
    
    local result = {}
    if Config.Framework == "qbcore" then
        result = MySQL.awaitQuery('SELECT opb.citizenid, SUM(opb.price) AS totalprice, p.charinfo, p.image FROM origen_police_bills opb INNER JOIN players p ON opb.citizenid COLLATE utf8mb4_general_ci = p.citizenid COLLATE utf8mb4_general_ci WHERE opb.payed = 0 AND opb.job = "'..jobCategory..'" GROUP BY opb.citizenid')
    else
        result = MySQL.awaitQuery('SELECT opb.citizenid, SUM(opb.price) AS totalprice, u.firstname, u.lastname, u.image FROM origen_police_bills opb INNER JOIN users u ON opb.citizenid COLLATE utf8mb4_general_ci = u.identifier COLLATE utf8mb4_general_ci WHERE opb.payed = 0 AND opb.job = "'..jobCategory..'" GROUP BY opb.citizenid')
    end
    return result
end

function GetBillsFromCitizenID(cid, jobCategory)
    local jobs = {}
    for _, jobData in pairs(Config.JobCategory[jobCategory]) do 
        jobs[#jobs + 1] = "'"..jobData.name.."'"
    end
    local jobFilter = table.concat(jobs, ',')
    return MySQL.awaitQuery('SELECT * FROM origen_police_bills WHERE citizenid = ? AND job IN ('..jobFilter..') ORDER BY id DESC', {cid})
end

function GetUnpayedBills(cid)
    return MySQL.awaitQuery('SELECT * FROM origen_police_bills WHERE citizenid = ? AND payed = 0 ORDER BY id DESC', {cid})
end

function GetBillsFromReporter(reportid)
    return MySQL.awaitQuery('SELECT citizenid, concepts, price, months FROM origen_police_bills WHERE reportid = ?', {reportid})
end

function NewBillReport(index, data, author, jobCategory)
    return MySQL.awaitInsert('INSERT INTO origen_police_bills (citizenid, title, concepts, price, job, author, months, reportid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {data.value[index].citizenid, Config.Translations.PoliceBill, json.encode(data.value[index].bills), data.value[index].price, jobCategory, author, data.value[index].months, data.reportid})
end

function UpdateBillReport(index, data)
    return MySQL.awaitUpdate('UPDATE origen_police_bills SET citizenid = ?, concepts = ?, price = ?, months = ? WHERE id = ?', {data.value[index].citizenid, json.encode(data.value[index].bills), data.value[index].price, data.value[index].months, data.value[index].billid})
end

function PayBill(cid)
    MySQL.awaitQuery("UPDATE origen_police_bills SET payed = ? WHERE id = ?", {1, cid})
end

exports("PayBill", PayBill)
exports("GetUnpayedBills", GetUnpayedBills)