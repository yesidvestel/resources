function DrawLSPDBadge(grade, number) {
	if (grade == undefined || number == undefined) {
		grade = 'ORIGEN';
		number = '0000';
		console.log("Error while drawing badge, grade or number is undefined, data: " + grade + " - " + number);
	}
	HideBadges()
	$('.police_badge').html(`
        <canvas id="police_badge_rank"></canvas>
        <div id="police_badge_number"></div>
    `);
	setTimeout(() => {
		$('.police_badge').fadeIn();
		let canvas = document.getElementById('police_badge_rank');
		let context = canvas.getContext('2d');
		let angle = Math.PI * 0.6;
		let radius = 50;
		let string = grade;
		let font = 18;
		let rot = (-1 * angle) / 2 - 0.2;

		if (string.length > 4) {
			font = 16;
			rot = (-1 * angle) / 2 - 0.1;
		} else if (string.length > 7) {
			font = 16;
			rot = (-1 * angle) / 2;
		}

		context.font = 'bold ' + font + 'px Gobold';
		context.fillStyle = '#202168';
		context.textAlign = 'center';

		context.translate(100, 100);
		context.rotate(rot);

		for (let i = 0; i < string.length; i++) {
			context.rotate(angle / string.length);
			context.save();
			context.translate(0, -1 * radius);
			context.fillText(string[i], 0, 0);
			context.restore();
		}

		$('#police_badge_number').html(number);
	}, 10);
}

function DrawBCSDBadge(grade, number) {
	if (grade == undefined || number == undefined) {
		grade = 'ORIGEN';
		number = '0000';
		console.log("Error while drawing badge, grade or number is undefined, data: " + grade + " - " + number);
	}
	HideBadges()
	$('.sheriff_badge').html(`
        <canvas id="sheriff_badge_rank"></canvas>
        <div id="sheriff_badge_number"></div>
    `);
	setTimeout(() => {
		$('.sheriff_badge').fadeIn();
		let canvas = document.getElementById('sheriff_badge_rank');
		let context = canvas.getContext('2d');
		let angle = Math.PI * 0.6;
		let radius = 50;
		let string = grade;
		let font = 18;
		let rot = (-1 * angle) / 2 - 0.1;

		if (string.length > 7) {
			font = 16;
			rot = (-1 * angle) / 2;
		}

		context.font = font + 'px Gobold';
		context.fillStyle = 'rgb(235, 217, 149)';
		context.textAlign = 'center';

		context.translate(100, 100);
		context.rotate(rot);

		for (let i = 0; i < string.length; i++) {
			context.rotate(angle / string.length);
			context.save();
			context.translate(0, -1 * radius);
			context.fillText(string[i], 0, 0);
			context.restore();
		}

		$('#sheriff_badge_number').html(number);
	}, 10);
}

function DrawFIBBadge(mugshot, name) {
	HideBadges()
	$('.fib_badge').html(`
        <div id="fib_badge_name">${name}</div>
        <img id="fib_badge_photo"></div>
    `);
	setTimeout(() => {
		$('.fib_badge').fadeIn();
		let nameElement = document.getElementById('fib_badge_name');
		nameElement.style.fontFamily = 'Creattion'
		nameElement.style.color = 'black'
		nameElement.style.transform = 'translateY(170px) translateX(210px)'
		nameElement.style.fontSize = '22px';
		nameElement.style.fontWeight = 'bold';

		let imgElement = document.getElementById('fib_badge_photo');
		imgElement.style.transform = 'translateX(257px) translateY(44px)'
		imgElement.style.borderRadius = '3px';

		$('#fib_badge_photo').attr("src", mugshot);
	}, 10);
}

function HideBadges() {
	$('.police_badge').hide();
	$('.sheriff_badge').hide();
	$('.fib_badge').hide();
}

$(document).on('click', '.generar-placa', function () {
	if(HasPermissionMenu('GenerateBadge')) return sendNotification('error', Translations.NoPermissionPage);
	const range = $('.agent-ficha .agent-grade').text();
	const plate = $('.agent-ficha .agent-placa').text();
	const jurisdiction = $('.agent-ficha .jurisdiction').text();

	if (range && plate && jurisdiction) {
		OpenModal(
			Translations.DoWantGenPlate,
			`
			<div class="scroll-rangos">
				<div class="row">
					<div class="col-4">
						<h1 class="bankgothic w-100 text-center">${Translations.Range}</h1>
						<h3 class="text-center">${range}</h2>
					</div>
					<div class="col-4">
						<h1 class="bankgothic w-100 text-center">${Translations.PlateAbrev}</h1>
						<h3 class="text-center">${plate}</h3>

					</div>
					<div class="col-4">
						<h1 class="bankgothic w-100 text-center">${Translations.Jurisdiction}</h1>
						<h3 class="text-center">${jurisdiction}</h3>

					</div>
				</div>
			</div>
			`,
			`<div class="btn-modal" onclick="generatePlate('${range}', '${plate}','${jurisdiction}')">${Translations.Confirm}</div>`,
			Translations.Cancel,
			70
		);
	} else {
		sendNotification('error', Translations.YouMustOpenProfile);
	}
});

function generatePlate(grade, police_badge, type) {
	const cid = $(
		'.police ' + policeTabSelected + ' .agent-ficha .citizenid'
	).text().trim();
	TriggerCallback('origen_police:server:GeneratePoliceBadge', {
		grade,
		police_badge,
		type,
		cid
	}).done((cb) => {
		if (cb === true) {
			sendNotification('success', Translations.PoliceBadgeGenerated, Translations.CheckInventory);
			CloseModal();
		} else {
			sendNotification('error', cb);
		}
	});
}