function ShowHelpNotification(key, msg)
    -- Put your code here if you want to use a custom notification
    if Config.Framework == "qbcore" then
        exports['qb-core']:DrawText(msg, nil, key)
    elseif Config.Framework == "esx" then
        Framework.ShowHelpNotification(msg, key)
    end
end

function ShowNotification(msg)
    if not Config.CustomNotify then
        if Config.Framework == "qbcore" then
            Framework.Functions.Notify(msg, "primary")
        elseif Config.Framework == "esx" then
            Framework.ShowNotification(msg)
        end
    else
        -- Put your code here if you want to use a custom notification
    end
end

function HideHelpNotification()
    if Config.Framework == "qbcore" then 
        exports["qb-core"]:HideText()
        return
    end
    -- Write your code here if you want to use a custom notification and delete the code above
end

function OpenMenu(...)
    if Config.OxLibMenu and Config.Framework == "esx" then
        if not lib then 
            return print("^1[Origen Police]^0 You have set the menu to ox_lib but you don't have uncommented the ox_lib line in the fxmanifest of origen_police^0")
        end
        local menuType = select(1, ...)
        if menuType == "dialog" then
            local menuID = select(3, ...)
            local title = select(4, ...).title
            local onSubmit = select(5, ...)
            local canel = select(6, ...)

            local input = lib.inputDialog(title, {'Value'})
 
            if not input then return end
            close = function() end
            onSubmit({value = input[1]}, {close = close})
        else
            local menuID = select(3, ...)
            local title = select(4, ...).title
            local elements = select(4, ...).elements
            local parsedOptions = {}
            local onSelectCallback = select(5, ...)
            for k, v in pairs(elements) do
                local option = {
                    title = v.label,
                    description = "",
                    onSelect = function()
                        local data = {}
                        data.current = {}
                        for z, s in pairs(v) do 
                            data.current[z] = s
                        end
                        local menuFunction = {}
                        menuFunction.close = function()
                            lib.hideContext(menuID)
                        end
                        onSelectCallback(data, menuFunction)
                    end,
                }
                table.insert(parsedOptions, option)
            end
            lib.registerContext({
                id = menuID,
                title = title,
                options = parsedOptions
            })
            lib.showContext(menuID)
        end
        return
    end
    if Config.OxLibMenu and Config.Framework == "qbcore" then
        local menuType = select(1, ...)
        if menuType == 'dialog' then
            local title = select(4, ...).title
            local onSubmit = select(5, ...)
            local input = lib.inputDialog(title, {'Value'})
 
            if not input then return end
            close = function() end
            onSubmit({value = input[1]}, {close = close})
        else
            local menuID = math.random(1, 1000).."origen_police"
            local mainData = select(1, ...)
            local title = mainData[1].header
            local options = {}
            for k, v in pairs(mainData) do
                if v.isMenuHeader then goto continue end
                table.insert(options, {
                    title = v.header,
                    description = v.txt,
                    onSelect = function()
                        if v.params.isAction then
                            v.params.event()
                        elseif v.params.event then
                            if v.params.isServer then
                                TriggerServerEvent(v.params.event, v.params.args)
                            else
                                TriggerEvent(v.params.event, v.params.args)
                            end
                        else
                            print("No event/action found for menu: ", v.header)
                        end
                    end
                })
                ::continue::
            end
            lib.registerContext({
                id = menuID,
                title = title,
                options = options
            })
            lib.showContext(menuID)
        end
        return
    end 

    if Config.Framework == "qbcore" then 
        local menuType = select(1, ...)
        if menuType == 'dialog' then
            local menuID = select(3, ...)
            local title = select(4, ...).title
            local onSubmit = select(5, ...)
            local cancel = select(6, ...)
            local input = exports['qb-input']:ShowInput({
                header = title,
                inputs = {
                    {
                        name = "value",
                        text = "Value",
                        type = "text",
                        isRequired = true
                    }
                }
            })
            if input then
                local data = {}
                data.value = input.value
                onSubmit(data, {close = function() end})
            end
        else
            exports["qb-menu"]:openMenu(...)
        end
    elseif Config.Framework == "esx" then
        Framework.UI.Menu.Open(...)
    else
        ShowNotification("The menu system isn't compatible with your framework")
    end
end

function ProgressBar(...)
    if Config.Framework == "qbcore" then
        Framework.Functions.Progressbar(...)
    elseif Config.Framework == "esx" then
        if GetResourceState("esx_progressbar") ~= "missing" then
            Framework.Progressbar(...)
        end
    end
end