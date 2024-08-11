async function SendData(data, cb) {
  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
      if (xhr.readyState == XMLHttpRequest.DONE) {
          if (cb) {
              cb(xhr.responseText)
          }
      }
  }
  xhr.open("POST", `https://0r-carcontrol/nuicb`, true)
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify(data))
}
let getEl = function(id) { return document.getElementById(id) }
function setcontrol(type,index) {
  return SendData({msg: 'carcontrol', type: type, index: index})
} 


var player;
let playerRuning = false;
let progressInterval = null;

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

window.addEventListener("message", ({ data }) => {
  if (!data) return;
  switch (data?.action) {
    case "show":
      $(".surukle").show(0);
      $(".main-wrapper").show(0);
      break;
    case "hide":
        $(".main-wrapper").hide(0);
        $(".mini-menu").hide(0);
      break;
    case "playMusic":
      playMusic(data.playerState, data.maxDuration, data.timestamp, data.link);
      break;
    case "pauseMusic":
      pauseVideo(data.playerState, data.timestamp, data.maxDuration);
      break;
    case "resumeMusic":
      resumeVideo(data.playerState, data.timestamp, data.maxDuration);
      break;
    case "updatePercentage":
      updatePercentage(data.timestamp, data.maxDuration)
      break;
    case "endMusic":
      playerRuning = false;
      $(".play-button").attr("src", "images/play.svg");
      updateVideoPreview("Nothing to play", "", "");
      clearInterval(progressInterval);
      $(".timeline").css("width", `0%`);
      break;
  }

  if (data?.vehicle) {

    $(".plaka").text(data?.vehicle.plaka);
    $(".fuel").text(`${(data?.vehicle.fuel || 100)?.toFixed(0)}%`);
    $('.fuel-bar').css({ 'stroke-dasharray': `${(data?.vehicle.fuel || 100)?.toFixed(0) * 2}% 400` })
    $(".temperature").text(
      `${data?.vehicle.engineTemperature?.toFixed(0) || 85}°`
    );
    $(".interior-temperature").text( "INTERIOR: " +
      `${data?.vehicle.engineTemperature?.toFixed(0) || 85}°`
    );
    
    $("#car-name").text(data?.vehicle?.name || "");
    $(".kilometer").text( "KILÓMETRO: " +
      parseFloat(data?.vehicle?.mileage || 0)?.toFixed(1) || "0"
    );
    $(".chart-km").text( 
      parseFloat(data?.vehicle?.mileage || 0)?.toFixed(1) || "0"
    );
  }
});

window.addEventListener("keydown", ({ key }) => {
  if (key == "Escape") $.post(`https://0r-carcontrol/exitMenu`);
});

const updateMenuContainer = function () {
  const menuId = $(this).data("id");
  const noPage = $(this).data("nopage");

  if (noPage)
    return $.post(
      `https://0r-carcontrol/${$(this).data("action")}`
    );

  $(".menu-categories")
    .children()
    .each((i, el) => {
      const className = $(el).attr("class").split(" ")[1];

      if (className == `menu-${menuId}`) {
        $(el).removeClass("menu-hidden");
      } else {
        $(el).addClass("menu-hidden");
      }
    });
};

const pauseVideo = (playerState, timestamp, maxDuration) => {
  playerRuning = false;
  playMusic(playerState, timestamp, maxDuration)
  $(".play-button").attr("src", "images/play.svg");
};

const resumeVideo = (playerState, timestamp, maxDuration) => {
  playerRuning = true;
  playMusic(playerState, timestamp, maxDuration)
  $(".play-button").attr("src", "images/stop.svg");
};

const getVideoData = async (url) => {
  const data = await fetch(`https://youtube.com/oembed?url=${url}&format=json`)
    .then((res) => res.ok ? res.json() : null)
    .catch((err) => null);
  
  if (!data) return null;

  return data;
};

const updateVideoPreview = (title, description, background) => {
  $(".song-name").text(title);
  $(".song-author").text(description);
 $(".cover-image").attr("src", background);
};

const playMusic = async (playerState, timestamp, maxDuration, link) => {
  if (playerState == "paused") {
    $(".play-button").attr("src", "images/play.svg");
    const percentage = (timestamp / maxDuration) * 100;
    $(".timeline").css("width", `${percentage}%`);
  } else {
    const percentage = (timestamp / maxDuration) * 100;
    $(".timeline").css("width", `${percentage}%`);
    $(".play-button").attr("src", "images/stop.svg");

    const videoData = await getVideoData(link);
    if (videoData) {
      updateVideoPreview(
        videoData.title,
        videoData.author_name,
        videoData.thumbnail_url
      );
    }
  }

  $(".spotify-input").val("");
};

