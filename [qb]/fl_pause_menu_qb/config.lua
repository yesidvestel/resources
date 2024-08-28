config = {
    discordLink = "https://discord.gg/M6BCbHBW3t", -- Set discrod link
    discord_Webhook = "https://discord.com/api/webhooks/1272204307491721298/NclUisg4f_gQnvyGQ9-W1uU1y_BJHE1iepRWvUGOj-M2MMYQ_TZXYlsP50qiZMJN24ds",
    discord_footer_message = "Reportado por ",
    discord_WebhookColor = 5416447, -- Only decimal color
    discord_error_message = "¡Formulario inválido!",

    ServerName = 'Comuna Latín Vice RP', -- Server Name
    server_language = 'es', -- en or hu

    -- Section Names and text
    Sections = {
        News = {
            title = 'Noticias', 
            text = 'Para estar al tanto de todas las noticias y actualizaciones importantes de la ciudad, asegúrate de seguir el canal de anuncios y el canal de news. Mantente informado para no perderte ninguna novedad relevante.'
        }, -- News Section

        Updates = {
            title = 'Actualizaciones', 
            text = 'Para conocer todas las novedades y actualizaciones del servidor, te invitamos a estar pendiente del canal de actualizaciones en Discord. ¡No te pierdas ninguna novedad!'
        }, -- Updates Section

        CharacterInfo = {
            title = 'Información del personaje', 
        }, -- Charachter Information Section
        
        Rules = {
            title = 'Normas', 
        }, -- Rules Section

        Report = {
            title = 'Informe', 
            text = 'Si el cliente es muy inteligente podrá conseguir el resultado deseado. Ni placer para ser rechazado.'
        }, -- Updates Section

        DiscordSection = {
            title = 'Discord', 
            text = 'Únase a nuestra discordia!'
        }, -- Discord Section

        SubmitSection = {
            title = 'Enviar', 
            text = 'Enviar informe a la discord!'
        }, -- Submit Section

        CustomSection = {
            title = 'Sección personalizada', 
            text = 'Aquí puedes revisar detalles específicos y ajustes personalizados relacionados con tu experiencia en el roleplay.'
        }, -- Submit Section

    },


    -- Set Button title and text
    Buttons = {
        MapSection = {
            title = 'Mapa', 
            text = '¡Mostrar el mapa!'
        }, 
        SettingsSection = {
            title = 'Ajustes', 
            text = '¡Abre la configuración!'
        },
        ResumeSection = {
            title = 'Reanudar', 
            text = '¡De vuelta al juego!'
        },
        DisconnectSection = {
            title = 'Desconectar', 
            text = '¡Adiós!'
        },
    },

    -- Set rules
    rules = {
        -- First Rule
        {
            title = 'Regla 1',
            text = 'Mantén la inmersión: Siempre actúa y responde como lo haría tu personaje. Evita hablar fuera de personaje a menos que sea absolutamente necesario, y utiliza los canales o señales apropiadas para distinguir entre el rol y la realidad.'
        },

        -- Second Rule
        {
            title = 'Regla 2',
            text = 'Respeta los límites de los demás: No hagas que tu personaje haga algo que incomode a otros jugadores sin su consentimiento. Esto incluye acciones violentas, lenguaje ofensivo, o cualquier otra cosa que pueda ser sensible para alguien.'
        },

        -- Third Rule
        {
            title = 'Regla 3',
            text = 'No hagas metagaming: No uses información que tu personaje no podría saber dentro del juego. Todo conocimiento debe provenir de lo que el personaje ha aprendido en el mundo del rol, no de lo que tú sabes como jugador.'
        },
    },

    -- Set placeholder text
    placeHolders = {
        text = "Por favor escriba cuál es el problema con el servidor....",
        title = "Establecer título...",
    },

    time = {
        text = "minutos"
    }
}