local Translations = {
    afk = {
        will_kick = 'Estás AFK y serás expulsado en ',
        time_seconds = ' segundos!',
        time_minutes = ' minuto(s)!',
        kick_message = 'Fuiste expulsado por estar AFK'
    },
    wash = {
        in_progress = "El vehículo está siendo lavado...",
        wash_vehicle = "[E] Lavar Vehículo",
        wash_vehicle_target = "Lavar Vehículo",
        dirty = "El vehículo no está sucio",
        cancel = "Lavado cancelado..."
    },
    consumables = {
        eat_progress = "Comiendo...",
        drink_progress = "Bebiendo...",
        liqour_progress = "Bebiendo licor...",
        coke_progress = "Olfateo rápido...",
        crack_progress = "Fumando crack...",
        ecstasy_progress = "Tomando pastillas",
        healing_progress = "Curando",
        meth_progress = "Fumando metanfetamina",
        joint_progress = "Encendiendo porro...",
        use_parachute_progress = "Poniendo el paracaídas...",
        pack_parachute_progress = "Empacando el paracaídas...",
        no_parachute = "¡No tienes un paracaídas!",
        armor_full = "¡Ya tienes suficiente armadura!",
        armor_empty = "No estás usando un chaleco...",
        armor_progress = "Poniendo la armadura corporal...",
        heavy_armor_progress = "Poniendo la armadura corporal...",
        remove_armor_progress = "Quitando la armadura corporal...",
        canceled = "Cancelado..."
    },
    cruise = {
        unavailable = "Control de crucero no disponible",
        activated = "Control de crucero activado",
        deactivated = "Control de crucero desactivado"
    },
    editor = {
        started = "¡Comenzó la grabación!",
        save = "¡Grabación guardada!",
        delete = "¡Grabación eliminada!",
        editor = "¡Hasta luego, cocodrilo!"
    },
    firework = {
        place_progress = "Colocando el fuego artificial...",
        canceled = "Cancelado...",
        time_left = "Lanzamiento del fuego artificial en ~r~"
    },
    seatbelt = {
        use_harness_progress = "Colocando el arnés de carrera",
        remove_harness_progress = "Quitando el arnés de carrera",
        no_car = "No estás en un coche."
    },
    teleport = {
        teleport_default = 'Usar Ascensor'
    },
    pushcar = {
        stop_push = "[E] Dejar de Empujar"
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})