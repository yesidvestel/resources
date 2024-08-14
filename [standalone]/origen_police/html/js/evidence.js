async function AnalizeEvidences(list, _date) {
	const date = new Date(_date * 1000);
	const day = date.getDate();
	const month = date.getMonth();
	const year = date.getFullYear();
	if(Translations.January == undefined) {
		console.error("Wait more time to load translations after restarting the script.")
	}
	
	var monthName = [
		Translations.January,
		Translations.February,
		Translations.March,
		Translations.April,
		Translations.May,
		Translations.June,
		Translations.July,
		Translations.August,
		Translations.September,
		Translations.October,
		Translations.November,
		Translations.December
	];
	$('.fecha-informe').html(day + ` ${Translations.Of} ` + monthName[month] + ' del ' + year);
	$('.zona-evidencias').html('');
	list.map((l) => {
		let datos = [];
		let tipo = '';
		let date;
		let fecha;
		let hora;
		let minutos;
		switch (l.type) {
			case 'Shoot':
				tipo = Translations.Shoot;
				break;
			case 'BloodRest':
				tipo = Translations.BloodRemains;
				break;
			case 'NpcBlood':
				tipo = Translations.BloodRemains;
				break;
			case 'Impact':
				tipo = Translations.BulletImpact;
				break;
			case 'VehCrash':
				tipo = Translations.VehicleBody;
				break;
			case 'FingerPrint':
				tipo = Translations.Fingerprint;
				break;
			case 'Weapon':
				tipo = Translations.Weapon;
				break;
			case 'Drug':
				tipo = Translations.Drug;
				break;
		}

		if (l.adn) {
			let tag = 'Citizen';
			if (l.type == 'Weapon') {
				tag = Translations.Fingerprints;
			}
			datos.push(
				`<div class="dato"><div class="black underline">${tag}:</div> <div>${l.adn}</div></div>`
			);
		}

		if (l.ammo) {
			datos.push(
				`<div class="dato"><div class="black underline">${Translations.Calibre}:</div> <div>${l.ammo}</div></div>`
			);
		}
		if (l.fkSerie) {
			datos.push(
				`<div class="dato"><div class="black underline">${Translations.Identifier}:</div> <div>${l.fkSerie}</div></div>`
			);
		}
		if (l.model) {
			datos.push(
				`<div class="dato"><div class="black underline">${Translations.Model}:</div> <div>${l.model}</div></div>`
			);
		}
		if (l.count) {
			datos.push(
				`<div class="dato"><div class="black underline">${Translations.Amount}:</div> <div>${l.count}</div></div>`
			);
		}
		if (l.color) {
			datos.push(
				`<div class="dato" style="display: flex;"><div class="black underline">${Translations.Color}:</div> <div style="width:5vh;margin-left:10px;background-color:rgb(${
					l.color[0] + ',' + l.color[1] + ',' + l.color[2]
				})"></div></div>`
			);
		}
		if (l.shooted) {
			if (l.shooted > 60) {
				let minutos2 = Math.floor(l.shooted / 60);
				let segundos2 = l.shooted - minutos * 60;
				datos.push(
					`<div class="dato"><div class="black underline">${Translations.Shot}:</div> <div>${minutos2} ${Translations.MinutesAnd} ${segundos2} ${Translations.SecondAprox}.</div></div>`
				);
			} else {
				datos.push(
					`<div class="dato"><div class="black underline">${Translations.Shot}:</div> <div>${l.shooted} ${Translations.SecondAprox}.</div></div>`
				);
			}
		}
		if (l.time) {
			date = new Date(l.time * 1000);
			fecha =
				date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();
			hora = date.getHours();
			if (hora < 10) hora = '0' + hora;
			minutos = date.getMinutes();
			if (minutos < 10) minutos = '0' + minutos;
			datos.push(
				`<div class="dato"><div class="black underline">${Translations.ApproximateTime}:</div> <div>${fecha} - ${
					hora + ':' + minutos
				}</div></div>`
			);
		}

		//Separa datos en 2 array de máximo 3 elementos
		let datos1 = '';
		for (let i = 0; i < datos.length; i++) {
			datos1 += `<div class="col-6 zona-1">` + datos[i] + `</div>`;
		}

		$('.zona-evidencias').append(`
        <div class="row bg-grey p-2 row-datos">
            <div class="col-12">
                <h2>${Translations.EvidenceOf} ${tipo}</h2>
            </div>
            ${datos1}
        </div>
        `);
	});
	$('.informe').show();
	$('.foto-informe').hide();
	$('.block-informe').fadeIn(300, function () {
		shotit();
	});
}

var shotit = function () {
	html2canvas(document.querySelector('.informe')).then(function (canvas) {
		document.querySelector('.canvas').appendChild(canvas);
		let leCanvas = document.getElementsByTagName('canvas')[0];
		let img = leCanvas.toDataURL('image/png');
		
		var request = new XMLHttpRequest();
		fetch('GetWebhook', {}).done(({url, fields}) => {
			if(!url) {
				$('.canvas').html('');
				return console.error("No webhook found for creating evidence report")
			}
			fields = fields.endsWith('[]') ? fields.slice(0, -2) : fields;
			const formData = new FormData();
			formData.append(fields, dataURItoBlob(img), 'evidence.jpg');
			request.open(
				'POST',
				url
			);
			request.send(formData);
			request.onreadystatechange = () => {
				if (request.readyState === 4) {
					let parse = JSON.parse(request.response);
					console.log(parse)
					if (fields == "files")
						$.post(
							'https://origen_police/savereportevidence',
							JSON.stringify({ url: parse.attachments[0].url })
						);
					else
						$.post(
							'https://origen_police/savereportevidence',
							JSON.stringify({ url: parse.url })
						);
				}
			};
			$('.canvas').html('');
		});
	});
};