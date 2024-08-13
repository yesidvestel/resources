let timerInterval, currentCounter, lastUpdateTime, color, translationStrings, emsCount;

const elements = {
    container: document.getElementById('container'),
    color: document.querySelector('.color'),
    dyingHeader: document.querySelector(".dying-header"),
    emergencyText: document.querySelector(".emergency"),
    body: document.body,
    timer: document.querySelector('.timer'),
    timerHeader: document.querySelector(".timer-header"),
    timerSubheader: document.querySelector(".timer-subheader"),
    minuteTens: document.getElementById('minute-tens'),
    minuteOnes: document.getElementById('minute-ones'),
    secondTens: document.getElementById('second-tens'),
    secondOnes: document.getElementById('second-ones'),
    timerBoxes: document.querySelectorAll('.timer-box'),
    timerSeparator: document.querySelector(".timer-separator"),
    timerContainer: document.querySelector('.timer-container'),
    ems: document.querySelector('.ems'),
    online: document.querySelector('.online'),
    emsCounter: document.querySelector('.ems-counter')
};

const adjustEMS = (emsOnline, color, showCount) => {
    if (!showCount) {
        elements.ems.style.display = "none";
        elements.online.style.display = "none";
        return;
    }

    if (emsOnline < 1) {
        elements.ems.style.color = "rgba(195, 7, 63, 1)";
        elements.online.style.display = "none";
        elements.ems.innerHTML = translationStrings.ems_offline;
        elements.emsCounter.style.bottom = "40px";
    } else {
        elements.ems.style.color = color;
        elements.ems.innerHTML = translationStrings.ems_online;
        elements.online.innerHTML = translationStrings.currently_online + emsOnline;
        elements.online.style.display = "block";
    }

    elements.ems.style.display = "block";
};


const updateTimerDisplay = (timeLeft) => {
    const minutes = Math.floor(timeLeft / 60).toString().padStart(2, '0');
    const seconds = (timeLeft % 60).toString().padStart(2, '0');
    elements.timer.innerHTML = `${minutes}:${seconds}`;
    if (timeLeft <= 0) elements.timer.innerHTML = "00:00";
};

const setColorCSSRule = (color) => {
    const styleSheet = document.styleSheets[1];
    const cssRule = `.color { color: ${color}; }`;
    styleSheet.insertRule ? styleSheet.insertRule(cssRule, styleSheet.cssRules.length) : styleSheet.addRule('.color', `color: ${color};`);
};

const displayScreenOne = (data, color) => {
    Object.assign(elements.body.style, { backgroundImage: 'none', backgroundColor: 'rgba(0, 0, 0, 0.329)' });
    Object.assign(elements.emsCounter.style, {
        fontWeight: "bold",
        display: "block",
        top: "10px",
        left: "50%",
        transform: "translateX(-50%)",
        textAlign: "center"
    });

    adjustEMS(data.emsOnline, color, data.showCount);

    if (data.dispatched) elements.emergencyText.innerHTML = translationStrings.ems_on_the_way;
    if (data.canRespawn) {
        elements.dyingHeader.innerHTML = translationStrings.player_passed;
        elements.timerHeader.innerHTML = translationStrings.player_hurt_respawn;
    }

    Object.assign(elements.timer.style, {
        fontWeight: "bold",
        fontSize: "2rem",
        padding: "1%",
        display: "block",
        color: color !== "red" ? color : ''
    });

    elements.container.style.display = 'flex';
    updateTimerDisplay(data.counter);
};


const displayScreenTwo = (data, color) => {
    Object.assign(elements.emsCounter.style, {
        display: "block",
        top: "10px",
        left: "50%",
        transform: "translateX(-50%)",
        textAlign: "center"
    });

    adjustEMS(data.emsOnline, color, data.showCount);

    Object.assign(elements.timer.style, {
        fontWeight: "bold",
        fontSize: "2rem",
        padding: "1%",
        display: "flex",
        color: color !== "red" ? color : ''
    });

    if (data.dispatched) elements.emergencyText.innerHTML = translationStrings.ems_on_the_way;
    if (data.canRespawn) {
        elements.dyingHeader.innerHTML = translationStrings.player_passed;
        elements.timerHeader.innerHTML = translationStrings.player_hurt_respawn;
    }

    Object.assign(elements.dyingHeader.style, { fontSize: "1.2rem" });
    elements.body.style.backgroundColor = 'rgba(0, 0, 0, 0.329)';
    elements.container.style.display = 'flex';
    updateTimerDisplay(data.counter);
};


