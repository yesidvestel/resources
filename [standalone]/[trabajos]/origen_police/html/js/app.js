var Translations = [];
var flash = document.getElementById('flash');
var Gobold = new FontFace('Gobold', 'url(fonts/gobold.ttf)');
let firstTime = true;
let firstTimeDispatch = true;
let dispatch_interval;
let permissions = {};
let jobData = {};
let jobCategories = {};
let radioLoaded = false;
let alertTiming = false;
let currentReport = null;

let actualEvidence;
let intervalAlert;
let frecuenciaActual = null;
let broadcastButtons;
let currentHueDeg = 0;
let lastBodyCamData = {};

let onDuty = true;
let policeTabSelected;
let defaultImage = './img/default.jpg';
let homeTabSetuped = false;
let dataTableLanguage = null;
let tags = null;
let condecorates = null;
let divisions = null;

$.get('./apps/police.html', function (data) {
	if (data) {
		$('.apps').html(data);
	} else {
		console.log('Error al cargar el HTML');
	}
});

function HasPermissionMenu(permName){
	if(permissions[jobData.name] == undefined){
		$('.police .duty-alert .animate__animated').html(
			`${jobData.name} ${Translations.NoPermissionsConfigured}`
		);
		$('.police .tab-content').addClass('blur');
		$('.police .duty-alert').fadeIn(300, function () {
			setTimeout(() => {
				$('.police .duty-alert').fadeOut(300, function () {
					$('.police .duty-alert .animate__animated').html(
						Translations.NotInDuty
					);
				});
				$('.police .tab-content').removeClass('blur');
			}, 3000);
		});
		return;
	}
	return jobData.level < permissions[jobData.name][permName];
}

function SetColor(RotateDeg) {
	currentHueDeg = RotateDeg;
	$(".screen").css("filter", "hue-rotate(" + RotateDeg + "deg)");
	$("[disableHueRotate]").css("filter", "hue-rotate(" + -RotateDeg + "deg)");
}

function SetupJobTemplate() {
	let category = policeFunctions.getCategory();
	let hueDeg = policeFunctions.getHueDeg(category);
	SetColor(hueDeg)
}

function HasPermission(permName){
	if(permissions[jobData.name] == undefined){
		console.log("PERMISSION NOT FOUND: " + permName)
		return;
	}
	return jobData.level < permissions[jobData.name][permName];
}

function closeMenu() {
	$.post('https://origen_police/close', JSON.stringify({}));
	$('.screen').removeClass('show');
	$('.home').off('keydown');
	setTimeout(() => {
		$('.lista-comercios').css('opacity', 0);
	}, 100);
}

function eventKeydown() {
	$(document).keydown(function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;

		if (keycode == '118' || keycode == '27') {
			closeMenu();
		}
	});
}

function sendNotification(type, title, message) {
	let id = Math.floor(Math.random() * 10000);
	let icon = 'fas fa-bell';
	if (type == 'success') {
		icon = 'fas fa-check';
	} else if (type == 'error') {
		icon = 'fas fa-times';
	}
	$('.notifications').append(`
        <div class="notification animate__fast animate__animated animate__bounceInDown ${type}" id="${id}">
                    <div class="icon">
                        <i class="${icon}"></i>
                    </div>
                    <div class="info">
                        <div class="name">${title}</div>
                        <div class="message">${message || ''}</div>
                    </div>
                </div>
    `);
	setTimeout(function () {
		$(`#${id}`)
			.removeClass('animate__bounceInDown')
			.addClass('animate__bounceOutUp')
			.fadeOut(500, function () {
				$(this).remove();
			});
	}, 3000);
}

