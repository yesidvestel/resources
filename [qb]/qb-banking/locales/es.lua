local Translations = {
    success = {
        withdraw = 'Retiro exitoso',
        deposit = 'Depósito exitoso',
        transfer = 'Transferencia exitosa',
        account = 'Cuenta creada',
        rename = 'Cuenta renombrada',
        delete = 'Cuenta borrada',
        userAdd = 'Usuario agregado',
        userRemove = 'Usuario eliminado',
        card = 'Tarjeta creada',
        give = '$%s efectivo dado',
        receive = '$%s efectivo recibido',
    },
    error = {
        error = 'Ocurrió un error',
        access = 'No autorizado',
        account = 'Cuenta no encontrada',
        accounts = 'Número máximo de cuentas creadas',
        user = 'Usuario ya agregado',
        noUser = 'Usuario no encontrado',
        money = 'Dinero insuficiente',
        pin = 'PIN no válido',
        card = 'No se encontró ninguna tarjeta bancaria',
        amount = 'Monto invalido',
        toofar = 'Estás muy lejos',
    },
    progress = {
        atm = 'Accediendo al cajero',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