const updatePercentage = async (timestamp, maxDuration) => {
  const percentage = (timestamp / maxDuration) * 100;
  $(".timeline").css("width", `${percentage}%`);
}

const musicInputChange = async () => {
  const link = $(".spotify-input").val();

  $.post(
    `https://0r-carcontrol/controlMusic`,
    JSON.stringify({ action: "playMusic", musicLink: link })
  );
};

const actionButtonClick = (e) => {
  const action = $(e.currentTarget).data("action");
  $.post(`https://0r-carcontrol/${action}`);
};

const doorActionButtionClick = (e) => {
  const doorIndex = $(e.currentTarget).data("index");
  // $(e.currentTarget).attr("src", "images/acik.svg");
  $.post(
    `https://0r-carcontrol/toggleDoor`,
    JSON.stringify(doorIndex)
  );
};

const musicVolumeChange = () => {
  $.post(
    `https://0r-carcontrol/controlMusic`,
    JSON.stringify({
      action: "changeVolume",
      volume: $(".volume").val()
    })
  );
};

$(document).ready(() => {
  $(".menu-exit").on("click", () =>
    $.post(`https://0r-carcontrol/exitMenu`)
  );
  $(".sidebar-option").on("click", updateMenuContainer);
  $(".play-button").on("click", () => {
    if (playerRuning) {
      pauseVideo();
    } else {
      resumeVideo();
    }

    $.post(
      `https://0r-carcontrol/controlMusic`,
      JSON.stringify({
        action: !playerRuning ? "pauseMusic" : "resumeMusic",
      })
    );
  });
  $(".spotify-input").on("input", musicInputChange);
  $(".lights-button").on("click", actionButtonClick);
  $(".kapilar").on("click", doorActionButtionClick);
  $(".mdoor-button").on("click", doorActionButtionClick);
  $(".volume").on("change", musicVolumeChange);
});
function SetNeonStyle(val) {
  SendData({ msg: 'neonstyle', val: val })
}

window.addEventListener("message", function(event) {
  var vehicle = event.data;
  switch (vehicle.carhud) {
      case 'arabada':
          var gear = vehicle.gear
          var speedsInt = vehicle.speed.toFixed()
          var mesafe = vehicle.metre.toFixed()
          var motor = vehicle.motor
          var head = vehicle.heading.toFixed()
          $(".distance").text(mesafe + "m");
          $(".distance-description").text(mesafe + " metros hasta el destino");
          $(".ok").css("rotate", `${head}deg`);
          $('.speed-bar').css("stroke-dasharray", `${speedsInt}% 1500`)
          $(".speed").text(speedsInt);
          $('.rpm-bar').css( "stroke-dasharray", `${gear * 150}% 400` )
            if (vehicle.gear == 0 && vehicle.rpm > 1) {
              $('.rpm').text(`R`)
          } else if (vehicle.gear == 0) {
              $('.rpm').text(`P`)
          } else if (vehicle.gear > 0) {
              $('.rpm').text(vehicle.gear)
          }
          if (motor < 1000.0 && 500.0 < motor) {
            $(".status-svg").attr("src", "images/safe.svg");
            $('.status').text(`Estado: Seguro`)
        } else if (motor < 500.0 && 250.0 < motor) {
            $(".status-svg").attr("src", "images/warn.svg");
            $('.status').text(`Estado : Advertencia`)
        } else if (motor < 250.0) {
            $(".status-svg").attr("src", "images/emergency.svg");
            $('.status').text(`Estado : Emergencia`)
        }
          break
      case 'indi':
//sd
          break
  }
});




$("#open-mini").click(function (e) { 
  $(".surukle").hide(0);
  $(".mini-surukle").hide(0);
  $(".mini-menu").hide(0);
  $(".main-wrapper").hide(0);
});
$(".fa-expand").click(function (e) { 
  $(".surukle").show(0);
  $(".mini-surukle").hide(0);
  $(".mini-menu").hide(0);
  $(".main-wrapper").show(0);
});

$(".fa-window-minimize").click(function (e) { 
  $(".surukle").hide(0);
  $(".mini-surukle").show(0);
  $(".mini-menu").show(0);
  $(".main-wrapper").hide(0);
});
$(".fa-xmark").click(function (e212) { 
  $(".surukle").hide(0);
  $(".mini-surukle").hide(0);
  $(".mini-menu").hide(0);
  $(".main-wrapper").hide(0);
  $.post(`https://0r-carcontrol/exitMenu`);
});

window.addEventListener('message', (event) => {
  let item = event.data;
  if (item.type === 'open2') {
      $('.location-1').text(`${item.streetName}`);
      $('.location-2').text(`${item.streetName2}`);
  }
})
  $( function() {
  $(".mini-surukle").draggable();
  } );
  $( function() {
  $(".surukle").draggable();
  } );