let tyx = "create";

$(document).ready(function () {
  window.addEventListener("message", function (event) {
    if (event.data.action == "OpenPaintBall") {
      LoadMenu();
      tworst = "adam";
      $(".all-paintball").css("display", "flex");
      $(".center-all").css("display", "flex");
    } else if (event.data.action == "update-teamp") {
      $("#red-total").html("JUGADORES "+ event.data.red)
      $("#blue-total").html("JUGADORES "+event.data.blue)
    } else if (event.data.action == "scoreboard") {
      if (event.data.display) {
        $("body").css("display", "flex")
      $(".scoreboard").css("display", "flex")
    } else {
      $("body").css("display", "none")
      $(".scoreboard").css("display", "none")
    }
    } else if (event.data.action == "time-update") {
      if (event.data.timeri <= 0) {
        $(".timer-bar").html("00:00")
      }else {
        $(".timer-bar").html(event.data.timeri)
      }
    } else if (event.data.action == "win-lose") {
      $("body").css("display", "flex")
      $(".scoreboard").css("display", "none")
      if (event.data.typ == "win") {
        $(".win").css("display", "flex")
      }else {
        $(".lose").css("display", "flex")
      }
    } else if (event.data.action == "saytime") {
      if (event.data.time == 0) {
        $("body").css("display", "none")
        $(".time").css("display", "none")
      }else {
        $("body").css("display", "flex")
        $(".time").css("display", "flex")
      }
      $(".time-text").html(event.data.time)
    } else if (event.data.action == "perm") {
        if (event.data.tx == "owner") {
        $(".start").css("opacity", 1)
        $(".disabled").css("opacity", 1)
      }else {
        $(".start").css("opacity", 0.24)
        $(".disabled").css("opacity", 0.25)
      }
    }else if (event.data.action == "loadLobby") {
      $(".total-lobby").html("TOTAL LOBBY " + event.data.TotalLobbys);
      if (event.data.password == true) {
        html =
          `
      <div class="lobbys-item" id="` +
          event.data.name +
          `" onclick="showLobby(this.id)">
      <div class="lobbys-l-item">` +
          event.data.name +
          `</div>
      <div class="lobbys-l-item">` +
          event.data.mapid +
          `</div>
      <div class="lobbys-l-item">` +
          event.data.time +
          ` Minute</div>
      <div class="lobbys-l-item">` +
          event.data.totallobby +
          ` Player</div>
      <div class="lobbys-l-item"><i class="fa-solid fa-lock"></i></div>
      <div class="lobbys-l-join" id="` +
          event.data.name +
          `" onclick="LoginLobby(this.id)">Join</div>
    </div>
    `;
        $(".lobbys-itemall").prepend(html);
      } else {
        html =
          `<div class="lobbys-item" id="` +
          event.data.name +
          `" onclick="showLobby(this.id)">
      <div class="lobbys-l-item">` +
          event.data.name +
          `</div>
      <div class="lobbys-l-item">` +
          event.data.mapid +
          `</div>
      <div class="lobbys-l-item">` +
          event.data.time +
          ` Minute</div>
      <div class="lobbys-l-item">` +
          event.data.totallobby +
          ` Player</div>
      <div class="lobbys-l-item"><i class="fa-solid fa-lock-open"></i></div>
      <div class="lobbys-l-join" id="` +
          event.data.name +
          `" onclick="LoginLobby(this.id)">Join</div>
    </div>
    `;
        $(".lobbys-itemall").prepend(html);
      }
    } else if (event.data.action == "update-name") {
      $(".lobby-c-text").html(event.data.name);
      $(".CrLobby").css("display", "flex");
    } else if (event.data.action == "get-px") {
      DefaultPlayers();
      DefaultTime();
      $(".Create-Password").val("");
      $("body").css("display", "flex");
      $(".all-paintball").css("display", "flex");
      $(".center-all-2").css("display", "block");
      $.post("https://BakiTelli_paintball/nui");
    } else if (event.data.action == "closeAllMenu") {
      CloseMenu();
    } else if (event.data.action == "score-update") {
      $("#red-s").html(event.data.red)
      $("#blue-s").html(event.data.blue)
    } else if (event.data.action == "timeupdate") {
      DefaultTime();
      if (event.data.time == 5) {
        $(".bes").css(
          "background",
          "radial-gradient(117.44% 117.44% at 50% 50%, #7CF602 0%, rgba(124, 246, 2, 0) 100%)"
        );
        $(".bes").css("color", "#000000");
      } else if (event.data.time == 10) {
        $(".on").css(
          "background",
          "radial-gradient(117.44% 117.44% at 50% 50%, #7CF602 0%, rgba(124, 246, 2, 0) 100%)"
        );
        $(".on").css("color", "#000000");
      } else if (event.data.time == 15) {
        $(".onbes").css(
          "background",
          "radial-gradient(117.44% 117.44% at 50% 50%, #7CF602 0%, rgba(124, 246, 2, 0) 100%)"
        );
        $(".onbes").css("color", "#000000");
      } else if (event.data.time == 20) {
        $(".yirmi").css(
          "background",
          "radial-gradient(117.44% 117.44% at 50% 50%, #7CF602 0%, rgba(124, 246, 2, 0) 100%)"
        );
        $(".yirmi").css("color", "#000000");
      } else if (event.data.time == 25) {
        $(".yirmibes").css(
          "background",
          "radial-gradient(117.44% 117.44% at 50% 50%, #7CF602 0%, rgba(124, 246, 2, 0) 100%)"
        );
        $(".yirmibes").css("color", "#000000");
      } else if (event.data.time == 30) {
        $(".otuz").css(
          "background",
          "radial-gradient(117.44% 117.44% at 50% 50%, #7CF602 0%, rgba(124, 246, 2, 0) 100%)"
        );
        $(".otuz").css("color", "#000000");
      }
    } else if (event.data.action == "playersDefault") {
      if (event.data.typ == "reset") {
        DefaultPlayers();
      } else {
        $("#" + event.data.team + event.data.num + " .team-id").html(
          "ID: " + event.data.src
        );
        $("#" + event.data.team + event.data.num + " .team-name").html(
          event.data.name
        );
        if (event.data.profile == "null") {
          $("#" + event.data.team + event.data.num + " .profilePhotoImg").css(
            "background-image",
            "url(https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/1024px-Windows_10_Default_Profile_Picture.svg.png)"
          );
        } else {
          var xhr = new XMLHttpRequest();
          xhr.responseType = "text";
          xhr.open("GET", event.data.steamid, true);
          xhr.send();
          xhr.onreadystatechange = processRequest;
          function processRequest(e) {
            if (xhr.readyState == 4 && xhr.status == 200) {
              var string = xhr.responseText.toString();
              var array = string.split("avatarfull");
              var array2 = array[1].toString().split('"');
              $(
                "#" + event.data.team + event.data.num + " .profilePhotoImg"
              ).css("background-image", "url(" + array2[2].toString() + ")");
            }
          }
        }
      }
    } else if (event.data.action == "timer") {
      let timerInterval;
      Swal.fire({
        title: "Cargando !",
        html: "Porfavor, espera.",
        timer: 400,
        background: "rgba(1, 4, 6, 0.0)",
        width: 600,
        iconColor: "white",
        padding: "0.5em",
        color: "#FFFFFF",
        timerProgressBar: false,
        didOpen: () => {
          Swal.showLoading();
          const b = Swal.getHtmlContainer().querySelector("b");
          timerInterval = setInterval(() => {
            // b.textContent = Swal.getTimerLeft();
          }, 100);
        },
        willClose: () => {
          clearInterval(timerInterval);
        },
      }).then((result) => {
        /* Read more about handling dismissals below */
        if (result.dismiss === Swal.DismissReason.timer) {
          // console.log("I was closed by the timer");
        }
      });
    } else if (event.data.action == "mapupdate") {
      $(".map-title-max").html(event.data.LobbyName);
      $(".center-map-title").html(event.data.LobbyName);
      $(".map-iy").html(event.data.LobbyInformation);
      $(".center-map-dec").html(event.data.name);
      $(".center-mapdetail").css(
        "background-image",
        'linear-gradient(180deg, rgba(9, 9, 13, 0.77) 0%, rgba(9, 9, 13, 0) 100%), url("' +
          event.data.LobbyImg +
          '")'
      );
    } else if (event.data.action == "login-p") {
      CloseMenu();
      $(".Create-Password").val("");
      $("body").css("display", "flex");
      $(".all-paintball").css("display", "flex");
      $(".center-all-2").css("display", "block");
      $.post("https://BakiTelli_paintball/nui");
    }
  });
});