const colorNameToHex = (color) => {
    const colors = {
        "aliceblue": "#f0f8ff",
        "antiquewhite": "#faebd7",
        "aqua": "#00ffff",
        "aquamarine": "#7fffd4",
        "azure": "#f0ffff",
        "beige": "#f5f5dc",
        "bisque": "#ffe4c4",
        "black": "#000000",
        "blanchedalmond": "#ffebcd",
        "blue": "#0000ff",
        "blueviolet": "#8a2be2",
        "brown": "#a52a2a",
        "burlywood": "#deb887",
        "cadetblue": "#5f9ea0",
        "chartreuse": "#7fff00",
        "chocolate": "#d2691e",
        "coral": "#ff7f50",
        "cornflowerblue": "#6495ed",
        "cornsilk": "#fff8dc",
        "crimson": "#dc143c",
        "cyan": "#00ffff",
        "darkblue": "#00008b",
        "darkcyan": "#008b8b",
        "darkgoldenrod": "#b8860b",
        "darkgray": "#a9a9a9",
        "darkgreen": "#006400",
        "darkkhaki": "#bdb76b",
        "darkmagenta": "#8b008b",
        "darkolivegreen": "#556b2f",
        "darkorange": "#ff8c00",
        "darkorchid": "#9932cc",
        "darkred": "#8b0000",
        "darksalmon": "#e9967a",
        "darkseagreen": "#8fbc8f",
        "darkslateblue": "#483d8b",
        "darkslategray": "#2f4f4f",
        "darkturquoise": "#00ced1",
        "darkviolet": "#9400d3",
        "deeppink": "#ff1493",
        "deepskyblue": "#00bfff",
        "dimgray": "#696969",
        "dodgerblue": "#1e90ff",
        "firebrick": "#b22222",
        "floralwhite": "#fffaf0",
        "forestgreen": "#228b22",
        "fuchsia": "#ff00ff",
        "gainsboro": "#dcdcdc",
        "ghostwhite": "#f8f8ff",
        "gold": "#ffd700",
        "goldenrod": "#daa520",
        "gray": "#808080",
        "green": "#008000",
        "greenyellow": "#adff2f",
        "honeydew": "#f0fff0",
        "hotpink": "#ff69b4",
        "indianred": "#cd5c5c",
        "indigo": "#4b0082",
        "ivory": "#fffff0",
        "khaki": "#f0e68c",
        "lavender": "#e6e6fa",
        "lavenderblush": "#fff0f5",
        "lawngreen": "#7cfc00",
        "lemonchiffon": "#fffacd",
        "lightblue": "#add8e6",
        "lightcoral": "#f08080",
        "lightcyan": "#e0ffff",
        "lightgoldenrodyellow": "#fafad2",
        "lightgray": "#d3d3d3",
        "lightgreen": "#90ee90",
        "lightpink": "#ffb6c1",
        "lightsalmon": "#ffa07a",
        "lightseagreen": "#20b2aa",
        "lightskyblue": "#87cefa",
        "lightslategray": "#778899",
        "lightsteelblue": "#b0c4de",
        "lightyellow": "#ffffe0",
        "lime": "#00ff00",
        "limegreen": "#32cd32",
        "linen": "#faf0e6",
        "magenta": "#ff00ff",
        "maroon": "#800000",
        "mediumaquamarine": "#66cdaa",
        "mediumblue": "#0000cd",
        "mediumorchid": "#ba55d3",
        "mediumpurple": "#9370db",
        "mediumseagreen": "#3cb371",
        "mediumslateblue": "#7b68ee",
        "mediumspringgreen": "#00fa9a",
        "mediumturquoise": "#48d1cc",
        "mediumvioletred": "#c71585",
        "midnightblue": "#191970",
        "mintcream": "#f5fffa",
        "mistyrose": "#ffe4e1",
        "moccasin": "#ffe4b5",
        "navajowhite": "#ffdead",
        "navy": "#000080",
        "oldlace": "#fdf5e6",
        "olive": "#808000",
        "olivedrab": "#6b8e23",
        "orange": "#ffa500",
        "orangered": "#ff4500",
        "orchid": "#da70d6",
        "palegoldenrod": "#eee8aa",
        "palegreen": "#98fb98",
        "paleturquoise": "#afeeee",
        "palevioletred": "#db7093",
        "papayawhip": "#ffefd5",
        "peachpuff": "#ffdab9",
        "peru": "#cd853f",
        "pink": "#ffc0cb",
        "plum": "#dda0dd",
        "powderblue": "#b0e0e6",
        "purple": "#800080",
        "rebeccapurple": "#663399",
        "red": "#ff0000",
        "rosybrown": "#bc8f8f",
        "royalblue": "#4169e1",
        "saddlebrown": "#8b4513",
        "salmon": "#fa8072",
        "sandybrown": "#f4a460",
        "seagreen": "#2e8b57",
        "seashell": "#fff5ee",
        "sienna": "#a0522d",
        "silver": "#c0c0c0",
        "skyblue": "#87ceeb",
        "slateblue": "#6a5acd",
        "slategray": "#708090",
        "snow": "#fffafa",
        "springgreen": "#00ff7f",
        "steelblue": "#4682b4",
        "tan": "#d2b48c",
        "teal": "#008080",
        "thistle": "#d8bfd8",
        "tomato": "#ff6347",
        "turquoise": "#40e0d0",
        "violet": "#ee82ee",
        "wheat": "#f5deb3",
        "white": "#ffffff",
        "whitesmoke": "#f5f5f5",
        "yellow": "#ffff00",
        "yellowgreen": "#9acd32"
    };
    return colors[color.toLowerCase()] || color;
};


