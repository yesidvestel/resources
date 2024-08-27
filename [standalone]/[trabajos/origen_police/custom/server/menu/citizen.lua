function SearchCitizen(citizenid, job)
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery('SELECT citizenid, charinfo, image FROM players WHERE citizenid LIKE @text OR CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, "$.firstname")), " ", JSON_UNQUOTE(JSON_EXTRACT(charinfo, "$.lastname"))) LIKE @text ' .. job.. 'LIMIT 50', {["@text"] = "%" .. citizenid .. "%"})
    else
        return MySQL.awaitQuery('SELECT identifier, firstname, lastname, image FROM users WHERE identifier LIKE @text OR CONCAT(firstname, " ", lastname) LIKE @text ' .. job.. 'LIMIT 50', {["@text"] = "%" .. citizenid .. "%"})
    end
end

function GetWanted()
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery('SELECT citizenid, charinfo, image FROM players WHERE wanted = 1'), {}
    else
        return MySQL.awaitQuery('SELECT identifier, firstname, lastname, image FROM users WHERE wanted = 1'), {}
    end
end

function GetCitizen(citizenid)
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery('SELECT citizenid, charinfo, job, image, dangerous, wanted, inventory FROM players WHERE citizenid = ?', {citizenid})
    else
        return MySQL.awaitQuery('SELECT identifier, inventory, firstname, lastname, image, dangerous, wanted, dateofbirth, sex, job, job_grade FROM users WHERE identifier = ?', {citizenid})
    end
end

function GetPoliceList(desiredJobsQuery)
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery('SELECT citizenid, charinfo, metadata, image, job FROM players WHERE '..desiredJobsQuery)
    else
        return MySQL.awaitQuery('SELECT identifier, firstname, lastname, image, job_grade, job FROM users WHERE '..desiredJobsQuery)
    end
end

function GetPolice(citizenid)
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery('SELECT citizenid, charinfo, job, image, metadata FROM players WHERE citizenid = ?', {citizenid})
    else
        return MySQL.awaitQuery('SELECT identifier, firstname, lastname, dateofbirth, job, job_grade, sex, image FROM users WHERE identifier = ?', {citizenid})
    end
end

function GetGender(gender)
    local retval = nil
    if Config.Framework == 'qbcore' then
        retval = gender == 1 and 'Female' or 'Male'
    elseif Config.Framework == 'esx' then
        retval = (gender == 'm' or gender == 'h') and 'Male' or 'Female'
    end
    return retval
end