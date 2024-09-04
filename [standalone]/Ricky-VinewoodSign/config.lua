Config = {}

-- Define el framework a usar: esx, qbcore, standalone o autodetect
Config.Framework = 'autodetect' 

-- Comando para abrir el menú
Config.Command = 'vinewood'

-- Grupos autorizados (solo para esx y qbcore)
Config.AuthorizedGroups = {
    group = {
        'admin'  -- Agrega aquí los grupos que tienen permiso para usar el comando
    },
    identifier = {
        'discord:570816359861321748',  -- Identificadores autorizados para standalone
        'license:301ae3559b4170dc213c2cca929fe42482657cc7',
        'fivem:2253455'
    }
}

-- Traducciones para el NUI
Config.Locales = {
    ['vinewood'] = "Vinewood",
    ['sign'] = "Firmar",
    ['text'] = "Texto",
    ['color'] = "Color",
    ['text_edited'] = "¡Texto editado!",
    ['type_text'] = "Vinewood"
}

-- Nombre del archivo donde se guardan los textos y colores
Config.FileName = 'textSettings.json'

-- Coordenadas y orientaciones para los modelos
Config.Coords = {
    [1] = {
        coordinate = vector3(668.4682, 1211.0850, 326.0588),
        heading = 343.5
    },
    [2] = {
        coordinate = vector3(681.3944, 1204.1750, 326.2883),
        heading = 345.0
    },
    [3] = {
        coordinate = vector3(696.2234, 1199.1080, 326.3676),
        heading = 345.0
    },
    [4] = {
        coordinate = vector3(711.2237, 1196.9670, 326.2217),
        heading = 345.0
    },
    [5] = {
        coordinate = vector3(728.8736, 1194.6030, 326.5620),
        heading = 345.0
    },
    [6] = {
        coordinate = vector3(745.7531, 1187.6000, 327.8065),
        heading = 345.0
    },
    [7] = {
        coordinate = vector3(763.6939, 1184.8940, 329.1479),
        heading = 345.0
    },
    [8] = {
        coordinate = vector3(776.6939, 1174.8940, 326.1479),
        heading = 345.0
    },
}