const applyGradientTextEffect = (element, color, screen) => {

    if (color === "red" && screen === 3) {
        element.style.background = 'linear-gradient(to right, rgba(195, 7, 63, 0.6), #f83d3dcb, #f83d3dcb, rgba(195, 7, 63, 0.6))';
        element.style.textShadow = '0 0 5px rgba(243, 33, 33, 0.199), 0 0 10px rgba(243, 33, 33, 0.199), 0 0 15px rgba(243, 33, 33, 0.199), 0 0 20px rgba(243, 33, 33, 0.199), 0 0 25px rgba(243, 33, 33, 0.199), 0 0 40px rgba(243, 33, 33, 0.199)';
        element.style.webkitTextFillColor = 'transparent';
        element.style.webkitBackgroundClip = 'text';
        return;
    }

    if (color === "blue" && screen === 3) {
        element.style.background = 'linear-gradient(to right, rgba(7, 63, 195, 0.6), #3d3df8cb, #3d3df8cb, rgba(7, 63, 195, 0.6))';
        element.style.textShadow = '0 0 5px rgba(33, 33, 243, 0.199), 0 0 10px rgba(33, 33, 243, 0.199), 0 0 15px rgba(33, 33, 243, 0.199), 0 0 20px rgba(33, 33, 243, 0.199), 0 0 25px rgba(33, 33, 243, 0.199), 0 0 40px rgba(33, 33, 243, 0.199)';
        element.style.webkitTextFillColor = 'transparent';
        element.style.webkitBackgroundClip = 'text';
        return;
    }

    if (!color.startsWith('#')) {
        color = colorNameToHex(color);
    }

    const hexColor = color.slice(1);
    const r = parseInt(hexColor.substr(0, 2), 16);
    const g = parseInt(hexColor.substr(2, 2), 16);
    const b = parseInt(hexColor.substr(4, 2), 16);

    if (screen === 3) {
        const lighterColor = `rgba(${r}, ${g}, ${b}, 0.3)`;
        const darkerColor = `rgba(${Math.max(r - 30, 0)}, ${Math.max(g - 30, 0)}, ${Math.max(b - 30, 0)}, 1)`;
        element.style.background = `linear-gradient(to right, ${lighterColor}, ${darkerColor}, ${darkerColor}, ${lighterColor})`;
        element.style.textShadow = `0 0 5px rgba(${r}, ${g}, ${b}, 0.4), 0 0 10px rgba(${r}, ${g}, ${b}, 0.4), 0 0 15px rgba(${r}, ${g}, ${b}, 0.4), 0 0 20px rgba(${r}, ${g}, ${b}, 0.4), 0 0 25px rgba(${r}, ${g}, ${b}, 0.4), 0 0 40px rgba(${r}, ${g}, ${b}, 0.4)`;
    } else if (screen === 5) {
        const darkerColor = `rgba(${Math.max(r - 30, 0)}, ${Math.max(g - 30, 0)}, ${Math.max(b - 30, 0)}, 1)`;
        element.style.background = `linear-gradient(to top, ${darkerColor} 0%, rgba(${r}, ${g}, ${b}, 0) 6%)`;
        element.style.webkitTextStroke = `1px rgba(${r}, ${g}, ${b}, 1.0)`;
        element.style.textShadow = `0 0 10px rgba(${r}, ${g}, ${b}, 0.2), 0 0 20px rgba(${r}, ${g}, ${b}, 0.2), 0 0 30px rgba(${r}, ${g}, ${b}, 0.2), 0 0 40px rgba(${r}, ${g}, ${b}, 0.2), 0 0 50px rgba(${r}, ${g}, ${b}, 0.2), 0 0 60px rgba(${r}, ${g}, ${b}, 0.2), 0 0 70px rgba(${r}, ${g}, ${b}, 0.2), 0 0 80px rgba(${r}, ${g}, ${b}, 0.2), 0 0 90px rgba(${r}, ${g}, ${b}, 0.2), 0 0 100px rgba(${r}, ${g}, ${b}, 0.2), 50px 50px 110px rgba(${r}, ${g}, ${b}, 0.2), -50px -50px 110px rgba(${r}, ${g}, ${b}, 0.2)`;
    }
    element.style.webkitTextFillColor = 'transparent';
    element.style.webkitBackgroundClip = 'text';
    element.style.backgroundClip = 'text';
}

