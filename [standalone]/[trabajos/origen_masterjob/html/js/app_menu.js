var or = {}
or.debug = false
or.langs = async()=> {return await $.post('https://origen_masterjob/Nuitranslate', JSON.stringify({}))}
or.lang = null
or.appLoaded = []
or.debuger = (...args)=> {
	if (or.debug) {
		console.log('^3[MASTERJOB]:NUI^0',...args)
	}
}
or.loadApp = (app, appCont) => {
    // Check if the app has already been loaded
    if (or.appLoaded.includes(app)) {
        or.debuger('^2 LOAD APP', app, 'Already loaded.');
        return true;
    }
    // If it has not been loaded, we proceed to load it
    or.debuger('^2 LOAD APP',appCont ,app);
    $.get(`./apps/${app}.html`, function (data) {
        if (data) {
            $(`${appCont}`).html(data);
            //Add the app to the array of loaded apps
            or.appLoaded.push(app);
			or.debuger('^2 LOAD APP', app, 'Successfully uploaded.');
			return true
        } else {
            console.log('^1Error loading HTML');
			return false
        }
    });
	return false
}


/* working */
or.open = ()=>{
	$('.app-container').removeClass('activa').hide();
	if (!creation) {
		$('.local-home').addClass('activa').show();

		localFunctions.loadlocal().then(() => {
			$('.screen').addClass('show');
			s_transition.currentTime = '0';
			s_transition.play();
			or.eventKeydown();
		});
	} else {
		or.debuger('creation system', creation)
		$('.screen').addClass('show');
		s_transition.currentTime = '0';
		s_transition.play();
		or.eventKeydown();
	}
}

or.fetch = (event, data) =>{
	or.debuger('^3fetch', event, data)
	return $.post('https://origen_masterjob/' + event, JSON.stringify(data)).promise();
}


or.exportEvent =(script, event, data)=> {
	return $.post('https://' + script + '/' + event, JSON.stringify(data)).promise();
}

or.closeMenu= ()=> {
	$.post('https://origen_masterjob/close', JSON.stringify({}));
	$('.screen').removeClass('show');
	$('.screen').hide();
	$('.home').off('keydown');
	$('.o-modal').hide();
	$('.jobapp').hide();
	setTimeout(() => {
		$('.lista-comercios').css('opacity', 0);
	}, 100);
}


or.isJsonString = (str) => {
	try {
		JSON.parse(str);
	} catch (e) {
		return false;
	}
	return true;
}

or.eventKeydown = () => {
	$(document).keydown(function (event) {
		var keycode = event.keyCode ? event.keyCode : event.which;

		if (keycode == '118' || keycode == '27') {
			or.closeMenu();
		}
	});
}

or.nameToId=(name) => {
	return name
		.normalize('NFD')
		.replace(/[\u0300-\u036f]/g, '')
		.toLowerCase()
		.replace(/ /g, '-')
		.replace(/á/g, 'a')
		.replace(/é/g, 'e')
		.replace(/í/g, 'i')
		.replace(/ó/g, 'o')
		.replace(/ú/g, 'u')
		.replace(/ñ/g, 'n')
		.replace(/ü/g, 'u')
		.replace(/[^a-z0-9-]/g, '');
}

or.timeStampToDate = (timeStamp) => {
	let date = new Date(timeStamp);
	let day = date.getDate();
	let month = date.getMonth() + 1;
	let year = date.getFullYear();
	let hour = date.getHours();
	let minutes = date.getMinutes();
	if (minutes < 10) {
		minutes = '0' + minutes;
	}
	return { date: `${day}/${month}/${year}`, time: `${hour}:${minutes}` };
}

or.translate = async()=>{
	try {
		if (!or.lang) or.lang = await or.langs()
        updateTranslations(or.lang || await or.langs());
		or.debuger('^2 translate ready',or.lang )
    } catch (error) {
		or.debuger('^3[error]:^0',JSON.stringify(error));
    }

}


function updateTranslations(translate) {
    const elementsToTranslate = document.querySelectorAll('[translate]');
    elementsToTranslate.forEach(element => {
        const key = element.getAttribute('translate');
        if (translate?.hasOwnProperty(key)) {
            if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                element.setAttribute('placeholder', translate[key]);
            } else {
                element.textContent = translate[key];
            }
        }
    });
}


/* cargar app local*/
or.loadApp('local', '.apps')
/*
$.get('./apps/local.html', function (data) {
	if (data) {
		$('.apps').html(data);
	} else {
		console.log('Error al cargar el HTML');
	}
});*/

$(document).ready(async()=>{
	
	or.translate()
})

/*MODAL*/
or.OpenModal = (title, content, footerButtons, closeText, width)=> {
	$('.o-modal').show()
	$('.o-modal').append(`
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

function CloseModal() {

	$('.c-modal .modal-block .modal-content')
		.removeClass('scale-in-2')
		.addClass('scale-out-2');
	$('.c-modal')
		.removeClass('fadeIn')
		.fadeOut(500, function () {
			$(this).remove();
			$('.o-modal').hide()
		});
}

or.OpenModalInvi = (title, content, footerButtons, closeText, width)=> {
	$('body').append(`
    <div class="c-modal fadeIn invi">
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

/*MODAL*/

or.stringToUrl= (string) => {
	return string
		.normalize('NFD')
		.replace(/[\u0300-\u036f]/g, '')
		.toLowerCase()
		.replace(/ /g, '-')
		.replace(/á/g, 'a')
		.replace(/é/g, 'e')
		.replace(/í/g, 'i')
		.replace(/ó/g, 'o')
		.replace(/ú/g, 'u')
		.replace(/ñ/g, 'n')
		.replace(/ü/g, 'u');
}



or.sendNotification=(type, title, message) => {
	//CREA UNA NOTIFICACIÓN INDEPENDIENTE Y LA AÑADE EN LA CLASE .notifications. DESPUÉS CREA UN TIMEOUT INDEPENDIENTE ASOCIADO A LA NOTIFICACIÓN PARA CONTROLAR SU CIERRE
	let id = Math.floor(Math.random() * 10000);
	let icon = 'fas fa-bell';
	if (type == 'success') {
		icon = 'fas fa-check';
	} else if (type == 'error') {
		icon = 'fas fa-times';
	}
	$('.notifications').append(`
        <div class="notification animate__fast animate__animated animate__bounceInDown ${type}" id="${id}">
                    <div class="icon">
                        <i class="${icon}"></i>
                    </div>
                    <div class="info">
                        <div class="name">${title}</div>
                        <div class="message">${message || ''}</div>
                    </div>
                </div>
    `);
	setTimeout(function () {
		$(`#${id}`)
			.removeClass('animate__bounceInDown')
			.addClass('animate__bounceOutUp')
			.fadeOut(500, function () {
				$(this).remove();
			});
	}, 3000);
}

or.unlockItem= (title, image, size)=> {
	$('.unlock .title').text(title);
	image ? $('.unlock img').attr('src', image) : null;
	size ? $('.unlock img').css('width', size) : null;
	s_unlock.currentTime = '0';
	s_unlock.play();
	$('.unlock').fadeIn(300);
}




$(document).on('click', '.confirm-item', function () {
	$('.unlock').fadeOut(300);
});




