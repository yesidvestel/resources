policeFunctions = {
	policeNavigation: function (name, to) {
		return new Promise(function (resolve, reject) {
			if (onDuty) {
				const activeTab = $('.tabs-bar .tab.active').attr('data-tab');
				policeTabSelected = '#tab-' + activeTab;
				$('#tab-' + activeTab + '>.scale-in')
					.removeClass('scale-in')
					.addClass('scale-out')
					.fadeOut(300, function () {
						$('#tab-' + activeTab).html(to);
						resolve();
					});
				$(".tabs-list .tab[data-tab='" + activeTab + "'] .tab-name").text(
					name,
					to
				);
			} else {
				policeFunctions.dutyAlert();
				resolve();
			}
		});
	},

	loadPoliceEvents: function () {
		citizenSelectorFunctions.loadSelectorFunctions();
		informesFunctions.loadInformesFunctions();
		vehiclesSectionFunctions.loadVehiclesFunctions();
		multasFunctions.loadMultasFunctions();
		codigoPenalFunctions.loadCodigoPenalFunctions();
		vehicleSelectorFunctions.loadSelectorFunctions();
		agentesFunctions.loadAgentesEvents();

		radioFunctions.loadRadioEventsMenu();
		centralFunctions.loadCentralEvents();

		camerasFunctions.cameraEvents();

		$(document).on('click', '.police .btn-federal', function () {
			if (HasPermissionMenu("FederalManagement")) {
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
			TriggerCallback('origen_police:server:GetFederalList', {}).done((cb) => {
				if (cb) {
					let rows = '';
					const data = Object.entries(cb);
					if (data.length > 0) {
						data.map(function (citizen) {
							const fecha = timeStampToDate(citizen[1].date);
							rows += `
                            <div class="col-4 mb-3">
                                <div class="citizen-box">
                                    <div class="citizen-image" style="background-image:url(${citizen[1].image || defaultImage
								});filter:hue-rotate(-${currentHueDeg}deg);"></div>
                                    <div class="p-2 text-center">
                                        <div class="citizen-name">${citizen[1].name}</div>
                                        <div class="d-flex flex-wrap">
                                            <div class="citizen-id"><i class="lni lni-postcard"></i> ${citizen[0]
								}</div>
                                            ${citizen[1].initial ? `<div class="meses"><i class="lni lni-timer"></i> ${citizen[1].initial
									} ${Translations.Month}</div>` : ''}
                                            <div class="meses-r"><i class="lni lni-timer"></i> ${citizen[1].time
								} ${Translations.RemainMonth}</div>
                                            <div class="fecha"><i class="lni lni-calendar"></i> ${fecha.date + ' - ' + fecha.time
								}</div>
                                            <div class="dangerous"><i class="lni lni-warning"></i> ${citizen[1].danger
								}</div>
                                            <div class="joined"><i class="lni lni-map-marker"></i> ${citizen[1].joinedfrom
								}</div>
                                            <div class="meses"><i class="fa-solid fa-bed"></i> ${citizen[1].online
									? Translations.ServingSentance
									: Translations.Sleeping
								}</div>
                                            <button class="btn-modal btn-sm w-100 p-0 mt-2" onclick="policeFunctions.liberarPreso('${citizen[0]
								}')">${Translations.Release}</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            `;
						});
					} else {
						rows = `<div class="col-12"><h5>${Translations.NoFederals}</h5></div>`;
					}
					OpenModal(
						`${Translations.FederalManagement}`,
						`
                        <div class="info-box p-3 border border-dark m-2 mt-0">
                            <h5>${Translations.AddConden}</h5>
                            <div class="row mt-2">
                                <div class="col-3">
                                    <input type="number" class="form-control w-100 input-id-condena h-100" placeholder="${Translations.CitizenID}">
                                </div>
                                <div class="col-3">
                                    <input type="number" class="form-control w-100 input-meses-condena h-100" placeholder="${Translations.Sentence} (${Translations.Month})">
                                </div>
                                <div class="col-3">
                                    <input type="text" class="form-control w-100 input-p-condena h-100" placeholder="${Translations.DangerousOrNot}">
                                </div>
                                <div class="col-3">
                                    <button class="btn-modal btn-nueva-condena w-100 p-0" onclick="policeFunctions.addCondena($(this).parent())">${Translations.Add}</button>
                                </div>
                            </div>
                        </div>
                       <div class="scroll-citizen-modal">
                            <div class="row">
                                ${rows}
                            </div>
                        </div>
                    `,
						`<div></div>`,
						Translations.Close,
						80
					);
				}
			});
		});

		$(document).on('click', '.tabs-list .tab .tab-name', function () {
			if (!$(this).parent().hasClass('active')) {
				if (onDuty) {
					policeFunctions.openTab(this, false);
				} else {
					policeFunctions.dutyAlert();
				}
			}
		});
		$(document).on('click', '.police .tabs-bar .tab.add', function () {
			policeFunctions.createTab(Translations.Home);
		});
		$(document).on('click', '.btn-police-citizen', function () {
			if (HasPermissionMenu("SearchCitizen")) {
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
			policeFunctions.policeNavigation(Translations.Citizens, $('.police-citizen').html());
		});

		$(document).on('click', '.btn-agentes', function () {
			if (HasPermissionMenu("AgentManagement")) {
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
			fetch('LoadPolicePage', { page: 'agents' }).done((cb) => {
				if (cb) {
					policeFunctions.policeNavigation(
						Translations.Polices,
						$('.police-manage').html()
					);
					setTimeout(() => {
						agentesFunctions.loadAgentes();
					}, 500);
				} else {
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
				}
			});
		});

		$(document).on('click', '.btn-camaras', function () {
			if (HasPermissionMenu("SecurityCamera")) {
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
			policeFunctions
				.policeNavigation(Translations.Cameras, $('.police-cameras').html())
				.then(() => {
					camerasFunctions.loadCameras();
				});
		});

		$(document).on('click', '.tab-close', function () {
			policeFunctions.closeTab(this);
		});
		$(document).on('click', '.duty-button', function () {
			$.post('https://origen_police/duty', JSON.stringify({}), function (cb) {
				if (cb != undefined) {
					policeFunctions.alternarServicio(cb);
				}
			});
		});

		$(document).on('click', '.police .btn-search-citizen', function () {
			policeFunctions.searchCitizen(this, false);
		});

		$(document).on('keydown', '.police .input-search-citizen', function (event) {
			var keycode = event.keyCode ? event.keyCode : event.which;
			if (keycode == '13') {
				policeFunctions.searchCitizen(this, false);
			}
		});

		$(document).on('click', '.citizen-list .citizen', function () {
			policeFunctions.getCitizen($(this).find('.citizen-id').text().trim());
		});

		$(document).on('click', '.police .new-note', function () {
			if (HasPermissionMenu("CreateNotes")) return sendNotification('error', Translations.NoPermissionPage);
			policeFunctions.newNote();
		});

		$(document).on('click', '.police .new-multa', function () {
			if (HasPermissionMenu("CreateBill")) return sendNotification('error', Translations.NoPermissionPage);
			const cid = $(this)
				.parent()
				.parent()
				.parent()
				.parent()
				.parent()
				.attr('citizen-id');
			const name = $(this)
				.parent()
				.parent()
				.parent()
				.parent()
				.parent()
				.attr('citizen-name');
			codigoPenalFunctions.loadTabla(1);

			multasFunctions.openBill(
				'ciudadano',
				multasFunctions.addMultaCitizen,
				name,
				cid
			);
		});

		$(document).on('click', '.cancel-note-button', function () {
			$(this)
				.parent()
				.parent()
				.removeClass('scale-in')
				.addClass('scale-out')
				.fadeOut(300, function () {
					$(this).remove();
					if (
						$('.police ' + policeTabSelected + ' .notes-list li').length == 0
					) {
						$('.police ' + policeTabSelected + ' .notes-list').append(
							`<li class="list-group-item list-group-item-action no-notes scale-in"><h5>${Translations.NoRegisteredNotes}</h5></li>`
						);
					}
				});
		});

		$(document).on('click', '.police .add-license', function () {
			if (HasPermissionMenu("AddLicenses")) return sendNotification('error', Translations.NoPermissionPage);
			const cid = $(this).closest('[citizen-id]').attr('citizen-id');

			TriggerCallback('origen_police:police:GetLicenses', {}).done((cb) => {
				if (cb) {
					let modalContent = '';
					Object.values(cb).forEach((license) => {
						modalContent += `
						<div class="btn-action license d-flex align-items-center p-2 rounded mt-2"
							onclick="policeFunctions.AddLicense('${cid}', '${license.name}', '${license.type}', '${license.expire}')"
						>
							<div class="license-icon"><i class="fa-solid fa-id-card"></i></div>
							<div class="ms-2">
								<div class="license-title">${license.name}</div>
							</div>
						</div>
						`;
					});
					OpenModal(
						Translations.AddNewLicense,
						`<div class="add-license-list row justify-content-center" style="max-height:40vh;overflow-y:scroll;">
							${modalContent}
						</div>`,
						'<div></div>',
						Translations.Cancel,
						50
					);
				} else {
					sendNotification('error', Translations.ErrorOccurred)
				}
			});
		});

		$(document).on('click', '.police .new-note-button', function () {
			if (HasPermissionMenu("CreateNotes")) return sendNotification('error', Translations.NoPermissionPage);
			const noteTitle = $(this).parent().parent().find('.note-title').val();
			const noteText = $(this).parent().parent().find('.note-text').val();
			const citizenid = $('.police ' + policeTabSelected + ' .citizenid')
				.text()
				.trim();
			const note = $(this);
			let params = { noteTitle, noteText, citizenid };
			if ($(this).attr('type') == 'agente') {
				params = { noteTitle, noteText, citizenid, police: true };
			}

			if (noteTitle.length > 0 && noteText.length > 0) {
				TriggerCallback('origen_police:police:NewPoliceNote', params).done((cb) => {
					if (cb) {
						const date = timeStampToDate(cb.date * 1000);
						note.parent()
							.parent()
							.removeClass('scale-in')
							.addClass('scale-out')
							.fadeOut(300, function () {
								$(this).remove();
								$(
									'.police ' + policeTabSelected + ' .notes-list'
								).prepend(`
                            <li class="list-group-item list-group-item-action scale-in" note-id="${cb.id}">
                                <h5>${noteTitle}</h5>
                                <p>${noteText}</p>
                                <div class="note-info d-flex">
                                    <div class="note-author"><i class="fas fa-user"></i> ${cb.author}</div>
                                    <div class="note-date"><i class="fas fa-calendar-alt"></i> ${date.date}</div>
                                    <div class="note-hour"><i class="fas fa-clock"></i> ${date.time}</div>
                                </div>
                                <div class="pin-button">
                                    <i class="fas fa-thumbtack"></i>
                                </div>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                            </li>
                            `);
							});
					}
				});
			}
		});

		$(document).on('click', '.police .citizen-scroll .pin-button', function () {
			if (HasPermissionMenu("PinNotes")) return sendNotification('error', Translations.NoPermissionPage);
			const noteId = $(this).parent().attr('note-id');
			const note = $(this).parent();
			let type = 'pin';
			if (note.hasClass('pinned')) {
				type = 'unpin';
			}
			TriggerCallback('origen_police:police:UpdatePoliceNote', {
				noteid: noteId,
				type: type
			}).done((cb) => {
				if (cb) {
					if (type == 'pin') {
						note.addClass('scale-out').fadeOut(300, function () {
							let nota = $(this);
							$(this).remove();
							nota.removeClass('scale-out')
								.addClass('scale-in')
								.addClass('pinned')
								.show();
							$(
								'.police ' + policeTabSelected + ' .notes-list-pinned'
							).prepend(nota);
						});
					} else {
						note.addClass('scale-out').fadeOut(300, function () {
							let nota = $(this);
							$(this).remove();
							nota.removeClass('scale-out')
								.removeClass('pinned')
								.addClass('scale-in')
								.show();
							$('.police ' + policeTabSelected + ' .notes-list').prepend(
								nota
							);
						});
					}
				}
			});
		});

		$(document).on('click', '.police .citizen-scroll .delete-button', function () {
			if (HasPermissionMenu("DeleteNotes")) return sendNotification('error', Translations.NoPermissionPage);
			const noteId = $(this).parent().attr('note-id');
			const note = $(this).parent();

			TriggerCallback('origen_police:police:UpdatePoliceNote', {
				noteid: noteId,
				type: 'delete'
			}).done((cb) => {
				if (cb) {
					note.addClass('scale-out').fadeOut(300, function () {
						$(this).remove();
					});
				}
			});
		});

		$(document).on(
			'click',
			'.police .citizen-ficha .busca-captura .btn-check',
			function () {
				if (HasPermissionMenu("SetWanted")) return sendNotification('error', Translations.NoPermissionPage);
				$('.police .citizen-ficha .busca-captura .btn-check').attr(
					'checked',
					false
				);
				$(this).attr('checked', true);
				const citizenid = $(
					'.police ' + policeTabSelected + ' .citizen-ficha .citizenid'
				)
					.text()
					.trim();
				let value = 0;
				if ($(this).hasClass('si')) {
					value = 1;
				}
				TriggerCallback('origen_police:police:UpdateCitizenStatus', {
					citizenid,
					column: 'wanted',
					value
				});
			}
		);

		$(document).on(
			'click',
			'.police .citizen-ficha .dangerous .btn-check',
			function () {
				if (HasPermissionMenu("SetDanger")) return sendNotification('error', Translations.NoPermissionPage);
				$('.police .citizen-ficha .dangerous .btn-check').attr('checked', false);
				$(this).attr('checked', true);
				const citizenid = $(
					'.police ' + policeTabSelected + ' .citizen-ficha .citizenid'
				)
					.text()
					.trim();
				let value = 0;
				if ($(this).hasClass('si')) {
					value = 1;
				}
				TriggerCallback('origen_police:police:UpdateCitizenStatus', {
					citizenid,
					column: 'dangerous',
					value
				});
			}
		);

		$(document).on('click', '.citizen-photo', function () {
			OpenModal(
				Translations.HowUploadImage,
				`
                <div class="d-flex justify-content-around content-tipo-imagen">
                    <button class="btn-modal" onclick="policeFunctions.cargarFoto(1)"><img src="./img/camera.png"></br>${Translations.Photo}</button>
                    <button class="btn-modal" onclick="policeFunctions.cargarFoto(0)"><img src="./img/link.png"></br>${Translations.AddURL}</button>
                </div>
            `,
				`<div></div>`,
				Translations.Cancel,
			);
		});
		$(document).on(
			'click',
			'.police .citizen-ficha .citizen-informes .informe, .police .agent-ficha .informe',
			function () {
				policeFunctions.createTab(Translations.Reports, '.police-reports');
				const that = $(this);
				setTimeout(() => {
					if (informesFunctions.loadReports()) {
						informesFunctions.loadInforme(that.find('.report-id').text());
					}
				}, 500);
			}
		);
		$(document).on(
			'click',
			'.police .citizen-ficha .multas-list .delete-button',
			function () {
				if (HasPermissionMenu("DeleteBill")) return sendNotification('error', Translations.NoPermissionPage);
				const billid = $(this).parent().attr('bill-id');

				TriggerCallback('origen_police:police:DeleteBill', {
					billid
				}).done((cb) => {
					if (cb) {
						$(this)
							.parent()
							.addClass('scale-out')
							.fadeOut(300, function () {
								$(this).remove();
							});
					} else {
						sendNotification(
							'error',
							'Only a high position can eliminate a fine'
						);
					}
				});
			}
		);
		$(document).on(
			'click',
			'.police .citizen-ficha .licenses-list .delete-button',
			function () {
				if (HasPermissionMenu("DeleteLicenses")) return sendNotification('error', Translations.NoPermissionPage);
				const citizenid = $(
					'.police ' + policeTabSelected + ' .citizen-ficha .citizenid'
				)
					.text()
					.trim();
				$(this)
					.parent()
					.addClass('scale-out')
					.fadeOut(300, function () {
						$(this).remove();
						let licenses = [];
						let data;
						$('.police .citizen-ficha .licenses-list li').each(function (
							element
						) {
							data = {
								name: $(this).attr('lictype'),
								expire: $(this).attr('expire')
							};
							licenses.push(data);
						});
						TriggerCallback('origen_police:police:RemoveLicense', {
							citizenid: citizenid,
							type: $(this).attr('lictype')
						});
					});
			}
		);

		$(document).on('click', '.police .btn-byc', function () {
			if (HasPermissionMenu("SearchCapture")) {
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
			TriggerCallback('origen_police:police:GetBusqueda', {}).done((cb) => {
				if (cb) {
					let rows = '';

					if (cb.length > 0) {
						cb.map(function (citizen) {
							rows += `
                            <div class="col-4 mb-3">
                                <div class="citizen-box">
                                    <div class="citizen-image" style="background-image:url(${citizen.image || defaultImage
								});filter:hue-rotate(-${currentHueDeg}deg);"></div>
                                    <div class="p-2 text-center">
                                        <div class="citizen-name">${citizen.name}</div>
                                        <div class="d-flex flex-wrap">
                                            <div class="citizen-id text-center"><i class="lni lni-postcard"></i> ${citizen.citizenid
								}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            `;
						});
					} else {
						rows = `<div class="col-12"><h5>${Translations.NoSubjectsInSearch}</h5></div>`;
					}
					OpenModal(
						Translations.SubjectsInSearch,
						`<div class="scroll-citizen-modal">
                        <div class="row">
                            ${rows}
                        </div>
                    </div>
                `,
						`<div></div>`,
						Translations.Close,
						80
					);
				}
			});
		});

		$(document).on('click', '.police .btn-deudores', function () {
			if (HasPermissionMenu("SearchDebtors")) {
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
			TriggerCallback('origen_police:police:GetMorosos', {}).done((cb) => {
				if (cb) {
					let rows = '';

					if (cb.length > 0) {
						cb.sort((a, b) => a.name.localeCompare(b.name));

						cb.map(function (citizen) {
							rows += `
                            <div class="col-4 mb-3">
                                <div class="citizen-box">
                                    <div class="citizen-image" style="background-image:url(${citizen.image || defaultImage
								});filter:hue-rotate(-${currentHueDeg}deg);"></div>
                                    <div class="p-2 text-center">
                                        <div class="citizen-name">${citizen.name}</div>
                                        <div class="d-flex flex-wrap">
                                            <div class="citizen-id text-center"><i class="lni lni-postcard"></i> ${citizen.citizenid
								}</div>
                                            <div class="citizen-id text-center text-danger fw-bold">${citizen.price
								} $</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            `;
						});
					} else {
						rows = `<div class="col-12"><h5>${Translations.NoDebtors}</h5></div>`;
					}
					OpenModal(
						`${Translations.DebtSubjects}`,
						`<input
						class='form-control w-100 mb-2 buscar-deudor'
						placeholder='${Translations.FindSubject}'></input>
						<div class="scroll-citizen-modal">

							<div class="row">
								${rows}
							</div>
						</div>
                `,
						`<div></div>`,
						Translations.Close,
						80
					);
				}
			});
		});

		$(document).on('click', '.operations-button', function () {
			if (HasPermissionMenu("Operations")) {
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
				if ($(this).text() == Translations.Operations) {
					valid = $(this);
				}
			});
			if (!valid) {
				policeFunctions.policeNavigation(Translations.Operations, $('.police-operations').html())
					.then(() => {
						loadShapesMap();
					});
			} else {
				policeFunctions.openTab($(valid), false);
			}
		});

		$(document).on('click', '.settings-button', function () {
			let valid;
			$('.tab-name').each(function (yo) {
				if ($(this).text() == Translations.Settings) {
					valid = $(this);
				}
			});
			if (!valid) {
				policeFunctions.policeNavigation(Translations.Settings, $('.police-settings').html())
					.then(() => {
						settingsFunctions.loadListeners();
					});
			} else {
				policeFunctions.openTab($(valid), false);
			}
		});

		$(document).on('click', '.settings-button', function () {
			if (HasPermissionMenu("Operations")) {
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
				if ($(this).text() == Translations.Settings) {
					valid = $(this);
				}
			});
			if (!valid) {
				policeFunctions.policeNavigation(Translations.Settings, $('.police-settings').html())
					.then(() => {
						// loadShapesMap();
					});
			} else {
				policeFunctions.openTab($(valid), false);
			}
		});
	},

	openTab: function (tab, create, tabClass) {
		if (create) {
			tabN = tab;
			policeFunctions.loadHomeFunctions();
			tabHome = true;
		} else {
			tabN = $(tab).parent().attr('data-tab');
			policeTabSelected = '#tab-' + tabN;
			tabHome = false;
		}

		if ($('.tab-content-menu #tab-' + tabN).length > 0) {
			$('.tab-content-menu .tab').removeClass('show');
			$('.tab-content-menu #tab-' + tabN).addClass('show');
			$('.tabs-list .tab').removeClass('active');
			$(tab).parent().addClass('active');
		} else {
			$('.tab-content-menu .tab').removeClass('show');
			const tabContent = $(tabClass).html();
			$('.tab-content-menu').append(`
                <div class="tab show" id="tab-${tabN}">
                    ${tabContent}
                </div>
            `);
			$('.tabs-list .tab').removeClass('active');
			$('.tabs-list .tab[data-tab=' + tabN + ']').addClass('active');
		}
		const activeTab = $('.tabs-bar .tab.active').attr('data-tab');
		policeTabSelected = '#tab-' + activeTab;
	},

	createTab: function (title, tabContent) {
		const tabNumber =
			parseInt($('.tabs-list .tab:last-child').attr('data-tab')) + 1 || 1;

		const numberOfTabs = $('.tabs-list .tab').length;

		if (numberOfTabs + 1 <= 12) {
			$('.tabs-list').append(`
                <div class="tab new-tab" data-tab="${tabNumber}">
                    <div class="tab-name">${title}</div><div class="tab-close"><i class="fas fa-times"></i></div>
                </div>
            `);
			setTimeout(() => {
				$('.tabs-list .tab.new-tab').removeClass('new-tab');
			}, 500);
			policeFunctions.openTab(
				tabNumber,
				true,
				tabContent ? tabContent : '.police-home'
			);
		}
	},

	closeTab: function (tab) {
		const tabN = $(tab).parent().attr('data-tab');
		if ($('.tabs-list .tab').length > 1) {
			if ($('.tabs-list .tab[data-tab=' + tabN + ']').hasClass('active')) {
				$('.tabs-list .tab[data-tab=' + tabN + ']')
					.addClass('animate__animated animate__fadeOutDown animate__faster')
					.fadeOut(300, function () {
						$(this).remove();
						$('.tabs-list .tab:last-child').addClass('active');
					});
				$('.tab-content-menu #tab-' + tabN).fadeOut(150, function () {
					$(this).remove();
					$('.tab-content-menu .tab:last-child').addClass('show');
				});
			} else {
				$('.tabs-list .tab[data-tab=' + tabN + ']')
					.addClass('animate__animated animate__fadeOutDown animate__faster')
					.fadeOut(300, function () {
						$(this).remove();
					});
				$('.tab-content-menu #tab-' + tabN).remove();
			}
		}
		if (
			$('.tabs-list .tab[data-tab=' + tabN + ']')
				.find('.tab-name')
				.text() == 'Radio'
		) {
			$('.tabs-list .tab[data-tab=' + tabN + ']').fadeOut(0, function () {
				$(this).remove();
			});
			$('.tab-content-menu #tab-' + tabN).fadeOut(0, function () {
				$(this).remove();

				policeFunctions.createTab(Translations.Home);
			});
		} else if (
			$('.tabs-list .tab[data-tab=' + tabN + ']')
				.find('.tab-name')
				.text() == Translations.Dispatch
		) {
			destruirMapaCentral();

			TriggerCallback('origen_police:server:CloseCentral', {});
			$('.tabs-list .tab[data-tab=' + tabN + ']').fadeOut(0, function () {
				$(this).remove();
			});
			$('.tab-content-menu #tab-' + tabN).fadeOut(0, function () {
				$(this).remove();

				policeFunctions.createTab(Translations.Home);
			});
		} else if (
			$('.tabs-list .tab[data-tab=' + tabN + ']')
				.find('.tab-name')
				.text() == Translations.Settings
		) {
			settingsLoaded = false;
		} else if (
			$('.tabs-list .tab[data-tab=' + tabN + ']')
				.find('.tab-name')
				.text() == Translations.Citizens
		) {
			destruirMapaAnkle();
		} else if (
			$('.tabs-list .tab[data-tab=' + tabN + ']')
				.find('.tab-name')
				.text() == Translations.Operations
		) {
			removeShapesMap();
			$('.tabs-list .tab[data-tab=' + tabN + ']').fadeOut(0, function () {
				$(this).remove();
			});
			$('.tab-content-menu #tab-' + tabN).fadeOut(0, function () {
				$(this).remove();

				policeFunctions.createTab(Translations.Home);
			});
		}
	},

	alternarServicio: function (cb) {
		onDuty = cb;
		const dutyText = cb ? Translations.InDuty : Translations.OutDuty;
		$('.service-tag').text(dutyText).toggleClass('on-service', cb);
		fetch('LoadPolicePage', { page: "home" }).done((cb) => {
			policeFunctions.setOnService(cb.cops);
		});
	},

	dutyAlert: function () {
		$('.police .tab-content-menu').addClass('blur');
		$('.police .duty-alert').fadeIn(300, function () {
			setTimeout(() => {
				$('.police .duty-alert').fadeOut(300);
				$('.police .tab-content-menu').removeClass('blur');
			}, 3000);
		});
	},

	getHueDeg: function (category) {
		for (let i = 0; i < jobCategories[category].length; i++) {
			if (jobCategories[category][i].name === jobData.name) {
				return jobCategories[category][i].colorHueDeg;
			}
		}
		return 0;
	},

	getCategory: function () {
		const category = Object.keys(jobCategories).find(key => {
			return jobCategories[key].some(element => element.name === jobData.name);
		});
		return category;
	},

	setOnService: function (cops) {
		let policeLabel;
		let category = policeFunctions.getCategory();

		if (cops === 0 || cops === undefined) {
			policeLabel = (category === "police" ? Translations.NoPoliceDuty : Translations.NoAmbulanceDuty);
		} else if (cops === 1) {
			policeLabel = cops + ' ' + (category === "police" ? Translations.PoliceOnDuty : Translations.AmbulanceOnDuty);
		} else {
			policeLabel = cops + ' ' + (category === "police" ? Translations.PoliceSOnDuty : Translations.AmbulancesOnDuty);
		}

		$('.police .number-polices').html(policeLabel);
	},

	//APP HOME
	loadHomeFunctions: function () {
		fetch('LoadPolicePage', { page: "home" }).done((cb) => {
			policeFunctions.alternarServicio(cb.service);
			policeFunctions.setOnService(cb.cops);
		});
	},
	searchCitizen: function (element, selector) {
		const text = !selector
			? $(element).parent().parent().find('.input-search-citizen').val()
			: $('.input-search-citizen-selector').val();
		if (text.length > 2 && text != '') {
			if (!selector) {
				$(policeTabSelected + ' .citizen-list').fadeOut(300, function () {
					TriggerCallback('origen_police:police:SearchCitizen', {
						text
					}).done((cb) => {
						if (cb != undefined && cb.length > 0) {
							$(policeTabSelected + ' .citizen-list').html('');
							cb.map(function (citizen) {
								const citizenName =
									citizen.firstname + ' ' + citizen.lastname;
								const citizenId = citizen.citizenid;
								const citizenImage = citizen.image || defaultImage;
								const citizenPhone = citizen.phone || 'Unknown';
								$(policeTabSelected + ' .citizen-list')
									.append(
										`
                                    <div class="white-block citizen">
                                        <div class="citizen-image image-${citizenId}" style="background-image:url('${citizenImage}');filter:hue-rotate(-${currentHueDeg}deg);"></div>
                                        <div class="citizen-info w-100">
                                            <div class="citizen-name w-100">${citizenName}</div>
                                            <div class="d-flex text-uppercase citizen-fast-data">
												<div class="w-50" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><i class="fa-solid fa-id-card"></i> <span class="citizen-id" style="max-width: 6em; display: inline-block;">${citizenId}</span></div>
                                                <div class="w-50" style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><i class="fa-solid fa-phone"></i> <span class="citizen-phone">${citizenPhone}</span></div>
                                            </div>
                                        </div>
                                    </div>
                                `
									)
									.fadeIn(300);
								
								setTimeout(() => {
									try {
										var imageElement = $(policeTabSelected + ' .citizen-list ' + `.image-${citizenId}`);
										var style = imageElement.css('background-image');
										const regex = /"([^"]*)"/g;
										let resultado;
										const resultados = [];

										while ((resultado = regex.exec(style)) !== null) {
											resultados.push(resultado[1]);
										}
										var url = resultados[0];

										var img = new Image();
										img.src = url;
										img.onerror = function () {
											imageElement.css('background-image', 'url(' + defaultImage + ')');
										}
									}
									catch (e) {}
								}, 200);
							});
							$(policeTabSelected + ' .citizen-list').fadeIn(300);
						} else {
							$(policeTabSelected + ' .citizen-list')
								.html(
									`
                                    <div class="citizen-item m-titles text-muted">
                                        <div class="citizen-name">${Translations.NoResult}</div>
                                    </div>
                                `
								)
								.fadeIn(300);
						}
					});
				});
			} else {
				let params = { text };
				if ($('.btn-search-citizen-selector').attr('data-type') != 'persona') {
					params = {
						text,
						job: $('.btn-search-citizen-selector').attr('data-type')
					};
				}
				$('.police .citizen-box-list .row').fadeOut(300, function () {
					TriggerCallback('origen_police:police:SearchCitizen', params).done(
						(cb) => {
							if (cb != undefined && cb.length > 0) {
								$('.police .citizen-box-list .row').html('');
								cb.map(function (citizen) {
									const citizenName =
										citizen.firstname + ' ' + citizen.lastname;
									const citizenId = citizen.citizenid;
									const citizenImage = citizen.image || defaultImage;
									$('.police .citizen-box-list .row').append(`
                                    <div class="col-4 h-100 mb-3">
                                        <div class="citizen-box">
                                            <div class="citizen-image image-${citizenId}" style="background-image:url(${citizenImage});filter:hue-rotate(-${currentHueDeg}deg);"></div>
                                            <div class="p-2 text-center">
                                                <div class="citizen-name">${citizenName}</div>
                                                <div class="citizen-id">${citizenId}</div>
                                            </div>
                                        </div>
                                    </div>
                                `);
								});
								$('.police .citizen-box-list .row').fadeIn(300);
							} else {
								$('.police .citizen-box-list .row')
									.html(
										`
                                    <div class="col-12 text-muted">
                                        <h4 class="citizen-name">${Translations.NoResultFound}</h4>
                                    </div>
                                `
									)
									.fadeIn(300);
							}
						}
					);
				});
			}
		}
	},

	getCitizen: function (citizenid) {
		TriggerCallback('origen_police:police:GetCitizen', { citizenid }).done((cb) => {
			if (cb) {
				let citizenBills = '';
				let citizenVehicles = '';
				let citizenNotes = '';
				let citizenNotesPinned = '';
				let citizenLicenses = '';
				let citizenProperties = '';
				let citizenReports = '';
				let citizenWeapons = '';
				let citizenAnkle = {};

				citizenAnkle = cb.ankle || {};

				if (cb.bills.length > 0) {
					cb.bills.map(function (bill) {
						let articulos = '';
						JSON.parse(bill.concepts).map(function (article) {
							articulos += `<li><p>${article}</p></li>`;
						});
						const fecha = timeStampToDate(bill.date);

						citizenBills += `
                        <li class="list-group-item list-group-item-action ${bill.payed ? 'multa-pagada' : ''
							}" bill-id="${bill.id}">
                            <h5>${fecha.date} - ${fecha.time}</h5>
                            <ul>
                                ${articulos}

                            </ul>
                            <div class="note-info d-flex">
                                <div class="multa-author"><i class="fas fa-user"></i> ${bill.author
							}</div>
                                <div class="multa-price"><i class="fas fa-dollar-sign"></i> ${bill.price
							}$</div>
                                <div class="multa-"><i class="fas fa-gavel"></i> ${bill.months
							} ${Translations.Month}</div>
                            </div>
                            <div class="delete-button">
                                <i class="fa-solid fa-trash"></i>
                            </div>
                        </li>
                        `;
					});
				} else {
					citizenBills = `
                    <li class="list-group-item list-group-item-action no-notes">
                        <h5>${Translations.NoRegisteredFines}</h5>
                    </li>`;
				}

				if (cb.notes.length > 0) {
					cb.notes.map(function (note) {
						const date = timeStampToDate(note.date);
						if (note.fixed) {
							citizenNotesPinned += `
                            <li class="list-group-item list-group-item-action pinned" note-id="${note.id}">
                                <h5>${note.title}</h5>
                                <p>${note.description}</p>
                                <div class="note-info d-flex">
                                    <div class="note-author"><i class="fas fa-user"></i> ${note.author}</div>
                                    <div class="note-date"><i class="fas fa-calendar-alt"></i> ${date.date}</div>
                                    <div class="note-hour"><i class="fas fa-clock"></i> ${date.time}</div>
                                </div>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                                <div class="pin-button">
                                    <i class="fas fa-thumbtack"></i>
                                </div>
                            </li>`;
						} else {
							citizenNotes += `
                            <li class="list-group-item list-group-item-action" note-id="${note.id}">
                                <h5>${note.title}</h5>
                                <p>${note.description}</p>
                                <div class="note-info d-flex">
                                    <div class="note-author"><i class="fas fa-user"></i> ${note.author}</div>
                                    <div class="note-date"><i class="fas fa-calendar-alt"></i> ${date.date}</div>
                                    <div class="note-hour"><i class="fas fa-clock"></i> ${date.time}</div>
                                </div>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                                <div class="pin-button">
                                    <i class="fas fa-thumbtack"></i>
                                </div>
                            </li>`;
						}
					});
				} else {
					citizenNotes = `
                    <li class="list-group-item list-group-item-action no-notes">
                        <h5>${Translations.NoRegisteredNotes}</h5>
                    </li>`;
				}

				if (cb.vehicles.length > 0) {
					cb.vehicles.map(function (vehicle) {
						citizenVehicles += `
                        <li class="list-group-item list-group-item-action">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="vehicle-title d-flex align-items-center">
                                    <h5>${vehicle.label}</h5>
                                    <div class="vehicle-plate">
                                        <p>${Translations.LicensePlate} <i class="fas fa-angle-right"></i> ${vehicle.plate
							}</p>
                                    </div>
                                </div>
                                <div class="confiscado">${vehicle.status} ${vehicle.wanted
								? ' <span class="text-danger fw-bold"><i class="fas fa-search"></i> SEARCHING</span>'
								: ''
							} </div>
                            </div>
                        </li>
                        `;
					});
				} else {
					citizenVehicles = `
                    <li class="list-group-item list-group-item-action no-notes">
                        <div class="d-flex justify-content-between align-items-center">
                        <h5>${Translations.NoData}</h5>
                        </div>
                    </li>`;
				}

				if (cb.properties.length > 0) {
					cb.properties.map(function (property) {
						citizenProperties += `
                        <li class="list-group-item list-group-item-action">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5>${property}</h5>
                            </div>
                        </li>
                        `;
					});
				} else {
					citizenProperties = `
                    <li class="list-group-item list-group-item-action no-notes">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5>${Translations.NoData}</h5>
                        </div>
                    </li>`;
				}

				if (cb.weapons.length > 0) {
					cb.weapons.map(function (weapon) {
						citizenWeapons += `
						<li class="list-group-item list-group-item-action">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="vehicle-title d-flex align-items-center">
                                    <div class="vehicle-plate">
                                        <p>${weapon.name} <i class="fas fa-angle-right"></i> ${weapon.serie}</p>
                                    </div>
                                </div>
                                <div class="confiscado">  </div>
                            </div>
                        </li>
						`;
					});
				} else {
					citizenWeapons = `
					<li class="list-group-item list-group-item-action no-notes">
						<div class="d-flex justify-content-between align-items-center">
							<h5>${Translations.NoData}</h5>
						</div>
					</li>`;
				}

				if (isJsonString(cb.licenses.length) && cb.licenses) {
					cb.licenses = JSON.parse(cb.licenses);
					if (cb.licenses.length > 0) {
						cb.licenses.map(function (license) {
							const datetime = timeStampToDate(
								parseInt(license.expire) * 1000
							);

							citizenLicenses += `
                            <li class="list-group-item list-group-item-action" expire="${license.expire
								}" lictype="${license.type}">
                                <span>${license.name}</span> <h5 class="expire">${Translations.Expiration + ': ' + datetime.date + ' - ' + datetime.time
								}</h5>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                            </li>
                            `;
						});
					} else {
						citizenLicenses = `
                        <li class="list-group-item list-group-item-action no-notes">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5>${Translations.NoData}</h5>
                            </div>
                        </li>`;
					}
				} else {
					citizenLicenses = `
                        <li class="list-group-item list-group-item-action no-notes">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5>${Translations.NoData}</h5>
                            </div>
                        </li>`;
				}
				if (cb.reports && cb.reports.length > 0) {
					cb.reports.map(function (report) {
						citizenReports += `
                        <div class="informe">
                            <span class="report-name">${report.title}</span> #<span class="report-id">${report.id}</span>
                        </div>`;
					});
				} else {
					citizenReports = `
                        <ul class="list-group w-100">
                            <li class="list-group-item list-group-item-action no-notes">
                                <h5>${Translations.NoData}</h5>
                            </li>
                        </ul>
                    `;
				}

				let birthdate = cb.birthdate.split('-');

				$(policeTabSelected + ' .citizen-ficha').fadeOut(300, function () {
					$(this).attr('citizen-id', cb.citizenid);
					$(this).attr('citizen-name', cb.firstname + ' ' + cb.lastname);
					$(this)
						.html(
							`
                <div class="row d-flex align-items-center m-titles citizen-info-all mt-0">
                    <div class="col-2 p-0">
                        <div class="citizen-photo" style="background-image:url('${cb.image || defaultImage
							}');filter:hue-rotate(-${currentHueDeg}deg);">
                            <div class="edit-photo"><img src="./img/webp/edit.webp"></div>
                        </div>
                    </div>
                    <div class="col-10 pe-0">
                        <div class="d-flex w-100 flex-data">
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Name}</div>
                                    <div class="info-box-value">${cb.firstname}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Surname}</div>
                                    <div class="info-box-value">${cb.lastname}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Gender}</div>
                                    <div class="info-box-value">${cb.gender}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Nationality}</div>
                                    <div class="info-box-value">${cb.nationality}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Birthdate}</div>
                                    <div class="info-box-value">${birthdate[0]}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Id}</div>
                                    <div class="info-box-value citizenid" style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${cb.citizenid
							}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.PhoneNumber}</div>
                                    <div class="info-box-value">${cb.phone || 'Unknown'
							}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.BankAccount}</div>
                                    <div class="info-box-value">${cb.iban}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Job}</div>
                                    <div class="info-box-value">${cb.job}</div>

                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-12 pe-1 text-center">
                        <div class="info-box m-1">
                            <div class="row">
                                <div class="col-6">
                                    <h4>${Translations.InSearchCapture}</h4>
                                    <div class="busca-captura btn-group mt-2 w-100" citizen-id="${cb.citizenid
							}" role="group" aria-label="Basic radio toggle button group">
                                        <input type="radio" class="btn-check si" name="btn-wanted-${cb.citizenid
							}" id="btn-wanted-${cb.citizenid
							}-1" autocomplete="off" ${cb.wanted == 1 && 'checked'}>
                                        <label class="btn btn-outline-primary" for="btn-wanted-${cb.citizenid
							}-1">${Translations.Yes}</label>

                                        <input type="radio" class="btn-check" name="btn-wanted-${cb.citizenid
							}" id="btn-wanted-${cb.citizenid
							}-2" autocomplete="off" ${cb.wanted == 0 && 'checked'}>
                                        <label class="btn btn-outline-primary no" for="btn-wanted-${cb.citizenid
							}-2">${Translations.No}</label>
                                    </div>
                                </div>
                                <div class="col-6 border-left text-center">
                                    <h4>${Translations.Dangerous}</h4>
                                    <div class="dangerous btn-group mt-2 w-100" citizen-id="${cb.citizenid
							}" role="group" aria-label="Basic radio toggle button group">
                                        <input type="radio" class="btn-check si" name="btn-dangerous-${cb.citizenid
							}" id="btn-dangerous-${cb.citizenid
							}-1" autocomplete="off" ${cb.dangerous == 1 && 'checked'}>
                                        <label class="btn btn-outline-primary" for="btn-dangerous-${cb.citizenid
							}-1">${Translations.Yes}</label>

                                        <input type="radio" class="btn-check" name="btn-dangerous-${cb.citizenid
							}" id="btn-dangerous-${cb.citizenid
							}-2" autocomplete="off" ${cb.dangerous == 0 && 'checked'}>
                                        <label class="btn btn-outline-primary no" for="btn-dangerous-${cb.citizenid
							}-2">${Translations.No}</label>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="col-6 pe-1">
                        <div class="info-box m-1 mt-2">
                            <div class="notes-title d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-quote-right"></i> ${Translations.Notes}</h4>
                                <div class="new-button new-note"><i class="fas fa-plus"></i> ${Translations.NewNote}</div>
                            </div>
                            <div class="citizen-info-container mt-2">
                                <ul class="list-group notes-list-pinned">
                                    ${citizenNotesPinned}
                                </ul>
                                <ul class="list-group notes-list mt-2">
                                    ${citizenNotes}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 ps-1">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-book"></i> ${Translations.Fine}</h4>
                                <div class="new-button new-multa"><i class="fas fa-plus"></i> ${Translations.AddFine}</div>
                            </div>
                            <div class="citizen-info-container mt-2">
                                <ul class="list-group multas-list">
                                   ${citizenBills}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 pe-1">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-sticky-note"></i> ${Translations.Reports}</h4>
                            </div>
                            <div class="citizen-info-container-mini mt-2 d-flex flex-wrap citizen-informes align-content-start">
                                ${citizenReports}
                            </div>
                        </div>
                    </div>
                    <div class="col-6 ps-1">
						<div class="row">
							<div class="col-6 pe-1">
								<div class="info-box m-1 mt-2">
									<div class="d-flex justify-content-between align-items-center">
										<h4><i class="fas fa-id-card"></i> ${Translations.Licenses}</h4>
										<div class="new-button add-license"><i class="fas fa-plus"></i> ${Translations.AddLicense}</div>
									</div>
									<div class="citizen-info-container-mini mt-2">
										<ul class="list-group licenses-list">
										${citizenLicenses}
										</ul>
									</div>
								</div>
							</div>
							<div class="col-6 ps-1">
								<div class="info-box m-1 mt-2">
									<div class="d-flex justify-content-between align-items-center">
										<h4><i class="fas fa-gun"></i> ${Translations.Weapons}</h4>
									</div>
									<div class="citizen-info-container-mini mt-2">
										<ul class="list-group weapons-list">
										${citizenWeapons}
										</ul>
									</div>
								</div>
							</div>
						</div>
                    </div>
                    <div class="col-6 pe-1">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-car"></i> ${Translations.Vehicles}</h4>
                            </div>
                            <div class="citizen-info-container-mini mt-2">
                                <ul class="list-group">
                                    ${citizenVehicles}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 ps-1">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-house"></i> ${Translations.Houses}</h4>
                            </div>
                            <div class="citizen-info-container-mini mt-2">
                                <ul class="list-group">
                                    ${citizenProperties}
                                </ul>
                            </div>
                        </div>
                    </div>
					<div class="col-12" style="display:${Object.entries(citizenAnkle).length != 0 ? "block" : "none"}">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-ring"></i> ANKLES</h4>
                            </div>
                            <div class="citizen-info-container-mini mt-2" style="display: flex;height: 25vh;border-radius: 11px;">
								<div class="col-7" id="anklemap"></div>
								<div class="col-5">
									<div style="margin-left: 2vh;">
										<h4><i class="fas fa-book"></i> ${Translations.AgentsInvolved}</h4>
										<div class="list-group-item list-group-item-action scale-in" style="border-radius: 6px;margin-top: 0.5vh;">
											<div class="d-flex align-items-center">
												<h5 class="persona-name">${citizenAnkle.policeLabel != null ? citizenAnkle.policeLabel : "none"}</h5>
											</div>
										</div>
										<h4 style="margin-top: 2vh;"><i class="fas fa-calendar-days"></i> ${Translations.LogsDate}</h4>
										<div class="d-flex" style="gap: 0.5vh;border-radius: 6px;margin-top: 0.5vh;">
												

									<li class="list-group-item list-group-item-action" expire="1893456000" lictype="driver" style="border-radius: 0.5vh;">
										<span>Registered</span>
										<h5 class="expire">${citizenAnkle.date != null ? new Date(citizenAnkle.date).toISOString().replace('T', ' ').substring(0, 19) : "none"}</h5>
									</li>
									<li class="list-group-item list-group-item-action" expire="1893456000" lictype="driver" style="border-radius: 0.5vh;">
										<span>Last Shock</span> 
										<h5 class="expire">${citizenAnkle.lastShock != null ? (citizenAnkle.lastShock == 0 ? "None" : new Date(citizenAnkle.lastShock).toISOString().replace('T', ' ').substring(0, 19)) : "none"}</h5>
									</li>
								</div>
								<h4 style="margin-top: 2vh;"><i class="fas fa-bars"></i> ${Translations.Action}</h4>
								<div style="gap: 0.5vh;display: flex;">
									<button onclick="ZoomAnkleBlip()" class="btn-action ankle-localize" style="display: flex;width: 100%;text-align: center;align-items: center;gap: .25vw;font-size: 1.4vh;">
										<i class="fas fa-location-dot"></i> <span>${Translations.Localize}</span>
									</button><button onclick="AnkleTase(${citizenAnkle.targetId})" class="btn-action ankle-tase" style="display: flex;width: 100%;text-align: center;align-items: center;gap: .25vw;font-size: 1.4vh;">
										<i class="fas fa-bolt"></i> <span>${Translations.Tase}</span>
									</button>
          						</div>
                            </div>
							</div>
                            </div>
                        </div>
                    </div>
                </div>

                `
						)
						.fadeIn(300);
				});
				setTimeout(() => {
					try {
						var imageElement = $(policeTabSelected + ' .citizen-ficha .citizen-photo');
						var style = imageElement.css('background-image');
						const regex = /"([^"]*)"/g;
						let resultado;
						const resultados = [];

						while ((resultado = regex.exec(style)) !== null) {
							resultados.push(resultado[1]);
						}
						var url = resultados[0];
						var img = new Image();
						img.src = url;
						img.onerror = function () {
							imageElement.css('background-image', 'url(' + defaultImage + ')');
						}
					}
					catch (e) {}
				}, 350);
				if(Object.entries(citizenAnkle).length != 0) 
					setTimeout(() => {
						LoadAnkleMap(citizenAnkle);
					}, 500);
			} else {
				$(policeTabSelected + ' .citizen-ficha').fadeOut(300, function () {
					$(this).html(`<h5>${Translations.NoData}</h5>`).fadeIn(300);
				});
			}
		});
	},

	newNote: (type) => {
		let agentClass = '';
		if (type) {
			agentClass = 'agente';
		}
		const noteHtml = `
            <li class="list-group-item list-group-item-action scale-in">
                <h5><input class="input note-title w-100" placeholder="${Translations.NoteTitle}"></h5>
                <p><textarea rows="4" class="input note-text w-100 mt-1" placeholder="${Translations.TextNote}"></textarea></p>
                <div class="d-flex justify-content-between mt-2">
                    <div class="btn btn-secondary cancel-note-button btn-sm me-2">${Translations.Cancel}</div>
                    <div class="btn btn-secondary new-note-button btn-sm" type="${agentClass}">${Translations.Save}</div>
                </div>
            </li>`;
		if ($('.police ' + policeTabSelected + ' .notes-list .no-notes').length > 0) {
			$('.police ' + policeTabSelected + ' .notes-list .no-notes').fadeOut(
				300,
				function () {
					$(this).remove();
					$('.police ' + policeTabSelected + ' .notes-list').append(noteHtml);
				}
			);
		} else {
			$('.police ' + policeTabSelected + ' .notes-list').prepend(noteHtml);
		}
	},

	cargarFoto: (type) => {
		if (type) {
			CloseModal();
			const citizenid = $(
				'.police ' + policeTabSelected + ' .info-box-value.citizenid'
			)
				.text()
				.trim();
			fetch('TakePicture', { citizenid }).done((cb) => {
				if (cb) {
					$('.police ' + policeTabSelected + ' .citizen-photo').css(
						'background-image',
						"url('" + cb + "')"
					);
					$('.police ' + policeTabSelected + ' .citizen-photo').css(
						'filter',
						`hue-rotate(-${currentHueDeg}deg)`
					);
					$('.police .white-block .citizen-image.image-' + citizenid).css(
						'background-image',
						"url('" + cb + "')"
					);
					$('.police .white-block .citizen-image.image-' + citizenid).css(
						'filter',
						`hue-rotate(-${currentHueDeg}deg)`
					);
					$('.police .white-block .image-' + citizenid).css(
						'background-image',
						"url('" + cb + "')"
					);
				}
			});
			$('.screen').removeClass('show');
			$.post('https://origen_police/close', JSON.stringify({}));
		} else {
			CloseModal();
			OpenModal(
				Translations.EnterURLImage,
				`
                <input class="form-control w-100 url-nueva-foto" placeholder="URL">
            `,
				`<button class="btn-modal" onclick="policeFunctions.guardarFoto($('.url-nueva-foto').val())">${Translations.SaveImage}</button>`,
				Translations.Cancel
			);
		}
	},

	guardarFoto: (value) => {
		CloseModal();
		const citizenid = $('.police ' + policeTabSelected + ' .info-box-value.citizenid')
			.text()
			.trim();

		TriggerCallback('origen_police:police:UpdateCitizenImage', {
			citizenid,
			value
		}).done((cb) => {
			if (cb) {
				$('.police ' + policeTabSelected + ' .citizen-photo').css(
					'background-image',
					"url('" + value + "')"
				);
				$('.police ' + policeTabSelected + ' .citizen-photo').css(
					'filter',
					`hue-rotate(-${currentHueDeg}deg)`
				);
				$('.police .white-block .image-' + citizenid).css(
					'background-image',
					"url('" + value + "')"
				);
			}
		});
	},

	liberarPreso: (cid) => {
		TriggerCallback('origen_police:server:releasefederal', {
			citizenid: cid
		}).done((cb) => {
			if (cb) {
				CloseModal();
			} else {
				sendNotification('error', Translations.ErrorOccurred);
			}
		});
	},

	addCondena: (yo) => {
		if (HasPermissionMenu('AddFederal')) return sendNotification('error', Translations.NoPermissionPage);
		const id = yo.parent().find('.input-id-condena').val().trim();
		const condena = yo.parent().find('.input-meses-condena').val().trim();
		const dangerous = yo.parent().find('.input-p-condena').val().trim();
		if (id.length != 0 && condena > 0 && condena < 10000 && dangerous.length > 0) {
			fetch('ExecuteCommand', {
				command: 'celda ' + id + ' ' + condena + ' ' + dangerous
			}).done((cb) => {
				if (cb) {
					CloseModal();
				}
			});
		} else {
			sendNotification('error', Translations.ErrorOccurred);
		}
	},

	AddLicense: (cid, label, type, expire) => {
		if (HasPermissionMenu("AddLicenses")) return sendNotification('error', Translations.NoPermissionPage);

		TriggerCallback('origen_police:police:AddLicense', {
			citizenid: cid,
			type: type
		}).done((cb) => {
			if (cb) {
				sendNotification('success', Translations.AddedLicense + ' ' + label);
				const datetime = timeStampToDate(
					parseInt(expire) * 1000
				);
				$('.police ' + policeTabSelected + ' ul.licenses-list .no-notes').remove();
				$('.police .citizen-ficha .licenses-list').prepend(`
					<li class="list-group-item list-group-item-action scale-in" expire="${expire}" lictype="${type}">
						<span>${label}</span> 
						<h5 class="expire">${Translations.Expiration + ': ' + datetime.date + ' - ' + datetime.time}</h5>
						<div class="delete-button">
							<i class="fa-solid fa-trash"></i>
						</div>
					</li>
				`);
				CloseModal();
			} else {
				sendNotification('error', Translations.ErrorOccurred);
			}
		});
	},
};

$(document).on('input', '.buscar-deudor', function () {
	const value = $(this).val();
	$('.c-modal .col-4 .citizen-name').each(function () {
		if ($(this).text().indexOf(value) === -1) {
			$(this).parent().parent().parent().fadeOut(300);
		} else {
			$(this).parent().parent().parent().fadeIn(300);
		}
	});
});

function AnkleTase(targetId) {
	fetch('AnckleShock', { id: targetId }).done((cb) => {});
}