const displayScreenThree = (data, color) => {
    Object.assign(elements.container.style, { bottom: "5%", top: "20%" });
    Object.assign(elements.emsCounter.style, {
        display: "block",
        top: "10px",
        left: "50%",
        transform: "translateX(-50%)",
        textAlign: "center"
    });

    adjustEMS(data.emsOnline, color, data.showCount);

    Object.assign(elements.timerContainer.style, {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: '20px'
    });

    applyGradientTextEffect(elements.dyingHeader, color, 3);

    elements.dyingHeader.style.fontSize = "1.4rem";
    elements.dyingHeader.style.fontWeight = "bolder";

    elements.timerBoxes.forEach(element => {
        Object.assign(element.style, {
            backgroundColor: "#333",
            padding: "10px",
            borderRadius: "5px",
            margin: "0 5px",
            display: "flex"
        });
    });

    elements.timerSeparator.innerHTML = ":";

    elements.timerHeader.innerHTML = translationStrings.player_hurt_find_help_or_ems;
    Object.assign(elements.timerHeader.style, {
        fontWeight: "normal",
        color: "rgb(185, 185, 185)",
        marginBottom: "1.2%",
        fontSize: ".8rem"
    });

    elements.timerSubheader.innerHTML = translationStrings.player_hurt_time_to_live;
    Object.assign(elements.timerSubheader.style, {
        marginBottom: "2%",
        marginTop: "1%",
        fontWeight: "bold",
        fontSize: ".8rem"
    });

    elements.emergencyText.innerHTML = "";
    elements.body.style.backgroundColor = 'rgba(0, 0, 0, 0.329)';

    updateTimerDisplay(data.counter);

    const minutes = Math.floor(data.counter / 60);
    const seconds = data.counter % 60;
    elements.minuteTens.innerHTML = Math.floor(minutes / 10);
    elements.minuteOnes.innerHTML = minutes % 10;
    elements.secondTens.innerHTML = Math.floor(seconds / 10);
    elements.secondOnes.innerHTML = seconds % 10;

    elements.container.style.display = 'flex';
};

