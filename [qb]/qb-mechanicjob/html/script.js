const navbarOptions = {
    // https://forums.gta5-mods.com/topic/3842/tutorial-handling-meta
    power: [
        { id: "fMass", label: "Masa", description: "El peso del vehículo en kg", min: 0, max: 10000 },
        { id: "fInitialDragCoeff", label: "Coeficiente de Arrastre Inicial", description: "Aumentar para simular el arrastre aerodinámico", min: 0, max: 100 },
        { id: "fDownforceModifier", label: "Modificador de Fuerza Descendente", description: "Cantidad de fuerza descendente aplicada al vehículo", min: 0, max: 100 },
        { id: "nInitialDriveGears", label: "Engranajes de Conducción", description: "Cantidad de engranajes del vehículo", min: 1, max: 10 },
        { id: "fInitialDriveForce", label: "Fuerza de Conducción", description: "Fuerza de salida de la transmisión", min: 0, max: 100 },
        { id: "fDriveInertia", label: "Inercia de Conducción", description: "Qué tan rápido alcanza el máximo de revoluciones", min: 0, max: 2 },
        { id: "fDriveBiasFront", label: "Sesgo de Conducción Frontal", description: "RWD: 0.0 | AWD: 0.5 | FWD: 1.0", min: 0, max: 1 },
        { id: "fInitialDriveMaxFlatVel", label: "Velocidad Máxima de Conducción", description: "Velocidad en la línea roja en la marcha más alta", min: 0, max: 1000 },
        { id: "fClutchChangeRateScaleUpShift", label: "Velocidad de Subida del Embrague", description: "Valor más alto = cambios más rápidos", min: 0, max: 100 },
        { id: "fClutchChangeRateScaleDownShift", label: "Velocidad de Bajada del Embrague", description: "Valor más alto = cambios más rápidos", min: 0, max: 100 },
    ],
    braking: [
        { id: "fSteeringLock", label: "Bloqueo de Dirección", description: "Ángulo máximo de dirección de las ruedas", min: 0, max: 1 },
        { id: "fBrakeForce", label: "Fuerza de Frenado", description: "Potencia total de frenado", min: 0, max: 100 },
        { id: "fBrakeBiasFront", label: "Sesgo de Frenado Frontal", description: "Trasero: 0.0 | Igual: 0.5 | Frontal: 1.0", min: 0, max: 1 },
        { id: "fHandBrakeForce", label: "Fuerza del Freno de Mano", description: "Determina la fuerza del freno de mano", min: 0, max: 100 },
    ],
    traction: [
        { id: "fTractionCurveMax", label: "Curva de Tracción Máxima", description: "Agarre en curva del vehículo", min: 0, max: 100 },
        { id: "fTractionCurveMin", label: "Curva de Tracción Mínima", description: "Agarre en aceleración/frenado del vehículo", min: 0, max: 100 },
        { id: "fTractionCurveLateral", label: "Curva de Tracción Lateral", description: "Forma de la curva de tracción lateral", min: 0, max: 100 },
        { id: "fTractionSpringDeltaMax", label: "Delta Máximo de Resorte de Tracción", description: "Distancia por encima del suelo en la que el coche perderá tracción", min: 0, max: 100 },
        { id: "fLowSpeedTractionLossMult", label: "Multiplicador de Pérdida de Tracción a Baja Velocidad", description: "Más bajo: menos derrape | Más alto: más derrape", min: 0, max: 100 },
        { id: "fTractionBiasFront", label: "Sesgo de Tracción Frontal", description: "Trasero: 0.1 | Igual: 0.5 | Frontal: 0.99", min: 0, max: 1 },
        { id: "fCamberStiffnesss", label: "Rigidez del Camber", description: "Agarre durante derrapes", min: 0, max: 100 },
        { id: "fTractionLossMult", label: "Multiplicador de Pérdida de Tracción", description: "Agarre en asfalto y barro", min: 0, max: 100 },
    ],
    suspension: [
        { id: "vecCentreOfMassOffset", label: "Desplazamiento del Centro de Masa", description: "Desplaza el centro de gravedad a la derecha, hacia adelante, hacia arriba", min: 0, max: 100 },
        { id: "vecInertiaMultiplier", label: "Multiplicador de Inercia", description: "Inercia rotacional", min: 0, max: 100 },
        { id: "fSuspensionForce", label: "Fuerza de Suspensión", description: "Fuerza de la suspensión", min: 0, max: 100 },
        { id: "fSuspensionCompDamp", label: "Amortiguación de Compresión", description: "Valores más altos = más rígido", min: 0, max: 100 },
        { id: "fSuspensionReboundDamp", label: "Amortiguación de Rebote", description: "Valores más altos = más rígido", min: 0, max: 100 },
        { id: "fSuspensionUpperLimit", label: "Límite Superior de Suspensión", description: "Límite visual de cuánto pueden subir las ruedas", min: 0, max: 100 },
        { id: "fSuspensionLowerLimit", label: "Límite Inferior de Suspensión", description: "Límite visual de cuánto pueden bajar las ruedas", min: 0, max: 100 },
        { id: "fSuspensionRaise", label: "Elevación de Suspensión", description: "Altura del cuerpo respecto a las ruedas", min: 0, max: 100 },
        { id: "fSuspensionBiasFront", label: "Sesgo de Suspensión Frontal", description: "Fuerza de la suspensión delantera/trasera", min: 0, max: 1 },
        { id: "fAntiRollBarForce", label: "Fuerza de la Barra Estabilizadora", description: "Valores más grandes = menos inclinación del cuerpo", min: 0, max: 100 },
        { id: "fAntiRollBarBiasFront", label: "Sesgo de la Barra Estabilizadora Frontal", description: "Frontal: 0 | Trasero: 1", min: 0, max: 1 },
        { id: "fRollCentreHeightFront", label: "Altura del Centro de Balanceo Frontal", description: "Valores más grandes = menos vuelcos", min: -0.15, max: 0.15 },
        { id: "fRollCentreHeightRear", label: "Altura del Centro de Balanceo Trasero", description: "Valores más grandes = menos vuelcos", min: -0.15, max: 0.15 },
    ],
    miscellaneous: [
        { id: "fPercentSubmerged", label: "Porcentaje Sumergido", description: "Porcentaje sumergido antes de considerarse hundido", min: 0, max: 100 },
        { id: "fCollisionDamageMult", label: "Multiplicador de Daño por Colisión", description: "Multiplica el daño por colisión", min: 0, max: 10 },
        { id: "fDeformationDamageMult", label: "Multiplicador de Daño por Deformación", description: "Multiplica el daño en la carrocería", min: 0, max: 10 },
        { id: "fWeaponDamageMult", label: "Multiplicador de Daño por Armas", description: "Multiplica el daño por armas", min: 0, max: 10 },
        { id: "fEngineDamageMult", label: "Multiplicador de Daño en el Motor", description: "Multiplica el daño en el motor", min: 0, max: 10 },
        { id: "fPetrolTankVolume", label: "Volumen del Tanque de Gasolina", description: "Cantidad de gasolina que se filtrará tras dañar el tanque del vehículo", min: 0, max: 100 },
        { id: "fOilVolume", label: "Volumen de Aceite", description: "Cantidad de aceite", min: 0, max: 100 },
        { id: "nMonetaryValue", label: "Valor Monetario", description: "Determina la reacción de los NPCs ante accidentes", min: 0, max: 1000000 },
    ],
};

