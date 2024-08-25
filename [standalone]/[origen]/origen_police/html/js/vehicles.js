vehiclesSectionFunctions = {
	loadVehiclesFunctions: () => {
		$(document).on('click', '.police .btn-vehicles', function () {
			if(HasPermissionMenu("SearchVehicles")) {
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
			policeFunctions.policeNavigation(Translations.Vehicles, $('.police-vehicles').html());
		});
	}
};

vehicleSelectorFunctions = {
	getCB: undefined,
	loadSelectorFunctions: () => {
		$(document).on(
			'click',
			'.police .vehiculos-container .close-button',
			function () {
				$(this).parent().removeClass('scale-in').addClass('scale-out');
				$('.police .vehiculos-container').fadeOut(300);
			}
		);

		$(document).on(
			'click',
			'.police .evidencias-container .close-button',
			function () {
				$(this).parent().removeClass('scale-in').addClass('scale-out');
				$('.police .evidencias-container').fadeOut(300);
			}
		);

		$(document).on('click', '.police .btn-search-vehicle-selector', function () {
			vehicleSelectorFunctions.searchVehicle();
		});

		$(document).on(
			'keydown',
			'.police .input-search-vehicle-selector',
			function (event) {
				var keycode = event.keyCode ? event.keyCode : event.which;
				if (keycode == '13') {
					vehicleSelectorFunctions.searchVehicle();
				}
			}
		);

		$(document).on(
			'click',
			'.police .vehiculos-container .vehicle-box-item',
			function () {
				let vehiclePlate = $(this)
					.find('.vehicle-plate-result span')
					.text()
					.trim();
				let vehicleName = $(this).find('.vehicle-name span').text().trim();
				if (vehicleSelectorFunctions.getCB) {
					vehicleSelectorFunctions.getCB(vehiclePlate, vehicleName);
					$('.police .vehiculos-container .personas-box')
						.removeClass('scale-in')
						.addClass('scale-out');
					$('.police .vehiculos-container').fadeOut(300);
				}
			}
		);
	},
	showAddVehicle: function (cb) {
		$('.police .vehiculos-container .input-search-vehicle-selector').val('');
		$('.police .vehiculos-container .vehicle-box-list .row').html(`
            <div class="col-12 text-muted">
                <h4 class="vehicle-name">${Translations.EnterPlateEngine}</h4>
            </div>`);
		$('.police .vehiculos-container .personas-box')
			.removeClass('scale-out')
			.addClass('scale-in');
		$('.police .vehiculos-container').fadeIn(300);

		vehicleSelectorFunctions.getCB = cb;
	},

	searchVehicle: function () {
		const plate = $('.police .personas-box .input-search-vehicle-selector').val();
		if (plate.length > 0) {
			$('.police .vehiculos-container .vehicles-box-list .row').fadeOut(
				300,
				function () {
					$(this).html('');
					TriggerCallback('origen_police:police:SearchVehicle', {
						plate
					}).done((cb) => {
						if (cb && cb.length > 0) {
							cb.forEach((vehicle, index) => {
								$('.police .vehiculos-container .vehicles-box-list .row')
									.append(`
                            <div class="col-12 mb-1">
                                <div class="vehicle-box-item">
                                        <div class="vehicle-plate-result w-100"><span>${vehicle.plate}</span></div>
                                        <div class="vehicle-name w-50"><i class="fas fa-car-alt"></i> <span>${vehicle.label}</span></div>
                                        <div class="vehicle-owner w-50"><i class="fas fa-user"></i> <span>${vehicle.owner}</span></div>
                                    </div>
                            </div>`);
							});
						} else {
							$('.police .vehiculos-container .vehicles-box-list .row')
								.html(`
                        <div class="col-12 text-muted">
                            <h4 class="vehicle-name">${Translations.NoResultFound}</h4>
                        </div>`);
						}
						$('.police .vehiculos-container .vehicles-box-list .row').fadeIn(
							300
						);
					});
				}
			);
		}
	}
};

vehiclesFunction = {
	loadVehicleList: (plate) => {
		TriggerCallback('origen_police:police:SearchVehicle', { plate }).then((data) => {
			if (data && data.length > 0) {
				$('.police ' + policeTabSelected + ' .vehicle-list').html('');

				data.map((vehicle) => {
					$('.police ' + policeTabSelected + ' .vehicle-list').append(`
                    <div class="white-block vehicle scale-in" id="${vehicle.plate}">
                        <i class="fa-solid fa-car icon"></i>
                        <div class="vehicle-name">
                            ${
								vehicle.label != 'NULL' ? vehicle.label : 'Unknown'
							} - <span>${vehicle.plate}</span>
                        </div>
                        <div class="d-flex text-uppercase citizen-fast-data justify-content-center flex-wrap mt-1 p-2">
                                <div class="w-100">
                                    <div class="report-owner">
                                        <i class="fas fa-user" aria-hidden="true"></i>
                                        <span>${vehicle.owner}</span>
                                    </div>
                                </div>
                                <div class="w-100">
                                    <div class="report-date">
                                        <i class="fa-solid fa-location-dot"></i>
                                        <span>${vehicle.status || 'Unknown'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `);
				});
			}
		});
	}
};

$(document).on('click', '.police .tab .btn-search-vehicle', function () {
	const label = $(this).parent().parent().find('.input-search-vehicles').val().trim();
	if (label.length > 2) {
		vehiclesFunction.loadVehicleList(label);
	} else {
		sendNotification('error', Translations.MinimumCharacters);
	}
});

$(document).on('click', '.police .tab .white-block.vehicle', function () {
	const plate = $(this).attr('id');

	$('.police ' + policeTabSelected + ' .ficha-vehiculo').fadeOut(300, function () {
		const ficha = $(this);
		TriggerCallback('origen_police:police:GetVehicle', { plate }).then((data) => {
			if (data) {
				ficha.attr('id', 'm-' + plate);
				ficha.html(`
                <div class="row m-titles">
                    <div class="col-6 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">
								${Translations.Model}
                            </div>
                            <div class="info-box-value">
                                ${data.label}
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">
                                ${Translations.LicensePlate}
                            </div>
                            <div class="info-box-value id-informe">
                                ${data.plate}
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0 mt-2">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">
								${Translations.Owner}
                            </div>
                            <div class="info-box-value id-informe">
                                ${data.owner}
                            </div>
                        </div>
                    </div>
                    <div class="col-6 p-0 mt-2">
                        <div class="info-box m-1 h-100">
                            <div class="info-box-title">
								${Translations.SearchAndCapture}
                            </div>
                            <div class="info-box-value id-vehiculo">
                                    <div class="busca-captura-vehicle btn-group mt-2 w-100" vehicle-id="${
										data.plate
									}" role="group" aria-label="Basic radio toggle button group">
                                        <input type="radio" class="btn-check si" name="btn-vehicle-${
											data.plate
										}" id="btn-vehicle-${
											data.plate
										}-1" autocomplete="off" ${data.wanted == 1 && 'checked'}>
                                        <label class="btn btn-outline-primary" for="btn-vehicle-${
											data.plate
										}-1">${Translations.Yes}</label>

                                        <input type="radio" class="btn-check" name="btn-vehicle-${
											data.plate
										}" id="btn-vehicle-${
											data.plate
										}-2" autocomplete="off" ${data.wanted == 0 && 'checked'}>
                                        <label class="btn btn-outline-primary no" for="btn-vehicle-${
											data.plate
										}-2">${Translations.No}</label>
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row m-titles mt-3">
                    <div class="col-12 p-0">
                        <div class="info-box m-1 mt-2">
                            <div
                                class="d-flex justify-content-between align-items-center"
                            >
                                <h4>
                                    <i
                                        class="fas fa-sticky-note"
                                    ></i>
                                    ${Translations.VehicleAnnotations}
                                </h4>
                            </div>
                            <div
                                class="citizen-info-container-mini mt-2 d-flex flex-wrap citizen-informes align-content-start"
                            >
                                <textarea
                                    class="input w-100 input-vehiculo-desc"
                                    placeholder="${Translations.EnterAnnotation}"
                                    rows="7"
                                    plate="${data.plate}"
                                >${data.description}</textarea>
                            </div>
                        </div>
                    </div>

                </div>
                `);
				ficha.fadeIn(300);
			} else {
				sendNotification('error', Translations.VehicleNotFound);
			}
		});
	});
});

$(document).on(
	'click',
	'.police .ficha-vehiculo .busca-captura-vehicle .btn-check',
	function () {
		$('.police .ficha-vehiculo .busca-captura-vehicle .btn-check').attr(
			'checked',
			false
		);
		$(this).attr('checked', true);
		const plate = $('.police ' + policeTabSelected + ' .ficha-vehiculo')
			.attr('id')
			.replace('m-', '');
		let value = 0;
		if ($(this).hasClass('si')) {
			value = 1;
		}

		TriggerCallback('origen_police:police:UpdateVehicle', {
			plate,
			key: 'wanted',
			value
		});
		sendNotification('success', Translations.VehicleSearchUpdated);
	}
);

$(document).on('focusout', '.police .ficha-vehiculo .input-vehiculo-desc', function () {
	const plate = $(this).attr('plate');
	const value = $(this).val();
	TriggerCallback('origen_police:police:UpdateVehicle', {
		plate,
		key: 'description',
		value
	});
	sendNotification('success', Translations.VehicleDescriptionUpdated);
});

policeFunctions.loadPoliceEvents();