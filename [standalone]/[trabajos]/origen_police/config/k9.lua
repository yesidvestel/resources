Config.K9 = {
    SearchRadious = 30.0, -- The radious that the dog will search for ilegal items
    Model = "a_c_shepherd", -- The model of the dog
    Vehicles = { -- Allowed vehicle models
        [GetHashKey("exp")] = 4, 
        [GetHashKey("fbi2")] = 4,
    },
    IlegalItems = { -- The ilegal items that the dog will search in the environment
        ["packaged_weed"] = true,
        ["meth_bag"] = true,
        ["cocaine_bag"] = true
    },
    SpawnOpenDoor = 2,
    SpawnCarOffset = vector3(-2.0, -1.0, 0.0)
}