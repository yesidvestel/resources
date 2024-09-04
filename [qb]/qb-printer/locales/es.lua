local Translations = {
    error = {
        invalid_ext = "Esa no es una extensión válida, solo",
        allowed_ext = "enlaces con extensiones permitidas.",

    },
    info = {
        use_printer = "Usar impresora"

    },
    command = {
        spawn_printer = "impresora"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
```