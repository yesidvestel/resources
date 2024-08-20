let RADIO_SCRIPT;

let playerBusiness;
let showingMenu = false;
let frecuenciaActual;

window.addEventListener('message', function (event) {
	if (event.data.action == 'OpenMenu') {
		or.debuger('openMenu lateral')
		$('.ilegal-quickmenu').show();
		or.debuger('KICKMENU')
		$('.screen').hide();
		openQuickMenu();
		RADIO_SCRIPT = event.data.radio_script;
		showingMenu = true;
		or.debuger('Job', event.data.business);
		if (event.data.business) {
			$('.tab-business').show();

			playerBusiness = event.data.business;
			or.debuger('job', event.data.business);

			$('.reparar').hide();
			$('.buy_veh').hide();
			$('.sell_veh').hide();

			switch (event.data.business_type) {
				case 'mechanic':
					$('.reparar').show();
					break;
				case 'compraventa':
					$('.buy_veh').show();
					$('.sell_veh').show();
					break;
				default:
					break;
			}
		} else {
			$('.tab-business').hide();
			if ($('.ilegal-quickmenu .tab-content.negocio').hasClass('active')) {
				$('.ilegal-quickmenu .ilegal-tab.tab-business.selected').removeClass(
					'selected'
				);
				$('.ilegal-quickmenu .ilegal-tab.tab-inventory').addClass('selected');
				$('.ilegal-quickmenu .tab-content.negocio.active')
					.removeClass('active')
					.fadeOut(0, function () {
						$(".ilegal-quickmenu .tab-content[tab='inventory']")
							.addClass('active')
							.fadeIn(0);
					});
			}
		}
	}

	if (event.data.radio) {
		radioFunctions.radioNetEvents(event.data);
	}
});

// Add an event listener to the document object that listens for the 'keydown' event
document.addEventListener('keydown', function (event) {
	// Check if the key pressed is the 'Escape' key
	if (event.key === 'Escape') {
		if (showingMenu) {
			showingMenu = false;
			closeQuickMenu();
		}
	}
});


$(document).on(
	'mouseenter',
	'.btn-action, .btn-action2, .btn-anim, .arma, .btn-action-2, .btn-cancel',
	function () {
		s_hover.currentTime = '0';
		s_hover.play();
	}
);
/*
function fetch(event, data) {
	return $.post('https://origen_masterjob/' + event, JSON.stringify(data)).promise();
}*/

function exportEvent(script, event, data) {
	return $.post('https://' + script + '/' + event, JSON.stringify(data)).promise();
}

function TriggerCallback(event, data) {
	data.name = event;
	return $.post(
		'https://origen_masterjob/TriggerCallback',
		JSON.stringify(data)
	).promise();
}

$(document).on('click', '.radio .radio-category .toggle-category', function () {
	$(this).parent().toggleClass('toggle');
	or.debuger('hola');
});

$(document).on('click', '.business.radio .radio-category .category-title', function () {
	let id = $(this).parent().attr('frec');
	or.exportEvent(RADIO_SCRIPT, 'SetMultiFrec', ['business_' + playerBusiness, id]);
	actualRadio = 'business';
});

$(document).on('click', '.business.radio .disconnect-button', function () {
	$(this).parent().find('.freq-name').removeClass('text-success').text('DESCONECTADO');
	$(this)
		.animate(
			{
				height: '0vh',
				opacity: 0
			},
			500,
			'easeOutBounce'
		)
		.hide(0);

		or.exportEvent(RADIO_SCRIPT, 'SetMultiFrec', ['business_' + playerBusiness, 'none']);
	actualRadio = '';
});

$(document).on('click', '.ilegal-quickmenu-bg', function () {
	closeQuickMenu();
});

