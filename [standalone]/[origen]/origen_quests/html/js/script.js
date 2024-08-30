var click = new Audio('https://origennetwork.com/music/v7/click.mp3?2');
var abrir = new Audio('https://origennetwork.com/music/v7/transition.ogg');
const s_over = new Audio('https://origennetwork.com/music/v7/over.wav?2');

click.volume = 0.15;
s_over.volume = 0.15;
abrir.volume = 0.15;

let missions = [];
let misiones;
let locations;
let locationsTypes;

let dataTableLanguage = null;
var Translations = [];

let bandasAuxAdmin;
let negociosAuxAdmin;

let inventory = null;

function OnTranslationsReady() {
	dataTableLanguage = {
		sProcessing: Translations.sProcessing,
		sLengthMenu: Translations.sLengthMenu,
		sZeroRecords: Translations.sZeroRecords,
		sEmptyTable: Translations.sEmptyTable,
		sInfo: Translations.sInfo,
		sInfoEmpty: Translations.sInfoEmpty,
		sInfoFiltered: Translations.sInfoFiltered,
		sInfoPostFix: '',
		sSearch: Translations.sSearch,
		sUrl: '',
		sInfoThousands: ',',
		sLoadingRecords: Translations.sLoadingRecords,
		oPaginate: {
			sFirst: Translations.oPaginateFirst,
			sLast: Translations.oPaginateLast,
			sNext: Translations.oPaginateNext,
			sPrevious: Translations.oPaginatePrevious
		},
		oAria: {
			sSortAscending: Translations.sSortAscending,
			sSortDescending: Translations.sSortDescending
		}
	};
}

$(document).on(
	'mouseenter',
	'.btn-sound, .mercado-item, .swiper-button-next, .swiper-button-prev, .missions-button, .list-item, .spawn, .btn-aparecer, .radio-button, .duty-button, .tabs-list .tab, .back-home, .btn-cancel, .btn-modal, .item-flex-box, .button-settings, .btn-comprar-carrito, .delete-item, .back-section, .secondary-box, .zona-apertura, .app-box, .btn-action, .btn-card-home, .btn-search, .white-block, .btn',
	function () {
		s_over.currentTime = '0';
		s_over.play();
	}
);

$(document).on(
	'click',
	'.btn-sound, .mercado-item, .swiper-button-next, .swiper-button-prev, .missions-button, .list-item, .spawn, .btn-aparecer, .radio-button, .duty-button, .tabs-list .tab, .back-home, .btn-cancel, .btn-modal, .item-flex-box, .button-settings, .btn-comprar-carrito, .delete-item, .back-section, .secondary-box, .app-box, .btn-action, .btn-card-home, .btn-search, .white-block, .btn',
	function () {
		click.currentTime = '0';
		click.play();
	}
);

function getAllGangs() {
	return TriggerCallback('origen_quests:server:GetGangsToAssing', {}).promise();
}

function getAllBusiness() {
	return TriggerCallback('origen_quests:server:GetBusinessesToAssing', {}).promise();
}