window.addEventListener('message', function (event) {
	if (event.data.action == 'alpr') {
		if (event.data.finfo) {
			$('#matricula-1').text(event.data.finfo.plate);
			$('#speed-1').text(event.data.finfo.kmh);
			$('#modelo-1').text(event.data.finfo.name);
		}
		if (event.data.rinfo) {
			$('#matricula-2').text(event.data.rinfo.plate);
			$('#speed-2').text(event.data.rinfo.kmh);
			$('#modelo-2').text(event.data.rinfo.name);
		}
	}
	else if(event.data.action == "translations" && Translations.length == 0) {
		Translations = Object.assign(Translations, event.data.translations);
		const transalateElements = $('[translate]');
		transalateElements.each(function () {
			const key = $(this).attr('translate');
			if(Translations[key]) {
				$(this).html(Translations[key])
			}
		});
		fetch('translationsRecived', {});
	} else if (event.data.action == 'balpr') {
		if (event.data.block) {
			$('.block').show();
		} else {
			$('.block').hide();
		}
	} else if (event.data.action == 'showalpr') {
		$('.menu').show();
	} else if (event.data.action == 'hidealpr') {
		$('.menu').hide();
	} else if (event.data.action == 'showphoto') {
		$('.foto-informe').attr('src', event.data.url);
		$('.informe').hide();
		$('.foto-informe').show();
		$('.block-informe').fadeIn(300);
	} else if (event.data.action == 'AnalizeEvidences') {
		AnalizeEvidences(event.data.list, event.data.date);
	} else if (event.data.action == 'Location') {
		$('.location').fadeIn(300);
		$('.location span').text(event.data.street + ' | ' + event.data.cardinal);
	} else if (event.data.action == 'HideLocation') {
		$('.location').fadeOut(300);
	} else if (event.data.action == 'RadarFlash') {
		flash.play();
		setTimeout(() => {
			$('.radar-flash').show();
			$('.radar-flash').fadeOut(1500);
		}, 50);
	} else if (event.data.action == 'ViewBadge') {
		if (event.data.type == 'LSPD') DrawLSPDBadge(event.data.grade, event.data.n);
		else if (event.data.type == 'BCSD') DrawBCSDBadge(event.data.grade, event.data.n);
		else if (event.data.type == 'FIB') DrawFIBBadge(event.data.url, event.data.name);
		else HideBadges();
	} else if (event.data.action == 'Federal') {
		if (event.data.mins)
			$('.federal')
				.html(Translations.RemainSentance + ' ' + event.data.mins + ' ' + (event.data.mins == 1 ? Translations.Month.slice(0, -1) : Translations.Month))
				.fadeIn(300);
		else $('.federal').fadeOut(300);
	} else if (event.data.action == 'nosignal') {
		if (event.data.toggle) $('.nosignal').show();
		else $('.nosignal').hide();
	} else if (event.data.action == 'OpenQuickAccess') {
		if(event.data.translations && Translations.length == 0) {
			Translations = Object.assign(Translations, event.data.translations);
			const transalateElements = $('[translate]');
			transalateElements.each(function () {
				const key = $(this).attr('translate');
				$(this).html(Translations[key] ? Translations[key] : Translations.UnknownKey);
			});
			fetch('translationsRecived', {});
		}
		if (firstTime) {
			loadQuickActions();
			firstTime = true;
		}
		permissions = event.data.permissions;
		jobData = event.data.jobData;

		if(jobData.name == "ambulance") {
			$(".police-tab[tab='guns']").hide();
			$(".action-police[event='esposar']").hide();
			$(".action-police[event='escoltar']").hide();
			$(".action-police[event='vehicleinof']").hide();
			$(".action-police[event='placaje']").hide();
			$(".title-1[translate='VehicleInteraction']").hide();
			$("#vehicle-interaction").hide();
			$("#radarButton").hide();
			$("#spikesButton").hide();
		} else {
			$(".police-tab[tab='guns']").show();
			$(".action-police[event='esposar']").show();
			$(".action-police[event='escoltar']").show();
			$(".action-police[event='vehicleinof']").show();
			$(".action-police[event='placaje']").show();
			$(".title-1[translate='VehicleInteraction']").show();
			$("#vehicle-interaction").show();
			$("#radarButton").show();
			$("#spikesButton").show();
		}

		PlayTransition()
		$('.friends').addClass('show').fadeIn(500);
		$('.friends .friends-bg').off('click').on('click', function () {
			$('.friends').removeClass('show');
			$.post('https://origen_police/focus', JSON.stringify({}));
		});
		radioFunctions.setFrecuencias();
	} else if (event.data.radio) {
		radioFunctions.radioNetEvents(event.data);
	} else if (event.data.action == 'ShowCarMegaphone') {
		$('.carmic').fadeIn(300);
	} else if (event.data.action == 'HideCarMegaphone') {
		$('.carmic').fadeOut(300);
	} else if (event.data.action == 'SyncQuick') {
		if (event.data.sprite) {
			$('.ref').removeClass('active');
			$('.ref[blip="' + event.data.sprite + '"]').addClass('active');
		} else if (event.data.color) {
			$('.color').removeClass('active');
			$('.color[number="' + event.data.color + '"]').addClass('active');
		} else if (event.data.ready) {
			//modifica el checkbox check-dispo a checked
			$('.check-dispo').prop('checked', true);
		} else {
			$('.check-dispo').prop('checked', false);
		}
	} else if (event.data.action == 'ShowAlerts') {
		if (firstTimeDispatch) {
			exportEvent('origen_police', 'GetKeyBinds').done((cb) => {
				if (cb) {
					Object.entries(cb).map(([key, value]) => {
						$(
							".dispatch .config-list .key-selector[action='" + value + "']"
						).text(key);
					});
				}
			});
			firstTimeDispatch = false;
		}
		$('.dispatch').toggleClass('show');
	} else if (event.data.action == 'SetAlert') {
		if (dispatch_interval) {
			clearInterval(dispatch_interval);
		}
		dispatchFunctions.addNewAlert(
			event.data.message,
			event.data.distance,
			event.data.street,
			event.data.code,
			event.data.count,
			event.data.total,
			event.data.ago,
			event.data.title,
			event.data.new,
			event.data.left,
			event.data.metadata,
			event.data.annotation,
			event.data.central,
			event.data.playerID
		);
	} else if (event.data.action == 'NoAlert') {
		$('.dispatch .alerts-container .alert-list').html(
			`<div class="text-muted p-2 w-100 text-center" style="font-size:1.3vh;">${Translations.NoAlertRecived}</div>`
		);
		$('.actual-alert').html('0');
		$('.total-alert').html('0');
	} else if (event.data.action == 'copy') {
		copyToClipboard(event.data.value);
	} else if (event.data.action == 'WantedLevel') {
		if (event.data.value > 0) {
			$('.stars img.show').removeClass('show');

			$('.stars img').each((i) => {
				if (i <= event.data.value - 1) {
					$('.stars img').eq(i).addClass('show');
				}
			});
		} else {
			$('.stars img.show').removeClass('show');
		}
	} else if(event.data.action == "DisconnectAllFreqs") {
		DisconnectAllFreqs();
	} else if (event.data.open) {
		permissions = event.data.permissions;
		jobData = event.data.jobData;
		jobCategories = event.data.jobCategories;
		$('.screen').addClass('show');
		PlayTransition()
		eventKeydown();
		const transalateElements = $('[translate]');
		transalateElements.each(function () {
			const key = $(this).attr('translate');
			if (BlacklistedTranslations.includes(key)) return;
			if(key == "placeholder" && $(this).attr('placeholder').includes("{{")){
				let placeholder = $(this).attr('placeholder').replace("{{", "").replace("}}", "");
				$(this).attr("placeholder", event.data.translations[placeholder]);
				$(this).attr("translate", null);
			} else {
				if (event.data.translations[key]) {
					$(this).html(event.data.translations[key]);
				}
			}
		});
		Translations = event.data.translations;
		SetupJobTemplate();
		if(!homeTabSetuped){
			policeFunctions.openTab(1, true, '.police-home');
			homeTabSetuped = true;
		}
		OnTranslationsReady()
		if(event.data.isAdmin)
			$(".settings-button").css("display", "flex")
	} else if (event.data.action) {

		switch (event.data.action) {
			case 'CloseRadioTab':
				$('.tab-name').each(function (yo) {
					if ($(this).text() == 'Radio') {
						policeFunctions.closeTab($(this));
					}
				});
				break;
			case 'HideCamHud':
				$('.cam-overlay').fadeOut(300);
				break;

			case 'RpolMessage':
				centralFunctions.addRpolMessage(event.data.message);
				break;

			case 'UpdateCentralPositions':
				!event.data.Cops instanceof Array
					? (event.data.Cops = Object.values(event.data.Cops))
					: null;

				centralFunctions.updateAgentesTable(event.data.Cops);
				centralFunctions.updatePoliceCarsMap(event.data.VehiclesTrackeds);
				break;

			case 'ReceiveAlert':
				centralFunctions.addAlert(event);
				break;

			case 'AddCentralMark':
				switch (event.data.data.icon) {
					case 'radar':
						CreateBlip(
							mapCentral,
							event.data.id,
							{
								x: event.data.data.objectCoords.x,
								y: event.data.data.objectCoords.y
							},
							MarkerBlips['radar'],
							`<div>${Translations.RadarOf} ${
								event.data.data.type == 1 ? Translations.Velocity : Translations.LicensePlate
							}</div>`
						);
						break;

					case 'traffic':
						mapFunctions.CreateCircle(
							mapCentral,
							event.data.id,
							{ x: event.data.data.coords.x, y: event.data.data.coords.y },
							event.data.data.radius,
							event.data.data.type == 'stop' ? 'red' : 'orange',
							event.data.data.type == 'stop' ? 'red' : 'orange',
							`<div>${
								event.data.data.type == 'stop'
									? Translations.TrafficStop
									: Translations.SpeedReduction
							}</div>`
						);
				}

				break;

			case 'EditAlert':
				centralFunctions.alerts.map((alert, i) => {
					if (alert.code == event.data.data.code) {
						Object.entries(event.data.data).map(([key, value]) => {
							alert[key] = value;
						});
						if (
							$(
								".police .tab .central .tabla-dispatch tbody tr[index='" +
									i +
									"']"
							).hasClass('selected')
						) {
							centralFunctions.setAlertShowing(alert, i);
						}
						if (event.data.data.unit) {
							let $units = $(
								'.police .tab .central .tabla-dispatch tbody #alert-' +
									alert.code
							).find('.units');
							if ($units.html() == '') {
								$units.html(event.data.data.unit);
							} else {
								$units.html(
									$units.html() + ' <br> ' + event.data.data.unit
								);
							}
						}
					}
				});
				break;

			case 'RemoveCentralMark':
				mapFunctions.destroyBlip(event.data.id);
				mapFunctions.destroyCircle(event.data.id);
				break;
			case 'ForceNotification':
				sendNotification('success', event.data.notify);
				break;
			case 'UpdateShapes':
				centralFunctions.updateShapes();
				break;
			case 'playsound':
				const s_temp = new Audio('sounds/'+event.data.soundid);
				s_temp.volume = 0.2;
				s_temp.play();
				break;
			case 'SetBodyCamEnabled':
				$('.cam-overlay .name').text(lastBodyCamData.name);
				$('.cam-overlay .other').text(lastBodyCamData.grade);
				setTimeout(() => {
					$.post('https://origen_police/close', JSON.stringify({}));
					$('.screen').removeClass('show');
					$('.cam-overlay').fadeIn(300);
				}, 800);
				break;
			default:
				break;
		}
	} else if(event.data.setDuty) {
		policeFunctions.alternarServicio(event.data.duty)
	} else if(event.data.startTalkSound) {
		PlayTalkOn()
	} else if (event.data.radioMenu) {
		radioFunctions.radioNetEventsMenu(event.data);
	}
});

