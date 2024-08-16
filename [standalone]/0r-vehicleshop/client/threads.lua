CreateThread(function()
    while Koci.Framework == nil do
        Koci.Framework = Utils.Functions.GetFramework()
        Wait(16)
    end
    
    local anyShopInZone = false
    while true do
        local sleepThread = 2000
        local playerCoords = GetEntityCoords(PlayerPedId())
        local prevShopInZone = anyShopInZone
        anyShopInZone = false

        for k, v in pairs(Config.Shops) do
            local inZone = false

            if #(v.coords - playerCoords) <= v.distance then
                local playerData = Koci.Client.GetPlayerData()
                local auth = true

                if v.job ~= false and v.job ~= playerData.job.name then
                    auth = false
                end

                if auth and not OpenedGallery then
                    sleepThread = 0
                    if v.textType == "drawtext" then
                        Koci.Client.DrawText3D(v.coords, _t("textui.open_gallery", v.name))
                    else
                        if not inZone then
                            anyShopInZone = true
                            inZone = true
                            Koci.Client.ShowTextUI(v.textType, _t("textui.open_gallery", v.name))
                        end
                    end

                    if IsControlJustPressed(1, 38) then
                        openGallery(v)
                        Koci.Client.HideTextUI()
                        inZone = false
                        Wait(1500)
                    end
                end
            end
        end
        if not anyShopInZone and prevShopInZone then
            Koci.Client.HideTextUI()
        end
        Wait(sleepThread)
    end
end)

CreateThread(function()
    for _, v in pairs(Config.Shops) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
end)
