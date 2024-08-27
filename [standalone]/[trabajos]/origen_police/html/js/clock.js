$(document).on('click', '.times-button', function () {
	if(HasPermissionMenu("TimeControl")) {
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
	let tabla = ``;
	let topList = '';

	TriggerCallback('origen_police:server:GetClocks', {}).done((cb) => {
		if (cb) {
			// const topTenValues = cb
			// 	.reduce((acc, obj) => {
			// 		const existingObj = acc.find((item) => item.name === obj.name);
			// 		if (existingObj) {
			// 			existingObj.minutes += obj.minutes;
			// 		} else {
			// 			acc.push({ minutes: obj.minutes, name: obj.name });
			// 		}
			// 		return acc;
			// 	}, [])
			// 	.sort((a, b) => b.minutes - a.minutes)
			// 	.slice(0, 10);

			cb.data.map((time) => {
				tabla += `
				<tr>
					<td>${time.name}</td>
					<td class="text-center">${time.clockin}</td>
					<td class="text-center">${time.clockout}</td>
					<td class="text-center">${time.minutes}</td>
				</tr>
				`;
			});

			cb.top.map((top, i) => {
				topList += `
				<li class="list-group-item">
					<div class="d-flex justify-content-between align-items-center">
						<div class="worker-name">
							<span class="top-number">${i + 1}</span>
							<span class="worker-name-span">${top.name}</span>
						</div>
						<div class="worker-time">
							<span class="worker-time-span fw-bold">${top.total_minutes} ${Translations.MinAbrev}.</span>
						</div>
					</div>
				</li>
				`;
			});

			OpenModal(
				`${Translations.TimeControl}`,
				`
				<div class="row">

					<div class="col-8">
					<h3 class="bankgothic">${Translations.TimeHistory}</h3>
					<table border="0" class="gtable w-100 mt-2">
						<thead>
							<tr>
								<th style="width:40%">${Translations.Agent}</th>
								<th class="text-center">${Translations.ClockIn}</th>
								<th class="text-center">${Translations.ClockOut}</th>
								<th class="text-center" style="width:10%">${Translations.Total}</th>
							</tr>
						</thead>
						<tbody>
							${tabla}

						</tbody>
					</table>
					</div>
					<div class="col-4">
						<h3 class="bankgothic">${Translations.TopWorkers}</h3>

						<ul class="list-group mt-2">
							${topList}
						</ul>
					</div>
				</div>
			`,
				`<div></div>`,
				Translations.Cancel,
				120
			);
			$('.c-modal .gtable').DataTable({
				language: dataTableLanguage,
				pageLength: 10,
				lengthChange: false,
				autoWidth: false
			});
		} else {
			sendNotification('error', Translations.ErrorOccurred);
		}
	});
});