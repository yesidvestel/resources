RegisterNetEvent('casino:context:hit&stand', function() 
    exports['qb-menu']:openMenu({
        {
            header = "Blackjack en el Casino Diamante",
            isMenuHeader = true,
        },
        {
            header = "Pedir", 
            txt = "Tomar otra carta",
            params = {
                event = "doj:client:blackjackMenu",
                args = 1
            }
        },
        {
            header = "Plantarse", 
            txt = "Sé un gallina",
            params = {
                event = "doj:client:blackjackMenu",
                args = 2
            }
        },
    })
end)

RegisterNetEvent('casino:context:hit&doubledown', function() 
    exports['qb-menu']:openMenu({
        {
            header = "Blackjack en el Casino Diamante",
            isMenuHeader = true,
        },
        {
            header = "Pedir", 
            txt = "Tomar otra carta",
            params = {
                event = "doj:client:blackjackMenu",
                args = 1
            }
        },
        {
            header = "Plantarse", 
            txt = "Sé un gallina",
            params = {
                event = "doj:client:blackjackMenu",
                args = 2
            }
        },
        {
            header = "Doble Apuesta", 
            txt = "Duplica tu apuesta inicial",
            params = {
                event = "doj:client:blackjackMenu",
                args = 3
            }
        },
    })
end)

RegisterNetEvent('casino:context:hit&split', function()
    exports['qb-menu']:openMenu({
        {
            header = "Blackjack en el Casino Diamante",
            isMenuHeader = true,
        },
        {
            header = "Pedir", 
            txt = "Tomar otra carta",
            params = {
                event = "doj:client:blackjackMenu",
                args = 1
            }
        },
        {
            header = "Plantarse", 
            txt = "Sé un gallina",
            params = {
                event = "doj:client:blackjackMenu",
                args = 2
            }
        },
        {
            header = "Dividir", 
            txt = "Dividir",
            params = {
                event = "doj:client:blackjackMenu",
                args = 4
            }
        },
    })
end)