$(document).ready(() => {
	$('.menu').draggable({
		containment: 'window'
	});

	$(document).on('keydown', function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;
		if (keycode == '27') {
			$('.block-informe').fadeOut(300);
			$.post('https://origen_police/focus', JSON.stringify({}));
			$('.friends').removeClass('show');
		}
	});

	Object.entries(ReferenceSprite).map(([key, value]) => {
		$('.ref-list').append(`
            <div class="ref" blip="${key}">
                <img src="${value}">
            </div>
        `);
	});

	Object.entries(ReferenceColor).map(([key, value]) => {
		$('.color-list').append(`
            <div class="color" number="${key}" style="background-color:${value}"></div>
        `);
	});
});

function dataURItoBlob(dataURI) {
	const byteString = atob(dataURI.split(',')[1]);
	const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

	const ab = new ArrayBuffer(byteString.length);
	const ia = new Uint8Array(ab);

	for (let i = 0; i < byteString.length; i++) {
		ia[i] = byteString.charCodeAt(i);
	}

	const blob = new Blob([ab], { type: mimeString });
	return blob;
}

function fetch(event, data) {
	return $.post('https://origen_police/' + event, JSON.stringify(data)).promise();
}

function exportEvent(script, event, data) {
	if(event == "SetMultiFrec" && data[1] != "none") {
		$(".reference-location-check").attr("disabled", false);
		$(".setting-list[setting='reference']").css("opacity", "1.0");
	}
	return $.post('https://' + script + '/' + event, JSON.stringify(data)).promise();
}

