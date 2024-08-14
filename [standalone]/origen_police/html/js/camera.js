camerasFunctions = {
	cameraEvents: () => {
		$(document).on('click', '.cameras .refresh-cameras', function () {
			const yo = $(this);
			yo.attr('disabled', true);
			camerasFunctions.loadCameras();
			setTimeout(() => {
				yo.attr('disabled', false);
			}, 2000);
		});
	},

	loadCameras: () => {
		$('.police .cameras .camera-list').html('');
		TriggerCallback('origen_police:server:GetBodyCams', {}).done((cb) => {
			if (cb && cb.length > 0) {
				cb.map((camera) => {
					$('.police .cameras .camera-list.bodycam').append(`
                    <div class="camera scale-in" id="pl-${camera.source}" onclick="camerasFunctions.showCam('body', ${
						camera.source
					}, '${camera.name}', '${camera.badge} - ${camera.grade}')">
                        <img src="${camera.image || './img/default.jpg'}" class="rounded" style="filter:hue-rotate(-${currentHueDeg}deg);">
                        <div class="camera-info">
                            <div class="camera-title">${camera.name}</div>
                            <div class="camera-owner">${camera.badge} - ${
						camera.grade
					}</div>
                        </div>
                    </div>
                    `);

					setTimeout(() => {
						try {
							var imageElement = $('.police .cameras .camera-list.bodycam #pl-'+camera.source.toString() +' img');
							var imgUrl = imageElement.attr("src");
							var url = imgUrl.replace('https://', 'https://').split('?')[0];
							console.log(url)
							var img = new Image();
							img.src = url;
							img.onerror = function () {
								imageElement.attr('src', defaultImage);
							}
						}
						catch (e) {}
					}, 200);
				});
			}
		});

		TriggerCallback('origen_police:server:GetVehiclesTracked', {}).done((cb) => {
			if (cb && Object.keys(cb).length > 0) {
				Object.entries(cb).map(([key, camera]) => {
					$('.police .cameras .camera-list.vehicles').append(`
                    <div class="camera scale-in" onclick="camerasFunctions.showCam('vehicle', ${key}, '${camera.model}', '${camera.plate}')">
                        <img src="./img/icons/8aWTt9A.png">
                        <div class="camera-info">
                            <div class="camera-title">${camera.model}</div>
                            <div class="camera-owner">${camera.plate}</div>
                        </div>
                    </div>
                    `);
				});
			}
		});
		exportEvent('origen_police', 'GetCamsInArea', {}).done((cb) => {
			if (cb && cb.length > 0) {
				cb.map((camera, i) => {
					$('.police .cameras .camera-list.business').append(`
                    <div class="camera scale-in" onclick="camerasFunctions.showCam('business', ${
						camera.obj
					}, '${Translations.SingleCamera} ${i + 1}', 'A ${camera.dist.toFixed(2)} ${Translations.Meters}')">
                        <img src="./img/icons/46IfeYQ.png">
                        <div class="camera-info">
                            <div class="camera-title">${Translations.SingleCamera} ${i + 1}</div>
                            <div class="camera-owner"><i class="fas fa-map-marker-alt"></i> A ${camera.dist.toFixed(
								2
							)} ${Translations.Meters}</div>
                        </div>
                    </div>
                    `);
				});
			}
		});
	},
	showCam: (type, source, name, grade) => {
		if (type == 'body') {
			if(HasPermissionMenu('SeeBodyCams')) return sendNotification('error', Translations.NoPermissionPage);
			lastBodyCamData = {
				name: name,
				grade: grade
			};
			fetch('ShowBodycam', { id: source });
		}
		if (type == 'vehicle') {
			if(HasPermissionMenu('SeeVehicleCamera')) return sendNotification('error', Translations.NoPermissionPage);
			fetch('ShowCarcam', { netid: source });
		}
		if (type == 'business') {
			if(HasPermissionMenu('SeeBusinessCameras')) return sendNotification('error', Translations.NoPermissionPage);
			exportEvent('origen_police', 'ShowCam', { obj: source });
		}
		if(type == 'body') return;

		$('.cam-overlay .name').text(name);
		$('.cam-overlay .other').text(grade);
		setTimeout(() => {
			$.post('https://origen_police/close', JSON.stringify({}));
			$('.screen').removeClass('show');
			$('.cam-overlay').fadeIn(300);
		}, 1000);
	}
};