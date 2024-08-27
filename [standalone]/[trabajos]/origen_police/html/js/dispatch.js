const dispatchFunctions = {
	addNewAlert: (
		message,
		distance,
		street,
		code,
		count,
		total,
		ago,
		title,
		newAlert,
		direction,
		metadata,
		annotation,
		central,
		playerID
	) => {
		$('.actual-alert').text(count);
		$('.total-alert').text(total);

		if (count == total) {
			$('.control .key.right').css('opacity', 0.5);
		} else {
			$('.control .key.right').css('opacity', 1);
		}

		if (count == 1) {
			$('.control .key.left').css('opacity', 0.5);
		} else {
			$('.control .key.left').css('opacity', 1);
		}

		const animEntry = direction ? 'entry' : 'entry-right';
		const animExit = direction ? 'exit' : 'exit-left';

		//MAP PARA METADATA QUE RECORRE EL OBJECTO Y SEGÚN SU KEY, ASIGNA UN ICONO Y LO UNE AL VALUE
		let metadataHtml = '';
		let centralClass = central ? 'central' : '';
		if (metadata) {
			Object.keys(metadata).map((key) => {
				let icon = '';
				let text = '';
				switch (key) {
					case 'name':
						icon = 'user';
						text = metadata[key];
						break;
					case 'model':
						icon = 'car';
						text = metadata[key];
						break;
					case 'plate':
						icon = 'keyboard';
						text = metadata[key];
						break;
					case 'speed':
						icon = 'tachometer-alt';
						text = metadata[key];
						break;
					case 'weapon':
						icon = 'gun';
						text = metadata[key];
						break;
					case 'ammotype':
						icon = 'record-vinyl';
						text = metadata[key];
						break;
					case 'color':
						icon = 'tint';
						text =
							"<div class='color-car' style='background-color:rgb(" +
							metadata[key] +
							'); box-shadow: 0 0 10px rgb(' +
							metadata[key] +
							")'></div>";
						break;
				}
				metadataHtml += `<div class="alert-metadata-item"><i class="fas fa-${icon}"></i> ${text}</div>`;
			});
		}

		dispatch_interval = setInterval(() => {
			ago = ago + 1;
			if (ago < 60 || ago % 60 == 0) {
				$('.alert-time').html(
					`<i class="fas fa-clock"></i> ${secondsOrMinutes(ago)}`
				);
			}
		}, 1000);

		if (central) {
			metadataHtml += `<div class="alert-metadata-item"> <i class="fa-solid fa-building-circle-arrow-right"></i> ${Translations.AssignedByDispatch}</div>`;
		}

		if (annotation) {
			metadataHtml += `<div class="alert-metadata-item align-items-start"><i class="fa-solid fa-note-sticky mt-1"></i> <div class="w-100">${annotation}</div></div>`;
		}

		$('.alert-list')
			.addClass(animExit)
			.animate({ opacity: 0 }, 250, function () {
				$(this).removeClass(animExit);
				$('.alert-list')
					.html(
						`
            <div class="alerta ${centralClass} ${newAlert ? 'parpadeo' : ''}">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="alert-title w-100">${title}</div>
                    <div class="alert-distance">
                        <i class="fas fa-road"></i> ${distance}
                    </div>
                </div>

                <div class="alert-description">${message ? message : ''}</div>
                <div class="alert-data">

                    <div class="alert-location">
                        <i class="fas fa-map-marker-alt"></i> ${street}
                    </div>
                    <div class="alert-code">
                        <i class="fas fa-list-ol"></i> #${checkNumber(code)}
                    </div>
					${playerID ? `
					<div class="alert-id">
						<i class="fas fa-user" aria-hidden="true"></i>${playerID}
					</div>
					` : ''}
                    <div class="alert-time">
                        <i class="fas fa-clock"></i> ${secondsOrMinutes(ago)}
                    </div>
                    ${metadataHtml}
                </div>
            </div>

            `
					)
					.addClass(animEntry);
				setTimeout(function () {
					$('.alert-list').removeClass(animEntry).animate({ opacity: 1 }, 250);
				}, 50);
			});
		if (!$('.tab-alerts').hasClass('selected')) {
			$('.dispatch .police-tab').removeClass('selected');
			$('.dispatch .tab-alerts').addClass('selected');

			$('.dispatch .tab-content.active')
				.removeClass('active')
				.fadeOut(150, function () {
					$('.dispatch .tab-content.alertas').addClass('active').fadeIn(150);
				});
		}
		// $(".alerts-container").append(`
	}
};

$(document).on('click', '.key-selector', function () {
	yo = $(this);
	yo.addClass('active').text(' - ');
	yo.on('keydown', function (event) {
		//Obtengo la tecla pulsada, la convierto en mayuscula y la pinto en el boton
		let tecla = false;
		let regex = /^[a-zA-Z0-9]+$/;
		let action = $(this).attr('action');
		if (teclas[event.keyCode]) {
			tecla = teclas[event.keyCode];
		} else {
			tecla = String.fromCharCode(event.keyCode).toUpperCase();
		}
		if (tecla && regex.test(tecla)) {
			exportEvent('origen_police', 'AddKeyBind', [tecla, action]);
			yo.removeClass('active').off('keydown');
			// $(".key-" + tecla).removeClass("key-" + tecla).addClass("key--").html(" - ");
			yo.html(tecla);
		}
	});
});

$(document).on('change', '.check-config-alerts', function () {
	const action = $(this).attr('action');

	//Introduce todos los checks que están en true de la clase check-config-alerts en un array
	let checks = [];
	$('.check-config-alerts').each(function () {
		if ($(this).prop('checked')) {
			checks.push($(this).attr('action'));
		}
	});
	fetch('SetFilter', { filter: checks });
});

$(".dispatch-block").draggable({
    containment: 'window',
    start: function () {
        $(this).css("transition", "none");
    },
    stop: function () {
        $(this).css("transition", "");
    },
});