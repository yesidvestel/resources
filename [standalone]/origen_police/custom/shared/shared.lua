function CanOpenTablet(xjob) -- This function is used to check if the player can open the tablet.
    if not xjob then return {false, nil}; end
    local getPlayerFunc = IsDuplicityVersion() and FW_GetPlayer or FW_GetPlayer
    if type(xjob) == "number" then
        local player = getPlayerFunc(xjob)
        if player == nil then
            return {false, nil, nil};
        end
        if player.PlayerData == nil or player.PlayerData.job == nil or player.PlayerData.job.name == nil then
            return {false, nil, nil};
        end
        xjob = player.PlayerData.job.name
    end
    for category, jobList in pairs(Config.JobCategory) do 
        for k, job in pairs(jobList) do 
            if string.lower(job.name) == string.lower(xjob) then
                if job.penalFilter == nil then
                    print("ERROR: The job "..job.name.." does not have a penalFilter set in the config/permissions.lua file.")
                end
                return {true, category, job.penalFilter or "police"};
            end
        end
    end
    return {false, nil};
end

exports("CanOpenTablet", CanOpenTablet) -- exports['origen_police']:CanOpenTablet('police')

function GetMinimunGrade(jobName, param)
    if Config.Permissions[jobName] or not Config.Permissions[jobName][param] then
        return Config.Permissions[jobName][param]
    end
    debuger("ERROR: The job "..jobName.." does not exist in the config file or the parameter "..param.." is not set.")
    return 888
end

exports("GetMinimunGrade", GetMinimunGrade)

function GetTableLength(table)
    if type(table) ~= "table" then return 0 end
    if(table == nil) then return 0 end
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end