radioFunctions = {
	radioLoad: (business, type) => {
		radioFunctions.loadAllPlayers(business, type);
		let group = 'business_';

		let updateCounter = 0;
		$('.user-list').sortable({
			connectWith: '.user-list',
			// cursorAt: { left: 70, top: 70 },
			items: '.radio-user',
			placeholder: 'radio-hover',
			update: function (event, ui) {
				updateCounter++;
				if (updateCounter == 2) {
					radioFunctions.updateChannelUsers(ui.sender.parent());
					radioFunctions.updateChannelUsers(ui.item.parent().parent());
					or.exportEvent(RADIO_SCRIPT, 'MovePlayerMultiFrec', [
						$(ui.item).attr('source'),
						group + business,
						$(ui.item).parent().parent().attr('frec')
					]);
				}
			},
			stop: function (event, ui) {
				updateCounter = 0;
			}
		});
	},
	setFrecuencias: (business, type) => {
		return new Promise(function (resolve, reject) {
			let event = 'LoadRadio';
			let clase = '.negocio';

			or.fetch(event, {}).done((radiodata) => {
				// or.debuger("Llego", radiodata)
				if (radiodata) {
					radioFunctions.setFrecCabecera(radiodata.myfrec.toUpperCase(), clase);
					let listFrecuencias = '';

					radiodata.freclist.map((frecuencia) => {
						listFrecuencias += `
                        <div class="radio-category toggle vacio" frec="${or.stringToUrl(
							frecuencia
						)}">
                            <div class="category-title">
                                ${frecuencia}
                            </div>
                            <div class="connected-users text-danger">
                                <i class="lni lni-users"></i> <span class="number">0</span>
                            </div>
                            <div class="toggle-category">
                                <i class="lni lni-chevron-down"></i>
                            </div>
                            <div class="user-list" frecuencia="f-1">

                            </div>
                            <div class="no-users scale-in">
                                There are no users connected to this frequency
                            </div>
                        </div>
                        `;
					});
					$(clase + ' .radio-list').html(listFrecuencias);
					radioFunctions.radioLoad(business, type);
				} else {
					$(clase + ' .radio-list').html(
						`<div class="text-danger w-100 text-center text-uppercase">${or.lang.not_radio}</div>`
					);
				}

				resolve();
			});
		});
	},
	radioNetEvents: (event) => {
		switch (event.radio) {
			case 'AddPlayerMultiFrec':
				radioFunctions.addPlayerToFrec(event.frec, event.id, event.data);

				if (event.i) {
					frecuenciaActual = event.frec;
					let clase = '.negocio';

					radioFunctions.setFrecCabecera(event.frec, clase);
				}

				break;

			case 'Talking':
				radioFunctions.talking(event.target, event.value);
				break;

			case 'RemovePlayerMultiFrec':
				radioFunctions.removePlayerFromFrec(event.frec, event.id);
				break;

			case 'SetMuted':
				radioFunctions.setMuted(event.id, event.value);
				break;
			case 'SetReady':
				radioFunctions.setReady(event.id, event.value);
				break;
			case 'Disconnected':
				let clase = '.negocio';

				radioFunctions.setFrecCabecera('NONE', clase);
				break;
		}
	},
	updateChannelUsers: (channel) => {
		const nUsers = channel.find('.radio-user').length;
		channel.find('.connected-users .number').text(nUsers);
		if (nUsers > 0) {
			channel
				.find('.connected-users')
				.removeClass('text-danger')
				.addClass('text-success');
			// channel.find(".no-users").remove();ç
			channel.removeClass('vacio');
		} else {
			channel
				.find('.connected-users')
				.removeClass('text-success')
				.addClass('text-danger');
			channel.addClass('vacio').addClass('toggle');
		}
	},
	setSpeaking: (user, speaking) => {
		if (speaking) {
			user.find('.radio-user .speaking').css('opacity', 1);
		} else {
			user.find('.radio-user .speaking').css('opacity', 0);
		}
	},

	setSilenced: (user, silenced) => {
		if (silenced) {
			user.find('.radio-user .volume-muted').css('opacity', 1);
		} else {
			user.find('.radio-user .volume-muted').css('opacity', 0);
		}
	},

	loadAllPlayers: (business, type) => {
		let group = 'business_';

		TriggerCallback(RADIO_SCRIPT + ':GetMultiFrecs', {
			group: group + business
		}).done((cb) => {
			if (cb) {
				Object.entries(cb).map(([key, value]) => {
					let aum;

					Object.entries(value).map(([id, data]) => {
						if (id == 0) aum = true;
						if (aum) id++;
						radioFunctions.addPlayerToFrec(key, id, data);
					});
				});
			}
		});
	},
	addPlayerToFrec: (frec, id, data) => {
		if (frec == frecuenciaActual) {
			s_talkon.currentTime = '0';
			s_talkon.play();
		}
		if (
			$('.radio .radio-category[frec="' + frec + '"] .user-list .source-' + id)
				.length == 0
		) {
			$('.radio .radio-category[frec="' + frec + '"] .user-list').append(`
            <div class="radio-user source-${id}" source="${id}">
                <div class="d-flex align-items-center w-100">
                    <span class="circle ${
						data.ready ? 'green' : 'red'
					}"></span> <span class="user-name">${
				data.name
			}</span> <span class="user-rango badge ms-2 bg-morado">${data.grade}</span>
                </div>
                <div class="volume-muted" style="${
					!data.muted ? 'opacity: 0' : 'opacity: 1'
				}">
                    <img src="./assets/volume-mute.png" class="radio-icon">
                </div>
                <div>
                    <img src="./assets/hablando.svg" class="speaking">
                </div>
            </div>
            `);
			$('.radio .radio-category[frec="' + frec + '"]').removeClass('toggle');
			radioFunctions.updateChannelUsers(
				$('.radio .radio-category[frec="' + frec + '"]')
			);
		}
	},
	removePlayerFromFrec: (frec, id) => {
		if (
			$('.radio .radio-category[frec="' + frec + '"] .user-list .source-' + id)
				.length > 0
		) {
			$(
				'.radio .radio-category[frec="' + frec + '"] .user-list .source-' + id
			).remove();
			radioFunctions.updateChannelUsers(
				$('.radio .radio-category[frec="' + frec + '"]')
			);
		}
	},

	setMuted: (target, value) => {
		$('.radio .radio-category .source-' + target + ' .volume-muted').css(
			'opacity',
			value ? 1 : 0
		);
	},

	setReady: (target, value) => {
		$('.radio .radio-category .source-' + target + ' .circle')
			.removeClass('red')
			.removeClass('green')
			.addClass(value ? 'green' : 'red');
	},

	talking: (target, value) => {
		if (!value) {
			s_talkoff.currentTime = '0';
			s_talkoff.play();
		}
		$('.radio .radio-category .source-' + target + ' .speaking').css(
			'opacity',
			value ? 1 : 0
		);
	},
	setAsignacion: (btn) => {
		$(btn).addClass('seleccionando').text(' - ');
		$(btn).on('keydown', function (event) {
			//Obtengo la tecla pulsada, la convierto en mayuscula y la pinto en el boton
			let tecla = false;
			let regex = /^[a-zA-Z0-9]+$/;
			let action = $(this).attr('id');
			if (teclas[event.keyCode]) {
				tecla = teclas[event.keyCode];
			} else {
				tecla = String.fromCharCode(event.keyCode).toUpperCase();
			}
			if (tecla && regex.test(tecla)) {
				or.exportEvent(RADIO_SCRIPT, 'RadioAddKeyBind', ['keyboard', tecla, action]);
				$(btn).removeClass('seleccionando').off('keydown');
				$('.key-' + tecla)
					.removeClass('key-' + tecla)
					.addClass('key--')
					.html(' - ');
				$(btn)
					.removeClass('key-' + $(btn).html().trim())
					.addClass('key-' + tecla)
					.html(tecla);
			}
		});
	},
	setFrecCabecera: (frec, clase) => {
		let clase2;
		let clase3;
		clase == '.negocio'
			? (clase2 = '.negocio .connected-zone .disconnect-button')
			: (clase2 = '.negocio.radio .connected-zone .disconnect-button');
		clase == '.negocio'
			? (clase3 = '.negocio .freq-name')
			: (clase3 = '.negocio.radio .freq-name');

		if (frec != 'NONE') {
			$(clase3).text(frec).addClass('text-success');
			$(clase2).show(0).animate(
				{
					height: '2vh',
					opacity: 1
				},
				500,
				'easeInOutCubic'
			);
		} else {
			$(clase3).find('.freq-name').removeClass('text-success').text('DISCONNECTED');
			$(clase2)
				.animate(
					{
						height: '0vh',
						opacity: 0
					},
					500,
					'easeOutBounce'
				)
				.hide(0);
		}
	}
};

