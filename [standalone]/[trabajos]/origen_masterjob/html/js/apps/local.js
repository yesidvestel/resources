let localData;
let configLocal;
let actualEvidencelocal;
let graficaBusiness;
let businessStats;
let myGrade;
let permissionsListLocal = ''
let MaxSocietySalary = 9999
let inventory_name = ""

const loadLocallang = async()=>{
	or.debuger('^3 CHECKING LANG')
	if (!or.lang) or.lang = await or.langs() 
	or.debuger('^3 CHECKING LANG', or.lang.total_acc)
	permissionsListLocal = `
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.total_acc}</div>
			<div class="permiso-description">${or.lang.total_acc_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo boss" permiso="boss">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.hum_resc}</div>
			<div class="permiso-description">${or.lang.hum_resc_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo rrhh" permiso="rrhh">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.art_mang}</div>
			<div class="permiso-description">${or.lang.art_mang_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo articles" permiso="articles">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.veh_management}</div>
			<div class="permiso-description">${or.lang.veh_management_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo vehicles" permiso="vehicles">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.acc_garg}</div>
			<div class="permiso-description">${or.lang.acc_garg_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo garajes" permiso="garajes">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.acc_radio}</div>
			<div class="permiso-description">${or.lang.acc_radio_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo radio" permiso="radio">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">>${or.lang.open_buss}</div>
			<div class="permiso-description">${or.lang.open_buss_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo openclose" permiso="openclose">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.billing}</div>
			<div class="permiso-description">${or.lang.billing_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo bills" permiso="bills">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.acc_warh}</div>
			<div class="permiso-description">${or.lang.acc_warh_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo inventory" permiso="inventory">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	<div class="permiso">
		<div class="permiso-info">
			<div class="permiso-title">${or.lang.acc_safe}</div>
			<div class="permiso-description">${or.lang.acc_safe_desc}</div>
		</div>
		<div class="check">
			<label class="switch">
				<input type="checkbox" class="check-dispo safefox" permiso="safebox">
				<span class="slider-check round"></span>
			</label>
		</div>
	</div>
	
	`;
}
loadLocallang()

$(document).on('click', ".app-button[app='local']", function () {
	$('.app-container').hide();

	setTimeout(() => {
		localFunctions.checkFirstTime();
	}, 600);
});

$(document).on('click', '.local .back-section', function () {
	localFunctions.navigate('local-home');
});
$(document).on('click', '.local .navigate', function () {
	localFunctions.navigate($(this).attr('app'));
});

$(document).on('click', '.local .btn-local-cars', function () {
	$(this).parent().toggleClass('show');
});

$(document).on('click', '.local .radio-category .toggle-category', function () {
	$(this).parent().toggleClass('toggle');
});

$(document).on('click', '.local .local-creator .continuar', function () {
	let rangos = {};
	let hayJefe = false;

	$('.local .rangos-creados .rango').each(function (i, n) {
		const divRangos = $(this);
		const divPermisos = $(
			".local .zona-permisos .permisos-tab[rango='" + divRangos.attr('rango') + "']"
		);

		rangos[i.toString()] = {
			label: divRangos.find('.rango-name').text().trim(),
			pay: parseInt(divRangos.attr('salario'))
		};

		divPermisos.find('.check input').each(function () {
			if ($(this).is(':checked')) {
				rangos[i.toString()][$(this).attr('permiso')] = true;
				if ($(this).attr('permiso') == 'boss') {
					hayJefe = true;
				}
			}
		});

		// or.debuger(rangos[i+""]);
	});
	const local = {
		label: $('.local .local-creator .input-local-title').val(),
		grades: rangos
	};

	if (!/^[a-zA-Z0-9\s]+$/.test(local.label)) {
		or.sendNotification(
			'error',
			or.lang.err_az_09 ||'The name of the premises can only contain letters and numbers'
		);
		return;
	}

	or.debuger(local);
	if (hayJefe) {
		if ($('.local .local-creator .input-local-title').val().length != 0) {
			TriggerCallback('origen_masterjob:server:CreateBusiness', local).done(
				(cb) => {
					or.debuger('RESULTADO:', cb);
					if (cb) {
						localFunctions.siguientePaso($(this).attr('paso'));
					} else {
						//NOTIFICACIÓN ERROR
						or.debuger('Error creating location');
						or.sendNotification(
							'error',
							or.lang.err_creabuss || 'An error has occurred when creating the business',
							or.lang.check_admin || 'Consult with the administration.'
						);
					}
				}
			);
		} else {
			//NOTIFICACIÓN ERROR
			or.debuger('Error when creating the premises');
			or.sendNotification('error', or.lang.err_name_buss || 'You must enter a name for the premises');
		}
	} else {
		//NOTIFICACIÓN ERROR JEFE
		or.debuger('No hay jefe');
		or.sendNotification('error', or.lang.err_rank_buss ||'You must choose at least one range with total access');
	}
});

$(document).on('click', '.local .local-creator .poner-npc', function () {
	// localFunctions.siguientePaso($(this).attr("paso"));
	$('.local .local-creator .pasos.dos').fadeOut(300, function () {
		or.closeMenu();
	});
});

$(document).on('click', '.local .local-creator .finalizar-local', function () {
	or.debuger('FINALIZO LOCAL');
	localFunctions.loadlocal().then(() => {
		localFunctions.navigate('local-home');
		$(".app-button[app='local']").attr('access', 'mybusiness');
	});
});

$(document).on('click', '.local .local-settings .tab-navigate', function () {
	if (!$(this).hasClass('active')) {
		if ($(this).attr('tab') == 'rangos' && !canAccess('jefe')) {
			return;
		}
		$('.local .local-settings .tab-navigate').removeClass('active');
		$(this).addClass('active');
		let that = $(this);
		if ($(this).attr('tab') == 'rangos') {
			localFunctions.updateGrades();
		} else {
			localFunctions.updateTerritories();
		}
		$('.local .local-settings .setting-tabs .tab.active')
			.removeClass('active')
			.removeClass('scale-in')
			.addClass('scale-out')
			.fadeOut(300, function () {
				const tab = that.attr('tab');
				$('.local .local-settings .setting-tabs .tab.' + tab)
					.removeClass('scale-out')
					.addClass('scale-in')
					.addClass('active')
					.fadeIn(300);
			});
	}
});

$(document).on('change', '.local .local-settings .permiso .check-dispo', function () {
	// $(".btn-guardar-rangos").fadeIn(300);
	const grade = $(this).parent().parent().parent().parent().attr('rango');
	const attr = $(this).attr('permiso');
	const value = $(this).is(':checked');
	or.debuger(grade, attr, value);
	TriggerCallback('origen_masterjob:server:UpdateGrade', {
		grade,
		attr,
		value
	}).done((cb) => {
		if (cb) {
			or.sendNotification('success', or.lang.secc_perms_updated || 'The permit has been updated correctly');
		} else {
			or.sendNotification('error', or.lang.err_perms_updated || 'An error has occurred when updating permission');
		}
	});
});

$(document).on('click', '.local .btn-settings', function () {
	localFunctions.updateTerritories();
});

$(document).on('click', '.local .local-reports .evidence img', function () {
	const img = $(this).attr('src');

	$('.local .informe-view img').attr('src', img);
	$('.local .informe-view').fadeIn(300);
});

$(document).on('click', '.local .informe-view', function () {
	$(this).fadeOut(300);
});

$(document).on('click', '.local #documentos', function () {
	or.debuger('HOLA');
	TriggerCallback('origen_masterjob:server:GetBusinessDocuments', {}).done((cb) => {
		or.debuger(cb);
		if (cb) {
			if (cb.length > 0) {
				$('.local-reports .report-list').html('');
				cb?.map((doc) => {
					let date = or.timeStampToDate(doc.date);
					or.debuger(date);
					$('.local-reports .report-list').append(`
                        <div class="white-block report scale-in" id="report-${
							doc.id
						}"  onclick="localFunctions.loadInforme(${doc.id})">
                            <i class="fas fa-sticky-note" aria-hidden="true"></i>
                        <div class="report-name">
                            ${doc.title}
                        </div>
                        <div class="d-flex w-100">
                                <div class="w-50">
                                    <div class="report-owner">
                                        <i class="fas fa-user" aria-hidden="true"></i>
                                        <span>${doc.author}</span>
                                    </div>
                                </div>
                                <div class="w-50">
                                    <div class="report-date">
                                        <i class="fas fa-calendar-alt" aria-hidden="true"></i>
                                        <span>${date.date + ' - ' + date.time}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `);
				});
			}
		} else {
			or.sendNotification('error', or.lang.err_documt_obt || 'An error has occurred when obtaining the documents');
		}
	});
});

$(document).on('click', '.local .local-reports .pin-button', function () {
	const noteId = $(this).parent().attr('note-id');
	const note = $(this).parent();
	let value = 1;
	if (note.hasClass('pinned')) {
		value = 0;
	}
	TriggerCallback('origen_masterjob:server:UpdateBusinessNote', {
		noteid: noteId,
		key: 'fixed',
		value
	}).done((cb) => {
		if (cb) {
			if (value) {
				note.addClass('scale-out').fadeOut(300, function () {
					let nota = $(this);
					$(this).remove();
					nota.removeClass('scale-out')
						.addClass('scale-in')
						.addClass('pinned')
						.show();
					$('.local .local-reports .notes-list-pinned').prepend(nota);
				});
			} else {
				note.addClass('scale-out').fadeOut(300, function () {
					let nota = $(this);
					$(this).remove();
					nota.removeClass('scale-out')
						.removeClass('pinned')
						.addClass('scale-in')
						.show();
					$('.local .local-reports .notes-list').prepend(nota);
				});
			}
		}
	});
});

$(document).on('click', '.local .local-reports .ficha ul .delete-button', function () {
	const noteId = $(this).parent().attr('note-id');
	const note = $(this).parent();

	TriggerCallback('origen_masterjob:server:DeleteBusinessNote', {
		id: noteId
	}).done((cb) => {
		if (cb) {
			note.addClass('scale-out').fadeOut(300, function () {
				$(this).remove();
			});
		}
	});
});

$(document).on('focusout', '.local .local-reports .report-title', function () {
	const documentid = parseInt($('.ficha').attr('reportid'));
	const title = $(this).val();
	or.debuger(title, documentid);
	if (title.length > 3) {
		TriggerCallback('origen_masterjob:server:UpdateBusinessDocument', {
			documentid,
			key: 'title',
			value: title
		}).done((cb) => {
			if (cb) {
				or.sendNotification('success', or.lang.succ_title_updt || 'The title has been updated correctly');
				$('.local .local-reports #report-' + documentid + ' .report-name').text(
					title
				);
			} else {
				or.sendNotification('error', or.lang.err_title_updt ||'An error has occurred when updating the title');
			}
		});
	} else {
		or.sendNotification('error', or.lang.err_3_letters || 'The title must have at least 3 characters');
	}
});

$(document).on('click', '.c-modal .photo-box-local', function () {
	const slot = $(this).data('slot');
	const name = $(this).data('name');
	const img = $(this).data('img');
	TriggerCallback('origen_masterjob:server:RemoveItem', {
		slot,
		name,
		amount: 1
	}).done((cb) => {
		if (cb) {
			$('.local .local-reports .evidences').append(`
                <div class="col-4 pt-2 scale-in">
                    <div class="evidence">
                        <img src="${img}">
                        <button class="btn text-white p-0 mt-2 delete-photo"><i class="lni lni-trash-can"></i></button>
                    </div>
                </div>
            `);
			CloseModal();
			localDocuments.updatePhotos();
		} else {
			CloseModal();

			or.sendNotification('error', or.lang.err_photo_add ||'A mistake has occurred when adding the photo');
		}
	});
});

