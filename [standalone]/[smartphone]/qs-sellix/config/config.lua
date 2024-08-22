Config = {}
Locales = Locales or {}

Config.Framework = 'qb' -- 'esx' or 'qb'

Config.Language = 'es'

Sellix = {
    ['items'] = {
        [1] = {
            name = 'rolex',
            label = 'Rolex',
            price = {500, 800},
            quantity = {1, 10},
        },
        
        [2] = {
            name = 'goldbar',
            label = 'Gold Bar',
            price = {900, 1350},
            quantity = {5, 18},
        },

        [3] = {
            name = 'goldchain',
            label = 'Gold Chain',
            price = {100, 250},
            quantity = {1, 14},
        },

        [4] = {
            name = 'goldcoin',
            label = 'Gold Coin',
            price = {100, 200},
            quantity = {1, 19},
        },

        [5] = {
            name = 'watch',
            label = 'Watch',
            price = {100, 200},
            quantity = {1, 19},
        },
        
        [6] = {
            name = 'diamond_ring',
            label = 'Diamond Ring',
            price = {270, 350},
            quantity = {1, 14},
        },

        [7] = {
            name = 'markedbills',
            label = 'Marked Bills',
            price = {11700, 15000},
            quantity = {1, 6},
        },

        [8] = {
            name = 'cashroll',
            label = 'Cash Roll',
            price = {1000, 2000},
            quantity = {1, 7},
        },

        [9] = {
            name = 'cashstack',
            label = 'Cash Stack',
            price = {575, 1125},
            quantity = {1, 7},
        },

        [10] = {
            name = 'sandwitch',
            label = 'Sandwitch',
            price = {200, 300},
            quantity = {1, 19},
        },

        [11] = {
            name = 'tablet',
            label = 'Tablet',
            price = {250, 400},
            quantity = {1, 10},
        },

        [12] = {
            name = 'phone',
            label = 'Smartphone',
            price = {250, 400},
            quantity = {1, 10},
        },
        
        [13] = {
            name = 'laptop',
            label = 'Laptop',
            price = {250, 400},
            quantity = {1, 10},
        },
    },

    ['peds'] = {
        [1] = {1704428387, "Kaven James", "https://cdn.discordapp.com/attachments/644631964774694942/770006933012348958/unknown.png"},
        [2] = {1975732938, "Jerald Wolff", "https://cdn.discordapp.com/attachments/705937454116372500/770264343346020382/unknown.png"},
        [3] = {1240128502, "Ivan Petrovic", "https://cdn.discordapp.com/attachments/705937454116372500/770265505054326834/unknown.png"},
        [4] = {-1427838341, "Sucma Cock", "https://cdn.discordapp.com/attachments/705937454116372500/770267413123563520/unknown.png"},
        [5] = {678319271, "Red sus", "https://cdn.discordapp.com/attachments/705937454116372500/770269921719615518/unknown.png"},
        [6] = {1182012905, "Master Bate", "https://cdn.discordapp.com/attachments/705937454116372500/770270736970809354/unknown.png"},
        [7] = {1090617681, "Anita P.Ness", "https://cdn.discordapp.com/attachments/705937454116372500/770274537538715658/unknown.png"},
        [8] = {-628553422, "Holden Tudiks", "https://cdn.discordapp.com/attachments/705937454116372500/770277237672116225/unknown.png"},
        [9] = {-872673803, "Mike Oxsmall", "https://cdn.discordapp.com/attachments/705937454116372500/770280321319960576/unknown.png"},
        [10] = {-518348876, "Pat Maweeni", "https://cdn.discordapp.com/attachments/705937454116372500/770282898346999898/unknown.png"},
        [11] = {-538688539, "Eye masterbated", "https://cdn.discordapp.com/attachments/705937454116372500/770285868337332245/unknown.png"},
        [12] = {1681385341, "Justin Herass", "https://cdn.discordapp.com/attachments/705937454116372500/770288018640076861/unknown.png"},
        [13] = {-709209345, "Jyent Deck", "https://cdn.discordapp.com/attachments/705937454116372500/770288656857563177/unknown.png"},
        [14] = {-847807830, "Mike Hunt", "https://cdn.discordapp.com/attachments/705937454116372500/770289872904257596/unknown.png"},
        [15] = {1951946145, "Ramit Inmah Ashol", "https://cdn.discordapp.com/attachments/705937454116372500/770290567140737074/unknown.png"},
        [16] = {1039800368, "Sofa King Gay", "https://cdn.discordapp.com/attachments/705937454116372500/770291220333068318/unknown.png"},
        [17] = {549978415, "Pat myaz", "https://cdn.discordapp.com/attachments/705937454116372500/770292614539771935/unknown.png"},
        [18] = {813893651, "Dixen Cider", "https://cdn.discordapp.com/attachments/705937454116372500/770302277792694302/unknown.png"},
        [19] = {51789996, "Cox Ucker", "https://cdn.discordapp.com/attachments/705937454116372500/770303484091826206/unknown.png"},
        [20] = {-892841148, "Hoof Hearted", "https://cdn.discordapp.com/attachments/705937454116372500/770304037035442186/unknown.png"},
        [21] = {773063444, "Ice wallow come", "https://cdn.discordapp.com/attachments/705937454116372500/770306207058886676/unknown.png"},
        [22] = {894928436, "Chris Peecock", "https://cdn.discordapp.com/attachments/705937454116372500/770308335555051530/unknown.png"},
        [23] = {-254493138, "Bo nerr", "https://cdn.discordapp.com/attachments/705937454116372500/770309309468246066/unknown.png"},
        [24] = {1830688247, "Issac oxs", "https://cdn.discordapp.com/attachments/705937454116372500/770310875520696370/unknown.png"},
        [25] = {1068876755, "Yuri Tarded", "https://cdn.discordapp.com/attachments/705937454116372500/770311711600541727/unknown.png"},
        [26] = {1809430156, "Phil McCrack", "https://cdn.discordapp.com/attachments/705937454116372500/770312695882711070/unknown.png"},
        [27] = {-929103484, "Heywood Jablowme", "https://cdn.discordapp.com/attachments/705937454116372500/770313369021579354/unknown.png"},
        [28] = {-1806291497, "Hugh Jass", "https://cdn.discordapp.com/attachments/705937454116372500/770312141647380490/unknown.png"},
        [29] = {1704428387, "Brian O'Connor", "https://cdn.discordapp.com/attachments/644631964774694942/770006933012348958/unknown.png"},
        [30] = {1975732938, "Amaya Downs", "https://cdn.discordapp.com/attachments/705937454116372500/770264343346020382/unknown.png"},
        [31] = {1240128502, "Alicja Hodges", "https://cdn.discordapp.com/attachments/705937454116372500/770265505054326834/unknown.png"},
        [32] = {-1427838341, "Antonio Logan", "https://cdn.discordapp.com/attachments/705937454116372500/770267413123563520/unknown.png"},
        [33] = {678319271, "Shyla Guerrero", "https://cdn.discordapp.com/attachments/705937454116372500/770269921719615518/unknown.png"},
        [34] = {1182012905, "Michalina Moss", "https://cdn.discordapp.com/attachments/705937454116372500/770270736970809354/unknown.png"},
        [35] = {1090617681, "Eugene Gibson", "https://cdn.discordapp.com/attachments/705937454116372500/770274537538715658/unknown.png"},
        [36] = {-628553422, "Leigh Benson", "https://cdn.discordapp.com/attachments/705937454116372500/770277237672116225/unknown.png"},
        [37] = {-872673803, "Haniya Mcghee", "https://cdn.discordapp.com/attachments/705937454116372500/770280321319960576/unknown.png"},
    },

    Drops = {
        [1] =  { ['x'] = 74.5,['y'] = -762.17,['z'] = 31.68,['h'] = 160.98 },
        [2] =  { ['x'] = 100.58,['y'] = -644.11,['z'] = 44.23,['h'] = 69.11 },
        [3] =  { ['x'] = 175.45,['y'] = -445.95,['z'] = 41.1,['h'] = 92.72 },
        [4] =  { ['x'] = 130.3,['y'] = -246.26,['z'] = 51.45,['h'] = 219.63 },
        [5] =  { ['x'] = 198.1,['y'] = -162.11,['z'] = 56.35,['h'] = 340.09 },
        [6] =  { ['x'] = 341.0,['y'] = -184.71,['z'] = 58.07,['h'] = 159.33 },
        [7] =  { ['x'] = -26.96,['y'] = -368.45,['z'] = 39.69,['h'] = 251.12 },
        [8] =  { ['x'] = -155.88,['y'] = -751.76,['z'] = 33.76,['h'] = 251.82 },
        [9] =  { ['x'] = -305.02,['y'] = -226.17,['z'] = 36.29,['h'] = 306.04 },
        [10] =  { ['x'] = -347.19,['y'] = -791.04,['z'] = 33.97,['h'] = 3.06 },
        [11] =  { ['x'] = -703.75,['y'] = -932.93,['z'] = 19.22,['h'] = 87.86 },
        [12] =  { ['x'] = -659.35,['y'] = -256.83,['z'] = 36.23,['h'] = 118.92 },
        [13] =  { ['x'] = -934.18,['y'] = -124.28,['z'] = 37.77,['h'] = 205.79 },
        [14] =  { ['x'] = -1214.3,['y'] = -317.57,['z'] = 37.75,['h'] = 18.39 },
        [15] =  { ['x'] = -822.83,['y'] = -636.97,['z'] = 27.9,['h'] = 160.23 },
        [16] =  { ['x'] = 308.04,['y'] = -1386.09,['z'] = 31.79,['h'] = 47.23 },
    },
}

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end