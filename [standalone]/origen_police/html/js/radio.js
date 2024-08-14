function DisconnectAllFreqs() {
	$(this).parent().find('.freq-name').removeClass('text-success').text(Translations.Disconnected);
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
	//SONIDO DESCONEXIÓN
	$('.alertas .radio-alert-status')
		.removeClass('text-success')
		.html(`<i class="fas fa-walkie-talkie"></i> ${Translations.Disconnected}`);
		
	frecuenciaActual = null;
	$(".reference-location-check").attr("disabled", true);
	$(".setting-list[setting='reference']").css("opacity", "0.5");
	exportEvent('origen_police', 'SetMultiFrec', [null, 'none']);
}

radioFunctions = {
	// Menu
	freqList: {
		sur: [],
		norte: [],
		especiales: [],
		ems: []
	},
	radioNetEventsMenu: (event) => {
		switch (event.radioMenu) {
			case 'AddPlayerMultiFrec':
				radioFunctions.addPlayerToFrecMenu(event.frec, event.id, event.data);
				if (event.i) {
					radioFunctions.setFrecCabeceraMenu(event.frec);
				}
				break;
			case 'Talking':
				radioFunctions.talkingMenu(event.target, event.value);
				break;
			case 'RemovePlayerMultiFrec':
				radioFunctions.removePlayerFromFrecMenu(event.frec, event.id);
				break;

			case 'SetMuted':
				radioFunctions.setMutedMenu(event.id, event.value);
				break;

			case 'SetReady':
				radioFunctions.setReadyMenu(event.id, event.value);
				break;

			case 'Disconnected':
				$('.police .radio .zona-conectar').fadeOut(300);
				break;
		}
	},
	loadRadioEventsMenu: () => {
		$(document).on('click', '.radio-button', function () {
			if(HasPermission("Radio")) {
				$('.police .duty-alert .animate__animated').html(
					Translations.NoPermission
				);
				$('.police .tab-content-menu').addClass('blur');
				$('.police .duty-alert').fadeIn(300, function () {
					setTimeout(() => {
						$('.police .duty-alert').fadeOut(300, function () {
							$('.police .duty-alert .animate__animated').html(
								Translations.NotInDuty
							);
						});
						$('.police .tab-content-menu').removeClass('blur');
					}, 3000);
				});
				return;
			}

			let valid;
			$('.tab-name').each(function (yo) {
				if ($(this).text() == 'Radio') {
					valid = $(this);
				}
			});

			if (!valid) {
				fetch('LoadPolicePage', { page: 'radio' }).done((cb) => {
					if (cb) {
						policeFunctions
							.policeNavigation('Radio', $('.police-radio').html())
							.then(() => {
								radioFunctions.setFrecuenciasMenu().then(() => {
									setTimeout(() => {
										if (cb != 'none')
											radioFunctions.setFrecCabeceraMenu(cb);
										radioFunctions.loadAllPlayersMenu();

										radioFunctions.sortableChannelsMenu();
									}, 300);
								});
							});
					} else {
						$('.police .duty-alert .animate__animated').html(
							Translations.NoRadio
						);
						$('.police .tab-content-menu').addClass('blur');
						$('.police .duty-alert').fadeIn(300, function () {
							setTimeout(() => {
								$('.police .duty-alert').fadeOut(300, function () {
									$('.police .duty-alert .animate__animated').html(
										Translations.NotInDuty
									);
								});
								$('.police .tab-content-menu').removeClass('blur');
							}, 3000);
						});
					}
				});
			} else {
				policeFunctions.openTab($(valid), false);
			}
		});
		$(document).on('click', '.police .radio-category-menu .toggle-category', function () {
			if(HasPermission("EnterRadioFreq")) return sendNotification('error', Translations.NoPermissionPage);
			console.log('toggle2');
			$(this).parent().toggleClass('toggle');
		});
		$(document).on('click', '.police .radio-category-menu .category-title', function () {
			if(HasPermission("EnterRadioFreq")) return sendNotification('error', Translations.NoPermissionPage);
			let id = $(this).parent().attr('frec');
			exportEvent('origen_police', 'SetMultiFrec', [null, id]);
		});
		$(document).on('click', '.police .radio .btn-teclas', function () {
			if(HasPermission("EnterRadioFreq")) return sendNotification('error', Translations.NoPermissionPage);
			exportEvent('origen_police', 'GetBinds', []).done((cb) => {
				Object.entries(cb).map(([key, value]) => {
					cb[value] = key;
				});

				let buttons = '';
				fetch('LoadRadioBinds', {}).done((radioBinds) => {
					radioBinds = radioBinds.binds

					Object.entries(radioBinds).map(([key, value]) => {
						buttons += `
							<div class="col-8 mb-2 d-flex align-items-center">
								<h4>${key.replaceAll("-", " ")}</h4>
							</div>
							<div class="col-4 mb-2">
								<button class="btn-modal w-100 key-${
										cb[key] || '-'
										}" id="${key}" onclick="radioFunctions.setAsignacionMenu(this)">${
									cb[key] || ' - '
								}</button>
							</div>`;
					});

					OpenModal(
						`${Translations.ShortCuts}`,
						`<div class="row" style="width:45vh;">
							<div class="col-8 mb-2 d-flex align-items-center">
								<h4>${Translations.AlternateMute}</h4>
							</div>
							<div class="col-4 mb-2">
								<button class="btn-modal w-100 key-${
									cb['mute'] || '-'
								}" id="mute" onclick="radioFunctions.setAsignacionMenu(this)">${
							cb['mute'] || ' - '
						}</button>
							</div>
							
						${buttons}
						</div>`,
						`<div></div>`,
						Translations.Close
					);
				});
			});
		});

		$(document).on('click', '.police .radio .zona-conectar .connected', function () {
			$(this).parent().fadeOut(300);
			//SONIDO DESCONEXIÓN
			frecuenciaActual = null;
			$(".reference-location-check").attr("disabled", true);
			$(".setting-list[setting='reference']").css("opacity", "0.5");
			exportEvent('origen_police', 'SetMultiFrec', [null, 'none']);
		});
	},

	setFrecuenciasMenu: () => {
		return new Promise(function (resolve, reject) {
			fetch('LoadFrecList', {}).done((freclist) => {
				freclist = freclist.freq;
				$('.police .radio .frecuencias').html('');
				for(let i = 0; i < Object.keys(freclist).length; i++)
				{
					const key = Object.keys(freclist)[i];
					const data = freclist[Object.keys(freclist)[i]];
					$("#radioContainerFreqs").append(`
					<div class="col-3" style="width:${100/Object.keys(freclist).length}%">
						<div class="bg-box h-max p-0 pt-2 pb-2">
							<h4 class="title-1-menu m-titles">${key}</h4>
							<div class="frecuencias ${stringToUrl(key)}"></div>
						</div>
					</div>
					`);
					for(let z = 0; z < data.length; z++)
					{
						const name = data[z];
						$(`.police .radio .${stringToUrl(key)}`).append(`
						<div class="radio-category-menu toggle vacio" frec="${stringToUrl(
							name
						)}">
							<div class="category-title">
								${name}
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
								${Translations.NoUsers}
							</div>
						</div>
						`);
					}
				}
				resolve();
			});
		});
	},

	updateChannelUsersMenu: (channel) => {
		const nUsers = channel.find('.radio-user').length;
		channel.find('.connected-users .number').text(nUsers);
		if (nUsers > 0) {
			channel
				.find('.connected-users')
				.removeClass('text-danger')
				.addClass('text-success');

			channel.removeClass('vacio');
		} else {
			channel
				.find('.connected-users')
				.removeClass('text-success')
				.addClass('text-danger');
			channel.addClass('vacio').addClass('toggle');
		}
	},

	setSpeakingMenu: (user, speaking) => {
		if (speaking) {
			user.find('.radio-user .speaking').css('opacity', 1);
		} else {
			user.find('.radio-user .speaking').css('opacity', 0);
		}
	},

	setSilencedMenu: (user, silenced) => {
		if (silenced) {
			user.find('.radio-user .volume-muted').css('opacity', 1);
		} else {
			user.find('.radio-user .volume-muted').css('opacity', 0);
		}
	},

	loadAllPlayersMenu: () => {
		TriggerCallback('origen_police:GetMultiFrecs', {}).done((cb) => {
			if (cb) {
				Object.entries(cb).map(([key, value]) => {
					let aum;
					Object.entries(value).map(([id, data]) => {
						if (id == 0) aum = true;
						if (aum) id++;
						radioFunctions.addPlayerToFrecMenu(key, id, data);
					});
				});
			}
		});
	},

	addPlayerToFrecMenu: (frec, id, data) => {
		if (frec == frecuenciaActual) {
			PlayTalkOn()
		}
		if (
			$(
				'.police .tab .radio .radio-category-menu[frec="' +
					frec +
					'"] .user-list .source-' +
					id
			).length == 0
		) {
			$('.police .tab .radio .radio-category-menu[frec="' + frec + '"] .user-list')
				.append(`
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
                    <img src="./img/volume-mute.png" class="radio-icon">
                </div>
                <div>
                    <img src="./img/hablando.svg" class="speaking">
                </div>
            </div>
            `);
			$('.police .tab .radio .radio-category-menu[frec="' + frec + '"]').removeClass(
				'toggle'
			);
			radioFunctions.updateChannelUsersMenu(
				$('.police .tab .radio .radio-category-menu[frec="' + frec + '"]')
			);
		}

		if (
			$(
				'.police .tab .central .radio-category-menu[frec="' +
					frec +
					'"] .user-list .source-' +
					id
			).length == 0
		) {
			$('.police .tab .central .radio-category-menu[frec="' + frec + '"] .user-list')
				.append(`
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
                    <img src="./img/volume-mute.png" class="radio-icon">
                </div>
                <div>
                    <img src="./img/hablando.svg" class="speaking">
                </div>
            </div>
            `);
			$('.police .tab .central .radio-category-menu[frec="' + frec + '"]').removeClass(
				'toggle'
			);

			radioFunctions.updateChannelUsersMenu(
				$('.police .tab .central .radio-category-menu[frec="' + frec + '"]')
			);
		}
	},

	removePlayerFromFrecMenu: (frec, id) => {
		if (
			$(
				'.police .tab .radio .radio-category-menu[frec="' +
					frec +
					'"] .user-list .source-' +
					id +
					', .police .tab .central .radio-category-menu[frec="' +
					frec +
					'"] .user-list .source-' +
					id
			).length > 0
		) {
			$(
				'.police .tab .radio .radio-category-menu[frec="' +
					frec +
					'"] .user-list .source-' +
					id +
					', .police .tab .central .radio-category-menu[frec="' +
					frec +
					'"] .user-list .source-' +
					id
			).remove();
			radioFunctions.updateChannelUsersMenu(
				$('.police .tab .radio .radio-category-menu[frec="' + frec + '"]')
			);
			radioFunctions.updateChannelUsersMenu(
				$('.police .tab .central .radio-category-menu[frec="' + frec + '"]')
			);
		}
	},

	setMutedMenu: (target, value) => {
		$('.police .tab .radio-category-menu .source-' + target + ' .volume-muted').css(
			'opacity',
			value ? 1 : 0
		);
	},

	setReadyMenu: (target, value) => {
		$('.police .tab .radio-category-menu .source-' + target + ' .circle')
			.removeClass('red')
			.removeClass('green')
			.addClass(value ? 'green' : 'red');
	},

	talkingMenu: (target, value) => {
		if (!value) {
			PlayTalkOff()
		}
		$('.police .tab .radio-category-menu .source-' + target + ' .speaking').css(
			'opacity',
			value ? 1 : 0
		);
	},

	setAsignacionMenu: (btn) => {
		const prevTecla = $(btn).html().trim();
		$(btn).addClass('seleccionando').text(' - ');
		$(btn).on('keydown', function (event) {
			let tecla = false;
			let regex = /^[a-zA-Z0-9]+$/;
			let action = $(this).attr('id');
			if (teclas[event.keyCode]) {
				tecla = teclas[event.keyCode];
			} else {
				tecla = String.fromCharCode(event.keyCode).toUpperCase();
			}
			if (tecla && regex.test(tecla)) {
				if (tecla == 'ESCAPE' || tecla == 'ESC' || tecla == 'BACK') {
					$(btn).removeClass('seleccionando').off('keydown');
					exportEvent('origen_police', 'RadioRemoveKeyBind', [
						prevTecla
					]);
					$(btn)
					.removeClass('key-' + prevTecla)
					.addClass('key--')
					.html(' - ');
					return;
				}

				exportEvent('origen_police', 'RadioAddKeyBind', [
					'keyboard',
					tecla,
					action
				]);
				$(btn).removeClass('seleccionando').off('keydown');
				$('.key-' + tecla)
					.removeClass('key-' + tecla)
					.addClass('key--')
					.html(' - ');
				$(btn)
					.removeClass('key-' + prevTecla)
					.addClass('key-' + tecla)
					.html(tecla);
			}
		});
	},

	setFrecCabeceraMenu: (frec) => {
		frecuenciaActual = frec;
		$(".reference-location-check").attr("disabled", false);
		$('.police .tab .radio .app-title .connected .frecuencia-actual').html(
			`<img src="./img/webp/speaking.webp" style="width:3vh; margin-right:1vh;"> ${frec}`
		);
		$('.police .tab .radio .app-title .zona-conectar').fadeIn(300);
	},

	setFrecuenciasCentralMenu: () => {
		return new Promise(function (resolve, reject) {
			fetch('LoadFrecList', {}).done((radiodata) => {
				const buttons = radiodata.buttons
				radiodata = radiodata.freq;
				if (radiodata) {
					$('.police .central .central-freq').html("");
					$('.police .central .actions-title-buttons').html("");
					broadcastButtons = buttons;
					for(let i = 0; i < Object.keys(buttons).length; i++) {
						const key = Object.keys(buttons)[i];
						const data = buttons[Object.keys(buttons)[i]];
						$('.police .central .actions-title-buttons').append(`
							<div
								action="${key}"
								class="broadcast d-flex align-items-center me-2">
								<i class="fa-solid fa-walkie-talkie me-1"></i>
								<div>${key}</div>
							</div>
						`);
					}
					for(let i = 0; i < Object.keys(radiodata).length; i++)
					{
						const key = Object.keys(radiodata)[i];
						const data = radiodata[Object.keys(radiodata)[i]];
						
						$('.police .central .central-freq').append(
							`<div class="title-1-menu">${key}</div>`
						);

						for(let z = 0; z < data.length; z++)
						{
							const name = data[z];
							$('.police .central .central-freq').append(`
							<div class="radio-category-menu toggle vacio" frec="${stringToUrl(
								name
							)}">
								<div class="category-title">
									${name}
								</div>
								<div class="speak-to"><i class="fas fa-microphone"></i> ${Translations.Talk}</div>
								<div class="connected-users text-danger">
									<i class="lni lni-users"></i> <span class="number">0</span>
								</div>
								<div class="toggle-category">
									<i class="lni lni-chevron-down"></i>
								</div>
								<div class="user-list" frecuencia="f-1">
	
								</div>
								<div class="no-users scale-in">
									${Translations.NoUsersChannel}
								</div>
							</div>
							`);
						} 
					}
				} else {
					$('.police .central .central-freq').html(
						`<div class="text-danger w-100 text-center text-uppercase">${Translations.NoRadio}</div>`
					);
				}

				resolve();
			});
		});
	},
	sortableChannelsMenu: () => {
		let updateCounter = 0;

		$('.user-list').sortable({
			connectWith: '.user-list',
			items: '.radio-user',
			placeholder: '.radio-hover',
			update: function (event, ui) {
				if(HasPermission("MovePlayerInRadio")) 
				{
					sendNotification('error', Translations.NoPermissionPage);
					return;
				}
				updateCounter++;
				if (updateCounter == 2) {
					radioFunctions.updateChannelUsersMenu(ui.sender.parent());
					radioFunctions.updateChannelUsersMenu(ui.item.parent().parent());
					exportEvent('origen_police', 'MovePlayerMultiFrec', [
						$(ui.item).attr('source'),
						'police',
						$(ui.item).parent().parent().attr('frec')
					]);
				}
			},
			stop: function (event, ui) {
				updateCounter = 0;
			}
		});
	},

	speakToMenu: (frec) => {
		exportEvent('origen_police', 'StartTalkRadio', [frec, 'central']);
	},

	stopSpeakToMenu: () => {
		exportEvent('origen_police', 'StopTalkRadio', {});
	},

	// 
	radioLoad: () => {
		radioFunctions.loadAllPlayers();

		let updateCounter = 0;
		$('.user-list').sortable({
			connectWith: '.user-list',
			// cursorAt: { left: 70, top: 70 },
			items: '.radio-user',
			placeholder: 'radio-hover',
			update: function (event, ui) {
				if(HasPermission("MovePlayerInRadio")) 
				{
					fetch('notification', Translations.NoPermissionMoveUsers);
					return;
				}
				updateCounter++;
				if (updateCounter == 2) {
					radioFunctions.updateChannelUsers(ui.sender.parent());
					radioFunctions.updateChannelUsers(ui.item.parent().parent());
					exportEvent('origen_police', 'MovePlayerMultiFrec', [
						$(ui.item).attr('source'),
						'police',
						$(ui.item).parent().parent().attr('frec')
					]);
				}
			},
			stop: function (event, ui) {
				updateCounter = 0;
			}
		});
	},
	setFrecuencias: () => {
		return new Promise(function (resolve, reject) {
			fetch('LoadRadio', {}).done((radiodata) => {
				if (radiodata) {
					if(radioLoaded) return;
					radioLoaded = true;
					$('.radio-list').html('');
					radioFunctions.setFrecCabecera(radiodata.myfrec.toUpperCase());
					for(let i = 0; i < Object.keys(radiodata.freclist).length; i++)
					{
						const key = Object.keys(radiodata.freclist)[i];
						const data = radiodata.freclist[Object.keys(radiodata.freclist)[i]];
						
						$('.radio-list').append(
							`<div class="title-1">${key}</div>`
						);

						for(let z = 0; z < data.length; z++)
						{
							const name = data[z];

							$('.radio-list').append(
								`<div class="radio-category toggle vacio" frec="${stringToUrl(
									name
								)}">
									<div class="category-title">
										${name}
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
										${Translations.NoUsers}
									</div>
								</div>`
							);
						}
					}
					radioFunctions.radioLoad();
				} else {
					radioLoaded = false;
					$('.radio-list').html(
						`<div class="text-danger w-100 text-center text-uppercase">${Translations.NoRadio}</div>`
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
					radioFunctions.setFrecCabecera(event.frec);
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
				radioFunctions.setFrecCabecera('NONE');
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

	loadAllPlayers: () => {
		TriggerCallback('origen_police:GetMultiFrecs', {}).done((cb) => {
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
                    <img src="./img/volume-mute.png" class="radio-icon">
                </div>
                <div>
                    <img src="./img/hablando.svg" class="speaking">
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
				exportEvent('origen_police', 'RadioAddKeyBind', [
					'keyboard',
					tecla,
					action
				]);
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

	setFrecCabecera: (frec) => {
		if (frec != 'NONE') {
			$('.radio .freq-name').text(frec).addClass('text-success');
			$('.alertas .radio-alert-status')
				.html('<i class="fas fa-walkie-talkie"></i> ' + frec)
				.addClass('text-success');
			$('.radio .connected-zone .disconnect-button').show(0).animate(
				{
					height: '2vh',
					opacity: 1
				},
				500,
				'easeInOutCubic'
			);
			if ($('.check-dispo').attr('disabled')) {
				$('.check-dispo').prop('checked', true);
				$('.alertas .disponibilidad-alert .no-dispo').fadeOut(300, function () {
					$('.alertas .disponibilidad-alert .dispo').fadeIn(300);
				});
			}
			$('.check-dispo').attr('disabled', false);
		} else {
			$('.alertas .disponibilidad-alert .dispo').fadeOut(300, function () {
				$('.alertas .disponibilidad-alert .no-dispo').fadeIn(300);
			});
			$('.check-dispo').attr('disabled', true).prop('checked', false);
			$('.friends .connected-zone')
				.find('.freq-name')
				.removeClass('text-success')
				.text(Translations.Disconnected);
			$('.friends .connected-zone .disconnect-button')
				.animate(
					{
						height: '0vh',
						opacity: 0
					},
					500,
					'easeOutBounce'
				)
				.hide(0);
			$('.alertas .radio-alert-status')
				.removeClass('text-success')
				.html('<i class="fas fa-walkie-talkie"></i> '+Translations.Disconnected);
		}
	}
};