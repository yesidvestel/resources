--------------------------NAME TAG-----------------------------
---------------------------------------------------------------
RegisterNetEvent('dusa_pets:cl:renamepet')
AddEventHandler('dusa_pets:cl:renamepet', function()
    if DoesEntityExist(pet) then
        if GetResourceState('ox_lib') ~= 'started' then 
            local dialog = exports['qb-input']:ShowInput({
                header = Config.Notifications[Config.Locale].context_header,
                submitText = "Accept",
                inputs = {
                    {
                        text = Config.Notifications[Config.Locale].context_label, -- text you want to be displayed as a place holder
                        name = "petname", -- name of the input should be unique otherwise it might override
                        type = "text", -- type of the input
                        isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                        -- default = "Mavis", -- Default text option, this is optional
                    },
                },
            })
            if dialog ~= nil then
                for k,v in pairs(dialog) do
                    TriggerServerEvent('dusa_pets:sv:updatePetName', v, activePet)
                    petName = v
                    dusa.serverCallback("dusa-pets:cb:getPetData", function(data)
                        SendNUIMessage({
                            type = 'o_petmenu',
                            petinvData = data,
                            action = 'updatePetName'
                        })
                    end)
                    dusa.showNotification(Config.Notifications[Config.Locale].pet_renamed_to..' '..v, 'success')
                    TriggerServerEvent('dusa-pets:removeItem', 'nametag', 1)
                end
            end
        else
            print('3131')
            local input = lib.inputDialog(Config.Notifications[Config.Locale].context_header, {{
                type = 'input',
                label = Config.Notifications[Config.Locale].context_label,
                description = Config.Notifications[Config.Locale].context_desc,
                required = true,
                min = 3,
                max = 16
            }})
            if input ~= nil then
                TriggerServerEvent('dusa_pets:sv:updatePetName', input[1], activePet)
                petName = input[1]
                dusa.serverCallback("dusa-pets:cb:getPetData", function(data)
                    SendNUIMessage({
                        type = 'o_petmenu',
                        petinvData = data,
                        action = 'updatePetName'
                    })
                end)
                dusa.showNotification(Config.Notifications[Config.Locale].pet_renamed_to..' '..input[1], 'success')
                TriggerServerEvent('dusa-pets:removeItem', 'nametag', 1)
            end
        end


    else
        dusa.showNotification(Config.Notifications[Config.Locale].call_to_rename, 'error')
    end
end)


--------------------------FEED BOWL----------------------------
---------------------------------------------------------------
RegisterNetEvent('dusa_pets:cl:feed')
AddEventHandler('dusa_pets:cl:feed', function()
    if DoesEntityExist(pet) then
        TriggerEvent('dusa:startPlacing', {obj = 'prop_bowl_crisps', item = 'petbowl'})
    else
        dusa.showNotification(Config.Notifications[Config.Locale].call_to_feed, 'error')
    end
end)

---------------------------BLIPS-------------------------------
---------------------------------------------------------------
CreateThread(function()
    petshop = AddBlipForCoord(Config.Blip.coords)
    SetBlipSprite(petshop, Config.Blip.sprite)
    SetBlipDisplay(petshop, 4)
    SetBlipScale(petshop, Config.Blip.scale)
    SetBlipColour(petshop, Config.Blip.color)
    SetBlipAsShortRange(petshop, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Blip.name)
    EndTextCommandSetBlipName(petshop)
end)