const displayScreenFour = (data, color) => {
    elements.online.innerHTML = translationStrings.currently_online + data.emsOnline;
    Object.assign(elements.emsCounter.style, {
        display: "block",
        top: "10px",
        left: "50%",
        transform: "translateX(-50%)",
        textAlign: "center"
    });

    adjustEMS(data.emsOnline, color, data.showCount);

    elements.timer.style.padding = "1%";
    elements.timer.style.color = color !== "red" ? color : '';

    elements.dyingHeader.innerHTML = translationStrings.player_hurt_critical.toUpperCase();
    elements.dyingHeader.classList.add("fading-text");
    elements.dyingHeader.style.fontSize = ".9rem";
    elements.dyingHeader.style.fontWeight = "500";
    elements.dyingHeader.style.backgroundColor = color !== "red" ? color : 'red';
    elements.dyingHeader.style.padding = "5px";

    Object.assign(elements.timerHeader.style, {
        fontWeight: "normal",
        color: "rgb(185, 185, 185)",
        fontSize: ".8rem"
    });
    elements.timerHeader.innerHTML = translationStrings.player_hurt_find_help_or_ems;

    Object.assign(elements.timerSubheader.style, {
        marginTop: "1%",
        fontWeight: "450",
        fontSize: ".8rem"
    });
    elements.timerSubheader.innerHTML = translationStrings.player_hurt_time_to_live;

    Object.assign(elements.container.style, { bottom: "5%", top: "75%" });
    elements.emergencyText.innerHTML = "";

    elements.body.style.backgroundColor = 'rgba(0, 0, 0, 0.329)';
    updateTimerDisplay(data.counter);
    elements.timer.style.display = "flex";
    elements.container.style.display = 'flex';
};

const displayScreenFive = (data, color) => {
    elements.ems.innerHTML = translationStrings.ems_online;
    elements.online.innerHTML = translationStrings.currently_online + data.emsOnline;
    elements.ems.style.color = color;
    Object.assign(elements.container.style, { bottom: "5%", top: "20%" });
    Object.assign(elements.emsCounter.style, {
        display: "block",
        top: "10px",
        left: "50%",
        transform: "translateX(-50%)",
        textAlign: "center"
    });

    Object.assign(elements.timerContainer.style, {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: '20px'
    });

    elements.dyingHeader.innerHTML = translationStrings.player_dying;

    applyGradientTextEffect(elements.dyingHeader, color, 5);

    elements.dyingHeader.style.fontSize = "1.6rem";
    elements.dyingHeader.style.fontWeight = "800";
    elements.dyingHeader.style.marginBottom = "6px";

    elements.timerBoxes.forEach(element => {
        Object.assign(element.style, {
            background: "linear-gradient(to top right, rgba(211, 211, 211, 0.2), rgba(211, 211, 211, 0.00))",
            padding: "15px 15px",
            borderRadius: "1px",
            margin: "0 5px",
            display: "flex",
            fontSize: "1.4rem",
            fontWeight: "bolder",
            border: ".5px solid rgba(211, 211, 211, 0.2)"
        });
    });

    elements.timerSeparator.innerHTML = ":";
    elements.timerSeparator.style.margin = "0px 8px";

    elements.timerHeader.innerHTML = translationStrings.player_hurt_severe;
    Object.assign(elements.timerHeader.style, {
        fontWeight: "normal",
        color: "rgb(185, 185, 185)",
        marginBottom: ".7%",
        fontSize: ".8rem"
    });

    elements.timerSubheader.innerHTML = translationStrings.player_hurt_find_help_or_ems.toUpperCase();
    Object.assign(elements.timerSubheader.style, {
        marginBottom: "2%",
        marginTop: "1%",
        fontWeight: "500",
        fontSize: ".7rem"
    });

    elements.emergencyText.innerHTML = "";
    elements.body.style.backgroundColor = 'rgba(0, 0, 0, 0.429)';
    updateTimerDisplay(data.counter);

    const minutes = Math.floor(data.counter / 60);
    const seconds = data.counter % 60;
    elements.minuteTens.innerHTML = Math.floor(minutes / 10);
    elements.minuteOnes.innerHTML = minutes % 10;
    elements.secondTens.innerHTML = Math.floor(seconds / 10);
    elements.secondOnes.innerHTML = seconds % 10;

    elements.container.style.display = 'flex';
};


