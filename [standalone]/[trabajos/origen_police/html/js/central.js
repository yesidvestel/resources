centralFunctions = {
	alerts: [],
	heatAlerts: [],
	loadCentralEvents: () => {
		$(document).on('click', '.police .btn-police-central', function () {
			if(HasPermissionMenu("Dispatch")) {
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
				if ($(this).text() == Translations.Dispatch) {
					valid = $(this);
				}
			});
			if (!valid) {
				fetch('LoadPolicePage', { page: 'central' }).done((cb) => {
					if (cb) {
						centralFunctions.heatAlerts = cb;
						policeFunctions
							.policeNavigation(Translations.Dispatch, $('.police-central').html())
							.then(() => {
								TriggerCallback(
									'origen_police:server:OpenCentral',
									{}
								).done((cb) => {
									!cb.Cops instanceof Array
										? (cb.Cops = Object.values(cb.Cops))
										: null;

									if (cb.TrafficZones.length != 0) {
										cb.TrafficZones.map((zone, i) => {
											mapFunctions.CreateCircle(
												mapCentral,
												i + 1,
												{
													x: zone.coords.x,
													y: zone.coords.y
												},
												zone.radius,
												zone.type == 'stop' ? 'red' : 'orange',
												zone.type == 'stop' ? 'red' : 'orange',
												`<div>${
													zone.type == 'stop'
														? Translations.TrafficStop
														: Translations.SpeedReduction
												}</div>`
											);
										});
									}

									if (cb.Radars.length != 0) {
										cb.Radars.map((radar, i) => {
											CreateBlip(
												mapCentral,
												i + 1,
												{
													x: radar.objectCoords.x,
													y: radar.objectCoords.y
												},
												MarkerBlips['radar'],
												`<div>${Translations.RadarOf} ${
													radar.type == 1 ? Translations.Velocity : Translations.LicensePlate
												}</div>`
											);
										});
									}

									centralFunctions.updatePoliceCarsMap(
										cb.VehicleTrackeds
									);
									centralFunctions.updateAgentesTable(cb.Cops);
									centralFunctions.intervalAlerts();
								});

								cargarMapaCentral(centralFunctions.heatAlerts);
								radioFunctions.setFrecuenciasCentralMenu().then(() => {
									setTimeout(() => {
										radioFunctions.loadAllPlayersMenu();

										let updateCounter = 0;
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
								$('.police .duty-alert').fadeOut(300);
								$('.police .tab-content-menu').removeClass('blur');
								$('.police .duty-alert .animate__animated').html(
									Translations.NotInDuty
								);
							}, 3000);
						});
					}
				});
			} else {
				policeFunctions.openTab($(valid), false);
			}
		});

		$(document).on('click', '.police .new-note-agente', function () {
			if(HasPermissionMenu("CreateNotes")) return sendNotification('error', Translations.NoPermissionPage);
			policeFunctions.newNote(1);
		});

		$(document).on('mousedown', '.police .tab .central .speak-to', function () {
			const frec = $(this).parent().attr('frec');
			radioFunctions.speakToMenu(frec);
		});
		$(document).on('mouseup', '.police .tab .central .speak-to', function () {
			radioFunctions.stopSpeakToMenu();
		});

		$(document).on('keypress', '.police .tab .central .input-rpol', function (e) {
			if (e.which == 13) {
				if(HasPermissionMenu("SendRadioMessage")) return sendNotification('error', Translations.NoPermissionPage);
				const message = $(this).val();
				$(this).val('');
				fetch('SendRpolMessage', { message });
			}
		});

		$(document).on('click', '.police .tab .central .selector-container', function () {
			if (
				$('.police .tab .central .alerts-container .id-alert').text().trim() !=
				'-'
			) {
				$(this).toggleClass('toggle');
				if ($(this).hasClass('toggle')) {
					let unidadesDispo = '';
					$('.police .tab .central .radio-category-menu').each(function () {
						if ($(this).find('.number').text() > 0) {
							unidadesDispo += `
                            <div class="unidad" frec="${$(this).attr('frec')}">
                            <i class="fa-solid fa-car-on"></i> ${$(this).attr(
								'frec'
							)} <span style="color:grey;margin-left:1vh;">(${$(this)
								.find('.number')
								.text()})</span>
                            </div>

                            `;
						}
					});
					$('.police .tab .central .unidades-dispo').html(unidadesDispo);
				}
			}
		});
		$(document).on(
			'click',
			'.police .tab .central .selector-container .unidad',
			function () {
				if(HasPermissionMenu("AssignAlertToUnit")) return sendNotification('error', Translations.NoPermissionPage);
				const unit = $(this).attr('frec').toUpperCase();
				const index = $(this).parent().attr('index');
				const alert = {
					coords: centralFunctions.alerts[index].coords,
					code: centralFunctions.alerts[index].code,
					title: centralFunctions.alerts[index].title,
					message: centralFunctions.alerts[index].message,
					annotation: centralFunctions.alerts[index].annotation,
					metadata: centralFunctions.alerts[index].metadata
				};
				TriggerCallback('ForceSelectAlert:police', { alert, unit });
			}
		);

		$(document).on(
			'click',
			'.police .tab .central .tabla-dispatch tbody tr',
			function () {
				$(this).removeClass('new-alert');
				const alert = centralFunctions.alerts[$(this).attr('index')];
				if(!alert) return;
				mapFunctions.setAlertFocus(alert.code);
				centralFunctions.setAlertShowing(alert, $(this).attr('index'));
				if ($('.police .central .info-mapa').hasClass('show')) {
					$('.police .central .info-mapa').toggleClass('show');
					setTimeout(() => {
						mapFunctions.showCentralAlert(
							alert.title,
							alert.street,
							alert.time,
							checkNumber(alert.code)
						);
					}, 300);
				} else {
					mapFunctions.showCentralAlert(
						alert.title,
						alert.street,
						alert.time,
						checkNumber(alert.code)
					);
				}
			}
		);

		$(document).on('click', '.police .tab .central .action-button', function () {
			const attr = $(this).attr('action');
			switch (attr) {
				case 'cameras':
					if(HasPermissionMenu("SecurityCamera")) return sendNotification('error', Translations.NoPermissionPage);
					policeFunctions.createTab(Translations.Cameras, '.police-cameras');
					setTimeout(() => {
						camerasFunctions.loadCameras();
					}, 50);
					break;

				case 'informes':
					if(HasPermissionMenu("SearchReports")) return sendNotification('error', Translations.NoPermissionPage);
					policeFunctions.createTab(Translations.Reports, '.police-reports');
					setTimeout(() => {
						informesFunctions.loadReports();
					}, 500);
					break;

				case 'wanted':
					if(HasPermissionMenu("SearchCitizen")) return sendNotification('error', Translations.NoPermissionPage);
					policeFunctions.createTab(Translations.Citizens, '.police-citizen');
					break;
			}
		});

		$(document).on('mousedown', '.police .tab .central .broadcast', function () {
			const attr = $(this).attr('action');
			const freqList = broadcastButtons[attr];
			for(let i = 0; i < freqList.length; i++)
			{
				freqList[i] = stringToUrl(freqList[i]);
			}
			exportEvent('origen_police', 'StartTalkRadio', freqList);
		});

		$(document).on('mouseup', '.police .tab .central .broadcast', function () {
			exportEvent('origen_police', 'StopTalkRadio', {});
		});

		$(document).on(
			'click',
			'.police .tab .central .actions-title .delete-alert',
			function () {
				const code = parseInt(
					$('.police .tab .central .alerts-container .id-alert').text()
				);
				centralFunctions.deleteAlert(code);
			}
		);

		$(document).on(
			'click',
			'.police .tab .central .btn-save-note-alert',
			function () {
				if(HasPermissionMenu("AddNotesToAlert")) return sendNotification('error', Translations.NoPermissionPage);
				const code = parseInt(
					$('.police .tab .central .alerts-container .id-alert').text()
				);
				const annotation = $(
					'.police .tab .central .alerts-container .input-note-alert'
				).val();
				centralFunctions.saveAlertNoteAlert(code, annotation);
			}
		);
	},

	addRpolMessage: (message) => {
		message = message.substring(2);

		message = message.split('^0');
		//remove the last empty character of message[0]
		message[0] = message[0].substring(0, message[0].length - 2 )
		message[1] = ` <span style="color:white;">${message[1]}</span>`;
		message = message.join(':');

		$('.police .tab .central .chat-messages').append(`
        <div class="chat-message animate__animated animate__fadeInLeft animate__fast">
            <div class="message">${message}</div>
        </div>
        `);
		$('.police .tab .central .chat-messages').scrollTop(
			$('.police .tab .central .chat-messages')[0].scrollHeight
		);
	},

	updateAgentesTable: (data) => {
		if (data) {
			$('.police .tab .central .agentes-servicio tbody').html('');
			let newSources = [];
			if (typeof data === 'object') {
				data = Object.values(data);
			}
			data.map((agente) => {
				if (agente) {
					if (agente.unit != '') {
						CreateReferenceBlip(
							mapCentral,
							agente.source,
							{ x: agente.ref.coords.x, y: agente.ref.coords.y },
							ReferenceSprite[agente.ref.sprite] ||
								'https://docs.fivem.net/blips/radar_level.png',
							`<div><div style="${agente.deptColor}" class="d-flex align-content-center mb-1"><span class="badge mt-0 mb-0 me-1 quicksand" style="filter:hue-rotate(-${currentHueDeg}deg)">${
								agente.dept
							}</span><div class="badge text-uppercase bg-dark quicksand">${
								agente.grade
							}</div></div><h4 class="d-flex bankgothic align-content-center">Agent ${
								agente.name
							} <small class="text-white-50 ms-1">#${
								agente.badge
							}</small></h4><small class="agent-radio-label"><i class="fa-solid fa-walkie-talkie"></i> ${
								agente.unit
							}</small></div>`,
							ReferenceColor[agente.ref.color] || '#FFF'
						);
					}
					newSources.push(agente.source);
					$('.police .tab .central .agentes-servicio tbody').append(`
                <tr>
                    <td>
                        <span class="badge w-100 text-center" style="background-color: ${agente.deptColor};filter:hue-rotate(-${currentHueDeg}deg)">${
						agente.dept
					}</span>
                    </td>
                    <td>
                        ${agente.grade}
                    </td>
                    <td>
                        ${agente.name} (${agente.badge})
                    </td>
                    ${
						!agente.hideGPS ? 
						(agente.ready
							? `<td class="text-success">${Translations.Available}</td>`
							: `<td class="text-danger">${Translations.NotAvailable}</td>`) :
								`<td class="text-danger">${Translations.NoSignal}</td>`
					}
                    <td class="text-center">
                        <button class="btn btn-action btn-small" ${agente.unit == '' ? `style="opacity:0.5;" disabled="true"`: ""} onclick="mapFunctions.setBlipFocus(${
							agente.source
						})"><i class="fa-solid fa-location-crosshairs"></i></button>
                    </td>
                </tr>
                `);
					if(agente.hideGPS) {
						mapFunctions.destroyBlip(agente.source);
					}
				}
			});
			mapFunctions.checkPoliceSources(newSources);
		}
	},
	updatePoliceCarsMap: (data) => {
		if (data) {
			Object.entries(data).map(([key, vehicle]) => {
				CreateBlip(
					mapCentral,
					'car-' + key,
					{ x: vehicle.coords.x, y: vehicle.coords.y },
					'./img/icons/cnYSq0w.png',
					`<div>${vehicle.model}</div><div>${vehicle.plate}</div>`
				);
			});
		}
	},

	addAlert(event) {
		centralFunctions.alerts.push(event.data.alert);
		const index = centralFunctions.alerts.length - 1;

		addBlipAtCoords(
			checkNumber(event.data.alert.code),
			event.data.alert.coords.y,
			event.data.alert.coords.x,
			event.data.alert.title,
			event.data.alert.street,
			secondsOrMinutes(event.data.alert.time),
			index
		);

		if ($('.police .tab .central .tabla-dispatch tbody .no-alerts').length > 0) {
			$('.police .tab .central .tabla-dispatch tbody').html('');
		}
		$('.police .tab .central .tabla-dispatch tbody').append(`
            <tr index="${index}" class="new-alert" id="alert-${event.data.alert.code}">
                <td>#${checkNumber(event.data.alert.code)}</td>
                <td>${event.data.alert.title}</td>
                <td>${event.data.alert.street}</td>
                <td class="timing">${secondsOrMinutes(event.data.alert.time)}</td>
                <td class="units"></td>
            </tr>
        `);
	},
	intervalAlerts: () => {
		if(alertTiming) return;
		alertTiming = true;
		intervalAlert = setInterval(() => {
			centralFunctions.alerts.map((alert, i) => {
				alert.time += 1;
				$(
					".police .tab .central .tabla-dispatch tbody tr[index='" +
						i +
						"'] .timing"
				).text(secondsOrMinutes(alert.time));
			});
		}, 1000);
	},
	setAlertShowing: (alert, index) => {
		$('.police .tab .central .actions-title').fadeIn(300);
		$('.police .tab .central .alerts-container .id-alert').text(
			checkNumber(alert.code)
		);
		$('.police .tab .central .unidades-dispo').attr('index', index);
		$('.police .tab .central .alerts-container .title-alert').text(alert.title);
		$('.police .tab .central .alerts-container .street-alert').text(alert.street);
		$('.police .tab .central .alerts-container .time-alert').text(
			'Hace ' + secondsOrMinutes(alert.time)
		);
		$('.police .tab .central .tabla-dispatch tbody tr.selected').removeClass(
			'selected'
		);
		$(
			".police .tab .central .tabla-dispatch tbody tr[index='" + index + "']"
		).addClass('selected');
		$('.police .tab .central .alerts-container .input-note-alert')
			.val(alert.annotation || '')
			.attr('disabled', false);

		let metadataHtml = '';
		const metadata = alert.metadata;
		if (metadata) {
			Object.keys(metadata).map((key) => {
				let icon = '';
				let text = '';
				switch (key) {
					case 'name':
						icon = 'user';
						text = `<b style='margin-right:.5vh;'>${Translations.AgentAlert}: </b> ` + metadata[key];							
						break;
					case 'model':
						icon = 'car';
						text = `<b style='margin-right:.5vh;'>${Translations.VehicleAlert}: </b> ` + metadata[key];
						break;
					case 'plate':
						icon = 'keyboard';
						text = `<b style='margin-right:.5vh;'>${Translations.PlateAlert}: </b> ` + metadata[key];
						break;
					case 'speed':
						icon = 'tachometer-alt';
						text = `<b style='margin-right:.5vh;'>${Translations.SpeedAlert}: </b> ` + metadata[key];
						break;
					case 'weapon':
						icon = 'gun';
						text = `<b style='margin-right:.5vh;'>${Translations.WeaponAlert}: </b> ` + metadata[key];
						break;
					case 'ammotype':
						icon = 'record-vinyl';
						text = metadata[key];
						break;
					case 'color':
						icon = 'tint';
						text =
							"<b style='text-transform: uppercase'>" + Translations.Color + ":</b> <div class='color-car' style='background-color:rgb(" +
							metadata[key] +
							'); box-shadow: 0 0 10px rgb(' +
							metadata[key] +
							")'></div>";
						break;
				}
				metadataHtml += `<div class="alert-metadata-item"><i class="fas fa-${icon}"></i> ${text}</div>`;
			});
		}
		$('.police .tab .central .alerts-container .message-alert').html(`
            ${alert.message ? alert.message : ''}
            <div class="alert-data">
                ${metadataHtml}
            </div>
        `);
	},

	deleteAlert: (code) => {
		centralFunctions.alerts = centralFunctions.alerts.filter(
			(alert) => alert.code != code
		);
		$('.police .tab .central .tabla-dispatch tbody tr.selected').remove();
		mapFunctions.destroyAlertBlip(code);
		$('.police .tab .central .alerts-container .id-alert').text('-');
		$('.police .tab .central .alerts-container .title-alert').text('-');
		$('.police .tab .central .alerts-container .street-alert').text('-');
		$('.police .tab .central .alerts-container .time-alert').text('-');
		$('.police .tab .central .alerts-container .message-alert').text('-');
		$('.police .tab .central .actions-title').fadeOut(300);
		$('.police .tab .central .alerts-container .input-note-alert')
			.val('')
			.attr('disabled', true);

		$('.police .tab .central .tabla-dispatch tbody tr').each((i, tr) => {
			$(tr).attr('index', i);
		});
	},
	saveAlertNoteAlert: (code, annotation) => {
		TriggerCallback('EditAlert:police', { code, annotation });
	},

	updateShapes: () => {
		TriggerCallback('origen_police:callback:GetShapes', {}).done((shapes) => {
			editableLayers.clearLayers();
			if (typeof shapes === 'object' && Object.keys(shapes).length > 0) {
				$(policeTabSelected + ' .shape-list').html('');
				Object.entries(shapes).forEach(([key, shape]) => {
					var layer = GetDataShapes(shape);
					if (layer) {
						editableLayers.addLayer(layer);
						if (shape.title) layer.bindPopup(shape.title);
					}
					const title = shape.title;
					const type = shape.type;
					const radius = shape.radius.toFixed(3);
					const pos = getCenter(shape);
					const zoom = calculateZoom(shape.radius)
					$(policeTabSelected + ' .shape-list')
						.append(
							`
						<div class="shape-block d-flex align-items-center">
							<div class="shape-info w-100">
								<div class="w-100 shape-title">${title}</div>
								<div class="w-100 shape-data d-flex align-items-center">
									<div>
										<i class="fa-solid fa-shapes"></i>
										<span class="shape-type">${type}</span>
									</div>
									${shape.radius > 0 && (
										`
										<div class="ms-3">
											<i class="fa-regular fa-circle-dot"></i>
											<span>${radius} m</span>
										</div>
										`
									) || ''}

								</div>
							</div>
							<div class="shape-button s_view d-flex align-items-center justify-content-center" 
								onclick="zoomShape(${pos}, ${zoom})"
							>
								<i class="fa-solid fa-eye"></i>
							</div>
							<div class="shape-button bg-danger bg-gradient d-flex align-items-center justify-content-center"
								onclick="centralFunctions.deleteShape(${shape.id})"
							>
								<i class="fa-solid fa-trash"></i>
							</div>
						</div>
					`
						)
						.fadeIn(300);
				});
				$(policeTabSelected + ' .shape-list').fadeIn(300);
			} else {
				$(policeTabSelected + ' .shape-list')
					.html(
						`
						<div class="operation-item m-titles text-muted text-center mb-3">
							<div class="no-operations" translate="NoShapes">
								${Translations.NoShapes}
							</div>
						</div>
					`
					).fadeIn(300);
			}
		});
	},

	createShape: (title) => {
		if (title.length > 4) {
			editableLayers.addLayer(currentLayer);
			var shape = saveShapes(editableLayers, title);
			TriggerCallback('origen_police:callback:UpdateShapes', {
				action: 'create',
				shape
			}).done((cb) => {
				if (!cb) return 
				CloseModal();
				centralFunctions.updateShapes();
			});
		} else {
			sendNotification('error', Translations.TitleTooShort);
		}
	},	

	deleteShape: (id) => {
		if(HasPermissionMenu("DeleteShape")) {
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
		OpenModal(
			Translations.DeleteShape,
			Translations.ConfirmDeleteShape,
			`<button class="btn-modal" onclick="centralFunctions.deleteShapeConfirm(${id})">${Translations.Remove}</button>`,
			Translations.Cancel
		);
	},

	deleteShapeConfirm: (id) => {
		const shapeID = id
		TriggerCallback('origen_police:callback:UpdateShapes', {
			action: 'delete',
			id: shapeID,
		}).done((cb) => {
			if (cb) {
				CloseModal();
				centralFunctions.updateShapes();
			}
		});
	},
};