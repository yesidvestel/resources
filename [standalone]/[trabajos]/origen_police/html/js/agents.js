agentesFunctions = {
	loadAgentesEvents: () => {
		$(document).on('click', '.police .agent-list .agent', function () {
			const citizenid = $(this).attr('cid');
			const job = $(this).attr('job');
			agentesFunctions.loadAgente(citizenid, job);
		});

		$(document).on('click', '.police .agent-grade', function () {
			if(HasPermissionMenu('ChangePoliceGrade')) return sendNotification('error', Translations.NoPermissionPage);
			const job = $(this).attr('job');
			fetch('GetPoliceGrades', {job: job}).then((data) => {
				let modalContent = '';
				let grades = {};
				const citizenid = $(
					'.police ' + policeTabSelected + ' .agent-ficha .citizenid'
				).text().trim();
				
				for (const key in data) {
					const element = data[key];

					if(grades[element.type] == null)
					{
						grades[element.type] = {};
					}
					grades[element.type][key] = element;
				}
				
				for(let key in grades) {
					let gradeContent = '';
					for(const key2 in grades[key]) {
						const d = grades[key][key2]
						gradeContent += `
						<div class="grade" data-id="${key2}" onclick="agentesFunctions.setRange('${job}', '${citizenid}', ${key2}, '${d.label || d.name}')">
						<div class="grade-name">${d.label || d.name}</div>
						<div class="grade-payment">${d.payment || d.salary}$</div>
						${d.scale != null ? `<div class="grade-scale">${d.scale}</div>` : ''}</div>`;
					}
					if(key)
						key = "LSPD"
					modalContent += `<div class="col-6" style="width:${100/Object.keys(grades).length}%">
						<div class="title-1-menu">${key.toUpperCase()}</div>
						${gradeContent}
					</div>`
				}
				OpenModal(
					Translations.ChangeRange,
					`
                <div class="scroll-rangos">
                    <div class="row">
                        ${modalContent}
                    </div>
                </div>
            `,
					'<div></div>',
					Translations.Cancel,
					70
				);
			});
		});

		$(document).on('click', '.police .agent-placa', function () {
			if(HasPermissionMenu('ChangePoliceBadge')) return sendNotification('error', Translations.NoPermissionPage);
			let placa = $(this).text().trim();
			OpenModal(
				Translations.ChangePlateNumber,
				`
                <label>${Translations.PlateNumberAbrev}</label>
                <input maxlength="3" type="number" class="form-control input-placa-number" value="${placa}">
                <div class="error d-none text-uppercase text-danger mt-2">${Translations.PlateMin3}</div>
            `,
				`<button class='btn-modal' onclick="agentesFunctions.savePlacaNumber()">${Translations.Save}</button>`,
				Translations.Cancel,
				35
			);
		});

		$(document).on('click', '.police .agentes .add-agente', function () {
			if(HasPermissionMenu('AddPolice')) return sendNotification('error', Translations.NoPermissionPage);
			fetch('GetClosestPlayers', { job: jobData.name }).done((cb) => {
				let html = '';
				if (cb && cb.length > 0) {
					cb.map((citizen) => {
						html += `
                        <div class="col-4 h-100 mb-3">
                            <div class="citizen-box" onclick="agentesFunctions.contratarAgenteModal('${
								citizen.citizenid
							}')">
                                <div class="citizen-image image-${
									citizen.citizenid
								}" style="background-image:url(${
							citizen.image || defaultImage
						}); filter:hue-rotate(-${currentHueDeg}deg)"></div>
                                <div class="p-2 text-center">
                                    <div class="citizen-name">${
										citizen.firstname + ' ' + citizen.lastname
									}</div>

                                </div>
                            </div>
                        </div>
                        `;
					});
				} else {
					html = `
                            <div class="col-12 text-muted">
                                <h4 class="citizen-name">${Translations.NoPeopleNear}</h4>
                            </div>
                        `;
				}
				OpenModal(
					Translations.AddPolice,
					`
                <div class="citizen-box-list">
                    <div class="row m-titles">
                        ${html}
                    </div>
                </div>
                `,
					'<div></div>',
					Translations.Cancel,
					60
				);
			});
		});
		$(document).on('click', '.police .btn-search-agent', function () {
			const job = $(this).attr('job');
			agentesFunctions.searchAgente($('.police .input-search-agent').val(), job);
		});

		$(document).on('keyup', '.police .input-search-agent', function (event) {
			const job = $(this).attr('job');
			agentesFunctions.searchAgente($(this).val(), job);
		});
	},
	loadAgentes: () => {
		$('.police ' + policeTabSelected + ' .agentes .agent-list')
			.html('')
			.fadeOut(0, function () {
				TriggerCallback('origen_police:police:GetPoliceList', {}).done((cb) => {
					if (cb && cb.length > 0) {
						//order the array by the key job of each entry
						cb.sort(function(a, b) {
							return a.job.localeCompare(b.job);
						});
						let registeredJobs = [];
						cb.map((agente) => {
							if(!registeredJobs.includes(agente.job)) {
								$(policeTabSelected + ' .agent-list').append(`
								<div class="job-${agente.job}">
									<div class="title-2 m-titles">${agente.titleLabel}</div>
									<div class="row m-titles search-box">
										<div class="col-10 p-0">
											<input
												type="text"
												placeholder="${Translations.LookAgent}"
												translate="placeholder"
												class="search-input w-100 input-search-agent" job="${agente.job}" />
										</div>
										<div class="col-2 p-0">
											<div class="btn btn-search btn-search-agent w-100">
												<i class="fas fa-search"></i>
											</div>
										</div>
									</div>
								</div>`);
								registeredJobs.push(agente.job);
							}
							const citizenName = agente.firstname + ' ' + agente.lastname;
							const citizenId = agente.citizenid;
							const citizenJob = agente.job;
							const citizenGrade = agente.grade;
							const citizenImage = agente.image || defaultImage;
							const citizenBadge = agente.badge || 'Unknown';
							$(policeTabSelected + ' .agent-list ' + `.job-${agente.job}`).append(`
								<div class="white-block agent agente-${citizenId}" job="${citizenJob}" cid="${citizenId}">
									<div class="citizen-image image-${citizenId}" style="background-image:url('${citizenImage}');filter:hue-rotate(-${currentHueDeg}deg);"></div>
									<div class="citizen-info w-100">
										<div class="agent-name w-100">${citizenName}</div>
										<div class="d-flex text-uppercase citizen-fast-data justify-content-between">
											<div class="agente-rango"><span class="citizen-id">${citizenGrade}</span></div>
											<div class="agente-placa"><i class="fa-solid fa-id-badge"></i> <span class="citizen-phone">${citizenBadge}</span></div>
										</div>
									</div>
								</div>
							`);
							try {
								var imageElement = $(`.image-${citizenId}`);
								var style = imageElement.css('background-image');
								const regex = /"([^"]*)"/g;
								let resultado;
								const resultados = [];

								while ((resultado = regex.exec(style)) !== null) {
									resultados.push(resultado[1]);
								}
								var url = resultados[0];
								var img = new Image();
								img.src = url;
								img.onerror = function () {
									$('.image-' + citizenId).css('background-image', 'url(' + defaultImage + ')');
								}
							}
							catch (e) {}
						});
					} else {
						$('.police ' + policeTabSelected + ' .agentes .agent-list').html(`
							<div class="col-12 text-muted">
								<h4 class="report-name">${Translations.NoResultFound}</h4>
							</div>`
						);
					}
					$('.police ' + policeTabSelected + ' .agentes .agent-list').fadeIn(
						300
					);
				});
			});
	},
	loadAgente: function (citizenid, job) {
		$('.police ' + policeTabSelected + ' .agentes .agent-ficha').fadeOut(
			300,
			function () {
				TriggerCallback('origen_police:police:GetPolice', {
					citizenid
				}).done((cb) => {
					let birthdate = cb.birthdate ? [cb.birthdate] : ['00/00/0000'];
					let citizenNotes = '';
					let citizenNotesPinned = '';
					let citizenReports = '';
					let citizenCondecorates = '';
					let citizenDivisions = '';

					if (cb.reports && cb.reports.length > 0) {
						cb.reports.map(function (report) {
							citizenReports += `
							<div class="informe">
								<span class="report-name">${report.title}</span> #<span class="report-id">${report.id}</span>
							</div>`;
						});
					} else {
						citizenReports = `
						<ul class="list-group w-100">
							<li class="list-group-item list-group-item-action no-notes">
								<h5>${Translations.NoRegisteredReports}</h5>
							</li>
						</ul>`;
					}

					if (cb.notes.length > 0) {
						cb.notes.map(function (note) {
							const date = timeStampToDate(note.date);
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
                        <h5>${Translations.NoData}</h5>
                    </li>`;
					}

					if (cb.condecorates && Object.keys(cb.condecorates).length > 0) {
						Object.keys(cb.condecorates).map((condecorate) => {
							if (condecorates[condecorate] == null) {
								return console.log('[ERROR] Condecorate not found: ' + condecorate);
							}
							let url = './img/condecorates/' + condecorates[condecorate].url;
							let name = condecorates[condecorate].name;
							let id = condecorates[condecorate].id;
							citizenCondecorates += `
								<div class="condecoracion" onclick="agentesFunctions.removeCondecorate('${id}', $(this))">
									<div class="retirar">${Translations.Remove}</div>
									<img src="${url}">
									<div class="condecoracion-title">${name}</div>
								</div>
							`;
						});
					} else {
						citizenCondecorates = `
							<div class="condecoracion w-100 no-condecoracion">

								<div class="w-100 text-muted">${Translations.NoDecorations}</div>
							</div>
						`;
					}

					if (cb.divisions && Object.keys(cb.divisions).length > 0) {
						Object.keys(cb.divisions).map((division) => {
							if (divisions[division] == null) {
								return console.log('[ERROR] Condecorate not found: ' + division);
							}
							let url = './img/divisions/' + divisions[division].url;
							let name = divisions[division].name;
							let id = divisions[division].id;
							citizenDivisions += `
								<div class="condecoracion" onclick="agentesFunctions.removeDivision('${id}', $(this))">
									<img src="${url}">
									<div class="condecoracion-title">${name}</div>
									<div class="retirar">${Translations.Remove}</div>
								</div>
							`;
						});
					} else {
						citizenDivisions = `
							<div class="condecoracion w-100 no-divisions">

								<div class="w-100 text-muted">${Translations.NoDecorations}</div>
							</div>
						`;
					}

					$('.police ' + policeTabSelected + ' .agentes .agent-ficha')
						.html(
							`
                <div class="row d-flex align-items-center m-titles citizen-info-all mt-0">
                    <div class="col-2 p-0">
                        <div class="citizen-photo" style="background-image:url('${
							cb.image || defaultImage
						}');filter:hue-rotate(-${currentHueDeg}deg);">
                            <div class="edit-photo"><img src="./img/webp/edit.webp"></div>
                        </div>
                    </div>
                    <div class="col-10 pe-0">
                        <div class="d-flex w-100 flex-data">
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Name}</div>
                                    <div class="info-box-value">${cb.firstname}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Surname}</div>
                                    <div class="info-box-value">${cb.lastname}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Gender}</div>
                                    <div class="info-box-value">${cb.gender}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Nationality}</div>
                                    <div class="info-box-value">${cb.nationality}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Birthdate}</div>
                                    <div class="info-box-value">${birthdate[0]}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Id}</div>
                                    <div class="info-box-value citizenid" style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${
										cb.citizenid
									}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Phone}</div>
                                    <div class="info-box-value">${
										cb.phone || 'Unknown'
									}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.BankAccount}</div>
                                    <div class="info-box-value">${cb.iban}</div>

                                </div>
                            </div>
                            <div class="w-33">
                                <div class="info-box m-1">
                                    <div class="info-box-title">${Translations.Jurisdiction}</div>
                                    <div class="info-box-value text-uppercase jurisdiction">${
										cb.department
									}</div>

                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-6 pe-1">
                        <div class="info-box m-1 d-flex justify-content-between align-items-center">
                            <h4>${Translations.Range}</h4>
                            <div class="agent-grade" job="${job}">${cb.grade}</div>
                        </div>
                    </div>
                    <div class="col-6 ps-1">
                        <div class="info-box m-1 d-flex justify-content-between align-items-center">
                            <h4>${Translations.PlateAbrev}</h4>
                            <div class="agent-placa">${cb.badge}</div>

                        </div>
                    </div>
                    <div class="col-6 pe-1">
                        <div class="info-box m-1 mt-2">
                            <div class="notes-title d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-quote-right"></i> ${Translations.Notes}</h4>
                                <div class="new-button new-note-agente"><i class="fas fa-plus"></i> ${Translations.NewNote}</div>
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
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fas fa-sticky-note"></i> ${Translations.Informs}</h4>
                            </div>
                            <div class="citizen-info-container mt-2 d-flex flex-wrap citizen-informes align-content-start">
                               ${citizenReports}
                            </div>
                        </div>
                    </div>

                    <div class="col-6 pe-1">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fa-solid fa-medal"></i> ${Translations.Award}</h4>
                                <div class="new-button add-condecorate" onclick="agentesFunctions.addCondecorate()"><i class="fas fa-plus"></i> ${Translations.AddAward}</div>
                            </div>
                            <div class="citizen-info-container mt-2 d-flex agent-condecoraciones">
                                ${citizenCondecorates}
                            </div>
                        </div>
                    </div>
                    <div class="col-6 ps-1">
                        <div class="info-box m-1 mt-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4><i class="fa-solid fa-building-user"></i> ${Translations.Divisions}</h4>
                                <div class="new-button set-division" onclick="agentesFunctions.addDivision()"><i class="fas fa-plus"></i> ${Translations.SetDivision}</div>
                            </div>
                            <div class="citizen-info-container mt-2 d-flex agent-divisions">
                                ${citizenDivisions}
                            </div>
                        </div>
                    </div>
                    <div class="col-12 text-center">
                        <button class="btn btn-danger mt-3 mb-2" onclick='agentesFunctions.modalDespedirAgente("${
							cb.citizenid
						}")'><i class="lni lni-trash-can"></i> ${Translations.FirePolice}</button>
                    </div>
                </div>
                `
						)
						.fadeIn(300);
					$(this).animate({ scrollTop: 0 }, 200);

					$(
						'.police ' + policeTabSelected + ' .agentes .agent-list .agent'
					).removeClass('selected');
					$(
						'.police ' +
							policeTabSelected +
							' .agentes .agent-list .agente-' +
							citizenid
					).addClass('selected');
				});
				setTimeout(() => {
					try {
						var imageElement = $('.police ' + policeTabSelected + ' .agentes .agent-ficha .citizen-photo');
						var style = imageElement.css('background-image');
						const regex = /"([^"]*)"/g;
						let resultado;
						const resultados = [];

						while ((resultado = regex.exec(style)) !== null) {
							resultados.push(resultado[1]);
						}
						var url = resultados[0];
						var img = new Image();
						img.src = url;
						img.onerror = function () {
							imageElement.css('background-image', 'url(' + defaultImage + ')');
						}
					}
					catch (e) {}
				}, 200);
			}
		);
	},
	savePlacaNumber: () => {
		const placa = $('.c-modal .input-placa-number').val();
		const citizenid = $('.police ' + policeTabSelected + ' .agent-ficha .citizenid')
			.text()
			.trim();
		if (placa.length < 3 || placa.length > 4) {
			$('.c-modal .input-placa-number').addClass('is-invalid');
			$('.c-modal .error').removeClass('d-none');
			return;
		} else {
			const newPlaca = $('.c-modal .input-placa-number').val();

			TriggerCallback('origen_police:police:SetPoliceBadge', {
				citizenid,
				badge: newPlaca
			}).then((cb) => {
				if (cb) {
					CloseModal();
					$('.police ' + policeTabSelected + ' .agent-ficha .agent-placa').text(
						newPlaca
					);
				}
			});

			return;
		}
	},
	setRange: (job, citizenid, grade, label) => {
		TriggerCallback('origen_police:server:SetPoliceJob', {
			citizenid,
			grade: grade + '',
			job: job
		}).then((cb) => {
			if (cb) {
				$('.police ' + policeTabSelected + ' .agent-ficha .agent-grade').text(
					label
				);
				agentesFunctions.loadAgentes();
				CloseModal();
			}
		});
	},

	contratarAgenteModal: (citizenid) => {
		fetch('GetPoliceGrades', {job: jobData.name}).then((data) => {
			let modalContent = '';
			let grades = {};
			
			for (const key in data) {
				const element = data[key];

				if(grades[element.type] == null)
				{
					grades[element.type] = {};
				}
				grades[element.type][key] = element;
			}
			
			for(let key in grades) {
				let gradeContent = '';
				for(const key2 in grades[key]) {
					const d = grades[key][key2]
					gradeContent += `
					<div class="grade" data-id="${key2}" onclick="agentesFunctions.contratarAgente('${citizenid}', ${key2})">
					<div class="grade-name">${d.label || d.name}</div>
					<div class="grade-payment">${d.payment || d.salary}$</div>
					${d.scale != null ? `<div class="grade-scale">${d.scale}</div>` : ''}</div>`;
				}
				if(key)
					key = "LSPD"
				modalContent += `<div class="col-6" style="width:${100/Object.keys(grades).length}%">
					<div class="title-1-menu">${key != undefined ? key.toUpperCase() : "LSPD"}</div>
					${gradeContent}
				</div>`
			}
			OpenModal(
				Translations.ChangeRange,
				`
			<div class="scroll-rangos">
				<div class="row">
					${modalContent}
				</div>
			</div>
		`,
				'<div></div>',
				Translations.Cancel,
				70
			);
		});
	},

	contratarAgente: (citizenid, jobGrade) => {
		TriggerCallback('origen_police:server:SetPoliceJob', {
			citizenid,
			job: jobData.name,
			grade: jobGrade
		}).then((cb) => {
			if (cb) {
				$('.police .agentes .agent-list').prepend(`
                <div class="white-block agent agente-${cb.citizenid}" cid="${
					cb.citizenid
				}">
                    <div class="citizen-image" style="background-image:url('${
						cb.image || defaultImage
					}');filter:hue-rotate(-${currentHueDeg}deg);"></div>
                    <div class="citizen-info w-100">
                        <div class="agent-name w-100">${
							cb.firstname + ' ' + cb.lastname
						}</div>
                        <div class="d-flex text-uppercase citizen-fast-data justify-content-between">
                            <div class="agente-rango"><span class="citizen-id">${
								cb.grade
							}</span></div>
                            <div class="agente-placa"><i class="fa-solid fa-id-badge"></i> <span class="citizen-phone">000</span></div>
                        </div>
                    </div>
                </div>
                `);
				CloseModal();
				agentesFunctions.loadAgentes();
			} else {
				sendNotification('error', Translations.ErrorOccurred);
				CloseModal();
			}
		});
	},
	searchAgente: (text, job) => {
		if (text.length > 1) {
			$('.police ' + policeTabSelected + ' .agentes .agent-list '+`.job-${job}`+' .agent').each(
				function () {
					if ($(this).text().toLowerCase().includes(text.toLowerCase())) {
						$(this).fadeIn(300);
					} else {
						$(this).fadeOut(300);
					}
				}
			);
		} else {
			$('.police ' + policeTabSelected + ' .agentes .agent-list '+`.job-${job}`+' .agent').fadeIn(
				300
			);
		}
	},

	modalDespedirAgente: (citizenid) => {
		if(HasPermissionMenu('HirePolice')) return sendNotification('error', Translations.NoPermissionPage);
		OpenModal(
			`ATENCIÓN`,
			`<div class="row">
                <div class="col-1">
                    <img src="./img/webp/trash.webp" class="img-fluid">
                </div>
                <div class="col-11 d-flex align-items-center">
                    <div>
                    <h5 class="text-danger fw-bold mb-3">${Translations.ThisActionCantRevert}</h5>
                    <h4>${Translations.DoYouWishContinue}</h4>
                    </div>
                </div>

            </div>`,
			`<button class="btn-modal" onclick="agentesFunctions.deleteAgente('${citizenid}')">${Translations.Confirm}</button>`,
			Translations.Cancel,
			80
		);
	},

	deleteAgente: (citizenid) => {
		TriggerCallback('origen_police:server:SetPoliceJob', { citizenid }).then((cb) => {
			if (cb) {
				$(
					'.police ' +
						policeTabSelected +
						' .agentes .agent-list .agente-' +
						citizenid
				).fadeOut(300);
				CloseModal();
			} else {
				sendNotification('error', "You don't have enough permissions to fire this agent.");
				CloseModal();
			}
		});
	},

	addCondecorate: () => {
		if(HasPermissionMenu('AddCondecorate')) return sendNotification('error', Translations.NoPermissionPage);
		//RECORRE cb Y CREA UNA CONDECORACION POR CADA OBJETO
		let condecoraciones = '';
		Object.values(condecorates).forEach((condecoracion) => {
			condecoraciones += `
            <div class="col-4">
                <div class="condecoracion" onclick="agentesFunctions.setCondecorate('${condecoracion.id}', '${condecoracion.url}', '${condecoracion.name}')">
                    <div class="condecoracion-image" style="background-image:url('./img/condecorates/${condecoracion.url}');"></div>
                    <div class="condecoracion-info">
                        <div class="condecoracion-name">${condecoracion.name}</div>
                        <div class="condecoracion-description">${condecoracion.description}</div>
                    </div>
                </div>
            </div>
            `;
		});

		OpenModal(
			Translations.AddCondecoration,
			`<div class="row max-height">
           ${condecoraciones}
        </div>`,
			'<div></div>',
			Translations.Cancel,
			80
		);
	},
	setCondecorate: (id, url, name) => {
		const citizenid = $('.police ' + policeTabSelected + ' .agent-ficha .citizenid')
			.text()
			.trim();
		TriggerCallback('origen_police:police:UpdatePoliceMetaData', {
			type: 'condecorates',
			citizenid,
			id,
			value: true
		}).then((cb) => {
			if (cb) {
				$(
					'.police ' +
						policeTabSelected +
						' .agent-ficha .agent-condecoraciones .no-condecoracion'
				).remove();
				$('.police ' + policeTabSelected + ' .agent-ficha .agent-condecoraciones')
					.append(`
                <div class="condecoracion" onclick="agentesFunctions.removeCondecorate('${id}', $(this))">
                    <div class="retirar">${Translations.Remove}</div>
                    <img src="./img/condecorates/${url}">
                    <div class="condecoracion-title">${name}</div>
                </div>
                `);
				CloseModal();
			}
		});
	},
	removeCondecorate: (id, yo) => {
		if(HasPermissionMenu('RemoveCondecorate')) return sendNotification('error', Translations.NoPermissionPage);
		const citizenid = $('.police ' + policeTabSelected + ' .agent-ficha .citizenid')
			.text()
			.trim();
		TriggerCallback('origen_police:police:UpdatePoliceMetaData', {
			type: 'condecorates',
			citizenid,
			id
		}).then((cb) => {
			if (cb) {
				yo.addClass('scale-out').fadeOut(500, function () {
					yo.remove();
				});
			}
		});
	},

	addDivision: () => {
		if(HasPermissionMenu('AddDivision')) return sendNotification('error', Translations.NoPermissionPage);
		//RECORRE cb Y CREA UNA CONDECORACION POR CADA OBJETO
		let htmlDivisions = '';
		Object.values(divisions).forEach((division) => {
			htmlDivisions += `
            <div class="col-4">
                <div class="condecoracion" onclick="agentesFunctions.setDivision('${division.id}', '${division.url}', '${division.name}')">
                    <img src="./img/divisions/${division.url}" class="w-100 mb-3 p-2">
                    <div class="condecoracion-info">
                        <div class="condecoracion-name">${division.name}</div>

                    </div>
                </div>
            </div>
            `;
		});

		OpenModal(
			Translations.AddDivision,
			`<div class="row max-height">
           ${htmlDivisions}
        </div>`,
			'<div></div>',
			Translations.Close,
			80
		);
	},
	setDivision: (id, url, name) => {
		const citizenid = $('.police ' + policeTabSelected + ' .agent-ficha .citizenid')
			.text()
			.trim();
		TriggerCallback('origen_police:police:UpdatePoliceMetaData', {
			type: 'divisions',
			citizenid,
			id,
			value: true
		}).then((cb) => {
			if (cb) {
				$(
					'.police ' +
						policeTabSelected +
						' .agent-ficha .agent-divisions .no-divisions'
				).remove();
				$('.police ' + policeTabSelected + ' .agent-ficha .agent-divisions')
					.append(`
                <div class="condecoracion" onclick="agentesFunctions.removeDivision('${id}', $(this))">
                    <img src="./img/divisions/${url}">
                    <div class="condecoracion-title">${name}</div>
                    <div class="retirar">${Translations.Remove}</div>
                </div>
                `);
				CloseModal();
			}
		});
	},

	removeDivision: (id, yo) => {
		if(HasPermissionMenu('RemoveDivision')) return sendNotification('error', Translations.NoPermissionPage);
		const citizenid = $('.police ' + policeTabSelected + ' .agent-ficha .citizenid')
			.text()
			.trim();

		TriggerCallback('origen_police:police:UpdatePoliceMetaData', {
			type: 'divisions',
			citizenid,
			id
		}).then((cb) => {
			if (cb) {
				yo.addClass('scale-out').fadeOut(500, function () {
					yo.remove();
				});
			}
		});
	}
};