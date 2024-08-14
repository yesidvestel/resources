function loadQuickActions() {
	$('.com-list .row').html('');
	codes.map((code) => {
		let color = '';
		if (code == 'QRR') {
			color = 'bg-qrr';
		}
		$('.com-list .row').append(`
        <div class="col-4 p-1">
            <div class="com-item ${color}">
                <div class="com-title">${code}</div>
            </div>
        </div>
        `);
	});
}

//EVENTOS PESTAÑAS
$('.tab-content.active').fadeIn(300);
$(document).on('click', '.friends .police-tab-list .police-tab', function () {
	const yo = $(this);
	let perm = true;
	if(yo.attr('tab') == "com-rad" && HasPermission("RadialCommunicationTab")) {
		perm = false;
	} else if(yo.attr('tab') == "radio" && HasPermission("RadioTab")) {
		perm = false;
	} else if(yo.attr('tab') == "interaccion" && HasPermission("InteractTab")) {
		perm = false;
	} else if(yo.attr('tab') == "guns" && HasPermission("HolsterTab")) {
		perm = false;
	} else if(yo.attr('tab') == "items" && HasPermission("ObjectPlacementTab")) {
		perm = false;
	}
	if(!perm) {
		return fetch('notification', Translations.NoTabPermission);
	}
	if (!$(this).hasClass('selected')) {
		$('.friends .police-tab').removeClass('selected');
		$(this).addClass('selected');
		if (yo.attr('tab') == 'radio') {
			radioFunctions.setFrecuencias();
		}
		$('.friends .tab-content.active')
			.removeClass('active')
			.fadeOut(150, function () {
				$(".friends .tab-content[tab='" + yo.attr('tab') + "']")
					.addClass('active')
					.fadeIn(150);
			});
	}
});
$(document).on('click', '.dispatch .police-tab-list .police-tab', function () {
	if (!$(this).hasClass('selected')) {
		$('.dispatch .police-tab').removeClass('selected');
		$(this).addClass('selected');
		const yo = $(this);
		$('.dispatch .tab-content.active')
			.removeClass('active')
			.fadeOut(150, function () {
				$(".dispatch .tab-content[tab='" + yo.attr('tab') + "']")
					.addClass('active')
					.fadeIn(150);
			});
	}
});

$(document).on('change', '.check-dispo', function () {
	if ($('.check-dispo').prop('checked')) {
		$('.alertas .disponibilidad-alert .no-dispo').fadeOut(300, function () {
			$('.alertas .disponibilidad-alert .dispo').fadeIn(300);
		});
	} else {
		$('.alertas .disponibilidad-alert .dispo').fadeOut(300, function () {
			$('.alertas .disponibilidad-alert .no-dispo').fadeIn(300);
		});
	}

	fetch('quickaction', {
		action: 'ToggleReady',
		state: $('.check-dispo').prop('checked')
	});
});

//EVENTOS RADIO
$(document).on('click', '.radio .radio-category .toggle-category', function () {
	$(this).parent().toggleClass('toggle');
});

$(document).on('click', '.radio .radio-category .category-title', function () {
	let id = $(this).parent().attr('frec');
	exportEvent('origen_police', 'SetMultiFrec', [null, id]);
});

$(document).on('click', '.radio .disconnect-button', function () {
	DisconnectAllFreqs()
});

$(document).on('click', '.ref', function () {
	let blip = $(this).attr('blip');
	$('.ref').removeClass('active');
	$(this).addClass('active');
	fetch('quickaction', { action: 'ReferenceIcon', id: blip });
});

$(document).on('click', '.color', function () {
	let number = $(this).attr('number');
	$('.color').removeClass('active');
	$(this).addClass('active');
	fetch('quickaction', { action: 'ReferenceColor', id: number });
});

//EVENTOS COMUNICADOS
$(document).on('click', '.com-list .com-item', function () {
	let code = $(this).find('.com-title').text();
	fetch('quickaction', { action: 'RadioCalls', id: code });
});

