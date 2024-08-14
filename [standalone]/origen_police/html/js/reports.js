informesFunctions = {
	loadInformesFunctions: () => {
		$(document).on('click', '.btn-police-reports', function () {
			if(HasPermissionMenu("SearchReports")) {
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
			policeFunctions.policeNavigation(Translations.Reports, $('.police-reports').html());
			setTimeout(() => {
				informesFunctions.loadReports();
			}, 500);
		});

		$(document).on('click', '.police .btn-search-report', function () {
			informesFunctions.searchReport();
		});

		$(document).on('keyup', '.police .input-search-report', function (e) {
			if (e.keyCode == 13) {
				informesFunctions.searchReport();
			}
		});

		$(document).on('change', '.police .select-tags-filter', function () {
			if ($(this).val() != 0) {
				informesFunctions.searchReport($(this).val());
			} else {
				informesFunctions.searchReport();
			}
		});

		$(document).on('click', '.police .report-list .report', function () {
			const reportid = $(this).find('.report-name span').text().replace('#', '');

			informesFunctions.loadInforme(reportid);
		});
		$(document).on('click', '.police .informes .add-informe', function () {
			if(HasPermissionMenu("CreateReport")) return sendNotification('error', Translations.NoPermissionPage);
			informesFunctions.crearInforme();
		});
		$(document).on('click', '.police .informes .add-persona', function () {
			if(HasPermissionMenu("AddPeopleToReport")) return sendNotification('error', Translations.NoPermissionPage);
			citizenSelectorFunctions.showAddPersona(informesFunctions.addPersonaInforme);
		});
		$(document).on('click', '.police .informes .multa-button', function () {
			if(HasPermissionMenu("AddBillReport")) return sendNotification('error', Translations.NoPermissionPage);
			const name = $(this).parent().find('.persona-name').text().trim();
			const cid = $(this).parent().data('id');
			codigoPenalFunctions.loadTabla(1);
			multasFunctions.openBill(
				'informe',
				informesFunctions.addMultaInforme,
				name,
				cid
			);
		});
		$(document).on(
			'click',
			'.police .informes .multas-list .delete-button',
			function () {
				if(HasPermissionMenu("RemovePeopleFromReport")) return sendNotification('error', Translations.NoPermissionPage);
				$(this)
					.parent()
					.removeClass('scale-in')
					.addClass('scale-out')
					.fadeOut(300, function () {
						$(this).remove();
						informesFunctions.updatePersonasInvolucradas();

						if (
							$(
								'.police ' +
									policeTabSelected +
									' .informes .multas-list li'
							).length == 0
						) {
							$('.police ' + policeTabSelected + ' .informes .multas-list')
								.html(`
                    <li class="list-group-item list-group-item-action no-notes scale-in">
                        <h5>There are no people involved</h5>
                    </li>`);
						}
					});
			}
		);

		$(document).on(
			'click',
			'.police .informes .agentes-list .delete-button',
			function () {
				$(this)
					.parent()
					.removeClass('scale-in')
					.addClass('scale-out')
					.fadeOut(300, function () {
						$(this).remove();
						informesFunctions.updateAgentes();
						if (
							$(
								'.police ' +
									policeTabSelected +
									' .informes .agentes-list li'
							).length == 0
						) {
							$('.police ' + policeTabSelected + ' .informes .agentes-list')
								.html(`
                    <li class="list-group-item list-group-item-action no-notes scale-in">
                        <h5>There are no agents involved</h5>
                    </li>`);
						}
					});
			}
		);

		$(document).on(
			'click',
			'.police .informes .victimas-list .delete-button',
			function () {
				$(this)
					.parent()
					.removeClass('scale-in')
					.addClass('scale-out')
					.fadeOut(300, function () {
						$(this).remove();
						informesFunctions.updateVictimas();
						if (
							$(
								'.police ' +
									policeTabSelected +
									' .informes .victimas-list li'
							).length == 0
						) {
							$(
								'.police ' +
									policeTabSelected +
									' .informes .victimas-list'
							).html(`
                    <li class="list-group-item list-group-item-action no-notes scale-in">
                        <h5>No victims involved</h5>
                    </li>`);
						}
					});
			}
		);

		$(document).on(
			'click',
			'.police .informes .vehiculos-list .delete-button',
			function () {
				$(this)
					.parent()
					.parent()
					.removeClass('scale-in')
					.addClass('scale-out')
					.fadeOut(300, function () {
						$(this).remove();
						informesFunctions.updateVehiculos();
						if (
							$(
								'.police ' +
									policeTabSelected +
									' .informes .vehiculos-list li'
							).length == 0
						) {
							$(
								'.police ' +
									policeTabSelected +
									' .informes .vehiculos-list'
							).html(`
                    <li class="list-group-item list-group-item-action no-notes scale-in">
                        <h5>No vehicles involved</h5>
                    </li>`);
						}
					});
			}
		);

		$(document).on('click', '.police .informes .add-agente', function () {
			if(HasPermissionMenu("AddReportAgent")) return sendNotification('error', Translations.NoPermissionPage);
			citizenSelectorFunctions.showAddPersona(
				informesFunctions.addAgenteInforme,
				'police'
			);
		});

		$(document).on('click', '.police .informes .evidence img', function () {
			const img = $(this).attr('src');
			$('.police .informe-view img').attr('src', img);
			$('.police .informe-view img').css('filter', `hue-rotate(-${currentHueDeg}deg)`);
			$('.police .informe-view').fadeIn(300);
		});

		$(document).on(
			'click',
			'.police .informes .evidence .delete-evidence',
			function () {
				if(HasPermissionMenu("DeleteEvidence")) return sendNotification('error', Translations.NoPermissionPage);
				actualEvidence = $(this).parent().parent();
				OpenModal(
					Translations.Atention,
					`<div class="row">
                <div class="col-1">
                    <img src="./img/webp/trash.webp" class="img-fluid">
                </div>
                <div class="col-11 d-flex align-items-center">
                    <div>
                    <h5 class="text-danger fw-bold mb-3">${Translations.ThisActionRemoveEvidence}</h5>
                    <h4>${Translations.DoYouWantContinue}</h4>
                    </div>
                </div>

            </div>`,
					`<button class="btn-modal" onclick="informesFunctions.deleteEvidence()">${Translations.Confirm}</button>`,
					Translations.Cancel
				);
			}
		);

		$(document).on('click', '.police .informes .add-victima', function () {
			if(HasPermissionMenu('AddVictimToReport')) return sendNotification('error', Translations.NoPermissionPage);
			citizenSelectorFunctions.showAddPersona(informesFunctions.addVictimaInforme);
		});

		$(document).on('click', '.police .informes .add-vehicle', function () {
			if(HasPermissionMenu("AddVehicleToReport")) return sendNotification('error', Translations.NoPermissionPage);
			vehicleSelectorFunctions.showAddVehicle(informesFunctions.addVehicleInforme);
		});

		$(document).on('click', '.police .informes .add-prueba', function () {
			if(HasPermissionMenu("AddEvidence")) return sendNotification('error', Translations.NoPermissionPage);
			informesFunctions.showAddEvidence();
		});

		$(document).on(
			'click',
			'.police .evidencias-container .evidence-box',
			function () {
				const slot = $(this).data('slot');
				const name = $(this).data('name');
				const img = $(this).data('img');
				TriggerCallback('origen_police:server:RemoveItem', {
					slot,
					item_name: name,
					amount: 1
				}).done((cb) => {
					if (cb) {
						$('.police ' + policeTabSelected + ' .informes .row.evidences')
							.append(`
                    <div class="col-4 pt-2 scale-in">
                        <div class="evidence">
                            <img src="${img}" style="filter:hue-rotate(-${currentHueDeg}deg);">
                            <button class="btn text-white p-0 mt-2 delete-evidence"><i class="lni lni-trash-can"></i></button>
                        </div>
                    </div>
                    `);
						$('.police .evidencias-container .personas-box')
							.removeClass('scale-in')
							.addClass('scale-out');
						$('.police .evidencias-container').fadeOut(300);
						informesFunctions.updateEvidencias();
					} else {
						informesFunctions.showAddEvidence();
					}
				});
			}
		);

		$(document).on('click', '.police .informe-view', function () {
			$(this).fadeOut(300);
		});

		$(document).on('change', '.police .informes .select-tags', function () {
			if(HasPermissionMenu("AddTags")) return sendNotification('error', Translations.NoPermissionPage);
			const val = $(this).val();
			if (val) {
				$('.police ' + policeTabSelected + ' .informes .tag-list').append(`
                <div class="tag scale-in">
                    <span>${val}</span>
                    <i class="fas fa-times"></i>
                </div>
            `);

				var divs = $(
					'.police ' + policeTabSelected + ' .informes .tag-list .tag'
				);
				divs.sort(function (a, b) {
					return $(a).text().trim().localeCompare($(b).text().trim());
				});
				$('.police ' + policeTabSelected + ' .informes .tag-list').html(divs);

				$(
					'.police ' +
						policeTabSelected +
						" .informes .select-tags option[value='" +
						val +
						"']"
				).remove();
			}
			informesFunctions.updateTags();
		});

		$(document).on('click', '.police .informes .tag-list .tag i', function () {
			if(HasPermissionMenu("RemoveTags")) return sendNotification('error', Translations.NoPermissionPage);
			$(this)
				.parent()
				.removeClass('scale-in')
				.addClass('scale-out')
				.fadeOut(300, function () {
					$(this).remove();
					informesFunctions.updateTags();
					informesFunctions.loadInformeTags();
				});
		});

		$(document).on('focusout', '.police .informes .input-report-name', function () {
			$(this).removeClass('text-warning');
			const data = {
				key: 'title',
				value: $(this).val()
			};
			if (data.value.length != 0) {
				informesFunctions.updateInforme(data);
			}
		});

		$(document).on('focusout', '.police .informes .input-report-ubi', function () {
			const data = {
				key: 'location',
				value: $(this).val()
			};
			if (data.value.length != 0) {
				informesFunctions.updateInforme(data);
			}
		});

		$(document).on('focusout', '.police .informes .input-report-desc', function () {
			const data = {
				key: 'description',
				value: $(this).val()
			};
			informesFunctions.updateInforme(data);
		});

		$(document).on('click', '.police .informes .delete-report', function () {
			const idReport = $('.police ' + policeTabSelected + ' .report.selected')
				.attr('id')
				.split('-')[1];

			OpenModal(
				Translations.Atention,
				`<div class="row">
                <div class="col-1">
                    <img src="./img/webp/trash.webp" class="img-fluid">
                </div>
                <div class="col-11 d-flex align-items-center">
                    <div>
                    <h5 class="text-danger fw-bold mb-3">${Translations.ThisActionEliminateReport}</h5>
                    <h4>${Translations.ThisWillAffectFines}</h4>
                    </div>
                </div>

            </div>`,
				`<button class="btn-modal" onclick="informesFunctions.deleteInforme(${idReport})">${Translations.Confirm}</button>`,
				Translations.Cancel,
				127
			);
		});
	},

	loadReports: () => {
		$('.police ' + policeTabSelected + ' .informes .report-list')
			.html('')
			.fadeOut(0, function () {
				TriggerCallback('origen_police:police:Get100Reports', {}).done((cb) => {
					if (cb && cb.length > 0) {
						cb.forEach((report, index) => {
							let date = timeStampToDate(report.date);

							let clasesTags = '';
							if (report.tags.includes(Translations.OpenCase)) {
								clasesTags += 'open-case ';
							} else if (report.tags.includes(Translations.NullCase)) {
								clasesTags += 'null-case ';
							} else if (report.tags.includes(Translations.CaseClosed)) {
								clasesTags += 'closed-case ';
							}

							$('.police ' + policeTabSelected + ' .informes .report-list')
								.append(`
                        <div class="white-block report scale-in ${clasesTags}" id="report-${report.id}" tags="${report.tags}">
                            <i class="fas fa-sticky-note" aria-hidden="true"></i>
                        <div class="report-name">
                            ${report.title} <span>#${report.id}</span>
                        </div>
                        <div class="d-flex w-100">
                                <div class="w-50">
                                    <div class="report-owner">
                                        <i class="fas fa-user" aria-hidden="true"></i>
                                        <span>${report.author}</span>
                                    </div>
                                </div>
                                <div class="w-50">
                                    <div class="report-date">
                                        <i class="fas fa-calendar-alt" aria-hidden="true"></i>
                                        <span>${date.date} - ${date.time}</span>
                                    </div>
                                </div>
                            </div>
                        </div>`);
						});
					} else {
						$('.police ' + policeTabSelected + ' .informes .report-list')
							.html(`
                    <div class="col-12 text-muted">
                        <h4 class="report-name">${Translations.NoResultFound}</h4>
                    </div>`);
					}
					$('.police ' + policeTabSelected + ' .informes .report-list').fadeIn(
						300
					);
				});
			});
		$('.police .informes .select-tags-filter').html(`<option value="0">${Translations.AllTags}</option>`);
		
		tags[tags[jobData.name] != null ? jobData.name : 'default'].map((tag) => {
			$('.police .informes .select-tags-filter').append(`
				<option value="${tag}">${tag}</option>
			`);
		});
		return true;
	},

	searchReport: (tag) => {
		$('.police ' + policeTabSelected + ' .informes .report-list').fadeOut(
			300,
			function () {
				$('.police ' + policeTabSelected + ' .informes .report-list').html('');
				let text = $(
					'.police ' + policeTabSelected + ' .informes .input-search-report'
				).val();
				if (text.length > 0 || tag) {
					data = {
						text,
						tags: false
					};
					if (tag) {
						data.tags = tag;
					}
					TriggerCallback('origen_police:police:SearchReport', data).done(
						(cb) => {
							if (cb && cb.length > 0) {
								cb.forEach((report, index) => {
									let date = timeStampToDate(report.date);

									$(
										'.police ' +
											policeTabSelected +
											' .informes .report-list'
									).append(`
                            <div class="white-block report scale-in" id="report-${report.id}">
                                <i class="fas fa-sticky-note" aria-hidden="true"></i>
                            <div class="report-name">
                                ${report.title} <span>#${report.id}</span>
                            </div>
                            <div class="d-flex w-100">
                                    <div class="w-50">
                                        <div class="report-owner">
                                            <i class="fas fa-user" aria-hidden="true"></i>
                                            <span>${report.author}</span>
                                        </div>
                                    </div>
                                    <div class="w-50">
                                        <div class="report-date">
                                            <i class="fas fa-calendar-alt" aria-hidden="true"></i>
                                            <span>${date.date} - ${date.time}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>`);
								});
							} else {
								$(
									'.police ' +
										policeTabSelected +
										' .informes .report-list'
								).html(`
                        <div class="col-12 text-muted">
                            <h4 class="report-name">${Translations.NoResultFound}</h4>
                        </div>`);
							}
							$(
								'.police ' + policeTabSelected + ' .informes .report-list'
							).fadeIn(300);
						}
					);
				} else {
					informesFunctions.loadReports();
				}
			}
		);
	},

	loadInformeTags: () => {
		$('.police ' + policeTabSelected + ' .informes .select-tags').html(`
        <option value="0" disable selected>
			${Translations.SelectLabel}
        </option>
        `);

		let auxTags = [...tags[jobData.name]];

		$('.police ' + policeTabSelected + ' .informes .tag-list .tag').each(function () {
			if (auxTags.includes($(this).find('span').text().trim())) {
				auxTags.splice(auxTags.indexOf($(this).find('span').text().trim()), 1);
			}
		});

		auxTags.forEach((tag) => {
			$('.police ' + policeTabSelected + ' .informes .select-tags').append(`
            <option value="${tag}">
                ${tag}
            </option>
            `);
		});
	},

	addPersonaInforme: function (name, citizenid) {
		$('.police .personas-container .personas-box')
			.removeClass('scale-in')
			.addClass('scale-out');
		$('.police .personas-container').fadeOut(300);
		if (
			$('.police ' + policeTabSelected + ' .informes .multas-list li.no-notes')
				.length > 0
		) {
			$('.police ' + policeTabSelected + ' .informes .multas-list').html('');
		}
		$('.police ' + policeTabSelected + ' .informes .multas-list').prepend(`
        <li class="list-group-item list-group-item-action scale-in" data-id="${citizenid}">
            <div class="d-flex align-items-center">
                <h5 class="persona-name">${name}</h5>
                <div class="ms-2 text-muted persona-cid"><i class="fas fa-id-card me-1"></i> ${citizenid}</div>
            </div>

            <div class="row multas-informes d-none">
                <div class="col-12 mb-2">
                    <ul>

                    </ul>
                </div>
                <div class="col-6">
                    <div class="info-box h-100">
                        <div class="info-box-title">${Translations.TotalPenalty}</div>
                        <div class="info-box-value text-danger">0 ${Translations.Month}</div>
                    </div>
                </div>
                <div class="col-6">
                    <div class="info-box h-100">
                        <div class="info-box-title">${Translations.TotalAmount}</div>
                        <div class="info-box-value text-success">0$</div>
                    </div>
                </div>
            </div>
            <div class="delete-button">
                <i class="fa-solid fa-trash"></i>
            </div>
            <div class="multa-button">
                <i class="fas fa-edit"></i> ${Translations.SendFine}
            </div>
        </li>
        `);

		informesFunctions.updatePersonasInvolucradas();
	},
	addAgenteInforme: function (name, citizenid) {
		$('.police .personas-container .personas-box')
			.removeClass('scale-in')
			.addClass('scale-out');
		$('.police .personas-container').fadeOut(300);
		if (
			$('.police ' + policeTabSelected + ' .informes .agentes-list li.no-notes')
				.length > 0
		) {
			$('.police ' + policeTabSelected + ' .informes .agentes-list').html('');
		}
		$('.police ' + policeTabSelected + ' .informes .agentes-list').prepend(`
        <li class="list-group-item list-group-item-action scale-in" data-id="${citizenid}">
            <div class="d-flex align-items-center">
                <h5 class="persona-name">${name}</h5>
                <div class="ms-2 text-muted persona-cid"><i class="fas fa-id-card me-1"></i> ${citizenid}</div>
            </div>
            <div class="delete-button">
                <i class="fa-solid fa-trash"></i>
            </div>
        </li>
        `);

		informesFunctions.updateAgentes();
	},
	addVictimaInforme: function (name, citizenid) {
		$('.police .personas-container .personas-box')
			.removeClass('scale-in')
			.addClass('scale-out');
		$('.police .personas-container').fadeOut(300);
		if (
			$('.police ' + policeTabSelected + ' .informes .victimas-list li.no-notes')
				.length > 0
		) {
			$('.police ' + policeTabSelected + ' .informes .victimas-list').html('');
		}
		$('.police ' + policeTabSelected + ' .informes .victimas-list').prepend(`
        <li class="list-group-item list-group-item-action scale-in" data-id="${citizenid}">
            <div class="d-flex align-items-center">
                <h5 class="persona-name">${name}</h5>
                <div class="ms-2 text-muted persona-cid"><i class="fas fa-id-card me-1"></i> ${citizenid}</div>
            </div>
            <div class="delete-button">
                <i class="fa-solid fa-trash"></i>
            </div>
        </li>
        `);
		informesFunctions.updateVictimas();
	},
	addMultaInforme: function (articulos, importe, meses, cid) {
		$(
			'.police ' +
				policeTabSelected +
				" .multas-list li[data-id='" +
				cid +
				"'] .multas-informes ul"
		).html('');
		articulos.forEach((articulo) => {
			$(
				'.police ' +
					policeTabSelected +
					" .multas-list li[data-id='" +
					cid +
					"'] .multas-informes ul"
			).append(`<li>${articulo.articulo}</li>`);
		});
		$(
			'.police ' +
				policeTabSelected +
				" .multas-list li[data-id='" +
				cid +
				"'] .multas-informes .info-box-value.text-danger"
		).text(meses + ' ' + Translations.Month);
		$(
			'.police ' +
				policeTabSelected +
				" .multas-list li[data-id='" +
				cid +
				"'] .multas-informes .info-box-value.text-success"
		).text(importe + '$');
		$(
			'.police ' +
				policeTabSelected +
				" .multas-list li[data-id='" +
				cid +
				"'] .multas-informes"
		).removeClass('d-none');
		informesFunctions.updatePersonasInvolucradas();
		if (currentReport != null)
			informesFunctions.loadInforme(currentReport);
	},

	updatePersonasInvolucradas: function () {
		let data = {
			key: 'implicated',
			value: []
		};
		$('.police ' + policeTabSelected + ' .informes .multas-list>li').each(function (
			i
		) {
			if ($(this).find('.multas-informes li').length > 0) {
				let bills = [];
				let isValid = true;
				let billId = $(this).find('.multas-informes').attr('billid');
				if($(this)
				.find('.multas-informes li')
				.each(function () {
					bills.push($(this).text().trim());
				}) == undefined) {
					isValid = false;
				}
				
				if(isValid)
					data.value.push({
						citizenid: $(this).data('id'),
						name: $(this).find('.persona-name').text().trim(),
						bills: bills,
						price: parseInt(
							$(this).find('.info-box-value.text-success').text().trim()
						),
						months: parseInt(
							$(this).find('.info-box-value.text-danger').text().trim()
						),
						billid: billId
					});
			} else {
				data.value.push({
					citizenid: $(this).data('id'),
					name: $(this).find('.persona-name').text().trim()
				});
			}
		});
		informesFunctions.updateInforme(data);
	},

	updateEvidencias: () => {
		const data = {
			key: 'evidences',
			value: []
		};
		$('.police ' + policeTabSelected + ' .informes .row.evidences img').each(
			function () {
				data.value.push($(this).attr('src'));
			}
		);
		data.value = JSON.stringify(data.value);
		informesFunctions.updateInforme(data);
	},

	updateTags: function () {
		let data = {
			key: 'tags',
			value: []
		};
		$('.police ' + policeTabSelected + ' .informes .tag-list .tag span').each(
			function () {
				data.value.push($(this).text().trim());
			}
		);
		data.value = JSON.stringify(data.value);
		informesFunctions.updateInforme(data);
	},

	crearInforme: function () {
		$('.police ' + policeTabSelected + ' .informes .informe-report').fadeOut(
			300,
			function () {
				TriggerCallback('origen_police:police:NewReport', {}).done((cb) => {
					if (cb) {
						let todayFullDateTime = new Date(cb.date);

						let todayDateTime =
							todayFullDateTime.getDate() +
							'/' +
							(todayFullDateTime.getMonth() + 1) +
							'/' +
							todayFullDateTime.getFullYear() +
							' - ' +
							todayFullDateTime.getHours() +
							':' +
							todayFullDateTime.getMinutes();

						if (todayFullDateTime.getHours() < 10) {
							todayDateTime =
								todayFullDateTime.getDate() +
								'/' +
								(todayFullDateTime.getMonth() + 1) +
								'/' +
								todayFullDateTime.getFullYear() +
								' - 0' +
								todayFullDateTime.getHours() +
								':' +
								todayFullDateTime.getMinutes();
						}
						currentReport = cb.id;
						$(this)
							.html(
								`
                    <div class="row m-titles content-report-${cb.id}">
                        <div class="col-4 p-0">
                            <div class="info-box m-1 h-100">
                                <div class="info-box-title">${Translations.ReportName}</div>
                                <div class="info-box-value">
                                    <input type="text" class="input-report-name" value="${Translations.IntroduceName}">
                                </div>

                            </div>
                        </div>
                        <div class="col-4 p-0">
                            <div class="info-box m-1 h-100">
                                <div class="info-box-title">${Translations.ReportID}</div>
                                <div class="info-box-value id-informe">
                                    #${cb.id}
                                </div>

                            </div>
                        </div>
                        <div class="col-4 p-0">
                            <div class="info-box m-1 h-100">
                                <div class="info-box-title">${Translations.DateAndHour}</div>
                                <div class="info-box-value">${todayDateTime}</div>

                            </div>


                        </div>
                        <div class="col-6 mt-2 p-0">
                            <div class="info-box m-1 h-100">
                                <div class="info-box-title">${Translations.AgentInCharge}</div>
                                <div class="info-box-value">${cb.author}</div>

                            </div>
                        </div>
                        <div class="col-6 mt-2 p-0">
                            <div class="info-box m-1 h-100">
                                <div class="info-box-title">${Translations.Location}</div>
                                <div class="info-box-value">
                                    <input type="text" class="input-report-ubi" value="${Translations.NoLocation}">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row m-titles mt-3">
                        <div class="col-12 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-sticky-note"></i> ${Translations.ReportDescription}</h4>
                                </div>
                                <div class="citizen-info-container-mini mt-2 d-flex flex-wrap citizen-informes align-content-start">
                                    <textarea class="input w-100 input-report-desc" placeholder="${Translations.EnterReportDesc}." rows="7"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="notes-title d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-quote-right"></i> ${Translations.Evidences}</h4>
                                    <div class="new-button add-prueba"><i class="fas fa-plus"></i> ${Translations.AddEvidence}</div>
                                </div>
                                <div class="citizen-info-container mt-2">
                                    <div class="row evidences w-100 m-0">

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-book"></i> ${Translations.PeopleInvolved}</h4>
                                    <div class="new-button add-persona"><i class="fas fa-plus"></i> ${Translations.AddPeople}</div>
                                </div>
                                <div class="citizen-info-container mt-2">
                                    <ul class="list-group multas-list">
                                        <li class="list-group-item list-group-item-action no-notes">
                                            <h5>${Translations.NoPeopleInvolved}</h5>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-book"></i> ${Translations.AgentsInvolved}</h4>
                                    <div class="new-button add-agente"><i class="fas fa-plus"></i> ${Translations.AddAgent}</div>
                                </div>
                                <div class="citizen-info-container-mini mt-2">
                                    <ul class="list-group agentes-list">
                                        <li class="list-group-item list-group-item-action no-notes">
                                            <h5>${Translations.NoAgentsInvolved}</h5>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4><img src="./img/icons/XydWJHC.png" class="img-icon"> ${Translations.Tags}</h4>
                                    <select class="input select-tags p-0">
                                        <option value="0" disabled>
										${Translations.SelectLabel}
                                        </option>
                                    </select>
                                </div>
                                <div class="citizen-info-container-mini mt-2">
                                    <div class="d-flex tag-list">

                                        <div class="tag">
                                            <span>${Translations.OpenCase}</span>
                                            <i class="fas fa-times"></i>
                                        </div>

                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="col-6 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4><img src="./img/icons/bdzbVYn.png" class="img-icon"> ${Translations.Victims}</h4>
                                    <div class="new-button add-victima"><i class="fas fa-plus"></i> ${Translations.AddVictim}</div>

                                </div>
                                <div class="citizen-info-container-mini mt-2">
                                    <ul class="list-group victimas-list">
                                        <li class="list-group-item list-group-item-action no-notes">
                                            <h5>${Translations.NoVictimsInvolved}</h5>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 p-0">
                            <div class="info-box m-1 mt-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h4><img src="./img/icons/N9zxK11.png" class="img-icon"> ${Translations.Vehicles}</h4>
                                    <div class="new-button add-vehicle"><i class="fas fa-plus"></i> ${Translations.AddVehicle}</div>

                                </div>
                                <div class="citizen-info-container-mini mt-2">
                                    <ul class="list-group vehiculos-list">
                                        <li class="list-group-item list-group-item-action no-notes">
                                            <h5>${Translations.NoVehicleInvolved}</h5>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 text-center">
                            <button class="btn btn-danger delete-report mt-3 mb-2"><i class="lni lni-trash-can"></i> ${Translations.DestroyReport}</button>
                        </div>
                    </div>
                    `
							)
							.fadeIn(300);
						$(
							'.police ' + policeTabSelected + ' .report-list .report'
						).removeClass('selected');

						$('.police .report-list').prepend(`
                    <div class="white-block report scale-in" id="report-${cb.id}">
                        <i class="fas fa-sticky-note" aria-hidden="true"></i>
                    <div class="report-name">
                        ${Translations.IntroduceName} <span>#${cb.id}</span>
                    </div>
                    <div class="d-flex w-100">
                            <div class="w-50">
                                <div class="report-owner">
                                    <i class="fas fa-user" aria-hidden="true"></i>
                                    <span>${cb.author}</span>
                                </div>
                            </div>
                            <div class="w-50">
                                <div class="report-date">
                                    <i class="fas fa-calendar-alt" aria-hidden="true"></i>
                                    <span>${todayDateTime}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    `);
						$(
							'.police ' +
								policeTabSelected +
								' .report-list .report#report-' +
								cb.id
						).addClass('selected');

						$(this).animate({ scrollTop: 0 }, 200);
						$(
							'.police ' + policeTabSelected + ' .input-report-name'
						).addClass('text-warning');

						informesFunctions.loadInformeTags();
					}
				});
			}
		);
	},
	addVehicleInforme: function (plate, name) {
		if (
			$('.police ' + policeTabSelected + ' .informes .vehiculos-list .no-notes')
				.length > 0
		) {
			$(
				'.police ' + policeTabSelected + ' .informes .vehiculos-list .no-notes'
			).remove();
		}

		$('.police ' + policeTabSelected + ' .informes .vehiculos-list').prepend(`
            <li class="list-group-item list-group-item-action" data-id="${plate}">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="vehicle-title d-flex align-items-center">
                        <h5>${name}</h5>
                        <div class="vehicle-plate">
                            <p>PLATE <i class="fas fa-angle-right" aria-hidden="true"></i> ${plate}</p>
                        </div>
                    </div>
                    <div class="delete-button">
                        <i class="fa-solid fa-trash"></i>
                    </div>
                </div>
            </li>
        `);
		informesFunctions.updateVehiculos();
	},
	showAddEvidence: function () {
		$('.police .evidencias-container .input-search-vehicle-selector').val('');
		fetch('GetInventory', ['report_evidence', 'photo']).done((cb) => {
			if (cb && cb.length > 0) {
				$('.police .evidencias-container .evidencias-box-list .row').html('');
				cb.map(function (evidence) {
					const info = evidence.info ? evidence.info : evidence.metadata;
					$('.police .evidencias-box-list .row').append(`
                    <div class="col-4 h-100 mb-3">
                        <div class="evidence-box" data-slot="${evidence.slot}" data-name="${evidence.name}" data-img="${info.url}">
                            <div class="evidence-image" style="background-image:url(${info.url});filter:hue-rotate(-${currentHueDeg}deg);"></div>
                            <div class="p-2 text-center">
                                <div class="evidence-name">${evidence.label}</div>
                                <div class="evidence-serie">${info.serie}</div>
                            </div>
                        </div>
                    </div>
                `);
				});
			} else {
				$('.police .evidencias-container .evidencias-box-list .row').html(`
                    <div class="col-12 text-muted">
                        <h4 class="citizen-name">${Translations.NoEvidences}</h4>
                    </div>`);
			}
		});

		$('.police .evidencias-container .personas-box')
			.removeClass('scale-out')
			.addClass('scale-in');
		$('.police .evidencias-container').fadeIn(300);
	},

	deleteEvidence: () => {
		CloseModal();
		actualEvidence.addClass('scale-out').fadeOut(300, function () {
			actualEvidence.remove();
			actualEvidence = null;
			informesFunctions.updateEvidencias();
		});
	},

	updateAgentes: function () {
		const datos = {
			key: 'cops',
			value: []
		};
		$('.police ' + policeTabSelected + ' .informes .agentes-list li').each(
			function () {
				const citizenid = $(this).data('id');
				const name = $(this).find('.persona-name').text().trim();
				datos.value.push({
					citizenid,
					name
				});
			}
		);
		datos.value = JSON.stringify(datos.value);

		informesFunctions.updateInforme(datos);
	},

	updateVehiculos: function () {
		const datos = {
			key: 'vehicles',
			value: []
		};
		$('.police ' + policeTabSelected + ' .informes .vehiculos-list li').each(
			function () {
				const plate = $(this).data('id');
				const name = $(this).find('h5').text().trim();
				datos.value.push({
					plate,
					name
				});
			}
		);
		datos.value = JSON.stringify(datos.value);

		informesFunctions.updateInforme(datos);
	},

	updateVictimas: function () {
		const datos = {
			key: 'victims',
			value: []
		};
		$('.police ' + policeTabSelected + ' .informes .victimas-list li').each(
			function () {
				const citizenid = $(this).data('id');
				const name = $(this).find('.persona-name').text().trim();
				datos.value.push({
					citizenid,
					name
				});
			}
		);
		datos.value = JSON.stringify(datos.value);

		informesFunctions.updateInforme(datos);
	},

	deleteInforme: function (reportid) {
		if(HasPermissionMenu('DeleteReport')) return sendNotification('error', Translations.NoPermissionPage);
		TriggerCallback('origen_police:police:DeleteReport', { reportid }).done((cb) => {
			if (cb) {
				$('.police .report-list .report#report-' + reportid).fadeOut(
					300,
					function () {
						$(this).remove();
					}
				);
				$('.police .informes .informe-report .content-report-' + reportid)
					.parent()
					.fadeOut(300, function () {
						$(this)
							.html(
								`
                    <div class="d-flex w-100 align-items-center flex-column" style="height: 73vh;">
                        <h1>${Translations.SelectReport}</h1>
                        <img src="./img/webp/document.webp">
                    </div>
                    `
							)
							.fadeIn(300);
					});
			}
			CloseModal();
		});
	},

	updateInforme: function (data) {
		data.reportid = parseInt(
			$('.police ' + policeTabSelected + ' .informes .id-informe')
				.text()
				.trim()
				.substring(1)
		);
		TriggerCallback('origen_police:police:UpdateReport', data).done((cb) => {
			if (cb) {
				if (data.key == 'title') {
					$(
						'.police .report-list .report#report-' +
							data.reportid +
							' .report-name'
					).html(`${data.value} <span>#${data.reportid}</span>`);
				}
				
			}
		});
	},

	loadInforme: function (reportid) {
		currentReport = reportid;
		$('.police ' + policeTabSelected + ' .informes .informe-report').fadeOut(
			300,
			function () {
				TriggerCallback('origen_police:police:GetReport', { reportid }).done(
					(cb) => {
						const todayDateTime = timeStampToDate(cb.date);
						let tags = '';
						if (cb.tags && isJsonString(cb.tags)) {
							const tagList = JSON.parse(cb.tags);
							tagList.forEach((tag) => {
								tags += `
                                <div class="tag scale-in">
                                    <span>${tag}</span>
                                    <i class="fas fa-times"></i>
                                </div>
                            `;
							});
						} else {
							tags = `
                        <div class="tag scale-in">
                            <span>${cb.tags}</span>
                            <i class="fas fa-times"></i>
                        </div>
                    `;
						}
						let evidences = '';
						if (cb.evidences && isJsonString(cb.evidences)) {
							const evidencesList = JSON.parse(cb.evidences);

							evidencesList.forEach((evidence) => {
								evidences += `
                        <div class="col-4 pt-2">
                            <div class="evidence">
                                <img src="${evidence}" style="filter:hue-rotate(-${currentHueDeg}deg);">
                                <button class="btn text-white p-0 mt-2 delete-evidence"><i class="lni lni-trash-can"></i></button>
                            </div>
                        </div>


                            `;
							});
						}

						let cops = '';
						if (cb.cops && isJsonString(cb.cops)) {
							const copsList = JSON.parse(cb.cops);
							if (copsList.length > 0) {
								copsList.forEach((cop) => {
									cops += `
										<li class="list-group-item list-group-item-action scale-in" data-id="${cop.citizenid}">
											<div class="d-flex align-items-center">
												<h5 class="persona-name">${cop.name}</h5>
												<div class="ms-2 text-muted persona-cid"><i class="fas fa-id-card me-1"></i> ${cop.citizenid}</div>
											</div>
											<div class="delete-button">
												<i class="fa-solid fa-trash"></i>
											</div>
										</li>
									`;
								});
							} else {
								cops = `<li class="list-group-item list-group-item-action no-notes">
                                <h5>${Translations.NoData}</h5>
                            </li>`;
							}
						}

						let vehicles = '';
						if (cb.vehicles && isJsonString(cb.vehicles)) {
							const vehiclesList = JSON.parse(cb.vehicles);
							if (vehiclesList.length > 0) {
								vehiclesList.forEach((vehicle) => {
									vehicles += `
                            <li class="list-group-item list-group-item-action" data-id="${vehicle.plate}">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="vehicle-title d-flex align-items-center">
                                    <h5>${vehicle.name}</h5>
                                    <div class="vehicle-plate">
                                        <p>${Translations.LicensePlate} <i class="fas fa-angle-right" aria-hidden="true"></i> ${vehicle.plate}</p>
                                    </div>
                                </div>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                            </div>
                        </li>
                            `;
								});
							} else {
								vehicles = `<li class="list-group-item list-group-item-action no-notes">
                                <h5>${Translations.NoData}</h5>
                            </li>`;
							}
						}

						let victims = '';
						if (cb.victims && isJsonString(cb.victims)) {
							const victimsList = JSON.parse(cb.victims);
							if (victimsList.length > 0) {
								victimsList.forEach((victim) => {
									victims += `
                            <li class="list-group-item list-group-item-action scale-in" data-id="${victim.citizenid}">
                                <div class="d-flex align-items-center">
                                    <h5 class="persona-name">${victim.name}</h5>
                                    <div class="ms-2 text-muted persona-cid"><i class="fas fa-id-card me-1" aria-hidden="true"></i> ${victim.citizenid}</div>
                                </div>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                            </li>
                            `;
								});
							} else {
								victims = `<li class="list-group-item list-group-item-action no-notes">
                                <h5>${Translations.NoData}</h5>
                            </li>`;
							}
						}

						let implicated = '';

						if (cb.implicated && isJsonString(cb.implicated)) {
							const implicatedList = JSON.parse(cb.implicated);
							if (implicatedList.length > 0) {
								implicatedList.forEach((imp) => {
									let classBill = 'd-none';
									let articles = '';
									let billid = "none";
									// imp.bills = JSON.parse(imp.bills);
									if (imp.bills.bills) {
										imp.bills.bills = JSON.parse(imp.bills.bills);
										classBill = '';
										billid = imp.billid;
										imp.bills.bills.map((article) => {
											articles += `
                                        <li>${article}</li>
                                    `;
										});
									}
									implicated += `
                            <li class="list-group-item list-group-item-action scale-in" data-id="${
								imp.citizenid
							}">
                                <div class="d-flex align-items-center">
                                    <h5 class="persona-name">${imp.name}</h5>
                                    <div class="ms-2 text-muted persona-cid"><i class="fas fa-id-card me-1"></i> ${
										imp.citizenid
									}</div>
                                </div>

                                <div class="row multas-informes ${classBill}" billid="${billid}">
                                    <div class="col-12 mb-2">
                                        <ul>
                                            ${articles || ''}
                                        </ul>
                                    </div>
                                    <div class="col-6">
                                        <div class="info-box h-100">
                                            <div class="info-box-title">${Translations.TotalPenalty}</div>
                                            <div class="info-box-value text-danger">${
												imp.bills.months ? imp.bills.months + ' ' + Translations.Month :
												'0 ' + Translations.Month
											}</div>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="info-box h-100">
                                            <div class="info-box-title">${Translations.TotalAmount}</div>
                                            <div class="info-box-value text-success">${
												imp.bills.price ? imp.bills.price + '$' : '0$'
											}</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="delete-button">
                                    <i class="fa-solid fa-trash"></i>
                                </div>
                                <div class="multa-button">
                                    <i class="fas fa-edit"></i> ${Translations.SendFine}
                                </div>
                            </li>
                            `;
								});
							} else {
								implicated = `<li class="list-group-item list-group-item-action no-notes">
                                <h5>${Translations.NoPeopleInvolved}</h5>
                            </li>`;
							}
						}

						$('.police ' + policeTabSelected + ' .informes .informe-report')
							.html(
								`
                <div class="row m-titles content-report-${cb.id}">
                    <div class="col-4 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">${Translations.ReportName}</div>
                            <div class="info-box-value">
                                <input type="text" class="input-report-name" value="${cb.title}">
                            </div>

                        </div>
                    </div>
                    <div class="col-4 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">${Translations.ReportID}</div>
                            <div class="info-box-value id-informe">
                                #${cb.id}
                            </div>

                        </div>
                    </div>
                    <div class="col-4 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">${Translations.DateAndHour}</div>
                            <div class="info-box-value">${todayDateTime.date} - ${todayDateTime.time}</div>

                        </div>


                    </div>
                    <div class="col-6 mt-2 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">${Translations.AgentInCharge}</div>
                            <div class="info-box-value">${cb.author}</div>

                        </div>
                    </div>
                    <div class="col-6 mt-2 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">${Translations.Location}</div>
                            <div class="info-box-value">
                                <input type="text" class="input-report-ubi" value="${cb.location}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row m-titles mt-3">
                    <div class="col-12 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-sticky-note"></i> ${Translations.ReportDescription}</h4>
                            </div>
                            <div class="citizen-info-container-mini mt-2 d-flex flex-wrap citizen-informes align-content-start">
                                <textarea class="input w-100 input-report-desc" placeholder="${Translations.EnterReportDesc}" rows="7">${cb.description}</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="notes-title d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-quote-right"></i> ${Translations.Evidences}</h4>
                                <div class="new-button add-prueba"><i class="fas fa-plus"></i> ${Translations.AddEvidence}</div>
                            </div>
                            <div class="citizen-info-container mt-2">
                                <div class="row evidences w-100 m-0">
                                    ${evidences}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-book"></i> ${Translations.PeopleInvolved}</h4>
                                <div class="new-button add-persona"><i class="fas fa-plus"></i> ${Translations.AddPeople}</div>
                            </div>
                            <div class="citizen-info-container mt-2">
                                <ul class="list-group multas-list">
                                    ${implicated}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-book"></i> ${Translations.AgentsInvolved}</h4>
                                <div class="new-button add-agente"><i class="fas fa-plus"></i> ${Translations.AddAgent}</div>
                            </div>
                            <div class="citizen-info-container-mini mt-2">
                                <ul class="list-group agentes-list">
                                    ${cops}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><img src="./img/icons/XydWJHC.png" class="img-icon"> ${Translations.Tags}</h4>
                                <select class="input select-tags p-0">
                                    <option value="0" disabled>
									${Translations.SelectLabel}
                                    </option>
                                </select>
                            </div>
                            <div class="citizen-info-container-mini mt-2">
                                <div class="d-flex tag-list">

                                    ${tags}

                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><img src="./img/icons/bdzbVYn.png" class="img-icon"> ${Translations.Victims}</h4>
                                <div class="new-button add-victima"><i class="fas fa-plus"></i> ${Translations.AddVictim}</div>

                            </div>
                            <div class="citizen-info-container-mini mt-2">
                                <ul class="list-group victimas-list">
                                   ${victims}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><img src="./img/icons/N9zxK11.png" class="img-icon"> ${Translations.Vehicles}</h4>
                                <div class="new-button add-vehicle"><i class="fas fa-plus"></i> ${Translations.AddVehicle}</div>

                            </div>
                            <div class="citizen-info-container-mini mt-2">
                                <ul class="list-group vehiculos-list">
                                    ${vehicles}
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 text-center">
                        <button class="btn btn-danger delete-report mt-3 mb-2"><i class="lni lni-trash-can"></i> ${Translations.DestroyReport}</button>
                    </div>
                </div>
                `
							)
							.fadeIn(300);
						$(this).animate({ scrollTop: 0 }, 200);

						informesFunctions.loadInformeTags();
						$(
							'.police ' +
								policeTabSelected +
								' .informes .report-list .report'
						).removeClass('selected');
						$(
							'.police ' +
								policeTabSelected +
								' .informes .report-list .report#report-' +
								reportid
						).addClass('selected');
					}
				);
			}
		);
	}
};