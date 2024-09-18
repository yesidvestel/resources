Citizen.CreateThread(function()
    Citizen.Wait(5000)
    
    local function ToNumber(str)
        return tonumber(str)
    end
    
    local resourceName = GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
    
    PerformHttpRequest('https://raw.githubusercontent.com/vames-dev/VMS_AssetsVersions/master/'..resourceName..'.txt', function(error, result, headers)
        if error then
            print('^1The version check failed with error: ' .. error .. '^0')
            return
        end
        
        print('Received result: ' .. result)
        
        local decodedResult = json.decode(result:sub(1, -2))
        
        if not decodedResult or not decodedResult.version then
            print('^1Failed to decode JSON or version field missing.^0')
            return
        end
        
        if ToNumber(decodedResult.version:gsub('%.', '')) > ToNumber(currentVersion:gsub('%.', '')) then
            local symbols = '^9'
            for cd = 1, 26+#resourceName do
                symbols = symbols..'-'
            end
            symbols = symbols..'^0'
            print(symbols)
            print('^1'..currentVersion..'^0.\nCurrent Version: ^2'..decodedResult.version..'^0')
            print(symbols)
        end
    end, 'GET')
end)