function TriggerCallback(event, data) {
	data.name = event;
	return $.post(
		'https://origen_police/TriggerCallback',
		JSON.stringify(data)
	).promise();
}

function timeStampToDate(timeStamp) {
	let date = new Date(timeStamp);
	let day = date.getDate();
	let month = date.getMonth() + 1;
	let year = date.getFullYear();
	let hour = date.getHours();
	let minutes = date.getMinutes();
	if (minutes < 10) {
		minutes = '0' + minutes;
	}
	return { date: `${day}/${month}/${year}`, time: `${hour}:${minutes}` };
}

function isJsonString(str) {
	try {
		JSON.parse(str);
	} catch (e) {
		return false;
	}
	return true;
}

function OpenModal(title, content, footerButtons, closeText, width) {
	$('.screen').append(`
    <div class="c-modal fadeIn">
       <div class="modal-block">
            <div class="modal-content scale-in-2" style="width: ${
				width ? width + 'vh' : 'max-content'
			}">
                <div class="modal-header">

                    <h2 class="title">${title}</h2>
                </div>
                <div class="modal-body">
                    ${content}
                </div>
                <div class="modal-footer">
                    ${footerButtons}
                    <button class="btn-cancel" onclick='CloseModal()'>${closeText}</button>
                </div>
            </div>
        </div>
    </div>
    `);
}

