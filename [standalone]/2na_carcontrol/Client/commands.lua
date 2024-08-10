RegisterKeyMapping('+carmenu', 'Shows car menu', 'KEYBOARD', Config.MenuKey)
RegisterCommand("+carmenu", function(source, args, rawCommand) 
    if ShowingMenu then 
        TriggerEvent("2na_carcontrol:Client:HideMenu")
    else
        TriggerEvent("2na_carcontrol:Client:ShowMenu")
    end
end)