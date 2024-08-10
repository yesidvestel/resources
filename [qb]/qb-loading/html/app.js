const { ref } = Vue

// Customize language for dialog menus and carousels here

const load = Vue.createApp({
  setup () {
    return {
      CarouselText1: 'Puede agregar/eliminar elementos, vehículos, trabajos y pandillas a través de la carpeta compartida.',
      CarouselSubText1: 'Foto capturada por: Markyoo#8068',
      CarouselText2: 'Se pueden agregar datos adicionales del reproductor modificando el archivo qb-core player.lua.',
      CarouselSubText2: 'Foto capturada por: ihyajb#9723',
      CarouselText3: 'Todos los ajustes específicos del servidor se pueden realizar en los archivos config.lua durante toda la compilación.',
      CarouselSubText3: 'Foto capturada por: FLAPZ[INACTIV]#9925',
      CarouselText4: 'Para obtener soporte adicional, únase a nuestra comunidad en discord.gg/qbcore',
      CarouselSubText4: 'Foto capturada por: Robinerino#1312',

      DownloadTitle: 'Downloading QBCore Server',
      DownloadDesc: "Espera mientras comenzamos a descargar todos los recursos/activos necesarios para jugar en COMUNA RP Server. \n\nUna vez que la descarga haya finalizado exitosamente, se lo colocará en el servidor y esta pantalla desaparecerá. Por favor, no dejes ni apagues tu PC. ",

      SettingsTitle: 'Ajustes',
      AudioTrackDesc1: 'Cuando está desactivado, se detendrá la reproducción de la pista de audio actual.',
      AutoPlayDesc2: 'Cuando las imágenes del carrusel desactivadas dejarán de circular y permanecerán en la última que se mostró.',
      PlayVideoDesc3: 'Cuando el vídeo deshabilitado dejará de reproducirse y permanecerá en pausa.',

      KeybindTitle: 'Combinaciones de teclas predeterminadas',
      Keybind1: 'Abrir el inventario',
      Keybind2: 'Proximidad del ciclo',
      Keybind3: 'Abrir teléfono',
      Keybind4: 'Alternar cinturón de seguridad',
      Keybind5: 'Abrir menú de destino',
      Keybind6: 'Menú radial',
      Keybind7: 'Abrir menú de HUD',
      Keybind8: 'hablar por radio',
      Keybind9: 'Marcador abierto',
      Keybind10: 'Cerraduras para vehículos',
      Keybind11: 'Alternar motor',
      Keybind12: 'Gesto de puntero',
      Keybind13: 'Ranuras de combinación de teclas',
      Keybind14: 'Gesto de manos arriba',
      Keybind15: 'Usar ranuras para artículos',
      Keybind16: 'Control de crucero',

      firstap: ref(true),
      secondap: ref(true),
      thirdap: ref(true),
      firstslide: ref(1),
      secondslide: ref('1'),
      thirdslide: ref('5'),
      audioplay: ref(true),
      playvideo: ref(true),
      download: ref(true),
      settings: ref(false),
    }
  }
})

load.use(Quasar, { config: {} })
load.mount('#loading-main')

var audio = document.getElementById("audio");
audio.volume = 0.05;

function audiotoggle() {
    var audio = document.getElementById("audio");
    if (audio.paused) {
        audio.play();
    } else {
        audio.pause();
    }
}

function videotoggle() {
    var video = document.getElementById("video");
    if (video.paused) {
        video.play();
    } else {
        video.pause();
    }
}

let count = 0;
let thisCount = 0;

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;
    },

    initFunctionInvoking(data) {
        document.querySelector(".thingy").style.left = "0%";
        document.querySelector(".thingy").style.width = (data.idx / count) * 100 + "%";
    },

    startDataFileEntries(data) {
        count = data.count;
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector(".thingy").style.left = "0%";
        document.querySelector(".thingy").style.width = (thisCount / count) * 100 + "%";
    },
};

window.addEventListener("message", function (e) {
    (handlers[e.data.eventName] || function () {})(e.data);
});