function openQuickMenu() {
	radioFunctions.setFrecuencias(playerBusiness, 'radio-business');
	$('.ilegal-quickmenu').addClass('show').css('display', 'block');
	s_swipe.currentTime = '0';
	s_swipe.play();
	or.closeMenu();
}

function closeQuickMenu() {
	$('.ilegal-quickmenu').removeClass('show');
	s_swipe.currentTime = '0';
	s_swipe.play();
	or.fetch('focus', {});
}

$(document).on('click', '.command', function (e) {
	let command = $(this).attr('event');
	$.post(
		'https://origen_masterjob/ExecuteCommand',
		JSON.stringify({ command: command })
	);
	closeQuickMenu();
});

$(document).on('click', '.event', function (e) {
	let event = $(this).attr('event');
	$.post('https://origen_masterjob/ExecuteEvent', JSON.stringify({ event }));
	closeQuickMenu();
});

$(document).on('click', '.action', function () {
	const action = $(this).attr('event');
	if (action == 'facturar') {
		or.exportEvent('origen_masterjob', 'newbill', {});
	} else if (action == 'reparar-vehiculo') {
		or.exportEvent('origen_masterjob', 'fixvehicle', {});
	} else if (action == 'buy-veh') {
		or.exportEvent('origen_masterjob', 'buy_vehicle', {});
	} else if (action == 'sell-veh') {
		or.exportEvent('origen_masterjob', 'sell_vehicle', {});
	} else if (action == 'facturar-tel') {
		or.exportEvent('origen_masterjob', 'newbill', { requestid: true });
	}
	closeQuickMenu();
});