$(document).on("keydown", function (event) {
  switch (event.keyCode) {
    case 27:
      CloseMenu();
  }
});

function CloseMenu() {
  $("body").css("display", "none");
  $(".all-paintball").css("display", "none");
  $(".win").css("display", "none");
  $(".lose").css("display", "none");
  $("#red-s").html("0")
  $("#blue-s").html("0")
  $(".center-all").css("display", "none");
  $(".center-all-2").css("display", "none");
  $(".CrLobby").css("display", "none");
  $(".scoreboard").css("display", "none");
  $(".win").css("display", "none");
  $(".lose").css("display", "none");
  $(".time").css("display", "none");
  $(".lobbys-itemall").empty();
  $.post("https://BakiTelli_paintball/close");
}

function LoadMenu() {
  $("body").css("display", "flex");
  $(".all-paintball").css("display", "none");
  $(".win").css("display", "none");
  $(".lose").css("display", "none");
  $(".center-all").css("display", "none");
  $(".center-all-2").css("display", "none");
  $(".CrLobby").css("display", "none");
}

function closeCreateLobby() {
  $(".CrLobby").css("display", "none");
}

function openCreateLobby() {
  tyx = "create";
  $(".create-lobby-dec").html("Deje en blanco si desea abrir sin contraseña.")
  $(".create-button").html("CREAR LOBBY")
  $.post("https://BakiTelli_paintball/addname");
}
function LoginLobby(name) {
  tyx = "login";
  $(".create-lobby-dec").html("Tenga en cuenta que las contraseñas constan únicamente de números..")
  $(".create-button").html("INICIAR LOBBY")
  $(".Create-Password").val("");
  $.post(
    "https://BakiTelli_paintball/LoginLobby",
    JSON.stringify({
      name: name,
    })
  );
}

