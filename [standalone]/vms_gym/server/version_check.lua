Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local function ToNumber(str)
        return tonumber(str)
    end
    local resourceName = GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
    PerformHttpRequest('https://raw.githubusercontent.com/vames-dev/VMS_AssetsVersions/master/'..resourceName..'.txt',function(error, result, headers)
        if not result then 
            return print('^1The version check failed, github is down.^0') 
        end
        local result = json.decode(result:sub(1, -2))
        if ToNumber(result.version:gsub('%.', '')) > ToNumber(currentVersion:gsub('%.', '')) then
            local symbols = '^9'
            for cd = 1, 26+#resourceName do
                symbols = symbols..'-'
            end
            symbols = symbols..'^0'
            print(symbols)
            print('^1'..currentVersion..'^0.\nCurrent Version: ^2'..result.version..)
            print(symbols)
        end
    end, 'GET')
end)