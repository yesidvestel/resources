---@param duplicate boolean
---@param mod 'repair' | 'cosmetic' | 'colors' | 11 | 12 | 13 | 15 | 18
---@param props NotifyProps?
---@param level number?
return function(duplicate, mod, props, level)
    if duplicate then
        lib.notify({
            title = 'Taller',
            description = 'Ya tienes este mod instalado',
            position = 'top',
            type = 'error',
        })
        return false
    end

    local success = lib.callback.await('customs:server:pay', false, mod, level)
    if success then
        lib.notify({
            id = props?.id,
            title = props?.title or 'Taller',
            description = props?.description,
            duration = props?.duration,
            position = props?.position or 'top',
            type = props?.type or 'success',
            style = props?.style,
            icon = props?.icon or 'fa-solid fa-llave-inglesa',
            iconColor = props?.iconColor,
        })
        SendNUIMessage({sound = true})
        return true
    end

    lib.notify({
        title = 'Taller',
        description = 'No tienes suficiente dinero',
        position = 'top',
        type = 'error',
    })
    return false
end