$(document).on('click', '.local .local-reports .evidence .delete-evidence', function () {
	actualEvidencelocal = $(this).parent().parent();
	or.OpenModal(
		or.lang.atention || `ATENTION`,
		`<div class="row">
        <div class="col-2">
            <img src="./img/webp/trash.webp" class="img-fluid">
        </div>
        <div class="col-10 d-flex align-items-center">
            <div>
            <h5 class="text-danger fw-bold mb-3">${or.lang.del_eviden_def||'This action will eliminate the photo definitively.'}</h5>
            <h4>${or.lang.del_eviden_cont||'Do you want to continue?'}</h4>
            </div>
        </div>

    </div>`,
		`<button class="btn-modal" onclick="localDocuments.deleteEvidence()">Confirmar</button>`,
		or.lang.cancel || 'Cancel',
		50
	);
});

let localFunctions = {
	navigate: function (app) {
		if (canAccess(app)) {
			if ($('.app-container.activa').length > 0) {
				$('.app-container.activa').fadeOut(150, function () {
					$(this).removeClass('activa');
					$('.app-container.' + app)
						.fadeIn(300)
						.addClass('activa');
				});
			} else {
				$('.app-container.' + app)
					.fadeIn(300)
					.addClass('activa');
			}
			if (app != 'local-home') {
				$('.local .back-section')
					.removeClass('animate__fadeOutUp')
					.addClass('animate__fadeInDown')
					.fadeIn(300);
			} else {
				$('.local .back-section')
					.fadeOut(300)
					.removeClass('animate__fadeInDown')
					.addClass('animate__fadeOutUp');
			}
		}
	},

	checkFirstTime: () => {
		if ($(".app-button[app='local']").attr('access') == 'create') {
			localFunctions.resetCreator();
		} else if ($(".app-button[app='local']").attr('access') == 'mybusiness') {
			$('.local .local-creator').hide(300);

			localFunctions.loadlocal().then(() => {
				$('.app-container.local-home').fadeIn(300).addClass('activa');
			});

			$('.app-container.local-home').fadeIn(300).addClass('activa');
		}
	},

	modalAddRango: (type) => {
		or.OpenModal(
			or.lang.new_grade || 'New grade',
			`
            <small class="mb-3 text-center d-block text-muted fw-100">${or.lang.new_grade_desc ||'The payment of the indicated salary will be made by invoicing the company.In case the billing has not been enough, all ranges will obtain the same minimum symbolic collection, until the billing is sufficient.'}</small>
            <label>${or.lang.rank_name || 'Rank name'}</label>
            <input maxlength="25" type="text" class="form-control input-rango-name" placeholder="${or.lang.rank_name_d||'Enter the name of the range'}">
            <label class="mt-3">${or.lang.payment||'Payment'}</label>
            <input max="${MaxSocietySalary}" maxlength="4" type="number" class="form-control input-rango-salario" placeholder="${or.lang.payment_desc||'Enter the salary of the range'}">
            <div class="error d-none text-uppercase text-danger mt-2">${or.lang.err_n_grade||'The name must contain at least 3 characters'}</div>
        `,
			`<button class='btn-modal' onclick="localFunctions.crearRango(${type})">${or.lang.create||'Create'}</button>`,
			or.lang.cancel || 'Cancel',
			35
		);
	},

	crearRango: (type) => {
		let nombre = $('.input-rango-name').val();
		let salario = parseInt($('.input-rango-salario').val());
		$('.error').addClass('d-none');
		let error = '';

		let rangoCreado = false;
		const appClass = type ? '.local-creator' : '.local-settings';
		$('.local ' + appClass + ' .rangos-creados .rango .rango-name').each(function () {
			or.debuger(
				'Comprobando: ',
				or.nameToId($(this).text().trim()),
				nombre,
				or.nameToId(nombre) == or.nameToId($(this).text().trim())
					? 'Es igual'
					: 'No es igual'
			);
			if (or.nameToId($(this).text().trim()) == or.nameToId(nombre)) {
				rangoCreado = true;
			}
		});
		or.debuger(salario, $('.input-rango-salario').val());
		if (nombre.length >= 3 && !rangoCreado && salario > 0 && salario <= (MaxSocietySalary)) {
			//COMPRUEBA SI EL RANGO NO HA SIDO YA CREADO COMPARANDO SU POSIBLE ID CON LOS YA CREADOS
			$('.local .rangos-creados .rango.active').removeClass('active');
			if (type) {
				$('.local .local-creator .rangos-creados').append(`
                <div class="rango active scale-in" salario="${salario}" rango="${or.nameToId(
					nombre
				)}" >
                    <div class="icon">
                        <i class="lni lni-tag"></i>
                    </div>
                    <div class="rango-name" onclick="localFunctions.verPermisosRango('${or.nameToId(
						nombre
					)}')">
                        ${nombre}
                    </div>
                    <i class="lni lni-trash-can delete-rango" onclick="localFunctions.deleteRango('${or.nameToId(
						nombre
					)}')"></i>
                </div>
                `);
				$(
					'.local .local-creator .zona-permisos .permisos-tab.activa'
				).removeClass('activa');
				setTimeout(() => {
					$('.local .local-creator .zona-permisos').append(`
                    <div class="permisos-tab activa" rango="${or.nameToId(nombre)}">
                        ${permissionsListLocal}
                    `);
				}, 300);
				$('.local .local-creator .rangos-dispo').text(`
                    (${10 - $('.local .rangos-creados .rango').length} RANGOS DISPONIBLES)
                `);
				if (10 - $('.local .local-creator .rangos-creados .rango').length < 10) {
					$('.local .local-creator .button-continuar.first').fadeIn(300);
				} else {
					$('.local .local-creator .button-continuar.first').fadeOut(300);
				}
				or.sendNotification('success', 'Rango creado correctamente');

				CloseModal();
			} else {
				TriggerCallback('origen_masterjob:server:AddGrade', {
					data: { label: nombre, pay: salario }
				}).done((cb) => {
					or.debuger('RANGO: ', cb);
					if (cb) {
						$('.local .local-settings .rangos-creados').append(`
                            <div class="rango active scale-in" rango="${cb}" salario="${salario}" >
                                <div class="icon">
                                    <i class="lni lni-tag"></i>
                                </div>
                                <div class="rango-name" onclick="localFunctions.verPermisosRangoSettings('${cb}')">
                                    ${nombre}
                                </div>
                                <i class="lni lni-trash-can delete-rango" onclick="localFunctions.deleteRangoSettings('${cb}')"></i>
                            </div>
                            `);
						$(
							'.local .local-settings .zona-permisos .permisos-tab.activa'
						).removeClass('activa');
						setTimeout(() => {
							$('.local .local-settings .zona-permisos').append(`
                                <div class="permisos-tab activa" rango="${cb}">
                                    ${permissionsListLocal}
                                `);
						}, 300);
						$('.local .local-settings .rangos-dispo').text(`
                                (${
									10 -
									$('.local .local-settings .rangos-creados .rango')
										.length
								} Available ranges)
                            `);

							or.sendNotification('success', or.lang.succ_rank_creat || 'Rank created correctly');
					} else {
						or.sendNotification(
							'error',
							or.lang.err_rank_creat ||'An error has occurred when creating the range',
							or.lang.check_admin || 'Consult with administration'
						);
					}
				});
				CloseModal();
			}
		} else { 
			if (rangoCreado) {
				error += `<div>${ or.lang.err_rank_exist||'The range already exists'}</div>`;
			}
			if (!salario || salario == 0) {
				error += `<div>${or.lang.cant_empty ||'Cannot be empty or 0'}</div>`;
			}
			if (salario < 0) {
				error += `<div>${or.lang.err_sal_min || 'The salary cannot be less than 0'}</div>`;
			}
			if (salario > (MaxSocietySalary)) {
				var maxSalaryMessage = or.lang.err_sal_max ? or.lang.err_sal_max.replace('%s', (MaxSocietySalary)) : `The salary cannot be greater than ${(MaxSocietySalary)}`;
				error += `<div>${maxSalaryMessage}</div>`;
			}
			if (nombre.length < 3) {
				error += `<div>${or.lang.err_3_letters ||'The name must contain at least 3 characters'}</div>`;
			}
			$('.error').html(error).removeClass('d-none');
		}
	},

	verPermisosRango: function (id) {
		$('.local .local-creator .rangos-creados .rango.active').removeClass('active');
		$('.local .local-creator .rangos-creados .rango[rango=' + id + ']').addClass(
			'active'
		);
		$('.local .local-creator .zona-permisos .permisos-tab.activa').removeClass(
			'activa'
		);
		setTimeout(() => {
			$(
				'.local .local-creator .zona-permisos .permisos-tab[rango=' + id + ']'
			).addClass('activa');
		}, 150);
	},

	deleteRango: (id) => {
		$('.local .local-creator .rangos-creados .rango[rango=' + id + ']').remove();
		$(
			'.local .local-creator .zona-permisos .permisos-tab[rango=' + id + ']'
		).remove();
		$('.local .local-creator .rangos-dispo').text(`
            (${
				10 - $('.local .local-creator .rangos-creados .rango').length
			} Available ranges)
        `);
		if (10 - $('.local .local-creator .rangos-creados .rango').length < 10) {
			$('.local .local-creator .button-continuar.first').fadeIn(300);
		} else {
			$('.local .local-creator .button-continuar.first').fadeOut(300);
		}
	},

	siguientePaso: (paso) => {
		$('.local .local-creator .pasos.activa').fadeOut(300, function () {
			$(this).removeClass('activa');
			$('.local .local-creator .pasos.' + paso).fadeIn(300, function () {
				$(this).addClass('activa');
			});
		});
	},

	loadlocal: () => {
		or.debuger('LLego a load local');
		return new Promise(function (resolve, reject) {
			TriggerCallback('origen_masterjob:server:GetBusiness', {}).done((cb1) => {
				or.exportEvent('origen_masterjob', 'Get_Config', {}).done((cb2) => {
					configLocal = JSON.parse(cb2);
					or.debuger('Configuración cargada.', configLocal);
					or.debuger('CB GetBusiness', cb1);
					if (cb1) {
						or.fetch('GetMyJob', {}).done((cb3) => {
							// or.debuger(cb, cb.level, parseInt(cb.level));
							myGrade = parseInt(cb3.grade.level);
							setServicio(cb3.onduty);
							localFunctions.updatelocal(cb1);
							resolve();
						});
					}
				});
			});
		});
	},

	updatelocal: (cb) => {
		or.debuger('UPDATE LOCAL: ', cb);
		if (!configLocal) return;
		$(
			'.local .local-home .local-title .title, .local .local-settings .local-title'
		).text(cb.label);
		$('.local .local-home .data.miembros').text(cb.players.length);
		// $(".local .local-stat .data.territorios").text(cb.territories.length);
		localFunctions.updateMembers(cb.players, cb.grades);
		localData = cb;
		setOpen(localData.open === 1 ? true : false);
		cb.metadata.LabelChanged ? $('.local #changelocalLabel').remove() : null;

		localFunctions.updateTerritories();
		let totalDuty = 0;
		let employeesList = '';
		const expulsar = canAccess('rrhh', 1);

		if (canAccess('safebox', 1)) {
			$('.transfer-menu').css('display', 'flex');
		} else {
			$('.transfer-menu').css('display', 'none');
		}

		localData.players?.map((player) => {
			if (player.onduty) {
				totalDuty++;
				employeesList += `
                <div class="employee d-flex justify-content-between align-items-center">
                    <div><i class="fa-regular fa-user"></i>
                    ${player.name}
					</div>
					${
						expulsar
							? `<button class="btn btn-action p-0 ps-1 pe-2 expulsar-servicio" citizenid="${player.citizenid}">${or.lang.remove_serv||'Remove from service'}</button>`
							: ''
					}

                </div>
                `;
			}
		});

		$('.local .members .registro-laboral').html('');
		localData.stats.duty?.map((player) => {
			$('.local .members .registro-laboral').prepend(`
            <div class="item-flex-box justify-content-between">
                ${
					player.duty
						? `<i class="fa-solid fa-right-to-bracket icon success"></i>`
						: `<i class="fa-solid fa-clock-rotate-left icon red"></i>`
				}
                <div class="item-flex-box-data w-100">
                    <div class="title">
                        ${player.name}
                    </div>


                </div>
                <div class="description badge-acent bg-dark me-1">
                    ${new Date(player.hour).toLocaleDateString('es-ES')}


                </div>
                <div class="description badge-acent">
                    ${new Date(player.hour).toLocaleTimeString('es-ES', {
						hour12: false,
						hour: '2-digit',
						minute: '2-digit'
					})}

                </div>

            </div>
            `);
		});

		$('.local .zona-servicio .employees-list').html(employeesList);

		$('.local .local-level').text(localData.level);
		$('.local .next-level').text((or.lang.level || 'LEVEL ') + (localData.level + 1));
		$('.local .progress-bar.nivel .progress-bar-fill').css(
			'width',
			(localData.experience * 100) /
				((localData.level + 1) * configLocal.BusinessLevelFactor) +
				'%'
		);
		$('.local-stat .n-empleados').text(localData.players.length);

		$('.local-stat .en-servicio').text(totalDuty);

		$('.local-stat .capital').text(localData.money);

		const ctx = document.getElementById('grafica-business');

		if (!businessStats || businessStats.length != localData.stats.money.length) {
			if (graficaBusiness) {
				graficaBusiness.destroy();
			}

			businessStats = localData.stats.money;
			const dates = localData.stats.money
				? localData.stats.money.map((data) => data.date)
				: [];
			const money = localData.stats.money
				? localData.stats.money.map((data) => data.money)
				: [];

			// or.debuger(dates, money);

			graficaBusiness = new Chart(ctx, {
				type: 'line',
				data: {
					labels: dates,
					datasets: [
						{
							label: or.lang.dalily_cap || 'Daily capital (14 days)',
							data: money,
							borderWidth: 2,
							backgroundColor: 'white',
							borderColor: 'white'
						}
					]
				},
				options: {
					scales: {
						y: {
							beginAtZero: true,
							grid: {
								color: '#ce1d754a'
							}
						},
						x: {
							grid: {
								color: '#ce1d754a'
							}
						}
					},
					plugins: {
						legend: {
							labels: {
								color: 'white',
								font: {
									size: 18,
									family: 'Bebas Neue'
								}
							}
						}
					}
				}
			});
		}
	},
/// continuar
	showAddArmor: () => {
		or.OpenModal(
			`Adquisición de armamento`,
			`
                HOLA
            `,
			`<div></div>`,
			'SALIR'
		);
	},

	resetCreator: () => {
		$('.local .local-creator .rangos-creados').html('');
		$('.local .local-creator .zona-permisos').html('');
		$('.local .local-creator .rangos-dispo').text(`
            (10 RANGOS DISPONIBLES)
        `);
		$('.local .local-creator .button-continuar').hide();
		$('.local .local-creator .input-local-title').val('');

		$('.local .local-creator .pasos.activa').removeClass('activa');
		$('.local .local-creator .pasos.uno').addClass('activa').show();

		$('.app-container').hide().removeClass('activa');
		$('.app-container.local-creator').show().addClass('activa');
	},

	updateMembers: (members, grades) => {
		// $(".local .local-home .members-list").html("");
		$('.local .local-settings .members-list').html('');
		// $('.num-empleados').text('Total employees: ' + members.length);
		$('.num-empleados').text(`${or.lang.total_employees || 'Total employees'}: ${members.length}`);
		members.map((member) => {
			// or.debuger(member, grades);
			// $(".local .local-home .members-list").append(`
			//     <div class="item-flex-box justify-content-between">
			//         <img src="./img/3NvxEqR.png" class="car-icon">
			//         <div class="item-flex-box-data w-100">
			//             <div class="title">
			//                 ${member.name}
			//             </div>
			//             <!-- <button class="btn-action btn-sm">Solicitar a grua</button> -->
			//             <div class="description badge-acent">
			//                 ${grades[member.grade].label}
			//             </div>
			//         </div>
			//         <!--<button class="btn-action">
			//             <i class="fas fa-user-cog" aria-hidden="true"></i>
			//         </button>-->
			//     </div>
			// `);
			$('.local .local-settings .members-list').append(`
                <div class="item-flex-box justify-content-between" onclick="localFunctions.modalSettingMember('${
					member.citizenid
				}', '${member.name}', ${member.grade})">
                    <img src="./img/3NvxEqR.png" class="car-icon">
                    <div class="item-flex-box-data w-100">
                        <div class="title">
                            ${member.name}
                        </div>
                        <!-- <button class="btn-action btn-sm">Solicitar a grua</button> -->
                        <div class="description badge-acent">
                            ${
								grades[member.grade]
									? grades[member.grade].label
									: or.lang.stranger || 'A stranger'
							}
                        </div>
                    </div>
                    <i class="fas fa-cog"></i>

                </div>
            `);
		});
	},

	modalSettingMember: (citizenid, name, memberGrade) => {
		let options = '';
		Object.entries(localData.grades).map((grade) => {
			// or.debuger(grade);
			let acceso = '';

			//CREO UNA VARIABLE AUXILIAR PARA GUARDAR EL PARÁMETRO QUE LE INDICA AL SELECT CUAL DEBE MOSTRARSE ACTIVO. SE MOSTRARÁ EL GRADO CUYO ID RECOGIDO EN memberGrade coincida con el valor de la posición 0 de grade
			let selected = grade[0] == memberGrade ? 'selected' : '';

			grade[1].boss ? (acceso = '(Acceso total)') : (acceso = '');
			options += `<option ${selected} value="${grade[0]}">${grade[1].label} ${acceso}</option>`;
		});

		or.OpenModal(
			or.lang.men_mang || 'Member management',
			`
           <div class="text-center">
            <h1>${name}</h1>
            <label class="mt-3">${or.lang.grade||'Member range'}</label>
            <select onchange="localFunctions.changeMemberRange('${citizenid}')" class="form-control form-rango-local mt-2">
                ${options}

            </select>
            <label class="mt-3 w-100">${or.lang.actions ||'Actions'}</label>
            <button class="btn btn-danger w-100 mt-1" onclick="localFunctions.removelocal('${citizenid}')">${or.lang.expel||'Expel'}</button>
           </div>
        `,
			`<div></div>`,
			or.lang.back || 'Close',
			35
		);
	},

	modalNewMember: () => {
		or.debuger('modalNewMember')
		or.fetch('GetClosestPlayers', { local: localData.id }).done((cb) => {
			or.debuger(cb)

			let html =
				`<small class='text-center text-uppercase text-muted d-block'>${or.lang.not_clst || 'There is no one around'}</small>`;

			if (cb.length != 0) {
				html = '';
				cb.map((player) => {
					html += `
                        <div class="member" onclick="localFunctions.addMember('${player.citizenid}', '${player.firstname} ${player.lastname}')">
                            <i class="fas fa-user"></i> ${player.firstname} ${player.lastname}
                        </div>
                    `;
				});
			}

			or.OpenModal(
				or.lang.add_menber || 'Add Member',
				`
                <h4 class="w-100 text-center">${ or.lang.clst_pp||'Close people'}</h4>
               <div class="add-member-list">
                    ${html}
               </div>
            `,
				`<button class="btn btn-modal" onClick="localFunctions.updateSearchMember()">${or.lang.continue || 'Update'}</button>`,
				or.lang.back ||'Close',
				35
			);
		});
	},

	updateSearchMember: () => {
		or.fetch('GetClosestPlayers', { local: localData.id }).done((cb) => {
			// or.debuger(cb);

			let html =
				`<small class='text-center text-uppercase text-muted d-block'>${or.lang.not_clst || 'There is no one around'}</small>`;

			if (cb.length != 0) {
				html = '';
				cb.map((player) => {
					html += `
                        <div class="member" onclick="localFunctions.addMember('${player.citizenid}', '${player.firstname} ${player.lastname}')">
                            <i class="fas fa-user"></i> ${player.firstname} ${player.lastname}
                        </div>
                    `;
				});
			}

			$('.add-member-list').html(html);
		});
	},

	addMember: (citizenid, name) => {
		//CloseModal();
		let html = '';
		// or.debuger(localData);
		Object.entries(localData.grades).map(([i, grade]) => {
			// or.debuger(grade, i);
			html += `
                <div class="member d-flex justify-content-between align-items-center" onclick="localFunctions.addMemberGrade('${citizenid}', '${i}')">
                    <div><i class="fas fa-fan me-2"></i> ${grade.label}</div> ${
				grade.boss ? `<span class='badge badge-acent'>${or.lang.total_acc || 'TOTAL ACCESS'}</span>` : ''
			}
                </div>
            `;
		});
		or.OpenModal(
			or.lang.rank_select || 'Range Selection',
			`
            <small class="w-100 text-center d-block text-uppercase w-100">${ or.lang.chang_rank || 'Choose the range to assign'} ${name}</small>
           <div class="add-member-list">
                ${html}
           </div>
        `,
			`<div></div>`,
			 or.lang.back || 'Cerrar',
			45
		);
	},

	addMemberGrade: (citizenid, grade) => {
		TriggerCallback('origen_masterjob:server:SendInvite', {
			citizenid,
			grade
		}).done((cb) => {
			// or.debuger(cb);
			if (cb) {
				or.sendNotification(
					'success',
					or.lang.inv_send || 'Invitation sent',
					or.lang.inv_send_desc || 'The invitation has been sent correctly.The player will receive a notification on his screen.'
				);
				CloseModal();
			}
		});
	},

	sendLocalInvitation: (id, label, grade, gradelabel) => {
		// CloseModal();
		$.post('https://origen_masterjob/focuson', JSON.stringify({}));
		or.OpenModalInvi(
			or.lang.inv_recibed || 'You have received an invitation',
			`   <div class="text-center">
                    <h3>You have received an invitation to join</br>${label}</h3>
                    <h4 class="mt-3">The assigned range is <b>${gradelabel}</b></h4>
                    <div class="text-uppercase">${or.lang.inv_acept_qst||'Do you want to accept the invitation?'}</div>
                </div>
            `,
			`<button class="btn btn-modal" onclick="localFunctions.acceptInvitation('${id}', ${grade})">${or.lang.inv_acp||'Accept invitation'}</button>`,
			or.lang.inv_dng || 'Denegar invitación',
			80
		);
	},

	acceptInvitation: (id, grade) => {
		TriggerCallback('origen_masterjob:server:AcceptInvite', {
			id,
			grade
		}).done((cb) => {
			// or.debuger(cb);
			if (cb) {
				CloseModal();
				$.post('https://origen_masterjob/focusoff', JSON.stringify({}));
				or.sendNotification(
					'success',
					or.lang.inv_scc || 'Accepted invitation',
					or.lang.inv_scc_desc || 'You have accepted the invitation correctly.Now part of a business is part.'
				);
				$(".app-button[app='local']")
					.attr('access', 'mybusiness')
					.addClass('accesible');
			}
		});
	},


	removelocal: (citizenid) => {
		or.OpenModal(
			or.lang.expel || 'Expel member',
			`   <div class="text-center">
                    <h3 class="text-danger">${or.lang.expel_qst||'Are you sure you want to expel this employee?'}</h3>
                </div>
            `,
			`<button class="btn btn-modal" onclick="localFunctions.removelocalConfirm('${citizenid}')">${or.lang.expel || 'Expel'}</button>`,
			or.lang.back || 'Cancel',
			80
		);
	},

	removelocalConfirm: (citizenid) => {
		TriggerCallback('origen_masterjob:server:KickPlayer', { citizenid }).done(
			(cb) => {
				// or.debuger(cb);
				if (cb == true) {
					or.sendNotification(
						'success',
						or.lang.expel_scc || 'Expelled member',
						or.lang.expel_scc_dec || 'You have ejected the employee correctly.'
					);
					CloseModal();
				} else {
					or.sendNotification('error', cb);
					CloseModal();
				}
			}
		);
	},
	changeMemberRange: (citizenid) => {
		let grade = $('.form-rango-local').val();
		CloseModal();

		TriggerCallback('origen_masterjob:server:ModifyPlayer', {
			citizenid,
			grade
		}).done((cb) => {
			if (cb == true) {
				or.sendNotification(
					'success',
					or.lang.grade_change || 'Grade changed',
					 or.lang.grade_change_desc || 'You have changed the employee rank correctly.'
				);
			} else {
				or.sendNotification('error', cb);
			}
		});
	},

	modallocalLabel: () => {
		if (!canAccess('jefe')) {
			return;
		}
		or.OpenModal(
			or.lang.change_buss || 'Change business name',
			`
           <div class="text-center">
            <h1>${localData.label}</h1>
            <label class="mt-3">${or.lang.new_name ||'New business name'}</label>
            <input type="text" class="form-control form-nombre-local mt-2">
           </div>
        `,
			`<button class="btn btn-modal" onclick="localFunctions.changelocalLabel()">${or.lang.rename||'Rename'}</button>`,
			or.lang.back || 'Cerrar',
			55
		);
	},

	changelocalLabel: () => {
		let label = $('.form-nombre-local').val();

		label = label.replace(/(<([^>]+)>)/gi, '');

		//Comprueba que label no está vacío y que mínimo tiene 3 caracteres
		if (label.length < 3) {
			or.sendNotification(
				'error',
				or.lang.name_short ||'Name too short',
				or.lang.err_n_grade || 'The name must have at least 3 characters.'
			);
			return;
		} else {
			CloseModal();

			TriggerCallback('origen_masterjob:server:ChangeLabel', { label }).done(
				(cb) => {
					// or.debuger(cb);
					if (cb) {
						or.sendNotification(
							'success',
							or.lang.name_change || 'Name changed',
							or.lang.change_correct || 'You have changed the business name correctly.'
						);
						localData.label = label;
						// $(".app-button[app='locales']").attr("label", label);
						$('.local-name').text(label);
					} else {
						or.sendNotification(
							'error',
							or.lang.err_change || 'An error has happened when changing the name',
							or.lang.check_admin || 'Consult with administration.'
						);
					}
				}
			);
		}
	},

	updateGrades: () => {
		const grades = localData.grades;
		$('.local .local-settings .rangos-list .rangos-creados').html('');
		$('.local .local-settings .zona-permisos').html('');
		let first = true;
		$('.local .local-settings .rangos-dispo').text(
			'(' + (10 - Object.entries(grades).length) + ' RANGOS DISPONIBLES)'
		);
		Object.entries(grades).map(([index, grade]) => {
			// or.debuger('Cargando a', grade.label);
			$('.local .local-settings .rangos-list .rangos-creados').append(`
            <div class="rango ${first ? 'active' : ''}" rango="${index}" >
                <div class="icon">
                    <i class="lni lni-tag"></i>
                </div>
                <div class="rango-name" onclick="localFunctions.verPermisosRangoSettings('${index}')">
                    ${grade.label}
                </div>
                <i class="lni lni-trash-can delete-rango" onclick="localFunctions.deleteRangoSettings('${index}')"></i>
            </div>
            `);

			$('.local .local-settings .zona-permisos').append(`
            <div class="permisos-tab ${first ? 'activa' : ''}" rango="${index}">
                <div class="permiso align-items-end">
                    <div class="permiso-info me-2">
                        <div class="permiso-title">${or.lang.salary_rank||'Rank Salary'}</div>
                        <div class="permiso-description"><input class="form-control input-salario" type="number" placeholder="${or.lang.payment_desc||'Enter the salary'}" value="${
							grade.pay
						}"></div>
                    </div>
                    <div class="btn-action btn-salario h-auto" rango="${index}">${or.lang.save || 'SAVE'}</div>
                </div>
                <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.total_acc||'Total Access'}</div>
                    <div class="permiso-description">${or.lang.total_acc_desc||'It allows members of this range to access and manage all functions.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo boss" permiso="boss" ${
							grade.boss ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.hum_resc||'Human Resources'}</div>
                    <div class="permiso-description">${or.lang.hum_resc_desc ||'Allows members of this range to hire and fire personnel in your business.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo rrhh" permiso="rrhh" ${
							grade.rrhh ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.art_mang || 'Articles management'}</div>
                    <div class="permiso-description">${ or.lang.art_mang_desc||'Allows members of this range to access and manage your business articles.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo articles" permiso="articles" ${
							grade.articles ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.veh_management || 'Vehicle management'}</div>
                    <div class="permiso-description">${ or.lang.veh_management_desc|| 'Allows members of this range to access and manage your business vehicles.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo vehicles" permiso="vehicles" ${
							grade.vehicles ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.acc_garg||'Access to garage'}</div>
                    <div class="permiso-description">${or.lang.acc_garg_desc ||'It allows members of this range to access the garage and use vehicles.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo garajes" permiso="garajes" ${grade.garajes ? 'checked' : ''}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.acc_radio || 'Radio access'}</div>
                    <div class="permiso-description">${ or.lang.acc_radio_desc || 'It allows members of this range to access the radio channels of the premises.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo radio" permiso="radio" ${
							grade.radio ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${ or.lang.open_buss||'Open/close local'}</div>
                    <div class="permiso-description">${ or.lang.open_buss_desc||'Allows members of this range to access or close the place of your business.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo openclose" permiso="openclose" ${
							grade.openclose ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.billing||'Billing'}</div>
                    <div class="permiso-description">${or.lang.billing_desc||'It allows members of this range to create invoices to deliver to customers.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo bills" permiso="bills" ${
							grade.bills ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.acc_warh||'Access to the warehouse'}</div>
                    <div class="permiso-description">${ or.lang.acc_warh_desc||'Allows members of this range to access the warehouse.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo inventory" permiso="inventory" ${
							grade.inventory ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            <div class="permiso">
                <div class="permiso-info">
                    <div class="permiso-title">${or.lang.acc_safe||'Access to the safe'}</div>
                    <div class="permiso-description">${ or.lang.acc_safe_desc||'Allows members of this range to access the safe of your business.'}</div>
                </div>
                <div class="check">
                    <label class="switch">
                        <input type="checkbox" class="check-dispo safefox" permiso="safebox" ${
							grade.safebox ? 'checked' : ''
						}>
                        <span class="slider-check round"></span>
                    </label>
                </div>
            </div>
            </div>

            `);

			first = false;
		});
	},
// continuarhakos
	verPermisosRangoSettings: function (id) {
		$('.local .local-settings .rangos-creados .rango.active').removeClass('active');
		$('.local .local-settings .rangos-creados .rango[rango=' + id + ']').addClass(
			'active'
		);
		$('.local .local-settings .zona-permisos .permisos-tab.activa').removeClass(
			'activa'
		);
		setTimeout(() => {
			$(
				'.local .local-settings .zona-permisos .permisos-tab[rango=' + id + ']'
			).addClass('activa');
		}, 150);
	},

	deleteRangoSettings: (id) => {
		or.OpenModal(
			or.lang.delete  || `Delete Range`,
			`<h3 class="text-warning text-center">${or.lang.delete_rank ||'You will eliminate this range and all the members assigned it'}</h3>
        <p class="text-center mt-4"><span class="text-uppercase">${or.lang.are_sure || 'Are you sure you want to eliminate it?'}</span></br>${or.lang.rank_deleted_desc || 'The members within the range will be expelled.'}</p>
        `,
			`<button class="btn btn-modal" onclick="localFunctions.deleteRangoConfirm('${id}')">${or.lang.delete ||'Delete'}</button>`,
			or.lang.back || `Cancel`,
			80
		);
	},

	deleteRangoConfirm: (id) => {
		CloseModal();
		TriggerCallback('origen_masterjob:server:RemoveGrade', { grade: id }).done(
			(cb) => {
				if (cb == true) {
					$(
						'.local .local-settings .rangos-creados .rango[rango=' + id + ']'
					).remove();
					$(
						'.local .local-settings .zona-permisos .permisos-tab[rango=' +
							id +
							']'
					).remove();
					$('.local .local-settings .rangos-dispo').text(`
                    (${
						10 - $('.local .local-settings .rangos-creados .rango').length
					} RANGOS DISPONIBLES)
                `);
					or.sendNotification('success', or.lang.succ_rank_prop_deled || 'Rank properly eliminated.');
				} else {
					or.sendNotification('error', cb);
				}
			}
		);
	},

	updateTerritories: () => {
		$('.local .local-settings .lista-puntos').html('');
		let html = '';
		localData.npcs.map((npc) => {
			html += `
            <div class="item-flex-box justify-content-between" style="width:98%" onclick="localFunctions.markerModalSettingsNpc('${npc.name}', ${npc.code})">
                <img src="./img/CcQrXaU.png" class="car-icon">
                <div class="item-flex-box-data">
                    <div class="title">
                        ${npc.name}
                    </div>
                </div>
                <i class="fas fa-cog"></i>
            </div>`;
		});

		localData.markers.map((marker) => {
			html += `
            <div class="item-flex-box justify-content-between" onclick="localFunctions.markerModalSettings('${
				configLocal.Markers[marker.type].label
			}', ${marker.code}, '${marker.type}')">
              <img src="./img/xRpNJN1.png" class="car-icon">
              <div class="item-flex-box-data">
                <div class="title">
                  ${configLocal.Markers[marker.type].label}
                </div>
              </div>
              <i class="fas fa-cog"></i>
            </div>
          `;
		});

		$('.local .local-settings .lista-puntos').append(`
        <div class="territorio">
            ${html}
        </div>
        `);
		$('.local .local-settings .total-territories').text(
			`${localData.markers.length} ${
				localData.markers.length == 1 ? or.lang.point_asing || 'PUNTO ASIGNADO' : or.lang.point_asings || 'PUNTOS ASIGNADOS'
			}`
		);
	},

	modalAddPoints: () => {
		if (!canAccess('jefe')) {
			return;
		}
		let html = '';
		// $(".c-modal .puntos-list").hide();
		// $(".c-modal .territorios-list").show();
		const auxArray = [];
		// Recorremos el primer objeto
		for (let key in configLocal.Markers) {
			// or.debuger(key, configLocal.Markers[key]);

			if (
				!configLocal.Markers[key].type ||
				configLocal.Markers[key].type == localData.type
			) {
				if (configLocal.Markers[key].max) {
					if (
						localData.markers.filter((marker) => marker.type == key).length <
						configLocal.Markers[key].max
					) {
						auxArray.push({
							key: key,
							label: configLocal.Markers[key].label
						});
					}
				} else {
					if (!localData.markers.some((marker) => marker.type == key)) {
						auxArray.push({
							key: key,
							label: configLocal.Markers[key].label
						});
					}
				}
			}
		}
		// or.debuger(auxArray);

		if (auxArray.length > 0) {
			auxArray.map((marker) => {
				html += `
                <div class="item-flex-box" onclick="localFunctions.addPoint('${marker.key}')">
                    <img src="./img/xRpNJN1.png" class="icon">
                    <div class="item-flex-box-data">
                        <div class="title-item">
                            ${marker.label}
                        </div>
                    </div>
                </div>
                `;
			});
		} else {
			html = `
                <div class="item-flex-box">
                    <div class="item-flex-box-data">
                        <div class="title-item">
                            ${or.lang.alrd_add_points ||'You have already added all the points available.'}
                        </div>
                    </div>
                </div>
            `;
		}

		$('.c-modal .puntos-list').html(html).fadeIn(300);

		or.OpenModal(
			or.lang.add_point || `Add Point`,
			`<h3 class="text-center">${or.lang.chang_point_add ||'Choose the point type you want to add'}</h3>
            <div class="data-list-territorio">
                <div class="territorios-list">
                    ${html}
                </div>
                <div class="puntos-list">

                </div>
            </div>

            `,
			`<div></div>`,
			or.lang.back || `Cancel`,
			50
		);
	},

	addPoint: (type) => {
		or.closeMenu();
		setTimeout(() => {
			CloseModal();
		}, 1000);
		or.exportEvent('origen_masterjob', 'AddMarker', {
			type: type
		});
	},

	markerModalSettings: (name, code, type) => {
		if (!canAccess('jefe')) {
			return;
		}
		or.OpenModal(
			or.lang.mod_point || `Modify point`,
			`<h3 class="text-center">${name}</h3>
             <button class="btn btn-modal w-100 mt-3" onclick="localFunctions.moveMarker(${code}, '${type}')">${or.lang.chose_new_pos||'Choose new position'}</button>

            `,
			`<div></div>`,
			or.lang.back ||`Cancel`,
			50
		);
	},
// 	<div class="col-12 mt-3">
// 	<label>Mensaje de voz</label>
// </div>
// <div class="col-8">
// 		<input class="form-control w-100 input-voz h-100" placeholder="Enter what the NPC will say">
// 	</div>
// 	<div class="col-4">
// 		<button class="btn btn-modal w-100" onclick="localFunctions.saveVoice(${code})">
// 		Keep
// 		</button>
// 	</div>
// </div>

	markerModalSettingsNpc: (name, code) => {
		if (!canAccess('jefe')) {
			return;
		}
		or.OpenModal(
			or.lang.mod_point || `Modify point`,
			`<h3 class="text-center">${name}</h3>
             <button class="btn btn-modal w-100 mt-3" onclick="localFunctions.moveNPC(${code})">${or.lang.chose_new_pos || 'Choose new position'}</button>
             <div class="mt-3 row">
				<div class="col-12">
					<label>${or.lang.animation || 'Animation'}</label>
				</div>
                <div class="col-8">
                    <input class="form-control w-100 input-anim h-100" placeholder="${or.lang.animation_desc||'Enter animation (Ej: e sit)'}">
                </div>

                <div class="col-4">
                    <button class="btn btn-modal w-100" onclick="localFunctions.changeAnimation(${code})">
                    Keep
                    </button>
                </div>
            `,
			`<div></div>`,
			or.lang.back || `Cancel`,
			50
		);
	},
	changeAnimation: (code) => {
		const anim = $('.c-modal .input-anim').val().trim();
		if (anim.length < 1) {
			or.sendNotification('error', or.lang.cant_empty || 'Animation cannot be empty');
		} else {
			TriggerCallback('origen_masterjob:server:UpdateNpcAnim', {
				code: code + '',
				anim
			}).done((cb) => {
				if (cb === true) {
					or.sendNotification(
						'success',
						or.lang.change_correct || 'The animation has been saved correctly',
						'If animation does not work, check that you have chosen a correct animation'
					);
				} else {
					or.sendNotification('error', cb);
				}
			});
		}
	},
	saveVoice: (code) => {
		const speech = $('.c-modal .input-voz').val().trim();
		if (speech.length < 5) {
			or.sendNotification('error', or.lang.no_more_long || 'The message must be longer');
		} else if (speech.length > 150) {
			or.sendNotification('error', or.lang.more_long || 'The message cannot be so long');
		} else {
			TriggerCallback('origen_materjob:server:UpdateNpcSpeech', {
				code: code + '',
				speech
			}).done((cb) => {
				if (cb === true) {
					or.sendNotification(
						'success',
						or.lang.change_correct ||'The message has been saved correctly',
						or.lang.speck_npc_mang || 'Now the NPC will say the message you have written when you interact with someone.'
					);
				} else {
					or.sendNotification('error', cb);
				}
			});
		}
	},
	moveMarker: (code, type) => {
		or.closeMenu();
		setTimeout(() => {
			CloseModal();
		}, 1000);
		or.exportEvent('origen_masterjob', 'MoveMarker', {
			markercode: `${code}`,
			type
		});
	},

	moveNPC: (code) => {
		or.closeMenu();
		setTimeout(() => {
			CloseModal();
		}, 1000);
		or.exportEvent('origen_masterjob', 'MoveNPC', {
			code: `${code}`
		});
	},

	newReport: () => {
		$('.local-reports .citizen-ficha').fadeOut(300, function () {
			TriggerCallback('origen_masterjob:server:CreateBusinessDocument', {}).done(
				(cb) => {
					// or.debuger(cb);

					if (cb) {
						let date = or.timeStampToDate(cb.date);

						$('.local-reports .citizen-ficha').html(`
                    <div class="row ficha" reportid="${cb.id}">
                        <div class="col-12 pe-3 ps-3">
                            <input class="report-title form-control w-100" value="Untitled document #${cb.id}" placeholder="${or.lang.document || 'Document name'}">
                        </div>
                        <div class="col-6 pe-1">
                            <div class="info-box m-1 mt-2">
                                <div class="notes-title d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-quote-right" aria-hidden="true"></i> ${or.lang.archive || 'Notas'}</h4>
                                    <div class="new-button new-note" onclick="localFunctions.newNote()"><i class="fas fa-plus" aria-hidden="true"></i>${or.lang.new_note||' New note'}</div>
                                </div>
                                <div class="citizen-info-container mt-2">
                                    <ul class="list-group notes-list-pinned">


                                    </ul>                
                                    <ul class="list-group notes-list mt-2">

                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 ps-1">
                            <div class="info-box m-1 mt-2">
                                <div class="notes-title d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-quote-right" aria-hidden="true"></i> ${or.lang.photographs}</h4>
                                    <div class="new-button add-prueba" onclick="localDocuments.addPhotoModal(${cb.id})"><i class="fas fa-plus" aria-hidden="true"></i> ${or.lang.add_new_phot||'Add photography'}</div>
                                </div>
                                <div class="citizen-info-container mt-2">
                                    <div class="row evidences w-100 m-0">

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 text-center">
                            <button class="btn btn-danger delete-report mt-1" onclick="localDocuments.modalRemoveDocument(${cb.id})"><i class="lni lni-trash-can"></i> ${or.lang.delete || 'Destroy'}</button>
                        </div>
                    </div>
                    `);
						$('.local-reports .report-list .report').length == 0
							? $('.local-reports .report-list').html(``)
							: null;
						$('.local-reports .report-list .report.selected').removeClass(
							'selected'
						);
						$('.local-reports .report-list').append(`
                    <div class="white-block report scale-in selected" id="report-${
						cb.id
					}" onclick="localFunctions.loadInforme(${cb.id})">
                        <i class="fas fa-sticky-note" aria-hidden="true"></i>
                    <div class="report-name">
                        Untitled document #${cb.id}
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
                                    <span>${date.date + ' - ' + date.time}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    `);
						$('.local-reports .citizen-ficha').fadeIn(300);
					} else {
						or.sendNotification(
							'error',
							or.lang.err_documt_obt ||'An error has occurred when creating the document'
						);
						$('.local-reports .citizen-ficha')
							.html(
								`
                            <div class="d-flex w-100 align-content-start justify-content-around flex-wrap" style="height: 73vh">
                                    <h1>
                                       ${or.lang.doc_select_desc || `Select a document to load your information`}
                                    </h1>
                                    <img src="./img/webp/document.webp">
                                </div>
                    `
							)
							.fadeIn(300);
					}
				}
			);
		});
	},

	newNote: () => {
		const noteHtml = `
            <li class="list-group-item list-group-item-action scale-in">
                <h5><input class="input note-title w-100" placeholder="Note title"></h5>
                <p><textarea rows="4" class="input note-text w-100 mt-1" placeholder="${or.lang.note_text || 'Note text'}"></textarea></p>
                <div class="d-flex justify-content-between mt-2">
                    <div class="btn btn-secondary cancel-note-button btn-sm me-2">${or.lang.back || 'Cancel'}</div>
                    <div class="btn btn-secondary new-note-button btn-sm" onclick="localFunctions.saveNewNote($(this))">${or.lang.save || 'Save'}</div>
                </div>
            </li>`;
		if ($('.local .local-reports .notes-list .no-notes').length > 0) {
			$('.local .local-reports .notes-list .no-notes').fadeOut(300, function () {
				$(this).remove();
				$('.local .local-reports .notes-list').append(noteHtml);
			});
		} else {
			$('.local .local-reports .notes-list').prepend(noteHtml);
		}
	},

	saveNewNote: (button) => {
		const title = button.parent().parent().find('.note-title').val();
		const description = button.parent().parent().find('.note-text').val();
		const documentid = $('.citizen-ficha .ficha').attr('reportid');
		const note = button;
		let params = { documentid, title, description };
		if (title.length > 0 && description.length > 0) {
			TriggerCallback('origen_masterjob:server:CreateBusinessNote', params).done(
				(cb) => {
					if (cb) {
						//Transforma cb.note que se encuetra en Timestamp en 2 constantes para fecha y hora
						const date = or.timeStampToDate(cb.date * 1000);
						note.parent()
							.parent()
							.removeClass('scale-in')
							.addClass('scale-out')
							.fadeOut(300, function () {
								button.remove();
								$(
									'.local .local-reports .citizen-ficha .notes-list'
								).prepend(`
                        <li class="list-group-item list-group-item-action scale-in" note-id="${cb.id}">
                            <h5>${title}</h5>
                            <p>${description}</p>
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
				}
			);
		}
	},

	loadInforme: (id) => {
		TriggerCallback('origen_masterjob:server:GetBusinessDocument', { id }).done(
			(cb) => {
				if (cb) {
					// or.debuger(cb);
					let citizenNotes = '';
					let citizenNotesPinned = '';
					if (cb.notes.length > 0) {
						cb.notes.map(function (note) {
							const date = or.timeStampToDate(note.date);
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
                    <h5>${or.lang.not_register_note || 'There are no registered notes'}</h5>
                </li>`;
					}

					let evidences = '';
					if (cb.images && or.isJsonString(cb.images)) {
						const evidencesList = JSON.parse(cb.images);

						evidencesList.forEach((evidence) => {
							evidences += `
                    <div class="col-4 pt-2">
                        <div class="evidence">
                            <img src="${evidence}">
                            <button class="btn text-white p-0 mt-2 delete-evidence"><i class="lni lni-trash-can"></i></button>
                        </div>
                    </div>


                        `;
						});
					}

					$('.local .local-reports .report.selected').removeClass('selected');
					$('.local .local-reports #report-' + id).addClass('selected');
					$('.local-reports .citizen-ficha').fadeOut(300, function () {
						$(this)
							.html(
								`
                    <div class="row ficha" reportid="${cb.id}">
                        <div class="col-12 pe-3 ps-3">
                            <input class="report-title form-control w-100" value="${cb.title}" placeholder="${or.lang.document||'Document name'}">
                        </div>
                        <div class="col-6 pe-1">
                            <div class="info-box m-1 mt-2">
                                <div class="notes-title d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-quote-right" aria-hidden="true"></i> ${or.lang.notes || 'Notas'}</h4>
                                    <div class="new-button new-note" onclick="localFunctions.newNote()"><i class="fas fa-plus" aria-hidden="true"></i> ${or.lang.new_note || 'New note'}</div>
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
                                <div class="notes-title d-flex justify-content-between align-items-center">
                                    <h4><i class="fas fa-quote-right" aria-hidden="true"></i> ${or.lang.photographs}</h4>
                                    <div class="new-button add-prueba" onclick="localDocuments.addPhotoModal(${cb.id})"><i class="fas fa-plus" aria-hidden="true"></i> ${ or.lang.add_new_phot ||'Add photography'}</div>
                                </div>
                                <div class="citizen-info-container mt-2">
                                    <div class="row evidences w-100 m-0">
                                       ${evidences}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 text-center">
                            <button class="btn btn-danger delete-report mt-1" onclick="localDocuments.modalRemoveDocument(${cb.id})"><i class="lni lni-trash-can"></i> ${or.lang.delete ||'Destroy'}</button>
                        </div>
                    </div>
                    `
							)
							.fadeIn(300);
					});
				}
			}
		);
	},

	addMoney: () => {
		const money = parseInt($('.c-modal .cant-dinero').val());
		if (money && money > 0) {
			TriggerCallback('origen_masterjob:server:TransferToSociety', {
				amount: money
			}).done((cb) => {
				if (cb && cb === true) {
					or.sendNotification('success', or.lang.trans_succ || 'Transfer carried out correctly');
					CloseModal();
				} else {
					or.sendNotification('error', cb);
				}
			});
		} else {
			or.sendNotification('error', or.lang.cant_empty || 'You must introduce a valid amount');
		}
	},

	removeMoney: () => {
		const money = parseInt($('.c-modal .cant-dinero').val());
		if (money && money > 0) {
			TriggerCallback('origen_masterjob:server:TransferToBank', {
				amount: money
			}).done((cb) => {
				if (cb && cb === true) {
					or.sendNotification('success',or.lang.trans_succ || 'Transfer carried out correctly');
					CloseModal();
				} else {
					or.sendNotification('error', cb);
				}
			});
		} else {
			or.sendNotification('error',  or.lang.cant_empty || 'You must introduce a valid amount');
		}
	}
};

//DOCUMENTOS

let localDocuments = {
	modalRemoveDocument: (id) => {
		or.OpenModal(
			or.lang.atention ||`ATTENTION`,
			`<div class="row">
        <div class="col-2">
            <img src="./img/webp/trash.webp" class="img-fluid">
        </div>
        <div class="col-10 d-flex align-items-center">
            <div>
            <h5 class="text-danger fw-bold mb-3">${or.lang.delte_doc_info ||'This action will eliminate the document permanently, including the photographs attached to it.'}</h5>
            <h4>${or.lang.delte_doc_info2||'This will not affect the fines, which will remain in the system.'}</h4>
            </div>
        </div>

    </div>`,
			`<button class="btn-modal" onclick="localDocuments.deleteDocument(${id})">${or.lang.confirm}</button>`,
			or.lang.back || 'Cancel',
			60
		);
	},

	deleteDocument: (id) => {
		TriggerCallback('origen_masterjob:server:DeleteBusinessDocument', {
			id
		}).done((cb) => {
			// or.debuger(cb);
			if (cb) {
				$('.local .local-reports .report.selected').removeClass('selected');
				$('.local .local-reports #report-' + id).fadeOut(300, function () {
					$(this).remove();
				});
				$('.local .local-reports .citizen-ficha').fadeOut(300);
				CloseModal();
			}
		});
	},

	addPhotoModal: () => {
		or.OpenModal(
			or.lang.add_new_phot || `Add photographs`,
			`
			<div class="col-12 text-muted">
				<input class="form-control w-100" placeholder="${or.lang.enter_url_img || 'Enter the image URL'}">
			</div>
			`,
			`<button class="btn btn-modal" onclick="localDocuments.addPhoto()">${or.lang.save || 'Save'}</button>`,
			or.lang.back || `Cancel`,
			60
		);
	},

	validURL: (url) => {
		const pattern = /^https?:\/\/.+\.(jpg|jpeg|png|gif|bmp|tiff|webp)$/i;
		return pattern.test(url);
	},

	addPhoto: () => {
		let img = $('.c-modal input').val();

		if (!localDocuments.validURL(img)) {
			or.sendNotification('error', or.lang.url_img_valid || 'The image URL is not valid');
			return;
		}

		$('.local .local-reports .evidences').append(`
			<div class="col-4 pt-2 scale-in">
				<div class="evidence">
					<img src="${img}">
					<button class="btn text-white p-0 mt-2 delete-evidence"><i class="lni lni-trash-can"></i></button>
				</div>
			</div>
		`);
		CloseModal();
		localDocuments.updatePhotos();
	},

	updatePhotos: () => {
		const data = {
			documentid: parseInt($('.local .local-reports .ficha').attr('reportid')),
			key: 'images',
			value: []
		};
		$('.local .local-reports .row.evidences img').each(function () {
			data.value.push($(this).attr('src'));
		});
		data.value = JSON.stringify(data.value);
		or.debuger(data);
		TriggerCallback('origen_masterjob:server:UpdateBusinessDocument', data).done((cb) => {
				if (cb) {
					or.sendNotification('success', or.lang.change_correct || 'Photography added correctly');
				}
			}
		);
	},
	deleteEvidence: () => {
		CloseModal();
		actualEvidencelocal.addClass('scale-out').fadeOut(300, function () {
			actualEvidencelocal.remove();
			actualEvidencelocal = null;
			localDocuments.updatePhotos();
		});
	}
};

const vehicles = [
	{
		id: 'sultan2',
		name: 'Sultan Classic',
		price: 10000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 0
	},
	{
		id: 'sultan2',
		name: 'Sultan Classic',
		price: 10000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 0
	},
	{
		id: 'adder',
		name: 'Adder',
		price: 1000000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 2
	},
	{
		id: 'banshee2',
		name: 'Banshee 900R',
		price: 565000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 3
	},
	{
		id: 'bullet',
		name: 'Bullet',
		price: 155000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 4
	},
	{
		id: 'cheetah',
		name: 'Cheetah',
		price: 650000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 5
	},
	{
		id: 'entityxf',
		name: 'Entity XF',
		price: 795000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 6
	},
	{
		id: 'infernus',
		name: 'Infernus',
		price: 440000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 7
	},
	{
		id: 'osiris',
		name: 'Osiris',
		price: 1500000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 8
	},
	{
		id: 'reaper',
		name: 'Reaper',
		price: 1425000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 9
	},
	{
		id: 'tempesta',
		name: 'Tempesta',
		price: 1000000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 10
	},
	{
		id: 'turismor',
		name: 'Turismo R',
		price: 500000,
		img: 'https://cdn.mos.cms.futurecdn.net/Jrd32uBmYw9E36JYBXUgYE.jpg',
		level: 11
	}
];

let swiperVehicle;

const vehicleFunctions = {
	createVehicleSlider: () => {
		// swiperVehicle ? swiperVehicle.destroy() : null;
		if (swiperVehicle) {
			// swiperVehicle.destroy();
			swiperVehicle.destroy();
			or.debuger('Destruyo slider');
		}

		let slider = '';
		$('.local .slider-vehiculos .swiper-wrapper').html();

		vehicles.map((vehicle) => {
			if (vehicle.level >= localData.level) {
				slider += `
                <div class="swiper-slide" data-swiper-autoplay="5000">
                    <div class="${
						vehicle.level > localData.level
							? 'slider-mission bloqueada'
							: 'slider-mission'
					}" style="background: url(${vehicle.img});">
                        <div class="mission-level-to">
                            ${or.lang.level || 'LEVEL'}
                            <span class="mission-level-number"
                                >${vehicle.level}</span
                            >
                        </div>
                        <div class="slider-info">
                            <div class="mission-data">
                                <div class="slider-title">
                                    ${vehicle.name}
                                </div>
                                <div class="slider-description">
                                    ${vehicle.price}$
                                </div>
                            </div>
                            ${
								vehicle.level == localData.level
									? `<div class="mission-action d-flex">
                                <button class="btn btn-success">
                                    <i class="fa-solid fa-cart-shopping"></i> ${or.lang.adq || 'ADQUIRIR'}
                                </button>
                                </div>`
									: ''
							}
                        </div>
                    </div>
                </div>
                    `;
			}
		});

		$('.local .slider-vehiculos .swiper-wrapper').html(slider);
		setTimeout(() => {
			swiperVehicle = new Swiper('.slider-vehiculos', {
				autoplay: {
					delay: 5000,
					disableOnInteraction: false
				},
				pagination: {
					el: '.swiper-pagination',
					type: 'progressbar'
				},

				navigation: {
					nextEl: '.swiper-button-next',
					prevEl: '.swiper-button-prev'
				},
				effect: 'coverflow',
				coverflowEffect: {
					rotate: 50,
					stretch: 0,
					depth: 100,
					modifier: 1,
					slideShadows: true
				}
			});
		}, 505);
	}
};

$(document).on('click', '.local #local-vehicles', function () {
	vehicleFunctions.createVehicleSlider();
});

$(document).on('click', '.local .slider-vehiculos .btn-success', function () {
	or.unlockItem('¡Nuevo vehículo adquirido!');
});

/*
$(document).on('click', '.local .btn-cant', function () {
	let action = $(this).hasClass('mas') ? 'sumar' : 'restar';
	let cant = parseInt($(this).parent().find('.cant').text());
	if (action == 'sumar') {
		cant++;
	} else {
		cant = Math.max(cant - 1, 1);
	}

	$(this).parent().find('.cant').text(cant);
});*/

let cart = [];

$(document).on(
	'click',
	'.local .local-articles .shop-articulos .add-cart-button',
	function () {
		const name = $(this).parent().parent().attr('name');
		const price = parseInt($(this).parent().parent().attr('price'));
		const cant = parseInt($(this).parent().find('.cant').text());
		const label = $(this).parent().parent().find('.title').text().trim();

		$(this).parent().find('.cant').text('1');
		addItemToCart(name, price, cant, label);
	}
);

$(document).ready(function () {
	or.exportEvent('origen_masterjob', 'Get_Config', {}).done((cb) => {
		inventory_name = JSON.parse(cb).Inventory;
		MaxSocietySalary = JSON.parse(cb).MaxSocietySalary;
	});
});

function addItemToCart(name, price, cant, label) {
	const item = {
		name,
		price,
		amount: cant,
		label
	};
	// Check if the item already exists in the cart by comparing its name property
	const existingItem = cart.find((item) => item.name === name);

	if (existingItem) {
		// If the item already exists, update its quantity and price
		existingItem.amount += cant;
		existingItem.price = existingItem.amount * price;
	} else {
		// If the item does not exist, add it to the cart
		const newItem = {
			name,
			price: cant * price,
			amount: cant,
			label
		};
		cart.push(newItem);
	}
	or.debuger(cart);
	updateCart();
}

const items = [
	{
		name: 'Toolbox',
		id: 'caja-herramientas',
		price: 1000,
		level: 1
	},
	{
		name: 'Work table',
		id: 'mesa-trabajo',
		price: 500,
		level: 2
	},
	{
		name: 'Work chair',
		id: 'silla-trabajo',
		price: 250,
		level: 3
	},
	{
		name: 'Desk lamp',
		id: 'lampara-escritorio',
		price: 150,
		level: 3
	},
	{
		name: 'Safe',
		id: 'caja-fuerte',
		price: 2000,
		level: 3
	},
	{
		name: 'Typewriter',
		id: 'maquina-escribir',
		price: 750,
		level: 4
	},
	{
		name: 'Board',
		id: 'pizarra',
		price: 300,
		level: 4
	},
	{
		name: 'Office chair',
		id: 'silla-oficina',
		price: 400,
		level: 4
	},
	{
		name: 'Desk',
		id: 'escritorio',
		price: 800,
		level: 4
	},
	{
		name: 'Drawer',
		id: 'cajonera',
		price: 350,
		level: 5
	},
	{
		name: 'Director chair',
		id: 'silla-director',
		price: 1000,
		level: 6
	}
];

or.loadLocalItems =()=> {
	or.debuger('^4 checkload')

	TriggerCallback('origen_masterjob:server:LoadAllowedItems', {}).done((cb) => {
		or.debuger('^1 checkload', JSON.stringify(cb));
		if (cb) {
			//or.debuger(localData.level);
			const itemsLevel1 = cb.filter((item) => item.level <= localData.level);
			const othersLevels = cb.filter((item) => item.level > localData.level);
			//or.debuger(itemsLevel1, othersLevels);
			let htmLUnlock = '';
			let htmlLocked = '';
			itemsLevel1?.forEach((item) => {
				htmLUnlock += `
        <div class="shop-flex-box justify-content-between" name="${item.name}" price="${
					item.price
				}">
            <div class="d-flex align-items-center">
				${checkItemImage(item.img || item.name) ? `<img src="${checkItemImage(item.img || item.name)}" class="icon">` : ''}
                <div class="buy-flex-box-data w-100">
                    <div class="title">
                        ${item.label}
                    </div>

                </div>
            </div>
            <div class="d-flex align-items-center">
                <div class="price badge badge-price">
                    ${item.price}$
                </div>
                <div class="shop-flex-box-count">
                    <div class="menos btn-cant"> <i class="fa-solid fa-minus"></i> </div>
                    <div class="cant"> 1 </div>
                    <div class="mas btn-cant"> <i class="fa-solid fa-plus"></i> </div>
                </div>

                <div class="btn btn-action-mini me-2 add-cart-button">
                    <i class="fa-solid fa-cart-shopping"></i> <span style="text-transform:uppercase">${or.lang.add || 'ADD'}<span>
                </div>
            </div>

        </div>
        `;
			});
			othersLevels?.forEach((item) => {
				htmlLocked += `
        <div class="shop-flex-box justify-content-between bloqueado">
            <div class="d-flex align-items-center">
				${checkItemImage(item.img) ? `<img src="${checkItemImage(item.img)}" class="icon">` : ''}
                <div class="buy-flex-box-data w-100">
                    <div class="title">
                        ${item.label}
                    </div>
                </div>
            </div>
            <div class="d-flex align-items-center">
                <div class="price badge bg-dark  me-2">
                    LEVEL ${item.level}
                </div>
            </div>
        </div>
        `;
			});

			$('.local .dark-content.shop-articulos').html(htmLUnlock);
			$('.local .dark-content.shop-articulos').append(htmlLocked);
		}
	});
}

function updateCart() {
	or.debuger('Actualizando carrito', cart);
	let total = 0;
	let cartHtml = '';
	cart.forEach((item) => {
		total += item.price;
		cartHtml += `
        <div class="shop-flex-box justify-content-between">
        <div class="d-flex align-items-center">
            <i class="fa-solid fa-tags me-1 icon"></i>
            <div class="buy-flex-box-data w-100">
                <div class="title">
                    ${item.label}
                </div>


            </div>
        </div>
        <div class="d-flex align-items-center">
            <div class="price badge badge-acent me-2">
                x${item.amount}
            </div>
            <div class="price badge badge-price">
                ${item.price}$
            </div>
            <div class="delete-item" name="${item.name}">
                <i class="fa-solid fa-trash"></i>
            </div>

        </div>
    </div>
        `;
	});
	$('.local .dark-content.carrito').html(cartHtml);
	$('.local .dark-content.carrito').parent().find('#total-carrito').text(total);

	if (cart.length != 0) {
		$('.local .dark-content.carrito')
			.parent()
			.find('.btn-comprar-carrito')
			.addClass('activo');
	} else {
		$('.local .dark-content.carrito')
			.parent()
			.find('.btn-comprar-carrito')
			.removeClass('activo');
	}
}

$(document).on('click', '.local .dark-content.carrito .delete-item', function () {
	const name = $(this).attr('name');
	$(this)
		.parent()
		.parent()
		.addClass('animate__animated animate__zoomOut animate__faster')
		.one('animationend', () => {
			or.debuger('ejecuto');
			cart = cart.filter((item) => item.name != name);
			updateCart();
		});
});

$(document).on('click', '.local .btn-load-articles', function () {
	or.loadLocalItems();
	updateAlmacen();
});

$(document).on('click', '.local .btn-comprar-carrito.activo', confirmarCompra);

function confirmarCompra() {
	or.OpenModal(
		or.lang.confirm || `Confirm purchase`,
		`<div class="row">

    <div class="col-12 d-flex text-center">
        <div>
        <h5 class="fw-bold mb-3">${ or.lang.post_articles_delivery || 'You are going to make an order and will be delivered in your business by a deliveryman.'}</h5>
        <h4>${or.lang.are_sure || 'Do you want to continue?'}</h4>
        </div>
    </div>

</div>`,
		`<button class="btn-modal btn-confirmar-compra">${or.lang.confirm || 'Confirm'}</button>`,
		or.lang.back  || 'Cancel',
		50
	);
}

$(document).on('click', '.btn-confirmar-compra', function () {
	let total = 0;
	cart.forEach((item) => {
		total += item.price;
	});

	// const total = parseInt($("#total-carrito").text().trim());
	or.debuger(cart, total);

	cart.forEach((item) => {
		delete item.label;
		delete item.price;
	});

	TriggerCallback('origen_masterjob:server:RequestItems', { items: cart, total }).then(
		(res) => {
			or.debuger(res);
			if (res === true) {
				or.sendNotification(
					'success',
					or.lang.change_correct || 'You have ordered correctly',
					or.lang.post_articles_send || 'A delivery man will be in charge of delivering the order in your business.'
				);
			} else {
				or.sendNotification('error', res);
			}
		}
	);

	CloseModal();
	cart = [];
	updateCart();
});

$(document).on('click', '.local .vender-item', function () {
	const cant = parseInt(
		$(this).parent().find('.cant').text().trim().replace(/\D/g, '')
	);

	const slot = parseInt($(this).attr('slot'));

	const name = $(this).attr('name');

	or.debuger(cant, name);
	const label = $(this).parent().parent().find('.title').text();

	let selectCant = '';
	for (let i = 1; i <= cant; i++) {
		selectCant += `<option value="${i}">${i}</option>`;
	}

	or.OpenModal(
		or.lang.art_sale || `Article on sale`,
		`<div class="row">

            <div class="col-12 text-center">
            <small class="text-center">${ or.lang.art_sale_des||'If the item is already on sale, the amount will be added and the price will be updated to the new one.'}</small>
            <h3>${label}</h3>
                <label class="mt-3">
                    ${or.lang.amount || 'Amount'}
                </label>
                <select class="form-select cant-select w-100">
                    ${selectCant}
                </select>
                <label  class="mt-3">
                    ${or.lang.price_per_unit || 'Price per unit'}
                </label>
                <input type="number" class="form-control price-input w-100" min="1" name="${name}" slot="${slot} placeholder="${or.lang.sale_p || 'Sale price'}">
                <div class="error d-none text-danger text-uppercase mt-2">${ or.lang.cant_empty ||'The price must be greater than 0'}</div>
            </div>

        </div>`,
		`<button class="btn-modal btn-vender-item clickable">${or.lang.confirm || 'Confirm'}</button>`,
		or.lang.back  || 'Cancel',
		40
	);
});

$(document).on('click', '.btn-vender-item.clickable', function () {
	$(this).removeClass('clickable');
	const yo = $(this);
	$('.c-modal .error').addClass('d-none');
	const cant = parseInt($('.cant-select').val());
	const price = parseInt($('.price-input').val());
	const name = $('.price-input').attr('name');
	const slot = parseInt($('.price-input').attr('slot'));
	or.debuger(cant, price, name);

	if (!price || price <= 0) {
		$('.c-modal .error').removeClass('d-none');
		yo.addClass('clickable');
	} else {
		TriggerCallback('origen_masterjob:server:PutOnShop', {
			item: name,
			amount: cant,
			price,
			slot
		}).then((cb) => {
			or.debuger(cb);
			if (cb && cb == true) {
				updateAlmacen();
				CloseModal();

				or.sendNotification(
					'success',
					or.lang.change_correct ||'You have put the item for sale correctly',
					or.lang.can_buy || 'Now customers can buy it in your business.'
				);
			} else {
				or.sendNotification('error', cb);
				CloseModal();
			}
		});
	}
});

let urls = {
	['ox_inventory']: 'https://cfx-nui-ox_inventory/web/images/%s',
	['codem']: 'https://cfx-nui-codem-inventory/html/itemimages/%s.png',
	['qb-inventory']: 'https://cfx-nui-qb-inventory/html/images/%s',
	['origen_inventory']: 'https://cfx-nui-origen_inventory/html/images/%s'
}

function checkItemImage(img) {
	var isValid = validURL(img);
	let url;
	if (isValid) {
		url = img;
	} else {
		url = urls[inventory_name].replace('%s', img);
	}
	return url;
}

function validURL(str) {
	or.debuger('^2 url', str)
	
	if ( str  && (str.startsWith('https://') || str.startsWith('http://'))) {
		return true;
	} else {
		return false;
	}
}

function updateAlmacen() {
	let almacenAccesible = true;
	// if(almacenAccesible){

	//     });

	// } else {
	//     $(".items-almacen").html(`
	//     <div class="w-100 h-100 d-flex justify-content-center flex-column text-center align-items-center">
	//         <h4>Alguien está usando el almacén en este momento</h4>
	//     </div>
	//     `);
	// }
	or.debuger('^4Updateo almacén');
	or.exportEvent('origen_masterjob', 'GetStashItems', {}).done((cb) => {
		or.debuger('GetStashItems',cb);

		if (Array.isArray(cb)) {
			cb = cb;
		} else if (typeof cb === 'object') {
			cb = Object.values(cb);
		}

		if (cb && cb.length > 0) {
			let html = '';

			cb.map((item) => {
				html += `
            <div class="shop-flex-box justify-content-between flex-wrap">
                <div class="d-flex align-items-center">
                    ${checkItemImage(item.image) ? `<img src="${checkItemImage(item.image)}" class="icon">` : ""}
                    <div class="buy-flex-box-data w-100">
                        <div class="title">
                            ${item.label}
                        </div>

                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <div class="cant badge badge-acent me-2">
                        x${item.amount}
                    </div>


                    <div class="btn btn-action-mini me-2 vender-item" name="${
						item.name
					}" slot="${item.slot}">
                        <i class="fa-solid fa-cart-shopping"></i> <span style='text-transform:uppercase'>${or.lang.put_on_sale || 'PUT ON SALE'}</span>
                    </div>
                </div>
                <hr class="w-100 m-0 ms-2 me-2">
                <div class="d-flex w-100">
                    <div class="description">
                        ${item.description || or.lang.no_desc || 'No description'}
                    </div>
                </div>

            </div>
            `;
			});
			$('.items-almacen').html(html);
		} else {
			$('.items-almacen').html(`
         <div class="w-100 h-100 d-flex justify-content-center flex-column text-center align-items-center">
             <h4>${or.lang.empty_warh||'The warehouse is empty'}</h4>
         </div>
         `);
		}
	});
}

$(document).on('click', '.local .btn-action.fichar.accesible', function () {
	const status = $(this).attr('status');
	$(this).removeClass('accesible');
	let state = status === 'on' ? false : true;
	or.debuger(localData.open);
	TriggerCallback('origen_masterjob:server:Duty', { state }).then((cb) => {
		or.debuger('Duty: ', cb);
		if (cb) {
			if (status == 'on') {
				$(this).find('.fichar-label').text(or.lang.sign_in || 'SIGN IN');
				$(this).attr('status', 'off');
				or.sendNotification('success', or.lang.turn_off || 'You have finished the turn');
			} else {
				$(this).find('.fichar-label').text(or.lang.sign_out ||'SIGN OUT');
				$(this).attr('status', 'on');
				or.sendNotification('success', or.lang.turn_on || 'You have started the turn');
			}
		} else {
			or.sendNotification(
				'error',
				'An error has occurred',
				'Consulta con la administración'
			);
		}
	});

	setTimeout(() => {
		$(this).addClass('accesible');
	}, 1000);
});

$(document).on('click', '.local .btn-salario', function () {
	const grade = $(this).attr('rango');
	const value = parseInt($(this).parent().find('.input-salario').val());
	or.debuger(grade, value);
	if (grade != null && value > 0) {
		if (value > (MaxSocietySalary)) {
			or.sendNotification('error', or.lang.err_sal_max ? or.lang.err_sal_max.replace('%s', (MaxSocietySalary)) : `The salary cannot be greater than ${(MaxSocietySalary)}`);
			return;
		}
		TriggerCallback('origen_masterjob:server:UpdateGrade', {
			grade,
			attr: 'pay',
			value
		}).done((cb) => {
			or.debuger(cb);
			if (cb) {
				or.sendNotification(
					'success',
					or.lang.change_correct || 'The salary of the range has changed correctly'
				);
			} else {
				or.sendNotification('error', or.lang.err_change || 'A mistake has occurred when saving the salary');
			}
		});
	} else {
		if (value == 0 || !value) {
			or.sendNotification('error', or.lang.cant_empty || 'The salary cannot be 0');
		} else if (value < 0) {
			or.sendNotification('error', or.lang.err_sal_min || 'The salary cannot be less than 0');
		}
	}
});

function setServicio(status) {
	if (!status) {
		$('.btn-action.fichar .fichar-label').text(or.lang.sign_in || 'SIGN IN');
		$('.btn-action.fichar').attr('status', 'off');
	} else {
		$('.btn-action.fichar .fichar-label').text(or.lang.sign_out || 'SIGN OUT');
		$('.btn-action.fichar').attr('status', 'on');
	}
}

// localData.open = true;

function setOpen(status) {
	if (status) {
		$('.local .zona-apertura').addClass('n-abierto');
	} else {
		$('.local .zona-apertura').removeClass('n-abierto');
	}
}

$(document).on('click', '.local .zona-apertura.clickable .cerrado', function () {
	s_click.currentTime = '0';
	s_click.play();
	if (canAccess('apertura')) {
		$('.local .zona-apertura').removeClass('clickable');

		TriggerCallback('origen_masterjob:server:ChangeOpenState', { state: 1 }).then(
			(cb) => {
				if (cb) {
					$('.local .zona-apertura').addClass('n-abierto');

					or.sendNotification('success', or.lang.open_publ || 'Business open to the public');
				} else {
					or.sendNotification(
						'error',
						or.lang.err_change || 'An error has occurred',
						or.lang.check_admin || 'Consult with the administration'
					);
				}
			}
		);

		setTimeout(() => {
			$('.local .zona-apertura').addClass('clickable');
		}, 2000);
	}
});

$(document).on('click', '.local .zona-apertura.clickable .cerrar-negocio', function () {
	s_click.currentTime = '0';
	s_click.play();

	if (canAccess('apertura')) {
		$('.local .zona-apertura').removeClass('clickable');

		TriggerCallback('origen_masterjob:server:ChangeOpenState', { state: 0 }).then(
			(cb) => {
				if (cb) {
					$('.local .zona-apertura').removeClass('n-abierto');
					or.sendNotification('success', or.lang.close_publ || 'Business closed to the public');
				} else {
					or.sendNotification(
						'error',
						or.lang.err_change || 'An error has occurred',
						or.lang.check_admin || 'Consult with the administration'
					);
				}
			}
		);

		setTimeout(() => {
			$('.local .zona-apertura').addClass('clickable');
		}, 2000);
	}
});

let canAnnounce = true;

$(document).on('click', '.local .zona-apertura.clickable .reapertura', function () {
	s_click.currentTime = '0';
	s_click.play();
	if (canAnnounce) {
		canAnnounce = false;
		TriggerCallback('origen_masterjob:server:ChangeOpenState', { state: 1 }).then(
			(cb) => {
				if (cb) {
					$('.local .zona-apertura').addClass('n-abierto');

					or.sendNotification('success', or.lang.anounce_report  || 'You have announced the reopening');
				} else {
					or.sendNotification(
						'error',
						or.lang.err_change || 'An error has occurred',
						or.lang.check_admin || 'Consult with the administration'
					);
				}
			}
		);
		setTimeout(() => {
			canAnnounce = true;
		}, 10000);
	} else {
		or.sendNotification('error', or.lang.recent_anounce || 'You have already recently announced the opening');
	}
});

$(document).on('click', '.local .zona-apertura.clickable .llamar-tendero', function () {
	s_click.currentTime = '0';
	s_click.play();
	$('.local .zona-apertura').removeClass('clickable');

	TriggerCallback('origen_masterjob:server:CallShopNPC', {}).then((cb) => {
		if (cb == true) {
			or.sendNotification(
				'success',
				or.lang.call_npc || 'You have called the shopkeeper to return to his post'
			);
		} else {
			or.sendNotification('error', cb);
		}
	});

	setTimeout(() => {
		$('.local .zona-apertura').addClass('clickable');
	}, 2000);
});

/* DEPRECATED
$(document).on('click', '.local .decorar', function () {
	or.closeMenu();
	fetch('ExecuteCommand', {
		command: 'decorate'
	});
});*/

$(document).on('click', '.local .gestion-articulos', function () {
	TriggerCallback('origen_masterjob:server:GetShopItems', {}).done((cb) => {
		let items = '';
		if (cb.length > 0) {
			cb.map((item) => {
				or.debuger(item);
				items += `
                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" item="${item.name}" productid="${item.productid}" amount="${item.amount}">
                    <div><i class="fa-solid fa-tags"></i> ${item.label} (x${item.amount})</div>
                    <div class="d-flex justify-content-center align-items-center">
                        <div class="text-success me-3"><input style="width:7vh;text-align:center;" value="${item.price}$" class="form-control price" type="text" placeholder="${or.lang.price || 'Price'}"></div>
                        <div class="btn btn-action" onclick="deleteItem($(this))"><i class="fas fa-trash-alt delete-item" aria-hidden="true"></i></div>
                    </div>
                </li>
                `;
			});
		} else {
			items = `
            <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
            <i>${or.lang.not_products ||'There are no products for sale'}</i>
            </li>
            `;
		}
		or.OpenModal(
			or.lang.art_sale || 'Articles for sale',
			`
        <ul class="list-group multas-list mt-2 list-items">
            ${items}
        </ul>

        `,
			'',
			or.lang.back || 'Return',
			55
		);
	});
});

function deleteItem(item) {
	const productid = item.parent().parent().attr('productid');
	const name = item.parent().parent().attr('item');
	const amount = parseInt(item.parent().parent().attr('amount'));
	or.debuger({
		id: productid,
		item: name,
		amount
	});
	TriggerCallback('origen_masterjob:server:RemoveShopItem', {
		id: productid,
		item: name,
		amount
	}).done((cb) => {
		if (cb === true) {
			updateAlmacen();
			or.sendNotification('success', or.lang.deleted_product || 'You have deleted the product correctly');
			item.parent().parent().remove();

			// verificar si al hacer el remove() la lista de items queda vacía y si es así, agregar un item que diga que no hay productos
			if ($('.list-items').children().length == 0) {
				$('.list-items').html(`
				<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
				<i>${or.lang.not_products ||'There are no products for sale'}</i>
				</li>
				`);
			}
		} else {
			or.sendNotification('error', cb);
		}
	});

	or.debuger('Elimino ', productid);
}

let auxNum;

$(document).on('focusin', '.list-items .list-group-item .price', function () {
	const inputValue = $(this).val();
	let numericValue = Number(inputValue.replace('$', ''));
	auxNum = numericValue;
	or.debuger(auxNum);
	$(this).val(numericValue);
});

$(document).on('focusout', '.list-items .list-group-item .price', function () {
	let numericValue = parseInt($(this).val(), 10);
	const id = $(this).parent().parent().parent().attr('productid');
	const yo = $(this);
	if (auxNum == numericValue) {
		yo.val(auxNum + '$');

		return;
	}
	if (isNaN(numericValue)) {
		yo.val(auxNum + '$');
		or.sendNotification('error', or.lang.not_found || 'The value entered is not valid');
	} else {
		or.debuger({
			id: id,
			key: 'price',
			value: numericValue
		});
		TriggerCallback('origen_masterjob:server:ModifyShopItem', {
			id: id,
			key: 'price',
			value: numericValue
		}).done((cb) => {
			if (cb === true) {
				or.sendNotification(
					'success',
					or.lang.change_correct || 'You have modified the product price correctly'
				);
				yo.val(numericValue + '$');
			} else {
				or.sendNotification('error', cb);
				yo.val(auxNum + '$');
			}
		});
	}
});

function canAccess(app, action) {
	let access = false;

	if (localData.grades[myGrade].boss) {
		access = true;
	}
	if (app == 'local-settings' && localData.grades[myGrade].rrhh) {
		access = true;
	}

	if (app == 'local-articles' && localData.grades[myGrade].articles) {
		access = true;
	}

	if (app == 'apertura' && localData.grades[myGrade].openclose) {
		access = true;
	}

	if (app == 'local-home') {
		access = true;
	}

	if (app == 'local-reports') {
		access = true;
	}

	if (app == 'jefe' && localData.grades[myGrade].boss) {
		or.debuger('accedo rangos');
		access = true;
	}

	if (app == 'rrhh' && localData.grades[myGrade].rrhh) {
		access = true;
	}

	if (app == 'safebox' && localData.grades[myGrade].safebox) {
		access = true;
	}

	if (!access && !action) {
		or.sendNotification('error', or.lang.not_perms || 'Do not have enough permits');
	}

	return access;
}

$(document).on('click', '.expulsar-servicio', function () {
	const citizenid = $(this).attr('citizenid');
	or.debuger(citizenid);
	TriggerCallback('origen_masterjob:server:Duty', { state: false, citizenid }).then(
		(cb) => {
			or.debuger(cb);
			if (cb === true) {
				or.sendNotification('success', or.lang.expel_scc || 'You have expelled this person properly');
			} else {
				or.sendNotification('error', or.lang.err_change || 'An error has occurred by expelling this person from service.');
			}
		}
	);
});

$(document).on('click', '.local .transfer-menu .ingresar', function () {
	or.OpenModal(
		or.lang.buss_money_dep || 'Enter money in business',
		`
	<div class="text-center mb-3">
		${or.lang.depot_transfer ||'You will make an entry into the business from your bank account.Remember to have the balance necessary to make the transfer!'}
	</div>
	<label>${or.lang.amount_enter ||'Amount to enter'}</label>
	<input class="form-control w-100 text-center cant-dinero" type="number" placeholder="${or.lang.amount_enter || 'Enter the quantity'}">

	`,
		`<div class="btn-modal" onClick="localFunctions.addMoney()">${or.lang.deposit ||'Make admission'}</div>`,
		or.lang.back || 'Return',
		65
	);
});

$(document).on('click', '.local .transfer-menu .retirar', function () {
	or.OpenModal(
		or.lang.buss_money_wd || 'Withdraw business money',
		`
	<div class="text-center mb-3 text-uppercase">
		capitalActual:
		<h1 class="text-success bankgothic">${localData.money}$</h1>
	</div>
	<label>${or.lang.amount_enter || 'Amount to enter'}</label>
	<input class="form-control w-100 text-center cant-dinero" placeholder="${or.lang.amount_enter || 'Enter the quantity'}" type="number">
	<small class="mt-3 w-100 text-center d-block">${or.lang.wd_transfer||'Remember that money will be admitted to your personal bank account.'}</small>
	`,
		`<div class="btn-modal" onClick="localFunctions.removeMoney()">${or.lang.withdrawn ||'Withdraw'}</div>`,
		or.lang.back || 'Return',
		65
	);
});
