Config.Maps = { -- IMPORTANT, THIS OPTION IS DEPRECATED, USE THE IC MENU SETTINGS TO CHANGE THE MAP MARKERS
}
-- IMPORTANT, THIS OPTION IS DEPRECATED, USE THE IC MENU SETTINGS TO CHANGE THE MAP MARKERS
-- IMPORTANT, THIS OPTION IS DEPRECATED, USE THE IC MENU SETTINGS TO CHANGE THE MAP MARKERS
-- IMPORTANT, THIS OPTION IS DEPRECATED, USE THE IC MENU SETTINGS TO CHANGE THE MAP MARKERS
-- IMPORTANT, THIS OPTION IS DEPRECATED, USE THE IC MENU SETTINGS TO CHANGE THE MAP MARKERS
-- IMPORTANT, THIS OPTION IS DEPRECATED, USE THE IC MENU SETTINGS TO CHANGE THE MAP MARKERS

Config.MarkersDraw = true -- Draw the markers on the map

-- DONT TOUCH BELOW;

MarkersList = {
    RequestVehicle = {
        sprite = 36,
        event = "origen_police:client:buyveh",
        text = "Request vehicle",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    ModifyVehicle = {
        sprite = 36,
        event = "origen_police:client:modifyveh",
        text = "Modify vehicle",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    SaveVehicle = {
        sprite = 36,
        radius = 3,
        event = "origen_police:client:deletevehicle",
        text = "Save vehicle",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    RequestBoat = {
        sprite = 35,
        event = "origen_police:client:boat",
        text = "Request boat",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    SaveBoat = {
        sprite = 35,
        radius = 3,
        event = "origen_police:client:deletevehicle",
        text = "Save boat",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    SaveHelicopter = {
        sprite = 34,
        radius = 3,
        event = "origen_police:client:deletevehicle",
        text = "Save helicopter",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    RequestHelicopter = {
        sprite = 34,
        event = "origen_police:client:helicop",
        text = "Request helicopter",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    DressingRoom = {
        sprite = 20,
        event = "origen_police:client:clothing",
        text = "Access to the dressing room",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    ["Inventory/Armoury"] = {
        sprite = 20,
        event = "origen_police:client:inventory",
        text = "Access to the inventory/armory",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    EvidenceReport = {
        sprite = 20,
        event = "origen_police:client:makereport",
        text = "Write evidence report",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
}


PublicMarkerList = {
    Duty = {
        sprite = 20,
        event = "origen_police:client:enterOnDuty",
        text = "Enter on duty",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    Finger = {
        sprite = 20,
        event = "origen_police:client:domyfinguer",
        text = "Put your finger on the reader",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    CriminalClothes = {
        sprite = 20,
        event = "origen_police:client:CriminalClothes",
        text = "Change clothes",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    Pertenences = {
        sprite = 20,
        event = "origen_police:client:pertenences",
        text = "Leave your belongings",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
    ConfiscatedVehicles = {
        sprite = 36,
        event = "origen_police:client:openConfiscatedMenu",
        text = "Confiscated vehicles",
        rgba = {r = 0, g = 0, b = 0, a = 255}
    },
}

Tables = {
    Markers = {
        
    }
}

Public = {
    Markers = {},
    CriminalClothe = {
        ["qb-clothing"] = {
            ["male"] = {
                ["hat"] = { item = -1, texture = 0},
                ["t-shirt"] = {
                    item = 15, texture = 0
                },
                ["torso2"] = {
                    item = 31, texture = 0
                },
                ["pants"] = {
                    item = 5, texture = 7
                },
                ["shoes"] = {
                    item = 56, texture = 1
                },
                ["arms"] = {
                    item = 12, texture = 0
                },
            }
        },
        ["illenium-appearance"] = {
            ["male"] = {
                model = "mp_m_freemode_01",
                components = {
                    {texture = 0, component_id = 0, drawable = 0},
                    {texture = 0, component_id = 1, drawable = 0},
                    {texture = 0, component_id = 2, drawable = 0},
                    {texture = 0, component_id = 3, drawable = 5},
                    {texture = 2, component_id = 4, drawable = 27},
                    {texture = 0, component_id = 5, drawable = 0},
                    {texture = 0, component_id = 6, drawable = 8},
                    {texture = 0, component_id = 7, drawable = 0},
                    {texture = 0, component_id = 8, drawable = 15},
                    {texture = 0, component_id = 9, drawable = 0},
                    {texture = 0, component_id = 10, drawable = 0},
                    {texture = 0, component_id = 11, drawable = 5}
                },        
            }
        }
    },
    Radars = {},
    Blips = {
        {
            coords = vector4(429.7668, -976.2729, 30.7057, 159.6318),
            sprite = 60,
            color = 29,
            name = "Police Station",
            size = 0.8
        },
        {
            coords = vector4(1811.3948, 3690.8940, 34.1778, 186.9994),
            sprite = 60,
            color = 60,
            name = "Police Station",
            size = 0.8
        },
        {
            coords = vector4(409.46, -1628.92, 29.29, 318.28),
            sprite = 237,
            color = 0,
            name = "Impound",
            size = 0.8
        }
    },
    TrafficZones = {}
}

BillsNPCPositions = {}
SpawnConfiscatedVehicles = {}
MapOptions = {}

function Shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

function LoadMarkers()
    for mapIndex, mapName in pairs(Config.Maps) do
        Tables.Markers[mapIndex] = {}
        local mapData = exports["origen_police"]:LoadMarkers(mapName)
        for markerType, markersData in pairs(mapData) do
            if markerType == "Options" then
                MapOptions[mapIndex] = markersData
                goto skip_marker_type
            end
            for markerIndex, markerData in pairs(markersData) do
                local newMarkerData = MarkersList[markerType]
                local newMarkerDataCopy = Shallowcopy(newMarkerData)
                if not newMarkerData then
                    if markerType == "BillsNPC" then 
                        BillsNPCPositions[#BillsNPCPositions + 1] = markerData.coords
                        goto skip_marker
                    end
                    if markerType == 'SpawnConfiscatedVehicles' then
                        SpawnConfiscatedVehicles[mapIndex] = markerData.coords
                        goto skip_marker
                    end
                    if markerType == 'Options' then
                        goto skip_marker
                    end
                    newMarkerData = PublicMarkerList[markerType]
                    newMarkerDataCopy = Shallowcopy(newMarkerData)
                    newMarkerDataCopy.coords = markerData.coords
                    newMarkerDataCopy.spawn = markerData.spawn
                    newMarkerDataCopy.station = mapIndex
                    newMarkerDataCopy.stationName = mapName
                    Public.Markers[#Public.Markers + 1] = newMarkerDataCopy
                else
                    newMarkerDataCopy.coords = markerData.coords
                    newMarkerDataCopy.spawn = markerData.spawn
                    newMarkerDataCopy.station = mapIndex
                    newMarkerDataCopy.stationName = mapName
                    Tables.Markers[mapIndex][#Tables.Markers[mapIndex] + 1] = newMarkerDataCopy
                end
                ::skip_marker::
            end
            ::skip_marker_type::
        end

        if not MapOptions[mapIndex] then 
            MapOptions[mapIndex] = {}
        end
    end
    CreateNPCsBills()
end

function IsStationActive(station)
    for k, v in pairs(Config.Maps) do 
        if v == station then return true end
    end
end

function ReloadMarkers()
    Tables.Markers = {}
    Public.Markers = {}
    ClearNPCsBills()
    LoadMarkers()
end

function IsJobAllowed(options, jobCat)
    if #options.AllowedJobCat == 0 then return true end
    for _, job in pairs(options.AllowedJobCat) do 
        if job == jobCat then 
            return true
        end
    end
    return false
end

Public.CriminalClothe = Public.CriminalClothe[Config.Clothing == "fivem-appearance" and "illenium-appearance" or Config.Clothing]