function loadAdminQuests() {
	TriggerCallback('origen_quests:server:GetQuests', {}).done((cb) => {
		if (cb) {
			if (cb.missions) {
				misiones = {};

				for (let i = 0; i < cb.missions.length; i++) {
					misiones[cb.missions[i].id] = cb.missions[i];
				}

				const misionesOrdenadas = Object.values(misiones).sort((a, b) => {
					return a.id - b.id;
				});

				$('.admin-quests .lista-misiones').html('');

				if (misionesOrdenadas.length > 0) {
					misionesOrdenadas.map((mission, index) => {
						$('.admin-quests .lista-misiones').append(`
						<li
							class="list-group-item">
							<div class="d-flex align-items-center justify-content-between flex-wrap">
								<h5>${mission.name}</h5>
								<div>
									<i
										class="lni lni-pencil-alt btn-list-action"
										onclick="npcFunctions.modalEditMission(${mission.id})"></i
									>
									<i 
										class="lni lni-trash-can btn-list-action"
										onclick="npcFunctions.confirmDeleteMission(${mission.id})"></i>
								</div>
							</div>
							<div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 1.2vh;">
								${mission.description}
							</div>
						</li>
						`);
					});
				} else {
					$('.admin-quests .lista-misiones').html(`
						<li class="list-group-item">
							<i>${Translations.NoMissionsAdded}</i>
						</li>
					`);
				}
			}

			if (cb.locations) {
				locations = {};

				for (let i = 0; i < cb.locations.length; i++) {
					locations[cb.locations[i].id] = cb.locations[i];
				}

				const locationsOrdenadas = Object.values(locations).sort((a, b) => {
					return a.id - b.id;
				});

				$('.admin-quests .lista-ubicaciones').html('');
				
				if (locationsOrdenadas.length > 0) {
					locationsOrdenadas.map((location, index) => {
						let htmlAssigned = '';

						if (location.missions.length > 0) {
							location.missions.map((mission) => {
								if (misiones[mission]) {
									htmlAssigned += `<li>${misiones[mission].name}</li>`;
								}
							});
						} else {
							htmlAssigned = `<li>${Translations.NoMissionsAssigned}</li>`;
						}

						location.coords = location.coords;

						$('.admin-quests .lista-ubicaciones').append(`
							<li class="list-group-item" location-id="${location.id}">
								<div class="d-flex align-items-center justify-content-between flex-wrap">
									<div><h5>${location.name}</h5></div>

									<div class="d-flex align-items-center">
										<div class="location-status ${location.active == 1 ? "on" : "off"}" onclick="npcFunctions.toggleLocation(${location.id}, ${location.active == 1 ? 0 : 1})">${location.active == 1 ? Translations.Active : Translations.Inactive}</div>

										<i
											class="lni lni-pencil-alt btn-list-action"
											onclick="npcFunctions.modalEditLocation(${location.id})">
										</i>
										<i
											class="lni lni-map-marker btn-list-action"
											onclick="npcFunctions.markLocation(${location.coords.x + ", " + location.coords.y + ", " + location.coords.z})">
										</i>
										<i
											class="lni lni-trash-can btn-list-action"
											onclick="npcFunctions.confirmDeleteLocation(${location.id})">
										</i>
									</div>
									<div class="w-100 info-box mt-1">
										<div${Translations.AssignedMissions}</div>
										<ul>
											${htmlAssigned}
										</ul>
									</div>
								</div>
							</div>
						`);
					});
				} else {
					$('.admin-quests .lista-ubicaciones').html(`
						<li class="list-group-item">
							<i>${Translations.NoLocationsAdded}</i>
						</li>
					`);
				}
			}

			if (cb.locationsTypes) {
				locationsTypes = cb.locationsTypes;
			}
		}
	});
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

function tableToArray(table) {
	let array = [];
	for (let i = 0; i < table.length; i++) {
		array.push(table[i]);
	}
	return array;
}

const npcFunctions = {
	auxSelectedGangs: [],
	auxSelectedBusiness: [],

	locationCoords: () => {
		or.fetch('GetCoords', {}).done((cb) => {
			if (cb) {
				$('.c-modal .locationCoords .input-cord-x').val(cb.x);
				$('.c-modal .locationCoords .input-cord-y').val(cb.y);
				$('.c-modal .locationCoords .input-cord-z').val(cb.z);
				$('.c-modal .locationCoords .input-cord-w').val(cb.w);
			}
		});
	},

	bindMission: () => {
		let mission = $('.c-modal .select-location-misiones').val();

		if (mission) {
			if ($('.c-modal .list-missions-binded [mission="' + mission + '"]').length > 0) {
				or.sendNotification('error', Translations.MissionAlreadyAssigned);
				return;
			}

			$('.c-modal .list-missions-binded .sin-items').remove();

			$('.c-modal .list-missions-binded').append(`
				<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster" mission="${mission}">
					<div>${misiones[mission].name}</div>
					<div class="btn btn-action" onclick="npcFunctions.unbindMission(${mission})"><i class="fas fa-trash-alt delete-item" aria-hidden="true"></i></div>
				</li>
			`);
		}
	},
	unbindMission: (mission) => {
		$('.c-modal .list-missions-binded [mission="' + mission + '"]').remove();

		if ($('.c-modal .list-missions-binded li').length == 0) {
			$('.c-modal .list-missions-binded').append(`
				<li class="sin-items list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster">
					<div style="text-align: center; width: 100%;">${Translations.NoMissionsAssigned}</div>
				</li>
			`);
		}
	},

    loadModalLocation: (ubicacion) => {
		let missionsListHTML = '';

		for (let i = 0; i < Object.keys(misiones).length; i++) {
			const mission = misiones[Object.keys(misiones)[i]];

			missionsListHTML += `<option value="${mission.id}">${mission.name}</option>`;
		}

		let optionsLocationsHTML = '';

		Object.entries(locationsTypes).forEach(([key, value]) => {
			optionsLocationsHTML += `<option value="${key}">${value}</option>`;
		});

		OpenModal(
			ubicacion ? Translations.EditLocation: Translations.NewLocation,
			`
            <h5>${Translations.Location}</h5>
            <div class="row mb-4">
                <div class="col-6">
                    <label>${Translations.Name}</label>
                    <input class="form-control w-100 input-nombre-ubicacion" placeholder="${Translations.LocationName}" translate="placeholder">
                </div>
                <div class="col-6">
                    <label>${Translations.Type}</label>
                    <select class="form-control w-100 select-tipo-ubicacion">
                        <option disabled default>${Translations.SelectType}</option>
                        ${optionsLocationsHTML}
                    </select>
                </div>
                <div class="col-4" style="display: none">
                    <label>${Translations.Model}</label>
                    <input class="form-control w-100 input-nombre-modelo" placeholder="${Translations.ModelName}" translate="placeholder">
                </div>
            </div>
            <h5>${Translations.Coordinates}</h5>
            <div class="row mb-4 locationCoords">
                <div class="col-2">

                    <input class="form-control w-100 input-cord-x h-100" placeholder="${Translations.CoordX}" translate="placeholder">
                </div>
                <div class="col-2">

                    <input class="form-control w-100 input-cord-y h-100" placeholder="${Translations.CoordY}" translate="placeholder">
                </div>
                <div class="col-2">

                    <input class="form-control w-100 input-cord-z h-100" placeholder="${Translations.CoordZ}" translate="placeholder">
                </div>
                <div class="col-2">

                    <input class="form-control w-100 input-cord-w h-100" placeholder="${Translations.CoordH}" translate="placeholder">
                </div>
                <div class="col-4">
                    <button class="btn-modal w-100" onclick="npcFunctions.locationCoords()">${Translations.CopyCoordinates}</button>
                </div>
            </div>
			 <h5 class="draw_options_title">${Translations.MarkerOptions}</h5>
			    <div class="row mb-4 markeroptions">
                <div class="col-2">

                    <input class="form-control w-100 input-marker_draw_distance h-100" placeholder="${Translations.DrawDistance}" translate="placeholder">
                </div>
				<div class="col-2">

                    <input class="form-control w-100 input-marker_type h-100" placeholder="${Translations.MarkerType}" translate="placeholder">
                </div>
				<div class="col-2">
                    <input class="form-control w-50 input-marker_color h-100" type="color" name="colorPicker" value="#ff0000">
                </div>
            </div>
            <h5 class="locationNpcAnims">${Translations.NPCAnimations}</h5>
            <div class="locationNpcAnims row mb-4">
                <div class="col-4">
                    <label>${Translations.StaticNPCAnimation}</label>
                    <input class="form-control w-100 input-anim-1" placeholder="${Translations.EnterAnimation}" translate="placeholder">
                </div>
                <div class="col-4">
                    <label>${Translations.NPCAnimationOnAcceptingMission}</label>
                    <input class="form-control w-100 input-anim-2" placeholder="${Translations.EnterAnimation}" translate="placeholder">
                </div>
                <div class="col-4">
                    <label>${Translations.PlayerAnimationOnAcceptingMission}</label>
                    <input class="form-control w-100 input-anim-3" placeholder="${Translations.EnterAnimation}" translate="placeholder">
                </div>
            </div>
			<h5>${Translations.Missions}</h5>
			<div class="p-2 info-box mt-2 assigned-missions ">
				<div class="d-flex justify-content-center align-items-center w-100" style="gap:1vh">
					<select class="form-select w-100 select-location-misiones">
						<option selected disabled>${Translations.SelectMission}</option>
						${missionsListHTML}
					</select>
					<button class="btn btn-action p-2" onclick="npcFunctions.bindMission()" style="color:white !important;">${Translations.Add}</button>
				</div>

				<h6 class="mt-3">${Translations.Assigned}</h6>
				<ul class="list-group multas-list mt-2 list-missions-binded">
					<li class="sin-items list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster">
						<div style="text-align: center; width: 100%;">${Translations.NoMissionsAssigned}</div>
					</li>
				</ul>
			</div>
        `,
			`<button class="btn-modal" onclick="npcFunctions.saveLocation(${ubicacion ? ubicacion : false})">${Translations.SaveChanges}</button>`,
			Translations.Cancel,
			127
		);

		if (ubicacion) {
			$('.c-modal .input-nombre-ubicacion').val(locations[ubicacion].name);
			$('.c-modal .select-tipo-ubicacion option[value="' + locations[ubicacion].type + '"]').prop('selected', true);
			$('.c-modal .select-tipo-ubicacion').trigger('change');
			$('.c-modal .input-cord-x').val(locations[ubicacion].coords.x);
			$('.c-modal .input-cord-y').val(locations[ubicacion].coords.y);
			$('.c-modal .input-cord-z').val(locations[ubicacion].coords.z);
			$('.c-modal .input-cord-w').val(locations[ubicacion].coords.w);
			$('.c-modal .input-anim-1').val(locations[ubicacion].anim1);
			$('.c-modal .input-anim-2').val(locations[ubicacion].anim2);
			$('.c-modal .input-anim-3').val(locations[ubicacion].anim3);
			$('.form-control .input-marker_draw_distance').val(locations[ubicacion].marker_draw_distance);
			$('.c-modal .input-marker_draw_distance').val(locations[ubicacion].marker_draw_distance);
			$('.form-control .input-marker_type').val(locations[ubicacion].marker_type);
			$('.c-modal .input-marker_type').val(locations[ubicacion].marker_type);
			$('.form-control .input-marker_color').val(locations[ubicacion].marker_color);
			function rgbToHex(r, g, b) {
				return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1).toUpperCase();
			};
			var rgbColor = locations[ubicacion].marker_color;
			var rgbValues = rgbColor.match(/\d+/g).map(Number);
			var r = rgbValues[0];
			var g = rgbValues[1];
			var b = rgbValues[2];
			var hexColor = rgbToHex(r, g, b);			
			$('.c-modal .input-marker_color').val(hexColor);
			console.log(hexColor);
			$('.c-modal .input-nombre-modelo').val(locations[ubicacion].model);

			const missions = locations[ubicacion].missions;

			if (missions && missions.length > 0) {
				$('.c-modal .list-missions-binded').html('');

				for (let i = 0; i < missions.length; i++) {
					let mission = missions[i];

					if (misiones[mission]) {
						$('.c-modal .list-missions-binded').append(`
							<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster" mission="${mission}">
								<div>${misiones[mission].name}</div>
								<div class="btn btn-action" onclick="npcFunctions.unbindMission(${mission})"><i class="fas fa-trash-alt delete-item" aria-hidden="true"></i></div>
							</li>
						`);
					}
				}
			}
		}
	},

	toggleLocation: (id, value) => {
		const $selector = $('.lista-ubicaciones [location-id="' + id + '"] .location-status');
		let state = value ? Translations.Active : Translations.Inactive;
		$selector.removeClass(value ? "off" : "on").addClass(value ? "on" : "off");
		$selector.text(state);
		$selector.attr("onclick", "npcFunctions.toggleLocation(" + id + ", " + (value ? 0 : 1) + ")");
		TriggerCallback("origen_quests:server:ToggleLocation", { id, active: value }).done((cb) => {
			if (cb) {
				or.sendNotification('success', Translations.ToggleLocation + ' ' + state);
			} else {
				or.sendNotification('error', Translations.ErrorOccurred);
			}
		});
	},

    addItemRequerido: (item, label, quantity) => {
		let itemExistente = $(".c-modal ul.list-requeridos li[item='" + item + "']");
		if (itemExistente.length && !quantity) {
			let input = itemExistente.find('input');
			let valor = parseInt(input.val());
			input.val(valor + 1);
		} else {
			$('.c-modal ul.list-requeridos .sin-items').parent().remove();
			$('.c-modal ul.list-requeridos').append(`
            <li class="list-group-item item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster" item=${item}>
                <div>${label}</div>
                <div class="d-flex justify-content-center align-items-center">
                    <input placeholder="${Translations.Amount}" class="form-control text-center me-2" value="${
						quantity ?? 1
					}" min="0" type="number" style="width:6vh">
                    <div class="btn btn-action" onClick="$(this).parent().parent().remove();"><i class="fas fa-trash-alt delete-item"></i></div>
                </div>
            </li>
            `);
		}
	},

	addItemEntregado: (item, label, quantity) => {
		let itemExistente = $(".c-modal ul.list-entregados li[item='" + item + "']");
		if (itemExistente.length && !quantity) {
			let input = itemExistente.find('input');
			let valor = parseInt(input.val());
			input.val(valor + 1);
		} else {
			$('.c-modal ul.list-entregados .sin-items').parent().remove();
			$('.c-modal ul.list-entregados').append(`
            <li class="list-group-item item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster" item=${item}>
                <div>${label}</div>
                <div class="d-flex justify-content-center align-items-center">
                    <input placeholder="${Translations.Amount}" class="form-control text-center me-2" min="0" value="${
						quantity ?? 1
					}" type="number" style="width:6vh">
                    <div class="btn btn-action" onClick="$(this).parent().parent().remove();"><i class="fas fa-trash-alt delete-item"></i></div>
                </div>
            </li>
            `);
		}
	},

	renderGangs: () => {
		let html = '';
		let options = '';
		let selected = $('.c-modal .select-gangs-misiones').val();
		let filteredGangs = bandasAuxAdmin.filter(
			(gang) => !npcFunctions.auxSelectedGangs.includes(gang)
		);

		if (selected) {
			if (selected == 'all') {
				npcFunctions.auxSelectedGangs = [];
				html = `<li class="todas list-group-item list-group-item-action d-flex justify-content-between align-items-center">
				<div>${Translations.AllGangs}</div>
			</li>`;
			} else {
				npcFunctions.auxSelectedGangs.push(filteredGangs[selected]);
			}
		}
		if (npcFunctions.auxSelectedGangs.length == 0) {
			html = `<li class="todas list-group-item list-group-item-action d-flex justify-content-between align-items-center">
				<div>${Translations.AllGangs}</div>
				</li>`;
			options += `<option selected disabled>${Translations.SelectGang}</option>`;
		} else {
			npcFunctions.auxSelectedGangs.map((gang, index) => {
				html += `<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" gang="${gang.id}">
						<div class="gang">${gang.label}</div>
						<div class="btn btn-action" onclick="npcFunctions.deleteGang(${index})"><i class="fas fa-trash-alt delete-item" aria-hidden="true"></i></div>
					</li>`;
			});
			options += `<option selected disabled>${Translations.SelectGang}</option><option value="all">${Translations.AllGangs}</option>`;
		}
		filteredGangs = bandasAuxAdmin.filter(
			(gang) => !npcFunctions.auxSelectedGangs.includes(gang)
		);

		filteredGangs.map((banda, index) => {
			options += `<option value="${index}" idbanda="${banda.id}">${banda.label}</option>`;
		});
		$('.c-modal .list-organizaciones').html(html);
		$('.c-modal .select-gangs-misiones').html(options);
		$('.c-modal .modal-cargado').scrollTop(
			$('.c-modal .modal-cargado')[0].scrollHeight
		);
	},

	deleteGang: (index) => {
		npcFunctions.auxSelectedGangs.splice(index, 1);
		npcFunctions.renderGangs();
	},

	renderBusiness: () => {
		let html = '';
		let options = '';
		let selected = $('.c-modal .select-negocios-misiones').val();
		let filteredBusiness = negociosAuxAdmin.filter(
			(negocio) => !npcFunctions.auxSelectedBusiness.includes(negocio)
		);

		if (selected) {
			if (selected == 'all') {
				npcFunctions.auxSelectedBusiness = [];
				html = `<li class="todas list-group-item list-group-item-action d-flex justify-content-between align-items-center">
				<div>${Translations.AllBusinesses}</div>
			</li>`;
			} else {
				npcFunctions.auxSelectedBusiness.push(filteredBusiness[selected]);
			}
		}
		if (npcFunctions.auxSelectedBusiness.length == 0) {
			html = `<li class="todas list-group-item list-group-item-action d-flex justify-content-between align-items-center">
					<div>${Translations.AllBusinesses}</div>
				</li>`;
			options += `<option selected disabled>${Translations.SelectBusiness}</option>`;
		} else {
			npcFunctions.auxSelectedBusiness.map((negocio, index) => {
				html += `<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" business="${negocio.id}">
						<div class="gang">${negocio.label}</div>
						<div class="btn btn-action" onclick="npcFunctions.deleteBusiness(${index})"><i class="fas fa-trash-alt delete-item" aria-hidden="true"></i></div>
					</li>`;
			});
			options += `<option selected disabled>${Translations.SelectBusiness}</option><option value="all">${Translations.AllBusinesses}</option>`;
		}
		filteredBusiness = negociosAuxAdmin.filter(
			(gang) => !npcFunctions.auxSelectedBusiness.includes(gang)
		);

		filteredBusiness.map((negocio, index) => {
			options += `<option value="${index}" idnegocio="${negocio.id}">${negocio.label}</option>`;
		});
		$('.c-modal .list-negocios').html(html);
		$('.c-modal .select-negocios-misiones').html(options);
		$('.c-modal .modal-cargado').scrollTop(
			$('.c-modal .modal-cargado')[0].scrollHeight
		);
	},

	deleteBusiness: (index) => {
		npcFunctions.auxSelectedBusiness.splice(index, 1);
		npcFunctions.renderBusiness();
	},

    saveMission: (mision) => {
		const nombre = $('.c-modal .input-nombre-mision').val();
		const desc = $('.c-modal .input-descripcion-mision').val();
		let valido = true;
		if (nombre == '' || nombre.length < 4) {
			or.sendNotification('error', Translations.NameLength4);
			valido = false;
		}

		if (desc == '' || desc.length < 10) {
			or.sendNotification('error', Translations.NameLength10);
			valido = false;
		}

		const requeridos = {};
		$('.c-modal .list-requeridos .item').each(function () {
			const key = $(this).attr('item');
			const value = parseInt($(this).find('.form-control').val());
			if (value > 0) {
				requeridos[key] = value;
			} else {
				validado = false;
				or.sendNotification('error', Translations.NoItem0);
			}
		});

		const entregados = {};
		$('.c-modal .list-entregados .item').each(function () {
			const key = $(this).attr('item');
			const value = parseInt($(this).find('.form-control').val());
			if (value > 0) {
				entregados[key] = value;
			} else {
				validado = false;
				or.sendNotification('error', Translations.NoItem0);
			}
		});

		const restGangs = {
			gangs: []
		};
		if ($('.restricciones .check-dispo.organizaciones').is(':checked')) {
			if ($('.c-modal .list-organizaciones .todas').length > 0) {
				restGangs.gangs.push('all');
			} else {
				$('.c-modal .list-organizaciones li').each(function () {
					const key = $(this).attr('gang');

					restGangs.gangs.push(key);
				});
			}

			restGangs.time = $('.c-modal .select-gangs-repeticiones').val();
		}

		const restBusiness = {
			business: []
		};
		if ($('.restricciones .check-dispo.negocios').is(':checked')) {
			if ($('.c-modal .list-negocios li.todas').length > 0) {
				restBusiness.business.push('all');
			} else {
				$('.c-modal .list-negocios li').each(function () {
					const key = $(this).attr('business');

					restBusiness.business.push(key);
				});
			}

			restBusiness.time = $('.c-modal .select-negocios-repeticiones').val();
		}

		let restCivil;
		if ($('.restricciones .check-dispo.civiles').is(':checked')) {
			restCivil = $('.c-modal .select-civiles-repeticiones').val();
		}

		if (valido) {
			const data = {
				name: nombre,
				description: desc,
				events: [],
				rest: []
			};

			if (Object.entries(requeridos).length > 0 || Object.entries(entregados).length > 0) {
				data.events.push({
					type: 'ItemTrade',
					requested: requeridos,
					give: entregados
				});
			}

			if (restGangs.gangs.length > 0) 
				data.rest.push(restGangs);

			if (restBusiness.business.length > 0)
				data.rest.push(restBusiness);

			if (restCivil)
				data.rest.push({ civ: restCivil });

			if (mision)
				data.id = mision;


			TriggerCallback(mision ? "origen_quests:server:UpdateMission" : 'origen_quests:server:CreateMission', {data}).done((cb) => {
				if (cb) {
					CloseModal();

					or.sendNotification('success', mision ? Translations.MissionEdited : Translations.MissionCreated);
					loadAdminQuests();
				} else {
					or.sendNotification('error', mision ? Translations.MissionEditFailed : Translations.MissionCreationFailed);
				}
			});
		}
	},

	

    loadModalMision: (mision) => {
		OpenModal(
			mision ? Translations.EditMission : Translations.NewMission,
			`
            <div class="cargando-modal" >
                <div class="d-flex justify-content-center align-items-center" style="height:50vh">
                <img src="https://i.gifer.com/origin/34/34338d26023e5515f6cc8969aa027bca.gif" style="width:15vh">
                </div>
            </div>
            <div class="modal-cargado" style="display:none;"></div>

        `,
			`<button class="btn-modal" onclick="npcFunctions.saveMission(${mision ? mision : false})">${Translations.SaveChanges}</button>`,
			Translations.Cancel,
			127
		);

		let tablaItems = '';
	
		let label = '';
		let description = '';
		itemsFunctions.loadItems().done((items) => {
			getAllGangs().done((gangs) => {
				getAllBusiness().done((business) => {
					if (items) {
						Object.entries(items).forEach(([key, item]) => {
							tablaItems += `
							<tr>
								<td>${item.name}</td>
								<td>${item.label}</td>
								<td>${item.description}</td>

								<td class="d-flex">

									<div class="btn-action me-2 p-1" style="font-size:1.2vh" onClick="npcFunctions.addItemRequerido('${item.name}', '${item.label}')">
										${Translations.Require}
									</div>
									<div class="btn-action me-2 p-1" style="font-size:1.2vh" onClick="npcFunctions.addItemEntregado('${item.name}', '${item.label}')">
										${Translations.Deliver}
									</div>

								</td>

							</tr>`;
						})
			
					}
					bandasAuxAdmin = gangs;
					negociosAuxAdmin = business;
					npcFunctions.auxSelectedGangs = [];
					npcFunctions.auxSelectedBusiness = [];
					let bandas = '';

					bandasAuxAdmin.map((banda, index) => {
						bandas += `<option value="${index}" idbanda="${banda.id}">${banda.label}</option>`;
					});

					let negocios = '';
					negociosAuxAdmin.map((negocio, index) => {
						negocios += `<option value="${index}" idnegocio="${negocio.id}">${negocio.label}</option>`;
					});

					if (mision) {
						label = misiones[mision].name;
						description = misiones[mision].description;
					}

					$('.c-modal .modal-cargado').append(`
						<h3>${Translations.Mission}</h3>
						<div class="row mb-4">
							<div class="col-12">
								<label>${Translations.Name}</label>
								<input class="form-control w-100 input-nombre-mision" placeholder="${Translations.MissionName}" value="${label}">
							</div>
							<div class="col-12 mt-2">
								<label>${Translations.Description}</label>
								<textarea class="form-control w-100 input-descripcion-mision" placeholder="${Translations.MissionDescription}">${description}</textarea>
							</div>
						</div>

						<h3>${Translations.Items}</h3>
						<table class="w-100 tabla-items-mision">
							<thead>
								<tr>
									<th>${Translations.Id}</th>
									<th>${Translations.Name}</th>
									<th>${Translations.Description}</th>

									<th>${Translations.Actions}</th>
								</tr>
							</thead>
							<tbody>
								${tablaItems}
							</tbody>
						</table>

						<div class="row mt-4">
							<div class="col-6">
								<h5>${Translations.RequiredItems}</h5>
								<ul class="list-group multas-list mt-2 list-requeridos">
									<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster">
										<div class="sin-items">${Translations.NoItemsSelected}</div>

									</li>
								</ul>
							</div>
							<div class="col-6">
								<h5>${Translations.DeliveredItems}</h5>
								<ul class="list-group multas-list mt-2 list-entregados">
									<li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster">
										<div class="sin-items">${Translations.NoItemsSelected}</div>

									</li>
								</ul>
							</div>
						</div>

						<h3 class="mt-4">${Translations.Restrictions}</h3>
						<div class="row mt-3 restricciones">
							<div class="col-4">
								<label>${Translations.Civils}</label>
								<div class="check">
									<label class="switch">
										<input type="checkbox" class="check-dispo civiles">
										<span class="slider-check round"></span>
									</label>
								</div>
								<div class="p-2 info-box mt-2 rest-civiles" style="display:none;">

									<h6>${Translations.MissionRepeat}</h6>
									<select class="form-select w-100 select-civiles-repeticiones">
										<option selected value="OneTime">${Translations.NoRepeatAllowed}</option>
										<option disabled></option>
										<option disabled><b>${Translations.Daily}</b></option>
										<option value="OneTimeADay">${Translations.OncePerDay}</option>
										<option disabled></option>
										<option disabled>${Translations.Weekly}</option>
										<option value="OneTimeAWeek">${Translations.OncePerWeek}</option>
										<option disabled></option>
										<option disabled>${Translations.Monthly}</option>
										<option value="OneTimeAMonth">${Translations.OncePerMonth}</option>
									</select>

								</div>

							</div>
							<div class="col-4">
								<label>${Translations.Gangs}</label>
								<div class="check">
									<label class="switch">
										<input type="checkbox" class="check-dispo organizaciones">
										<span class="slider-check round"></span>
									</label>
								</div>
								<div class="p-2 info-box mt-2 rest-gangs" style="display:none;">
									<div class="d-flex justify-content-center align-items-center w-100" style="gap:1vh">
										<select class="form-select w-100 select-gangs-misiones">
											<option selected disabled>${Translations.SelectGang}</option>
											${bandas}
										</select>
										
										<button class="btn btn-action p-2" onClick="npcFunctions.renderGangs()" style="color:white !important;">${Translations.Add}</button>

									</div>
									<h6 class="mt-3">${Translations.SelectedGangs}</h6>
									<ul class="list-group multas-list mt-2 list-organizaciones">
										<li class="todas list-group-item list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster">
											<div>${Translations.AllGangs}</div>

										</li>
									</ul>
									<h6 class="mt-3">${Translations.MissionRepeat}</h6>
									<select class="form-select w-100 select-gangs-repeticiones">
											<option selected value="OneTime">${Translations.NoRepeatAllowed}</option>
											<option disabled></option>
											<option disabled><b>${Translations.Daily}</b></option>
											<option value="OneTimeADayMember">${Translations.OncePerDayPerMember}</option>
											<option value="OneTimeADayGang">${Translations.OncePerDayPerMember}</option>
											<option disabled></option>
											<option disabled>${Translations.Weekly}</option>
											<option value="OneTimeAWeekMember">${Translations.OncePerWeekPerMember}</option>
											<option value="OneTimeAWeekGang">${Translations.OncePerWeekPerGang}</option>
											<option disabled></option>
											<option disabled>${Translations.Monthly}</option>
											<option value="OneTimeAMonthMember">${Translations.OncePerMonthPerMember}</option>
											<option value="OneTimeAMonthGang">${Translations.OncePerMonthPerGang}</option>

									</select>

								</div>

							</div>
							<div class="col-4">
							<label>${Translations.Businesses}</label>
							<div class="check">
								<label class="switch">
									<input type="checkbox" class="check-dispo negocios">
									<span class="slider-check round"></span>
								</label>
							</div>
							<div class="p-2 info-box mt-2 rest-business" style="display:none;">
								<div class="d-flex justify-content-center align-items-center w-100" style="gap:1vh">
									<select class="form-select w-100 select-negocios-misiones">
										<option selected disabled>${Translations.SelectBusiness}</option>
										${negocios}
									</select>
									<button class="btn btn-action p-2" onClick="npcFunctions.renderBusiness()" style="color:white !important;">${Translations.Add}</button>
								</div>
								<h6 class="mt-3">${Translations.SelectedBusinesses}</h6>
								<ul class="list-group multas-list mt-2 list-negocios">
									<li class="list-group-item todas list-group-item-action d-flex justify-content-between align-items-center animate__animated animate__zoomIn animate__faster">
										<div>${Translations.AllBusinesses}</div>

									</li>
								</ul>
								<h6 class="mt-3">${Translations.MissionRepeat}</h6>
								<select class="form-select w-100 select-negocios-repeticiones">
										<option selected value="OneTime">${Translations.NoRepeatAllowed}</option>
										<option disabled></option>
										<option disabled><b>${Translations.Daily}</b></option>
										<option value="OneTimeADayEmployee">${Translations.OncePerDayPerEmployee}</option>
										<option value="OneTimeADayBusiness">${Translations.OncePerDayPerBusiness}</option>
										<option disabled></option>
										<option disabled>${Translations.Weekly}</option>
										<option value="OneTimeAWeekEmployee">${Translations.OncePerWeekPerEmployee}</option>
										<option value="OneTimeAWeelBusiness">${Translations.OncePerWeekPerBusiness}</option>
										<option disabled></option>
										<option disabled>${Translations.Monthly}</option>
										<option value="OneTimeAMonthEmployee">${Translations.OncePerMonthPerEmployee}</option>
										<option value="OneTimeAMonthBusiness">${Translations.OncePerMonthPerBusiness}</option>

									</select>

							</div>

						</div>

					</div>

				`);

					if (mision != undefined) {
						if (misiones[mision].events) {
							itemsFunctions.loadItems().done((items) => {
								if (items) {
									const aMisiones = misiones[mision].events;
									aMisiones.map((evento, _) => {
										if (evento.give) {
											let gives = Object.values(evento.give);
											let givesKeys = Object.keys(evento.give);
											gives.map((itemGive, index) => {
												const id = givesKeys[index];
												const quantity = itemGive;
												const label = items[id].label;
												
												npcFunctions.addItemEntregado(
													id,
													label,
													quantity
												);
											});
										}
										if (evento.requested) {
											let gives = Object.values(evento.requested);
											let givesKeys = Object.keys(evento.requested);

											gives.map((itemGive, index) => {
												const id = givesKeys[index];
												const label = items[id].label;

												const quantity = itemGive;

												npcFunctions.addItemRequerido(
													id,
													label,
													quantity
												);
											});
										}
									});
								}
							});
						}

						if (misiones[mision].rest) {
							const aRestricciones = misiones[mision].rest;
							aRestricciones.map((rest, index) => {
								if (rest.civ) {
									$('.restricciones .check-dispo.civiles').prop(
										'checked',
										true
									);
									$('.restricciones .check-dispo.civiles').trigger('change');
									$('.c-modal .select-civiles-repeticiones').val(rest.civ);
									$('.c-modal .select-civiles-repeticiones').trigger('change');
								}

								if (rest.gangs) {
									$('.restricciones .check-dispo.organizaciones').prop(
										'checked',
										true
									);
									$('.restricciones .check-dispo.organizaciones').trigger(
										'change'
									);
									$('.c-modal .select-gangs-repeticiones').val(rest.time);
									$('.c-modal .select-gangs-repeticiones').trigger('change');

									if (rest.gangs.includes('all')) {
										$('.c-modal .select-gangs-misiones [value="all"]').prop('selected', true)
										$('.c-modal .select-gangs-misiones').trigger('change');
										$('.restricciones .rest-gangs button').trigger(
											'click'
										);
									} else {
										rest.gangs.map((gang, index) => {
											$('.c-modal .select-gangs-misiones [idbanda="' + gang + '"]').prop('selected', true)
											$('.c-modal .select-gangs-misiones').trigger('change');
											$('.restricciones .rest-gangs button').trigger(
												'click'
											);
										});
									}
								}

								if (rest.business) {
									$('.restricciones .check-dispo.negocios').prop(
										'checked',
										true
									);
									$('.restricciones .check-dispo.negocios').trigger('change');
									$('.c-modal .select-negocios-repeticiones').val(rest.time);
									$('.c-modal .select-negocios-repeticiones').trigger('change');

									if (rest.business.includes('all')) {
										$('.c-modal .select-negocios-misiones [value="all"]').prop('selected', true)
										$('.c-modal .select-negocios-misiones').trigger('change');
										$('.restricciones .rest-business button').trigger(
											'click'
										);
									} else {
										rest.business.map((business, index) => {
											$('.c-modal .select-negocios-misiones [idnegocio="' + business + '"]').prop('selected', true)
											$('.c-modal .select-negocios-misiones').trigger('change');
											$('.restricciones .rest-business button').trigger(
												'click'
											);
										});
									}
								}
							});
						}
					}

					$('.c-modal .tabla-items-mision').DataTable({
						language: dataTableLanguage,
						pageLength: 10,
						lengthChange: false
					});

					$('.c-modal .cargando-modal').fadeOut(300, function () {
						$('.c-modal .modal-cargado').fadeIn(300);
					});
				});
			});
		});
	},
	modalEditMission: (yo) => {
		npcFunctions.loadModalMision(yo);
	},

	modalEditLocation: (id) => {
		npcFunctions.loadModalLocation(id);
	},


	markLocation: (x, y, z) => {
		or.fetch('SetWaypointinCoords', { x, y });
		or.sendNotification('success', Translations.LocationMarkedOnMap);
	},

	saveLocation: (ubicacion) => {
		function hexToRgb(hex) {
			hex = hex.replace(/^#/, '');
			let bigint = parseInt(hex, 16);
			let r = (bigint >> 16) & 255;
			let g = (bigint >> 8) & 255;
			let b = bigint & 255;
			return `rgb(${r}, ${g}, ${b})`;
		};

		const nombre = $('.c-modal .input-nombre-ubicacion').val();
		const tipo = $('.c-modal .select-tipo-ubicacion').val();
		let x = $('.c-modal .input-cord-x').val();
		let y = $('.c-modal .input-cord-y').val();
		let z = $('.c-modal .input-cord-z').val();
		let w = $('.c-modal .input-cord-w').val();
		let anim1;
		let anim2;
		let anim3;
		let modelo;
		let marker_draw_distance = $('.c-modal .input-marker_draw_distance').val();
		let marker_type = $('.c-modal .input-marker_type').val();
		let marker_color_input = $('.c-modal .input-marker_color').val();
		let marker_color = hexToRgb(marker_color_input);
		let valido = true;

		console.log(hexToRgb(marker_color));

		if (nombre == '' || nombre.length < 4) {
			or.sendNotification('error', Translations.NameLength4);
			valido = false;
		}

		// if (marker_draw_distance == '' || marker_draw_distance.length < 1) {
		// 	or.sendNotification('error', Translations.MarkerDrawMinimeLenght);
		// 	valido = false;
		// }

		// if (marker_type == '' || isNaN(marker_type) || marker_type < 0 || marker_type > 43) {
		// 	or.sendNotification('error', Translations.MarkerTypeNoValid);
		// 	valido = false;
		// }

		 if (marker_type < 0 || marker_type > 43) {
		 	or.sendNotification('error', Translations.MarkerTypeNoValid);
		 	valido = false;
		 }

		if (x == '' || y == '' || z == '' || w == '') {
			or.sendNotification('error', Translations.AllCoordinatesRequired);
			valido = false;
		} else {
			x = parseFloat(x).toFixed(2);
			y = parseFloat(y).toFixed(2);
			z = parseFloat(z).toFixed(2);
			w = parseFloat(w).toFixed(2);
		}

		if (tipo != 'marker') {
			modelo = $('.c-modal .input-nombre-modelo').val();

			if (modelo == '' || modelo.length < 4) {
				or.sendNotification('error', Translations.ModelNameRequired);
				valido = false;
			}

		}

		if (tipo == 'new_npc') {
			anim1 = $('.c-modal .input-anim-1').val();
			anim2 = $('.c-modal .input-anim-2').val();
			anim3 = $('.c-modal .input-anim-3').val();
		}

		if (valido) {
			const data = {
				name: nombre,
				type: tipo,
				coords: {
					x,
					y,
					z,
					w
				},
				anim1,
				anim2,
				anim3,
				model: modelo,
				marker_draw_distance,
				marker_type,
				marker_color,
				missions: []
			};

			if ($('.c-modal .list-missions-binded .sin-items').length == 0) {
				$('.c-modal .list-missions-binded li').each(function () {
					data.missions.push(parseInt($(this).attr('mission')));
				});
			}

			if (ubicacion)
				data.id = ubicacion;

			TriggerCallback(ubicacion ? "origen_quests:server:UpdateLocation" : 'origen_quests:server:CreateLocation', {data}).done((cb) => {
				if (cb) {
					CloseModal();

					or.sendNotification('success', ubicacion ? Translations.LocationEdited : Translations.LocationCreated);
					loadAdminQuests();
				} else {
					or.sendNotification('error', ubicacion ? Translations.LocationEditFailed : Translations.LocationCreationFailed);
				}
			});
		}
	},

	confirmDeleteMission: (yo) => {
		OpenModal(
			Translations.DeleteMission,
			`
            <h5>${Translations.ConfirmDeleteMission}</h5>
            <p>${Translations.ActionCannotBeUndone}</p>
        `,
			`<button class="btn-modal" onclick="npcFunctions.deleteMission(${yo})">${Translations.Delete}</button>`,
			Translations.Cancel
		);
	},
	
	confirmDeleteLocation: (id) => {
		OpenModal(
			Translations.DeleteLocation,
			`
            <h5>${Translations.ConfirmDeleteLocation}</h5>
            <p>${Translations.ActionCannotBeUndone}</p>
        `,
			`<button class="btn-modal" onclick="npcFunctions.deleteLocation(${id})">${Translations.Delete}</button>`,
			Translations.Cancel
		);
	},

	deleteLocation: (id) => {
		TriggerCallback("origen_quests:server:DeleteLocation", { id }).done((cb) => {
			if (cb) {
				CloseModal();
				or.sendNotification('success', Translations.LocationDeleted);
				loadAdminQuests();
			} else {
				or.sendNotification('error', Translations.ErrorOccurred);
			}
		});
	},

	deleteMission: (id) => {
		TriggerCallback('origen_quests:server:DeleteMission', {id}).done((cb) => {
			if (cb) {
				CloseModal();
				or.sendNotification('success', Translations.MissionDeleted);
				loadAdminQuests();
			} else {
				or.sendNotification('error', Translations.ErrorOccurred);
			}
		});
	},

}

function LoadTranslations(translations) {
	Translations = Object.assign(Translations, translations);
	const transalateElements = $('[translate]');
	transalateElements.each(function () {
		const key = $(this).attr('translate');
		$(this).html(Translations[key] ? Translations[key] : Translations.UnknownKey);
	});
}

window.addEventListener('message', function (event) {

    if (event.data.menu) {
        or.open();
		loadAdminQuests();

		if(event.data.translations && Translations.length == 0) {
			LoadTranslations(event.data.translations);
			OnTranslationsReady();
		}

		inventory = event.data.inventory;

		$(".missions-list").html("");

        missions.forEach(mission => {
            $(".missions-list").append(`<div class="mission" mission-id="${mission.id}"><i class="fa-regular fa-circle-question"></i> ${mission.name}</div>`);
        });
    } 

	if (event.data.action == "open") {
        missions = event.data.missions;

		if(event.data.translations && Translations.length == 0) {
			LoadTranslations(event.data.translations);
			OnTranslationsReady();
		}

		inventory = event.data.inventory;

        $(".quests-container").fadeIn(500);
        $(".quests-container").attr("location-id", event.data.location_id);

        abrir.play();

        $(".missions-list").html("");

        missions.forEach(mission => {
            $(".missions-list").append(`<div class="mission" mission-id="${mission.id}"><i class="fa-regular fa-circle-question"></i> ${mission.name}</div>`);
        });
    }
});

function showMission(id) {
    $(".mission-content-block").fadeOut(200);

    missions.forEach(mission => {
        if (mission.id == id) {
            $(".mission-content-block").attr("mission-id", mission.id);
            $(".mission-content-block .name").html(mission.name);
            $(".mission-content-block .mission-content .description").html(markdownToHtml(mission.description));

            $(".items").hide();
            $(".items .request").html("");
            $(".items .reward").html("");
            
            mission.events.forEach(event => {
                if (event.type == "ItemTrade") {
                    Object.values(event.requested).forEach(item => {
						$(".items .request").append(`
							<div class="item" label="${item.label}" description="${item.description}">
								<img src="${getImageUrl(item.name)}" onerror="javascript:this.src='./img/default.png'">
								<div class="cantidad">x${item.amount}</div>
							</div>
						`);
                    });

                    Object.values(event.give).forEach(item => {
						$(".items .reward").append(`
							<div class="item" label="${item.label}" description="${item.description}">
								<img src="${getImageUrl(item.name)}" onerror="javascript:this.src='./img/default.png'">
								<div class="cantidad">x${item.amount}</div>
							</div>
						`);
                    });

                    $(".items").show();
                }
            });

            setTimeout(function() {
                $(".mission-content-block").fadeIn(200);
            }, 200);
        }
    });
}


$(document).on("click", ".mission", function() {
    click.play();

    let id = $(this).attr("mission-id");

    showMission(id);
});

$(document).on("click", ".accept", function() {
    click.play();

    let id = $(".mission-content-block").attr("mission-id");
    let location_id = $(".quests-container").attr("location-id");

    $.post("https://origen_quests/accept", JSON.stringify({id: parseInt(id), location_id: parseInt(location_id)}));
	closeQuests()
});

$(document).on("keydown", function(data) {
    if (data.which == 27) {
		$.post("https://origen_quests/close");
        or.closeMenu();
		closeQuests();
    }
});

function closeQuests() {
    abrir.play();

    $(".quests-container").fadeOut(500);

    $.post("https://origen_quests/close");

    $(".mission-content-block").fadeOut(200);

    $('.item-info-container').hide();
}

function getImageUrl(str) {
    if (str.startsWith('https://') || str.startsWith('http://')) {
        return str;
    } else {
		if (inventory == 'ox_inventory') {
			return `https://cfx-nui-ox_inventory/web/images/${str}.png`;
		} else {
			return `https://cfx-nui-${inventory}/html/images/${str}.png`;
		}
    }
}

$(document).on('mouseenter', '.item', function (e) {
	e.preventDefault();

    const label = $(this).attr('label');
    const description = $(this).attr('description');

	if (label && description) {
		let top = $(this).offset().top + 'px';
		let left = $(this).offset().left - 250 + 'px';

		$('.item-info-container').show();
		$('.item-info-container').css('top', top);
		$('.item-info-container').css('left', left);

        $('.item-info-title').html(label);
		$('.item-info-description').html(description);
	}
});

$(document).on('mouseleave', '.item', function (e) {
	e.preventDefault();

	$('.item-info-container').hide();
});

$(document).on('change', '.restricciones .check-dispo', function () {
	$('.restricciones .check-dispo').not(this).prop('checked', false);

	const isChecked = $(this).is(':checked');
	if ($(this).hasClass('organizaciones') && isChecked) {
		$('.c-modal .rest-gangs').show(300);
	} else {
		$('.c-modal .rest-gangs').hide(300);
	}

	if ($(this).hasClass('civiles') && isChecked) {
		$('.c-modal .rest-civiles').show(300);
	} else {
		$('.c-modal .rest-civiles').hide(300);
	}

	if ($(this).hasClass('negocios') && isChecked) {
		$('.c-modal .rest-business').show(300);
	} else {
		$('.c-modal .rest-business').hide(300);
	}
	$('.c-modal .modal-cargado').animate(
		{ scrollTop: $('.c-modal .modal-cargado')[0].scrollHeight },
		300
	);
});


$(document).on('change', '.select-tipo-ubicacion', function () {
	const value = $(this).val();

	if (value == 'marker') {
		$(".input-nombre-ubicacion").parent().removeClass("col-4").addClass("col-6");
		$(this).parent().removeClass("col-4").addClass("col-6");
		$(".input-marker_draw_distance").css("display", "flex");
		$(".draw_options_title").css("display", "flex");
		$(".input-marker_type").css("display", "flex");
		$(".input-marker_color").css("display", "flex");
		$(".input-nombre-modelo").parent().hide();
	} else {
		$(".input-nombre-ubicacion").parent().removeClass("col-6").addClass("col-4");
		$(this).parent().removeClass("col-6").addClass("col-4");
		$(".input-marker_draw_distance").css("display", "none");
		$(".input-marker_type").css("display", "none");
		$(".input-marker_color").css("display", "none");
		$(".draw_options_title").css("display", "none");
		$(".input-nombre-modelo").parent().show();
	}

	if (value == "new_npc") {
		$(".locationNpcAnims").css("display", "flex");
	} else {
		$(".locationNpcAnims").css("display", "none");
	}
});

function markdownToHtml(markdown) {
    markdown = markdown.replace(/^(#+)\s+(.*)$/gm, function(match, p1, p2) {
        var level = p1.length;
        return "<h" + level + ">" + p2 + "</h" + level + ">";
    });
    markdown = markdown.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>");
    markdown = markdown.replace(/\*(.*?)\*/g, "<em>$1</em>");
    markdown = markdown.replace(/^(?!<h|<ul|<ol|<li|<p|<div)(.*)$/gm, "<p>$1</p>");
    return markdown;
}


function Search(type) {
    let text = $(`.search-input-${type}`).val().toLowerCase();
    let list = $(`.lista-${type} .list-group-item`);

    for (let i = 0; i < list.length; i++) {
        let listItemText = list[i].textContent.toLowerCase();
        if (!listItemText.includes(text)) {
            list[i].style.display = "none";
        } else {
            list[i].style.display = "block";
        }
    }
}