window.addEventListener('message', (event) => {
    if (event.data.action === "displayDeathScreen") {
        color = event.data.color;
        translationStrings = event.data.translationStrings;

        elements.dyingHeader.innerHTML = translationStrings.player_dying;
        elements.timerHeader.innerHTML = translationStrings.time_to_respawn;
        elements.emergencyText.innerHTML = translationStrings.player_hurt_find_help_or_ems;

        setColorCSSRule(color);

        switch (event.data.type) {
            case 1: displayScreenOne(event.data, color); break;
            case 2: displayScreenTwo(event.data, color); break;
            case 3: displayScreenThree(event.data, color); break;
            case 4: displayScreenFour(event.data, color); break;
            case 5: displayScreenFive(event.data, color); break;
        }
    }

    if (event.data.action === "updateDeathScreen") {

        elements.online.innerHTML = translationStrings.currently_online + (event.data.emsOnline || 0);

        if (!event.data.showCount) {
            elements.ems.style.display = "none";
            elements.online.style.display = "none";
        } else if (event.data.emsOnline < 1) {
            elements.online.style.display = "none";
            elements.ems.innerHTML = translationStrings.ems_offline;
            elements.emsCounter.style.bottom = "40px";
            elements.ems.style.color = "rgba(195, 7, 63, 1)";
        } else {
            elements.ems.innerHTML = translationStrings.ems_online;
            elements.ems.style.color = event.data.color;
            elements.online.style.display = "block";
        }

        switch (event.data.type) {
            case 1:
            case 2:
                if (event.data.dispatched) elements.emergencyText.innerHTML = translationStrings.ems_on_the_way;
                if (event.data.canRespawn) {
                    elements.dyingHeader.innerHTML = translationStrings.player_passed;
                    elements.timerHeader.innerHTML = translationStrings.player_hurt_respawn;
                }
                break;
            case 3:
            case 4:
                if (event.data.dispatched) elements.timerHeader.innerHTML = translationStrings.ems_on_the_way;
                if (event.data.canRespawn) {
                    elements.dyingHeader.innerHTML = translationStrings.player_hurt_unconscious;
                    elements.timerSubheader.innerHTML = translationStrings.player_hurt_respawn;
                }
                break;
            case 5:
                if (event.data.dispatched) elements.timerSubheader.innerHTML = translationStrings.ems_on_the_way;
                if (event.data.canRespawn) {
                    elements.dyingHeader.innerHTML = translationStrings.player_hurt_unconscious.toUpperCase();
                    elements.timerHeader.innerHTML = translationStrings.player_hurt_respawn;
                }
                break;
        }

        updateTimerDisplay(event.data.counter);

        if ([3, 5].includes(event.data.type)) {
            const minutes = Math.floor(event.data.counter / 60);
            const seconds = event.data.counter % 60;
            elements.minuteTens.innerHTML = Math.floor(minutes / 10);
            elements.minuteOnes.innerHTML = minutes % 10;
            elements.secondTens.innerHTML = Math.floor(seconds / 10);
            elements.secondOnes.innerHTML = seconds % 10;
        }

        elements.container.style.display = 'flex';
    }

    if (event.data.action === "hideDeathScreen") {
        elements.emsCounter.style.display = "none";
        elements.container.style.display = 'none';
        elements.body.style.backgroundColor = '';
        elements.body.style.backgroundImage = 'none';
    }
});
