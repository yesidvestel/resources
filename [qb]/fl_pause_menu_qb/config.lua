config = {
    discordLink = "https://discord.gg/56zt87zcgB", -- Set discrod link
    discord_Webhook = "https://discord.com/api/webhooks/1242584310100525147/q4Oiyffc6lhLbM_5rtnJhBZw9u69OZW1ajSZb_A1tzLBASXDQeropt28FzzOji70rp0x",
    discord_footer_message = "Reported by ",
    discord_WebhookColor = 16753920, -- Only decimal color
    discord_error_message = "Invalid form!",

    ServerName = 'ComunaRp', -- Server Name
    server_language = 'en', -- en or hu

    -- Section Names and text
    Sections = {
        News = {
            title = 'Noticias', 
            text = 'Si el cliente es muy inteligente podrá conseguir el resultado deseado. Ni placer para ser rechazado.'
        }, -- News Section

        Updates = {
            title = 'Actualizaciones', 
            text = 'Si el cliente es muy inteligente podrá conseguir el resultado deseado. Ni placer para ser rechazado.'
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
            title = 'Entrar', 
            text = 'Enviar informe a la discord!'
        }, -- Submit Section

        CustomSection = {
            title = 'Sección personalizada', 
            text = 'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Neque voluptas at recusandae.'
        }, -- Submit Section

    },


    -- Set Button title and text
    Buttons = {
        MapSection = {
            title = 'Map', 
            text = 'Mostrar el mapa!'
        }, 
        SettingsSection = {
            title = 'Ajustes', 
            text = 'Abre la configuración!'
        },
        ResumeSection = {
            title = 'Reanudar', 
            text = 'De vuelta al juego!'
        },
        DisconnectSection = {
            title = 'Desconectar', 
            text = 'Adiós!'
        },
    },

    -- Set rules
    rules = {
        -- First Rule
        {
            title = 'Regla 1',
            text = 'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Aliquid perspiciatis quo error magni ad unde expedita possimus minima, itaque aspernatur dolores corporis, eius labore, laborum placeat voluptatibus id vitae nesciunt?'
        },

        -- Second Rule
        {
            title = 'Regla 2',
            text = 'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Aliquid perspiciatis quo error magni ad unde expedita possimus minima, itaque aspernatur dolores corporis, eius labore, laborum placeat voluptatibus id vitae nesciunt?'
        },

        -- Third Rule
        {
            title = 'Regla 3',
            text = 'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Aliquid perspiciatis quo error magni ad unde expedita possimus minima, itaque aspernatur dolores corporis, eius labore, laborum placeat voluptatibus id vitae nesciunt?'
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