
var s_unlock = new Audio('https://origennetwork.com/music/v7/unlock.mp3');
var s_click = new Audio('https://origennetwork.com/music/v7/click.mp3?2');
var s_over = new Audio('https://origennetwork.com/music/v7/over.wav?2');
var s_transition = new Audio('https://origennetwork.com/music/v7/transition.ogg');
var s_transition2 = new Audio('https://origennetwork.com/music/v7/transition2.wav');
var s_talkoff = new Audio('https://origennetwork.com/music/v7/walkieoff.mp3?a');
var s_talkon = new Audio('https://origennetwork.com/music/v7/walkieon.mp3?b');
var s_success = new Audio('https://origennetwork.com/music/v7/confirm.mp3');
var s_swipe2 = new Audio('https://origennetwork.com/music/v7/transition2.wav');
var s_hover = new Audio('https://origennetwork.com/music/v7/over.wav?2');
var s_swipe = new Audio('https://origennetwork.com/music/v7/transition.ogg');

var controlsShown = false;

// VOLUME ///

s_click.volume = 0.1;
s_hover.volume = 0.1;
s_swipe.volume = 0.2;
s_transition.volume = 0.2;
s_transition2.volume = 0.1;
s_talkoff.volume = 0.3;
s_talkon.volume = 0.5;
s_success.volume = 0.2;
s_unlock.volume = 1;
s_swipe2.volume = 0.1;

///////////////////////////

let inventory = 'qb_inventory';
let business;
let canSpeak = true;
let creation = false;

////////////////////////////////

$(document).on(
	'click',
	'.btn-cant, .close-button, .btn-comprar, .btn-modal, .btn-cancel',
	function () {
		s_click.currentTime = '0';
		s_click.play();
		// s_hover.currentTime = '0';
		// s_hover.play();
	}
);

$(document).on(
	'mouseenter',
	'.btn-sound, .mercado-item, .swiper-button-next, .swiper-button-prev, .missions-button, .list-item, .spawn, .btn-aparecer, .radio-button, .duty-button, .tabs-list .tab, .back-home, .btn-cancel, .btn-modal, .item-flex-box, .button-settings, .btn-comprar-carrito, .delete-item, .back-section, .secondary-box, .zona-apertura, .app-box, .btn-action, .btn-card-home, .btn-search, .white-block, .btn',
	function () {
		s_over.currentTime = '0';
		s_over.play();
		s_click.currentTime = '0';
		s_click.play();
	}
);


$(document).on('click', '.btn-cant', function () {
	let action = $(this).hasClass('mas') ? 'sumar' : 'restar';
	let cant = parseInt($(this).parent().find('.cant').text());
	let max = parseInt($(this).parent().parent().parent().parent().attr('units'));
	if (action == 'sumar') {
		if (cant == max) return;
		cant++;
	} else {
		cant = Math.max(cant - 1, 1);
	}

	let price = parseInt($(this).parent().parent().parent().parent().attr('price'));
	let total = price * cant;
	or.debuger(price, cant, total);
	$(this)
		.parent()
		.parent()
		.parent()
		.find('.articulo-price')
		.text(total + '$');

	$(this).parent().find('.cant').text(cant);
});

$(document).on('click', '.close-button', function () {
	$('.container-fluid').removeClass('show');
	$.post('https://origen_masterjob/CloseShop', JSON.stringify({}));
});

$(document).keydown(function (e) {
	if (e.keyCode == 27) {
		$('.close-button').click();
	}
});

let icons = {
	'left': 'fa-left-long',
	'right': 'fa-right-long',
	'up': 'fa-up-long',
	'down': 'fa-down-long',
	'delete': 'fa-delete-left',
	'enter': 'fa-right-to-bracket',
	'wheel': 'fa-computer-mouse-scrollwheel'
}

window.addEventListener('message', function (event) {
	if (event.data.open) or.open()
	if (event.data.reload) location.reload(true);
	or.debuger('eventLOg',event.data.action)
	switch (event.data.action) {
		case 'ControlsNotify':
			if (event.data.keys) {
				if (controlsShown) return;
				controlsShown = true;
				$(".container-bar").html("");
				Object.entries(event.data.keys).map(([key, value]) => {
					$(".container-bar").append(`
					<div class="control">
						<div class="mouse"><i class="fa-solid ${icons[value.key]}"></i></div>
						<div class="desc">${value.label}</div>
					</div>
					`);                  
				})

				$(".container-bar").removeClass("animate__fadeOutDown").addClass("animate__fadeInUp").fadeIn(500);
				$(".control-bar").addClass("d-flex");
			} else {
				controlsShown = false;
				$(".container-bar").removeClass("animate__fadeInUp").addClass("animate__fadeOutDown").fadeOut(500, function(){
					$(".control-bar").removeClass("d-flex");
				});
			}
			break;
			
		case 'OpenBMenu':
			$('.screen').show();
			break;

		case 'OpenShop':
			s_swipe.currentTime = '0';
			s_swipe.play();
			$('.container-fluid').addClass('show');
			business = event.data.business;
			or.debuger('^6OpenShop^0', JSON.stringify(event.data.data, null, ' '))
			loadLocalItems(event.data.data);
			break;

		case 'SetupBusinessCreation':
			or.debuger('^2Open Create')
			this.setTimeout(() => {
				$('.screen').show();
				$('.local-home').removeClass('activa').hide();
				$('.local-creator').addClass('activa').show();
			}, 1000);
			creation = true;
			break;

		case 'HideCamHud':
			$('.cam-overlay').fadeOut(300);
			break;

		case 'BusinessCreated':
			$('.screen').show();
			$('.ilegal-quickmenu').hide();
			$('.local .local-creator .pasos.activa').removeClass('activa');
			$('.local .local-creator .pasos.tres').addClass('activa');
			this.setTimeout(() => {
				$('.local-home').removeClass('activa').hide();
				$('.local-creator').addClass('activa').show();
				creation = false;
			}, 500);
			break;

		case 'InviteToBusiness':
			$('.screen').show();
			localFunctions.sendLocalInvitation(
				event.data.id,
				event.data.label,
				event.data.grade,
				event.data.gradelabel
			);

			break;
		case 'UpdateMyBusiness':
			$('.screen').show();
			localFunctions.updatelocal(event.data.Data);
			break;

		case 'ForceNotification':
			$('.screen').show();
			or.sendNotification('success', event.data.notify);
			break;

		case 'Tunnig':
				or.debuger('open Tunning System')
				or.loadApp('tunning', '.jobapp')
				this.setTimeout(()=>{
					tunning.open(event.data.menu)
				},300)
				
			break;
		default:
			break;
	}
}
);

