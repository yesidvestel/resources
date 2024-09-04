local Translations = {
    error = {
        no_deposit = "Depósito de $%{value} requerido",
        cancelled = "Cancelado",
        vehicle_not_correct = "¡Este no es un vehículo comercial!",
        no_driver = "Debes ser el conductor para hacer esto.",
        no_work_done = "Aún no has hecho ningún trabajo.",
        backdoors_not_open = "Las puertas traseras del vehículo no están abiertas",
        get_out_vehicle = "Necesitas salir del vehículo para realizar esta acción",
        too_far_from_trunk = "Necesitas tomar las cajas del maletero de tu vehículo",
        too_far_from_delivery = "Necesitas estar más cerca del punto de entrega"
    },
    success = {
        paid_with_cash = "Depósito de $%{value} pagado en efectivo",
        paid_with_bank = "Depósito de $%{value} pagado desde el banco",
        refund_to_cash = "Depósito de $%{value} reembolsado en efectivo",
        you_earned = "Has ganado $%{value}",
        payslip_time = "Visitaste todas las tiendas... ¡Es hora de tu recibo de pago!",
    },
    menu = {
        header = "Camiones disponibles",
        close_menu = "⬅ Cerrar menú",
    },
    mission = {
        store_reached = "Has llegado a la tienda, toma una caja del maletero con [E] y entrégala en el marcador",
        take_box = "Toma una caja de productos",
        deliver_box = "Entregar caja de productos",
        another_box = "Toma otra caja de productos",
        goto_next_point = "Has entregado todos los productos, al siguiente punto",
        return_to_station = "Has entregado todos los productos, regresa a la estación",
        job_completed = "Has completado tu ruta, por favor recoge tu cheque de pago"
    },
    info = {
        deliver_e = "~g~E~w~ - Entregar productos",
        deliver = "Entregar productos",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
