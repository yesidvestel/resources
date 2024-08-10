local properties = nil

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    Wait(1000)
    SendNUIMessage({
        action = 'SET_STYLE',
        data = Config.Style
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    SendNUIMessage({
        action = 'SET_STYLE',
        data = Config.Style
    })
end)

RegisterNUICallback('buttonSubmit', function(data, cb)
    SetNuiFocus(false)
    properties:resolve(data.data)
    properties = nil
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    SetNuiFocus(false)
    properties:resolve(nil)
    properties = nil
    cb('ok')
end)

local function ShowInput(data)
    Wait(150)
    if not data then return end
    if properties then return end

    properties = promise.new()

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = data
    })

    return Citizen.Await(properties)
end

exports('ShowInput', ShowInput)

RegisterCommand('testinput', function()
    local bill = exports['qb-input']:ShowInput({
        header = "Generar recibo",
		submitText = "Facturar",
        inputs = {
            {
                text = "Server ID(#)",
				name = "citizenid", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true -- Optional [accepted values: true | false] but will submit the form if no value is inputted
            },
            {
                text = "Precio de la factura ($)", -- text you want to be displayed as a place holder
                name = "billprice", -- name of the input should be unique otherwise it might override
                type = "number", -- type of the input - number will not allow non-number characters in the field so only accepts 0-9
                isRequired = false -- Optional [accepted values: true | false] but will submit the form if no value is inputted
            }
			
        }
    })
    if bill ~= nil then
        if bill.citizenid == nil or bill.billprice == nil then 
            return 
        end
        TriggerServerEvent("qb-input:bill:player", bill.citizenid, bill.billprice)
    end
	
end)
RegisterKeyMapping('testinput', 'Open invoice', 'keyboard', 'F6')