$(document).on('click', '.friends .action-police', function () {
	let action = $(this).attr('event');
	switch (action) {
		case 'cachear':
			fetch('quickaction', { command: 'cachearPolice' });
			break;
		case 'esposar':
			fetch('quickaction', { event: 'origen_police:client:cuffuncuff' });
			break;

		case 'escoltar':
			fetch('quickaction', { event: 'origen_police:client:drag' });
			break;

		case 'vehicleinof':
			fetch('quickaction', { event: 'origen_police:client:vehicleinof' });
			break;

		case 'placaje':
			fetch('quickaction', { command: 'placaje' });
			break;

		case 'revive':
			fetch('quickaction', { command: 'revivep' });
			break;

		case 'health':
			fetch('quickaction', { command: {"qb": 'heal', "esx": "healp"} });
			break;

		case 'anklecuff':
			fetch('quickaction', { event: 'origen_police:client:anklecuff' });
			break;

		case 'vehicledata':
			fetch('quickaction', { event: 'origen_police:client:vehicledata' });
			break;

		case 'dvpolice':
			fetch('quickaction', { event: 'origen_police:client:dvpolice' });
			break;
		
		case 'callTow':
			fetch('quickaction', { event: 'origen_police:request_tow_truck' });
			break;

		case 'openveh':
			fetch('quickaction', { event: 'origen_police:client:openveh' });
			break;

		case 'stoptraffic':
			fetch('quickaction', { serverevent: 'origen_police:server:stoptraffic' });
			break;

		case 'slowtraffic':
			fetch('quickaction', { serverevent: 'origen_police:server:slowtraffic' });
			break;

		case 'resumetraffic':
			fetch('quickaction', { serverevent: 'origen_police:server:resumetraffic' });
			break;

		case 'holster boxers':
			fetch('quickaction', { command: action });
			break;

		case 'holster backhandgun':
			fetch('quickaction', { command: action });
			break;

		case 'holster waisthandgun':
			fetch('quickaction', { command: action });
			break;

		case 'holster handguns':
			fetch('quickaction', { command: action });
			break;

		case 'holster chesthandgun':
			fetch('quickaction', { command: action });
			break;

		case 'holster hiphandgun':
			fetch('quickaction', { command: action });
			break;

		case 'holster leghandgun':
			fetch('quickaction', { command: action });
			break;

		case 'holster handguns2':
			fetch('quickaction', { command: action });
			break;

		case 'holster tacticalrifle':
			fetch('quickaction', { command: action });
			break;

		case 'holster assault':
			fetch('quickaction', { command: action });
			break;

		case 'plceobj Conos':
			fetch('quickaction', { command: action });
			break;

		case 'plceobj Barreras':
			fetch('quickaction', { command: action });
			break;

		case 'plceobj Pinchos':
			fetch('quickaction', { command: action });
			break;

		case 'plceobj Radar':
			fetch('quickaction', { command: action });
			break;

		case 'plceobj Señales de tráfico':
			fetch('quickaction', { command: action });
			break;

		case 'rmveobj':
			fetch('quickaction', { command: action });
			break;

		case 'unarm':
			fetch('quickaction', { event: 'origen_armas:unarm' });
			break;
	}
	if (action != 'rmveobj') {
		$('.friends').removeClass('show');
		$.post('https://origen_police/focus', JSON.stringify({}));
	}
});

$(".reference-location-check").on("change", function () {
	if (frecuenciaActual == null) return;
	fetch('SetLocation', { value: $(this).is(":checked") })
});

$(".body-cam-check").on("change", function () {
	fetch('SetBodyCamEnabled', { value: $(this).is(":checked") })
});

$(document).on("click", ".radio_anim", function () {
    PlayClick();

    let anim = parseInt($(this).attr("anim"));

    $(`.radio_anim`).find(".com-item").removeClass("com-selected");
    $(this).find(".com-item").addClass("com-selected");

    fetch("SetRadioAnim", {anim: anim});
});

function setVolumeIcon(volume) {
	let iconClass = '';
	if (volume <= 1) {
		iconClass = 'fa-volume-xmark';
	} else if (volume < 33) {
		iconClass = 'fa-volume-off';
	} else if (volume < 66) {
		iconClass = 'fa-volume-low';
	} else {
		iconClass = 'fa-volume-high';
	}
	$('.volume-icon i')
		.removeClass()
		.addClass('fas ' + iconClass);
}

function volumeSelector(crr) {
	const val = $(crr).val();
	setVolumeIcon(val);
	const progressElement = document.getElementById('progress-volumen');
	progressElement.value = val;
}

let lastVolumeUpdate = 0;
$(document).on("input", "#inp-musicvolume", function() {
    if(lastVolumeUpdate != 0 && Date.now() - lastVolumeUpdate < 300) return;
    lastVolumeUpdate = Date.now();
    const volume = $(this).val();
    fetch("SetVolume", parseInt(volume));
})