function CloseModal() {
	$('.c-modal .modal-block .modal-content')
		.removeClass('scale-in-2')
		.addClass('scale-out-2');
	$('.c-modal')
		.removeClass('fadeIn')
		.fadeOut(500, function () {
			$(this).remove();
		});
}

function stringToUrl(string) {
	return string
		.normalize('NFD')
		.replace(/[\u0300-\u036f]/g, '')
		.toLowerCase()
		.replace(/ /g, '-')
		.replace(/á/g, 'a')
		.replace(/é/g, 'e')
		.replace(/í/g, 'i')
		.replace(/ó/g, 'o')
		.replace(/ú/g, 'u')
		.replace(/ñ/g, 'n')
		.replace(/ü/g, 'u');
}

function secondsOrMinutes(seconds) {
	seconds = seconds / 1000;
	if (seconds < 60) {
		return seconds + ' ' + Translations.seconds;
	} else {
		return Math.floor(seconds / 60) + ' ' + Translations.minutes;
	}
}

function checkNumber(number) {
	if (number < 10) {
		return '000' + number;
	} else if (number < 100) {
		return '00' + number;
	} else if (number < 1000) {
		return '0' + number;
	} else {
		return number;
	}
}

function nameToId(name) {
	return name
		.normalize('NFD')
		.replace(/[\u0300-\u036f]/g, '')
		.toLowerCase()
		.replace(/ /g, '-')
		.replace(/á/g, 'a')
		.replace(/é/g, 'e')
		.replace(/í/g, 'i')
		.replace(/ó/g, 'o')
		.replace(/ú/g, 'u')
		.replace(/ñ/g, 'n')
		.replace(/ü/g, 'u')
		.replace(/[^a-z0-9-]/g, '');
}



//ESTA FUNCIÓN RECIBE UN STRING Y DEVUELVE EL STRING EN MINUSCULAS, SUSTITUYENDO ESPACIOS Y CARACTERES RAROS POR GUIONES O LETRAS NORMALES
function stringToUrl(string) {
	return string
		.normalize('NFD')
		.replace(/[\u0300-\u036f]/g, '')
		.toLowerCase()
		.replace(/ /g, '-')
		.replace(/á/g, 'a')
		.replace(/é/g, 'e')
		.replace(/í/g, 'i')
		.replace(/ó/g, 'o')
		.replace(/ú/g, 'u')
		.replace(/ñ/g, 'n')
		.replace(/ü/g, 'u');
}



//EVENTOS DISPATCH


//EVENTOS ACCIONES RAPIDAS



function secondsOrMinutes(seconds) {
	if (seconds < 60) {
		return seconds + ` ${Translations.seconds}`
	} else {
		return Math.floor(seconds / 60) + ` ${Translations.minutes}`;
	}
}

function checkNumber(number) {
	if (number < 10) {
		return '000' + number;
	} else if (number < 100) {
		return '00' + number;
	} else if (number < 1000) {
		return '0' + number;
	} else {
		return number;
	}
}

function copyToClipboard(texto) {
	var elementoTemporal = document.createElement('textarea');
	elementoTemporal.value = texto;
	document.body.appendChild(elementoTemporal);
	elementoTemporal.select();
	elementoTemporal.setSelectionRange(0, 99999);
	document.execCommand('copy');
	document.body.removeChild(elementoTemporal);
}