let currentStats = {};

const generateNavbarItems = () => {
    const navbar = document.querySelector(".navbar");
    navbar.innerHTML = "";

    Object.keys(navbarOptions).forEach((option) => {
        const button = document.createElement("button");
        button.classList.add("nav-item");
        button.id = option;
        button.textContent = option.charAt(0).toUpperCase() + option.slice(1);
        navbar.appendChild(button);
    });
};

const displayFieldsForNavbarOption = (option) => {
    const contentArea = document.getElementById("content-area");
    contentArea.innerHTML = "";
    const selectedOptions = navbarOptions[option];

    selectedOptions.forEach((option) => {
        const inputContainer = document.createElement("div");
        inputContainer.classList.add("input-container");

        const inputLabel = document.createElement("label");
        inputLabel.classList.add("input-label");
        inputLabel.htmlFor = option.id;
        inputLabel.textContent = option.label || option.id;

        const numberInput = document.createElement("input");
        numberInput.type = "number";
        numberInput.id = option.id;
        numberInput.classList.add("number-input");
        numberInput.value = currentStats[option.id] !== undefined ? currentStats[option.id] : "";

        if (option.min !== undefined) {
            numberInput.min = option.min;
        }
        if (option.max !== undefined) {
            numberInput.max = option.max;
        }

        if (option.description) {
            inputLabel.addEventListener("mouseover", () => {
                document.getElementById("table-description").textContent = option.description;
            });

            inputLabel.addEventListener("mouseout", () => {
                document.getElementById("table-description").textContent = "";
            });
        }

        inputContainer.appendChild(inputLabel);
        inputContainer.appendChild(numberInput);
        contentArea.appendChild(inputContainer);
    });
};

const openTuner = (stats) => {
    currentStats = stats;
    document.querySelector(".tablet").style.display = "block";
    generateNavbarItems();
    displayFieldsForNavbarOption("power");
};

const saveSettings = () => {
    const contentArea = document.getElementById("content-area");
    let data = {};
    let isInputValid = true;

    const inputContainers = contentArea.querySelectorAll(".input-container");
    inputContainers.forEach((container) => {
        const inputElement = container.querySelector(".number-input");
        if (inputElement) {
            const value = parseFloat(inputElement.value);
            const min = parseFloat(inputElement.min);
            const max = parseFloat(inputElement.max);

            if (value < min || value > max) {
                console.log(inputElement.id + " out of range");
                isInputValid = false;
            } else {
                data[inputElement.id] = value;
            }
        }
    });

    if (isInputValid) {
        fetch("https://qb-mechanicjob/saveTune", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
        });
    }
};

const resetSettings = () => {
    fetch("https://qb-mechanicjob/reset", { method: "POST" });
    closeTuner();
};

const closeTuner = () => {
    document.querySelector(".tablet").style.display = "none";
    fetch("https://qb-mechanicjob/closeTuner", { method: "POST" });
};

document.addEventListener("click", function (event) {
    const targetId = event.target.id;
    const targetClass = event.target.className;

    if (targetClass === "nav-item") {
        displayFieldsForNavbarOption(targetId);
        return;
    }

    switch (targetId) {
        case "save-button":
            saveSettings();
            break;
        case "reset-button":
            resetSettings();
            break;
        case "cancel":
            closeTuner();
            break;
    }
});

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeTuner();
    }
});

window.addEventListener("message", function (event) {
    var eventData = event.data;
    if (eventData.action == "openTuner") {
        openTuner(eventData.stats);
    }
});
