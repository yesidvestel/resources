codigoPenalFunctions = {
	loadCPFunctions: function () {
		fetch('LoadPolicePage', { page: 'penalcode' }).done((cb) => {
			if (cb.boss) {
				$('.police .app-codigo-penal .app-title button').removeClass('d-none');
				$('.police .app-codigo-penal .h-accion').removeClass('d-none');
				$('.police .app-codigo-penal .td-accion').removeClass('d-none');
			} else {
				$('.police .app-codigo-penal .app-title button').addClass('d-none');
				$('.police .app-codigo-penal .h-accion').addClass('d-none');
				$('.police .app-codigo-penal .td-accion').addClass('d-none');
				$(document).off(
					'dblclick',
					'.police .app-codigo-penal .tabla-codigo-penal tbody tr td span'
				);
			}
		});
	},
	loadCodigoPenalFunctions: () => {
		$(document).on('click', '.police .btn-codigopenal', function () {
			if(HasPermissionMenu("CriminalCode")) {
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
			policeFunctions
				.policeNavigation(Translations.CriminalCodeAbrev, $('.police-codigopenal').html())
				.then(() => {
					codigoPenalFunctions.loadTabla(0);
					codigoPenalFunctions.loadCPFunctions();
				});
		});

		$(document).on('keyup', '.police .app-codigo-penal .search-cp', function () {
			let search = $(this).val().toLowerCase();
			if (search.length > 0) {
				$('.police .app-codigo-penal .tabla-codigo-penal tbody tr').each(
					function () {
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
					}
				);
			} else {
				$('.police .app-codigo-penal .tabla-codigo-penal tbody tr').fadeIn(300);
			}
		});

		$(document).on(
			'dblclick',
			`.police .app-codigo-penal .tabla-codigo-penal tbody tr .td-articulo,
            .police .app-codigo-penal .tabla-codigo-penal tbody tr .td-descripcion,
            .police .app-codigo-penal .tabla-codigo-penal tbody tr .td-importe,
            .police .app-codigo-penal .tabla-codigo-penal tbody tr .capitulos,
            .police .app-codigo-penal .tabla-codigo-penal tbody tr .td-pena`,
			function () {
				let val = $(this).find('span').text();
				$(this)
					.html(
						`
                <input rows="1" class="input-table-cp" value="${val}">
            `
					)
					.find('.input-table-cp')
					.focus();
			}
		);

		$(document).on(
			'focusout',
			'.police .app-codigo-penal .tabla-codigo-penal tbody tr td .input-table-cp',
			function () {
				let val = $(this).val();

				const idart = parseInt($(this).parent().parent().attr('index'));
				const idcap = $(this).parent().parent().attr('id-cap');

				$(this).parent().html(val);

				if (val.length > 0) {
					if (idart) {
						const title = $(
							".police .tab .app-codigo-penal tr[index='" + idart + "']"
						)
							.find('.td-articulo')
							.text()
							.trim();

						const description = $(
							".police .tab .app-codigo-penal tr[index='" + idart + "']"
						)
							.find('.td-descripcion')
							.text()
							.trim();

						const price = parseInt(
							$(".police .tab .app-codigo-penal tr[index='" + idart + "']")
								.find('.td-importe')
								.text()
								.trim()
						);

						const month = parseInt(
							$(".police .tab .app-codigo-penal tr[index='" + idart + "']")
								.find('.td-pena')
								.text()
								.trim()
						);

						TriggerCallback('origen_police:callback:UpdatePenalCode', {
							type: 'edit-art',
							title,
							description,
							price,
							month,
							cap: parseInt(idcap),
							id: parseInt(idart)
						}).done((cb) => {
							if (cb) {
								codigoPenalFunctions.loadTabla(0);
							}
						});
					} else {
						const description = val;

						TriggerCallback('origen_police:callback:UpdatePenalCode', {
							type: 'edit-cap',
							id: parseInt(idcap),
							title: description
						}).done((cb) => {
							if (cb) {
								codigoPenalFunctions.loadTabla(0);
							}
						});
					}
				}
			}
		);
		$(document).on('click', '.police .app-codigo-penal .add-capitulo', function () {
			OpenModal(
				Translations.CreateNewChapter,
				`
                <div class="row">

                    <div class="col-12">
                        <input class="form-control w-100 input-nuevo-capitulo" placeholder="${Translations.ChapterName}">
                    </div>
                </div>
            `,
				`<button class="btn-modal" onclick="codigoPenalFunctions.saveCapitulo()">${Translations.SaveChapter}</button>`,
				Translations.Cancel
			);
		});

		$(document).on('click', '.police .app-codigo-penal .add-articulo', function () {
			let capitulos = '';
			$(
				'.police ' +
					policeTabSelected +
					' .app-codigo-penal .tabla-codigo-penal tbody .capitulos'
			).each(function () {
				capitulos += `<option value="${$(this).parent().attr('id-cap')}">${$(this)
					.text()
					.trim()}</option>`;
			});
			OpenModal(
				`${Translations.CreateNewArticle}`,
				`
                <label>${Translations.SelectChapter}</label>
                <select class="form-select w-100 select-capitulo">
                    <option value="0">${Translations.SelectChapter}</option>
                    ${capitulos}
                </select>
                <label class="mt-3">${Translations.ArticleName}</label>
                <input class="form-control w-100 input-n-articulo" placeholder="${Translations.EnterName}">
                <label class="mt-3">${Translations.DescriptionArticle}</label>
                <textarea class="form-control w-100 input-descripcion-articulo" placeholder="${Translations.EnterDescription}"></textarea>
                <div class="row mt-3">
                    <div class="col-6">
                        <label>${Translations.Amount}</label>
                        <input type="number" min="0" class="form-control text-center w-100 input-importe-articulo">
                    </div>
                    <div class="col-6">
                        <label>Sentance (${Translations.Month})</label>
                        <input type="number" min="0" class="form-control text-center w-100 input-pena-articulo">
                    </div>
                </div>
            `,
				`<button class="btn-modal" onclick="codigoPenalFunctions.saveArticulo()">${Translations.SaveArticle}</button>`,
				Translations.Cancel
			);
		});
	},
	saveCapitulo: () => {
		const title = $('.c-modal .input-nuevo-capitulo').val().trim();
		if (title.length > 2) {
			TriggerCallback('origen_police:callback:UpdatePenalCode', {
				title,
				type: 'new-cap'
			}).done((cb) => {
				if (cb) {
					CloseModal();
					codigoPenalFunctions.loadTabla(0);
				}
			});
		}
	},
	saveArticulo: () => {
		const id = $('.c-modal .select-capitulo').val().trim();
		const title = $('.c-modal .input-n-articulo').val().trim();
		const desc = $('.c-modal .input-descripcion-articulo').val().trim();
		const importe = parseInt($('.c-modal .input-importe-articulo').val().trim());
		const pena = parseInt($('.c-modal .input-pena-articulo').val().trim());

		if (title.length > 2 && desc.length > 0 && pena >= 0 && importe >= 0 && id != 0) {
			TriggerCallback('origen_police:callback:UpdatePenalCode', {
				title: title,
				description: desc,
				price: importe,
				month: pena,
				cap: parseInt(id),
				type: 'new-art'
			}).done((cb) => {
				if (cb) {
					CloseModal();
					codigoPenalFunctions.loadTabla(0);
				} else {
					sendNotification(
						'error',
						'An error has occurred when adding the article',
						'Consult with administration'
					);
				}
			});
		} else {
			sendNotification('error', 'Fill all data to continue');
		}
	},
	loadTabla: (type) => {
		TriggerCallback('origen_police:callback:GetPenalCode', {}).done((cb) => {
			const classHtml = !type
				? '.police .app-codigo-penal .tabla-codigo-penal tbody'
				: '.police .multas-container .tabla-codigo-penal-multas tbody';
			$(classHtml).html('');
			Object.entries(cb).map(([key, value]) => {
				$(classHtml).append(`
                <tr id-cap="${value.id}">
                    <td colspan="${!type ? 4 : 5}" class="text-center capitulos">
                        <span style="text-transform: initial;">${value.title}</span>
                    </td>
                    ${
						!type
							? `
                        <td class="td-accion">
                            <button class="btn btn-table w-100 h-100 btn-delete-articulo"
                            onclick="codigoPenalFunctions.deleteCP(0, '${key}')">${Translations.Delete}</button>
                        </td>
                    `
							: ''
					}

                </tr>
                `);
				value.arts.map((article, index) => {
					$(classHtml).append(`
                    <tr index="${article.id}" id-cap="${value.id}">
                        <td class="td-articulo">
                            <span style="text-transform: initial;">${article.title}</span>
                        </td>
                        <td class="td-descripcion">
                            <span style="text-transform: initial;">${article.description}</span>
                        </td>
                        <td class="td-importe">
                            <span style="text-transform: initial;">${article.price}</span>
                        </td>
                        <td class="td-pena no-wrap">
                            <span>${article.month} ${Translations.Month}</span>
                        </td>
                        <td class="td-accion">
                            <button class="btn btn-table w-100 h-100 ${
								!type ? 'btn-delete-articulo' : 'btn-add-articulo'
							}" ${
						!type
							? `onclick="codigoPenalFunctions.deleteCP(1, '${value.id}', ${article.id})"`
							: ''
					}>${!type ? Translations.Delete : Translations.Add}</button>
                        </td>


                    </tr>
                    `);
				});
			});
		});
	},
	deleteCP: (type, cap, art) => {
		let title = '';
		let description = '';
		if (type == 0) {
			title = Translations.DeleteChapter;
			description = Translations.AreYouSureDeleteArticle;
		} else {
			title = Translations.DeleteArticle;
			description = Translations.AreYouSureDeleteArticle;
		}
		OpenModal(
			title,
			description,
			`<button class="btn-modal" onclick="codigoPenalFunctions.deleteCPConfirm(${type}, '${cap}', ${art})">${Translations.Remove}</button>`,
			Translations.Cancel
		);
	},
	deleteCPConfirm: (type, cap, art) => {
		let data = {};
		if (type == 0) {
			data = { type: 'delete-cap', id: parseInt(cap) };
		} else {
			data = {
				type: 'delete-art',
				cap: parseInt(cap),
				id: parseInt(art)
			};
		}
		TriggerCallback('origen_police:callback:UpdatePenalCode', data).done((cb) => {
			if (cb) {
				CloseModal();
				codigoPenalFunctions.loadTabla(0);
			}
		});
	}
};