Config.RandomNames = {
    { -- Nombres
        ["male"] = {
            "Tyler",
            "Jim",
            "Derek",
            "Jhon",
            "Maverick",
            "Yuuto",
            "Eiden",
            "Aiden",
            "Nathan",
            "Jay",
            "Ray",
            "Nael",
            "Rick",
            "Jason",
            "Frank",
            "John",
            "Michael",
            "Robert",
            "David",
            "James",
            "William",
            "Richard",
            "Charles",
            "Joseph",
            "Thomas",
            "Christopher",
            "Daniel",
            "Paul",
            "Mark",
            "Donald",
            "George",
            "Kenneth",
            "Steven",
            "Edward",
            "Brian",
            "Ronald",
            "Anthony",
            "Kevin",
            "Jason",
            "Matthew",
            "Gary",
            "Timothy",
            "Jose",
            "Larry",
            "Jeffrey",
            "Mike",
        },
        ["female"] = {
            "Dannyel",
            "Mirella",
            "Zowy",
            "Carolina",
            "Chiara",
            "Lauren",
            "Veronica",
            "Evelyn",
            "Ray",
            "Angela",
            "Danitza",
            "Noa",
            "Naomi",
            "Sarah",
            "Sophie",
            "Kiara",
            "Akuma",
            "Arch",
            "Sandra",
            "Alma",
            "Kira",
            "Daniel",
        } 
    },
    { -- Apellidos
        "Kawasaki",
        "Leon",
        "Locket",
        "Williams",
        "Scott",
        "White",
        "Rodriguez",
        "Park",
        "Charlin",
        "Brooks",
        "Hunter",
        "Smith",
        "Carter",
        "Walker",
        "Wallace",
        "Stark",
        "Berry",
        "Troya",
        "Street",
        "Thompson",
        "Salvatore",
        "Miller",
        "Clark",
        "Jones",
        "Black",
        "Blue",
        "Red",
        "O Connor",
        "O Neil",
        "Oreo",
        "Parker",
        "Rivera",
        "Martin",
        "Diaz",
        "Grimes",
        "Walter",
        "Smith",
        "Johnson",
        "Williams",
        "Brown",
        "Jones",
        "García",
        "Miller",
        "Davis",
        "Rodríguez",
        "Martínez",
        "Hernández",
        "López",
        "González",
        "Pérez",
        "Taylor",
        "Anderson",
        "Wilson",
        "Jackson",
        "Moore",
        "Martin",
        "Lee",
        "Pérez",
        "Harris",
        "Clark",
        "Lewis",
        "Robinson",
        "Walker",
        "Hall",
        "Allen",
        "King",
        "Nabosky"
    }
}

function GetRandomName(m_o_f)
    if not m_o_f or (m_o_f ~= "male" and m_o_f ~= "female") then
        m_o_f = "male"
    end
    return Config.RandomNames[1][m_o_f][math.random(1, #Config.RandomNames[1][m_o_f])] .. " " .. Config.RandomNames[2][math.random(1, #Config.RandomNames[2])]
end

exports("GetRandomName", GetRandomName)