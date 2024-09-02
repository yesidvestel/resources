local Translations = {
    ui = {
        -- Principal
        male = "Hombre",
        female = "Mujer",
        error_title = "¡Error!",
        characters_header = "Selector de Personajes",
        characters_count = "personajes",
      
        -- Configurar Personajes
        default_image = 'image/action_dot.gif',
        create_new_character = "Crear nuevo personaje",
        -- default_right_image = 'image/action_key.png',

        -- Crear personaje
        create_header = "Creación de Identidad",
        header_detail = "Ingresa los detalles de tu personaje",
        gender_marker = "Indicador de Género",
        
        missing_information = "Falta información por completar.",
        badword = "Has usado una palabra inapropiada, ¡inténtalo de nuevo!",
       
        create_firstname = "Nombre",
        create_lastname = "Apellido",
        create_nationality = "Nacionalidad",
        create_birthday = "Fecha de Nacimiento",

        -- Botones
        select = "Seleccionar",
        create = "Crear",
        spawn = "Aparecer",
        delete = "Eliminar",
        cancel = "Cancelar",
        confirm = "Confirmar",
        close = "Cerrar",
    },

    notifications = {
        ["char_deleted"] = "¡Personaje eliminado!",
        ["deleted_other_char"] = "Has eliminado con éxito el personaje con el ID de ciudadano %{citizenid}.",
        ["forgot_citizenid"] = "¡Olvidaste ingresar un ID de ciudadano!",
    },

    commands = {
        -- /deletechar
        ["deletechar_description"] = "Elimina el personaje de otro jugador",
        ["citizenid"] = "ID de Ciudadano",
        ["citizenid_help"] = "El ID de Ciudadano del personaje que deseas eliminar",

        -- Cargado
       
        -- /logout
        ["logout_description"] = "Cerrar sesión de Personaje (Solo Admin)",

        -- /closeNUI
        ["closeNUI_description"] = "Cerrar Multi NUI"
    },

    misc = {
        ["succes_loaded"] = '^2[qb-core]^7 %{value} se ha cargado exitosamente!',
        ["droppedplayer"] = "Te has desconectado de QBCore"
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})