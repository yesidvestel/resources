-- Add translations by MC
local Translations = {
    headers = {
        ['bsm'] = 'Menú del jefe - ',
    },
    body = {
        ['manage'] = 'Administrar empleados',
        ['managed'] = 'Consulta tu lista de empleados',
        ['hire'] = 'Contratar empleados',
        ['hired'] = 'Contratar civiles cercanos',
        ['storage'] = 'Acceso al almacenamiento',
        ['storaged'] = 'Almacenamiento abierto',
        ['outfits'] = 'Trajes',
        ['outfitsd'] = 'Ver outfits guardados',
        ['money'] = 'Administración del dinero',
        ['moneyd'] = 'Consulta el Saldo de tu Empresa',
        ['mempl'] = 'Administrar empleados - ',
        ['mngpl'] = 'Administrar ',
        ['grade'] = 'Grado: ',
        ['fireemp'] = 'Echar',
        ['hireemp'] = 'Contratar - ',
        ['cid'] = 'Ciudadano ID: ',
        ['balance'] = 'Balance: $',
        ['deposit'] = 'Depósito',
        ['depositd'] = 'Depositar dinero en cuenta',
        ['withdraw'] = 'Retirar',
        ['withdrawd'] = 'Retirar dinero de la cuenta',
        ['depositm'] = 'Depositar dinero <br> Saldo disponible: $',
        ['withdrawm'] = 'Retirar dinero <br> Saldo disponible: $',
        ['submit'] = 'Confirmar',
        ['amount'] = 'Cantidad',
        ['return'] = 'Devolver',
        ['exit'] = 'Salir',
    },
    drawtext = {
        ['label'] = '[E] Gestionar trabajos',
    },
    target = {
        ['label'] = 'Menú del jefe',
    },
    headersgang = {
        ['bsm'] = 'Manejo de pandillas  - ',
    },
    bodygang = {
        ['manage'] = 'Administrar miembros de pandillas',
        ['managed'] = 'Reclutar o despedir miembros de pandillas',
        ['hire'] = 'Reclutar miembros',
        ['hired'] = 'Contratar miembros de pandillas',
        ['storage'] = 'Acceso al almacenamiento',
        ['storaged'] = 'Alijo de pandillas abierto',
        ['outfits'] = 'Trajes',
        ['outfitsd'] = 'Cambiarse de ropa',
        ['money'] = 'Administración del dinero',
        ['moneyd'] = 'Consulta el saldo de tu pandilla',
        ['mempl'] = 'Administrar miembros de pandillas - ',
        ['mngpl'] = 'Administrar ',
        ['grade'] = 'Grado: ',
        ['fireemp'] = 'Echar',
        ['hireemp'] = 'Contratar miembros de pandillas - ',
        ['cid'] = 'Ciudadano ID: ',
        ['balance'] = 'Balance: $',
        ['deposit'] = 'Depósito',
        ['depositd'] = 'Depositar dinero en cuenta',
        ['withdraw'] = 'Retirar',
        ['withdrawd'] = 'Retirar dinero de la cuenta',
        ['depositm'] = 'Depositar dinero <br> Saldo disponible: $',
        ['withdrawm'] = 'Retirar dinero <br> Saldo disponible: $',
        ['submit'] = 'Confirmar',
        ['amount'] = 'Cantidad',
        ['return'] = 'Devolver',
        ['exit'] = 'Salir',
    },
    drawtextgang = {
        ['label'] = '[E] Gestión de pandillas',
    },
    targetgang = {
        ['label'] = 'Menú de pandillas',
    }
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