$(document).on('click', '.btn-comprar', function () {
	let item = $(this).parent().parent().parent().attr('name');
	let label = $(this).parent().parent().parent().attr('label');
	let cant = parseInt($(this).parent().find('.cant').text());
	let price = parseInt($(this).parent().parent().parent().attr('price'));
	let total = price * cant;
	let id = $(this).parent().parent().parent().attr('productid');
	let img = $(this).parent().parent().parent().find('.articulo-img img').attr('src');
	or.debuger(item, cant, price, total, img, label);
	or.OpenModal(
		`
    CONFIRM PURCHASE`,
		`
    <div class="text-center">
        <div>Do you want to make this purchase?</div>
        <img src="${img}" style="width:10vh;margin-top:1vh;margin-bottom:1vh;">
        <h3>${label} (x${cant})</h3>
        <div class="text-uppercase">Total: <span class="money">${total}$</span></div>
    </div>

    `,
		`<button class="btn-modal" onclick="buyItem('${item}', ${cant}, ${total}, ${id})">${or.lang.confirm}</button>`,
		`Cancel`,
		50
	);
});

function buyItem(item, cant, total, id) {
	or.debuger('^4 Buy Items' , { business, price: total, item, amount: cant });
	TriggerCallback('origen_masterjob:server:BuyItem', {
		business,
		price: total,
		item,
		amount: cant,
		id
	}).then((cb) => {
		or.debuger(cb);
		if (cb) {
			loadLocalItems(cb);
		} else {
			CloseModal();
			or.debuger('Error: ', cb);
		}
	});
	CloseModal();
}

function OpenModal(title, content, footerButtons, closeText, width) {
	$('.container-fluid').append(`
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
		});
}

function loadLocalItems(items) {
	let html = '';
	or.debuger('recibed items', JSON.stringify(items, null, ' '))
	if (items && items.length > 0) {
		items.map((item) => {
			html += `
            <div class="col-6">
                <div class="articulo" price="${item.price}" units="${item.amount}" name="${item.name}" label="${item.itemdata.label}" productid="${item.productid}">
                    <div class="d-flex justify-content-center align-items-center w-100">
                        <div class="articulo-img">
							${checkItemImage(item.itemdata.image) ? `<img src="${checkItemImage(item.itemdata.image)}">` : ""}
                        </div>
                        <div class="articulo-content">
                            <div class="articulo-title">${item.itemdata.label}</div>
                            <div class="articulo-desc">
                                ${item.itemdata.description}
                            </div>
                            <div class="articulo-stock">
                                ${item.amount} Unity${
				item.amount == 1 ? '' : 'es'
			} Available
                            </div>

                        </div>
                    </div>
                    <div class="article-footer">
                        <div class="articulo-price money">${item.price}$</div>

                        <div class="d-flex align-items-center">
                            <div class="shop-flex-box-count">
                                <div class="menos btn-cant"> <i class="fa-solid fa-minus"></i> </div>
                                <div class="cant"> 1 </div>
                                <div class="mas btn-cant"> <i class="fa-solid fa-plus"></i> </div>
                            </div>
                            <button class="btn-comprar">Buy</button>
                        </div>
                    </div>
                </div>
            </div>
            `;
			$('.row-articulos').html(html);
		});
	} else {
		$('.row-articulos').html(`
        <div class="col-12">
            <div class="w-100 h-100 d-flex justify-content-center flex-column text-center align-items-center text-uppercase" style="font-family:Quicksand;">
                <h4 style="font-weight:100;">No items for sale</h4>
            </div>
        </div>
        `);
	}
}

function TriggerCallback(event, data) {
	data.name = event;
	return $.post(
		'https://origen_masterjob/TriggerCallback',
		JSON.stringify(data)
	).promise();
}


function navigate(from, to) {
	$(from)
		.removeClass('scale-in')
		.addClass('scale-out')
		.fadeOut(300, function () {
			$(to).removeClass('scale-out').addClass('scale-in').fadeIn(300);
		});
}