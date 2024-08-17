citizenSelectorFunctions = {
	getCB: undefined,
	loadSelectorFunctions: () => {
		$(document).on('click', '.police .personas-container .close-button', function () {
			$(this).parent().removeClass('scale-in').addClass('scale-out');
			$('.police .personas-container').fadeOut(300);
		});

		$(document).on('click', '.police .btn-search-citizen-selector', function () {
			policeFunctions.searchCitizen(this, true);
		});

		$(document).on(
			'keydown',
			'.police .input-search-citizen-selector',
			function (event) {
				var keycode = event.keyCode ? event.keyCode : event.which;
				if (keycode == '13') {
					policeFunctions.searchCitizen(this, true);
				}
			}
		);

		$(document).on('click', '.police .citizen-box', function () {
			let citizenName = $(this).find('.citizen-name').text().trim();
			let citizenid = $(this).find('.citizen-id').text().trim();
			if (citizenSelectorFunctions.getCB) {
				citizenSelectorFunctions.getCB(citizenName, citizenid);
			}
		});
	},

	showAddPersona: function (cb, type) {
		if (type) {
			if (type == 'police') {
				$('.police .personas-container .app-title').text(Translations.SelectAnAgent2);
				$('.police .personas-box .btn-search-citizen-selector').attr(
					'data-type',
					'police'
				);
				$('.police .personas-box .input-search-citizen-selector').attr(
					'placeholder',
					Translations.LookForAgent
				);
			}
		} else {
			$('.police .personas-box .btn-search-citizen-selector').attr(
				'data-type',
				'persona'
			);
			$('.police .personas-container .app-title').text(Translations.SelectCitizen);
			$('.police .personas-box .input-search-citizen-selector').attr(
				'placeholder', 
				Translations.FindACitizen
			);
		}
		$('.police .personas-box .citizen-box-list .row').html(`
        <div class="col-12 text-muted">
            <h4 class="citizen-name">${Translations.EnterNameToSearch}</h4>
        </div>`);
		$('.police .personas-box .input-search-citizen-selector').val('');

		$('.police .personas-box').removeClass('scale-out').addClass('scale-in');
		$('.police .personas-container').fadeIn(300);

		citizenSelectorFunctions.getCB = cb;
	}
};