multasFunctions = {
	getCB: undefined,
	loadMultasFunctions: () => {
		$(document).on(
			'click',
			'.police .multas-container .btn-add-articulo',
			function () {
				const articulo = $(this)
					.parent()
					.parent()
					.find('.td-articulo')
					.text()
					.trim();
				const importe = parseInt(
					$(this).parent().parent().find('.td-importe').text().trim()
				);
				const meses = parseInt(
					$(this).parent().parent().find('.td-pena').text().trim()
				);

				$('.police .lista-articulos-multa').append(`
            <li class="list-group-item list-group-item-action scale-in" data-id="">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="art-multa">${articulo}</h5>
                    <div class="info-multa">
                        <div class="pena">${meses} ${Translations.Month}</div>
                        <div class="importe text-success">${importe}$</div>
                        <div class="eliminar"><i class="fas fa-trash"></i></div>
                    </div>
                </div>
            </li>
            `);
				multasFunctions.refreshMultasPenas();
			}
		);

		$(document).on(
			'click',
			'.police .multas-container .lista-articulos-multa .eliminar',
			function () {
				$(this)
					.parent()
					.parent()
					.parent()
					.removeClass('scale-in')
					.addClass('scale-out')
					.fadeOut(300, function () {
						$(this).remove();
						multasFunctions.refreshMultasPenas();
					});
			}
		);

		$(document).on(
			'click',
			'.police .multas-container .btn-add-custom-art',
			function () {
				const articulo = $(this)
					.parent()
					.parent()
					.find('.input-concepto')
					.val()
					.trim();
				const importe = parseInt(
					$(this).parent().parent().find('.input-importe').val().trim()
				);
				const meses = parseInt(
					$(this).parent().parent().find('.input-meses').val().trim()
				);

				if (articulo.length > 0 && importe > 0 && meses + '' != 'NaN') {
					$('.police .lista-articulos-multa').append(`
                <li class="list-group-item list-group-item-action scale-in">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="art-multa">${articulo}</h5>
                        <div class="info-multa">
                            <div class="pena">${meses} ${Translations.Month}</div>
                            <div class="importe text-success">${importe}$</div>
                            <div class="eliminar"><i class="fas fa-trash"></i></div>

                        </div>
                    </div>
                </li>`);
					$(this).parent().parent().find('.input-concepto').val('');
					$(this).parent().parent().find('.input-importe').val('');
					$(this).parent().parent().find('.input-meses').val('');
					multasFunctions.refreshMultasPenas();
				}
			}
		);
		$(document).on('click', '.police .multas-container .close-button', function () {
			$(this).parent().removeClass('scale-in').addClass('scale-out');
			$('.police .multas-container').fadeOut(300);
		});

		$(document).on('click', '.police .multas-container .btn-save-multa', function () {
			multasFunctions.saveMulta();
		});
		$(document).on(
			'keyup',
			'.police .multas-container .search-cp-multas',
			function () {
				let search = $(this).val().toLowerCase();
				if (search.length > 0) {
					//Busca las coincidencias en la tabla del código penal, para las celdas td-articulos y td-descripcion y oculta las que no coincidan.
					$(
						'.police .multas-container .tabla-codigo-penal-multas tbody tr'
					).each(function () {
						let articulo = $(this).find('.td-articulo').text().toLowerCase();
						let descripcion = $(this)
							.find('.td-descripcion')
							.text()
							.toLowerCase();
						if (articulo.includes(search) || descripcion.includes(search)) {
							$(this).fadeIn(300);
						} else {
							$(this).fadeOut(300);
						}
					});
				} else {
					$(
						'.police .multas-container .tabla-codigo-penal-multas tbody tr'
					).fadeIn(300);
				}
			}
		);
	},

	openBill: function (type, cb, name, cid) {
		$('.police .multas-box').attr('data-name', name);
		$('.police .multas-box').attr('data-id', cid);
		$('.police .multas-container .multas-box')
			.removeClass('scale-out')
			.addClass('scale-in');
		$('.police .multas-container').fadeIn(300);
		multasFunctions.getCB = cb;
	},
	refreshMultasPenas: function () {
		let totalImporte = 0;
		let totalMeses = 0;
		$('.police .lista-articulos-multa .list-group-item').each(function () {
			const importe = parseInt($(this).find('.importe').text().trim());
			const meses = parseInt($(this).find('.pena').text().trim());
			totalImporte += importe;
			totalMeses += meses;
		});

		$('.police .total-importe').text(totalImporte + '$');
		$('.police .total-meses').text(totalMeses + ' ' + Translations.Month);
	},
	saveMulta: function () {
		let articulos = [];
		if ($('.police .lista-articulos-multa .list-group-item').length > 0) {
			$('.police .lista-articulos-multa .list-group-item').each(function () {
				articulos = [
					...articulos,
					{
						articulo: $(this).find('.art-multa').text().trim(),
						importe: parseInt($(this).find('.importe').text().trim()),
						meses: parseInt($(this).find('.pena').text().trim())
					}
				];
			});
			const importe = parseInt(
				$('.multas-box').find('.total-importe').text().trim()
			);
			const meses = parseInt($('.multas-box').find('.total-meses').text().trim());
			const cid = $('.police .multas-box').attr('data-id');
			if (multasFunctions.getCB) {
				multasFunctions.getCB(articulos, importe, meses, cid);
				$('.police .multas-box').removeClass('scale-in').addClass('scale-out');
				$('.police .multas-container').fadeOut(300);
			}
			sendNotification('success', Translations.FineAdded);
		} else {
			sendNotification('error', Translations.NoArticle);
		}
	},

	addMultaCitizen: function (articulos, importe, meses, cid) {
		let articulosHTML = '';
		let arrayArticulos = [];
		articulos.map(function (article) {
			articulosHTML += `<li><p>${article.articulo}</p></li>`;
			arrayArticulos = [...arrayArticulos, article.articulo];
		});
		TriggerCallback('origen_police:police:SendBill', {
			citizenid: cid,
			bills: arrayArticulos,
			price: importe,
			months: meses
		}).done((cb) => {
			if (cb) {
				const fecha = timeStampToDate(cb.date);
				$('.police ' + policeTabSelected + ' ul.multas-list .no-notes').remove();

				$('.police ' + policeTabSelected + ' ul.multas-list').prepend(`
                <li class="list-group-item list-group-item-action" bill-id="${cb.billid}">
                    <h5>${fecha.date + ' - ' + fecha.time}</h5>
                    <ul>
                        ${articulosHTML}

                    </ul>
                    <div class="note-info d-flex">
                        <div class="multa-author"><i class="fas fa-user"></i> ${
							cb.author
						}</div>
                        <div class="multa-price"><i class="fas fa-dollar-sign"></i> ${importe}$</div>
                        <div class="multa-"><i class="fas fa-gavel"></i> ${meses} ${Translations.Month}</div>
                    </div>
                    <div class="delete-button">
                        <i class="fa-solid fa-trash"></i>
                    </div>
                </li>
                `);
			}
		});
	}
};