function CreateLobby() {
  if (tyx == "create") {
  CloseMenu();
  $.post(
    "https://BakiTelli_paintball/NewLobby",
    JSON.stringify({
      password: $(".Create-Password").val(),
    })
  );
  $(".Create-Password").val("");
  $("body").css("display", "flex");
  $(".all-paintball").css("display", "flex");
  $(".center-all-2").css("display", "block");
  $.post("https://BakiTelli_paintball/nui");
} else {
  $.post(
    "https://BakiTelli_paintball/checkPassword",
    JSON.stringify({
      password: $(".Create-Password").val(),
    })
  );
}
}

function Next() {
  $.post("https://BakiTelli_paintball/Next");
}

function Previous() {
  $.post("https://BakiTelli_paintball/Previous");
}

function LoginTeam(team, num) {
  $.post(
    "https://BakiTelli_paintball/LoginTeam",
    JSON.stringify({
      team: team,
      num: num,
    })
  );
}

function Time(time) {
  $.post(
    "https://BakiTelli_paintball/Time",
    JSON.stringify({
      time: time,
    })
  );
}

function DefaultTime() {
  $(".bes").css("background", "rgba(255, 255, 255, 0.04)");
  $(".on").css("background", "rgba(255, 255, 255, 0.04)");
  $(".onbes").css("background", "rgba(255, 255, 255, 0.04)");
  $(".yirmi").css("background", "rgba(255, 255, 255, 0.04)");
  $(".yirmibes").css("background", "rgba(255, 255, 255, 0.04)");
  $(".otuz").css("background", "rgba(255, 255, 255, 0.04)");

  $(".bes").css("color", "rgba(255, 255, 255, 0.28)");
  $(".on").css("color", "rgba(255, 255, 255, 0.28)");
  $(".onbes").css("color", "rgba(255, 255, 255, 0.28)");
  $(".yirmi").css("color", "rgba(255, 255, 255, 0.28)");
  $(".yirmibes").css("color", "rgba(255, 255, 255, 0.28)");
  $(".otuz").css("color", "rgba(255, 255, 255, 0.28)");
}

function showLobby(name) {
  $.post(
    "https://BakiTelli_paintball/showLobby",
    JSON.stringify({
      name: name,
    })
  );
}

function DefaultPlayers() {
  var teams = ["red", "blue"];
  var players = ["1", "2", "3", "4", "5"];
  teams.forEach(function (team) {
    players.forEach(function (player) {
      var selector = "#" + team + player;
      $(selector + " .profilePhotoImg").css(
        "background-image",
        "url(./img/add.png)"
      );
      $(selector + " .team-name").html("Unirse al equipo");
      $(selector + " .team-id").html("Ninguno");
    });
  });
}

function Disband() {
  $.post("https://BakiTelli_paintball/Disband");
}


function Start() {
  $.post("https://BakiTelli_paintball/Start");
}