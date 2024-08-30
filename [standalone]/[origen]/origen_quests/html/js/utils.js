var or = {}
or.appLoaded = []
// Hakos did this and i stole it
or.debuger = (...args)=> {
	if (or.debug) {
		console.log('^3[QUESTS]:NUI^0',...args)
	}
}
or.loadApp = (app, appCont) => {
    if (or.appLoaded.includes(app)) [
        // return true;
    ]

    $.get('./apps/quests.html', function (data) {
        if (data) {
            $(`${appCont}`).html(data);
            or.appLoaded.push(app);
        }
    });
};

or.loadApp('adminMenu', '.apps')

or.open = ()=>{
	$('.app-container').removeClass('activa').hide();
	$('.admin-quests').addClass('activa').show();
	$('.screen').show(function() {
		abrir.currentTime = '0';
		abrir.play();
		$('.screen').addClass('show');
	});
}

or.closeMenu= ()=> {
	// $.post('https://origen_quests/close', JSON.stringify({}));
	$('.screen').removeClass('show', function() {
		setTimeout(() => {
			$('.screen').hide();
		}, 500);
	});
}


or.fetch = (event, data) =>{
	or.debuger('^3fetch', event, data)
	return $.post('https://origen_quests/' + event, JSON.stringify(data)).promise();
}


or.exportEvent =(script, event, data)=> {
	return $.post('https://' + script + '/' + event, JSON.stringify(data)).promise();
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




function TriggerCallback(event, data) {
	data.name = event;
	return $.post(
		'https://origen_quests/TriggerCallback',
		JSON.stringify(data)
	).promise();
}


const itemsFunctions = {
    loadItems: () => {
		let _items = TriggerCallback('origen_quests:server:GetItems', {});
		return _items
	},
}