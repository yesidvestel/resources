const tunning = {}
tunning.menu = []
tunning.lastmenu = []
tunning.listeners = []

tunning.open = (menu)=> {
	or.debuger('^6open menu tunning')
	tunning.menu = []
	tunning.lastmenu = []
	$('.jobapp').show()
	$('.tunning').show()
	or.eventKeydown()
	tunning.loadmenu(menu)
}

tunning.checkMenu = (id,type, wid) => {
	switch (id) {
		case 'back':
			if (tunning.lastmenu.length > 0) {
				tunning.loadmenu(tunning.lastmenu) 
			} else { 
				or.closeMenu()
				tunning.menu = []
				tunning.lastmenu = []
			};
			break;
		case 'close':
			or.closeMenu()
			tunning.menu = []
			tunning.lastmenu = []
			$.post('https://origen_masterjob/NuiFocus', JSON.stringify(false))
			break
	}

	switch (type) {
		case 'mod':
		   	const opt = tunning.menu.find((e)=>{
				return e.id == id
			})
			if (opt) {
				or.debuger('options mod',JSON.stringify(opt.data), opt.data.tw)
				return `<div class="input-cont" data-menu="${type}" data-id="${id}" data-wid="${opt.data.tw}">
				  <i class="fa-solid fa-arrow-left"></i>
				  <input type="number" value="${opt.data.current || 0 }" min="0" max="${opt.data.max}" />
				  <i class="fa-solid fa-arrow-right"></i>
				</div>`
			  }
			or.debuger('^2 modifacame el coche', type, id)
			break;
		case 'wheels':
			const o = tunning.menu.find((e)=>{
				return e.data.tw == wid
			})
			or.debuger('^4wheels ', JSON.stringify(o))
			if (o) {
				return `<div class="input-cont" data-menu="${type}" data-id="${id}" data-wid="${o.data.tw}">
					<i class="fa-solid fa-arrow-left"></i>
					<input type="number" value="${o.data.current || 0 }" min="0" max="${o.data.max}" />
					<i class="fa-solid fa-arrow-right"></i>
					</div>`
			}
			break;
			
	}
}


tunning.loadmenu = (menu) => {
	camrot = false
	if (tunning.listeners.length > 0) tunning.listeners.forEach(e =>$(`#${e}`).off('input'))
	or.debuger('^4loadmenu', tunning.menu.length)
    if (tunning.parsemenu(menu)) {
		if (tunning.menu.length > 0) tunning.lastmenu = tunning.menu
        tunning.menu = menu;
        $('.modify-cont').empty();
        menu.forEach((item) => {
			if (item.type == 'prirgb' || item.type =='secrgb' || item.type == 'xenon' || item.type == 'rgbneon' || item.type == 'tyresm'){
				$('.modify-cont').append(`
				<div class="colorp">
					<label for="${item.id}" class="modify" data-menu="${item.type}" data-id="${item.id}" >${item.label}</label>
					<input class='head' type="color" id="${item.id}" name="head" value="#008A60" />
				</div>
				`);
				tunning.listeners.push(item.id)
				$(`#${item.id}`).on('input', function(t) {
					const color = tunning.hexToRgb(t.target.value)
					or.debuger(color.r)
					tunning.post('cazyColor', {rgb:color, t:item.type, id:item.id})
				  });
			} else {
				$('.modify-cont').append(`<div class="modify"  data-menu="${item.type}"  data-id="${item.id}" data-wid="${item.data?.tw}">${item.label}</div>`);
			}
        });
		if (tunning.lastmenu.length > 0) 
		$('.modify-cont').append(`<div class="modify"  data-menu="back"  data-id="back">Back</div>`);
    }
}

tunning.parsemenu = (menu) => {
	if (Array.isArray(menu)){
		return true
	} else if (typeof menu == 'object') {
		or.debuger('^1[ERROR]: Your menu is a object')
		return false
	} else {
		or.debuger('^1[ERROR]: type of your menu is not supported')
		return false
	}
}

tunning.hexToRgb = (hex) =>{
	hex = hex.replace(/^#/, '');
    let bigint = parseInt(hex, 16);
    let r = (bigint >> 16) & 255;
    let g = (bigint >> 8) & 255;
    let b = bigint & 255;
    return { r, g, b};
}

tunning.post = (e,data,cb)=> {
	return $.post(`https://origen_masterjob/${e}`, JSON.stringify(data), cb)
}

$('.tunning .header .accept').on('click', function() {
	tunning.post('AcceptTunning')
	
})

$('.tunning .header .home').on('click', function() {
	tunning.post('reloadmenu')
})

$(document).on('click', '.tunning .modify-cont .modify', function () {
	const id = $(this).data('id');
	const type = $(this).data('menu');
	const wid = $(this).data('wid');

	or.debuger('^6 click modification', id, type, wid)
	const a = tunning.checkMenu(id, type, wid)
	if (a) {
	  or.debuger('^3 abrete')
	  if ($('.input-cont').length) {
		$('.input-cont').remove();
	  }
	  $(this).after(a);
	}
	if (type == 'menu') {
	  or.fetch('GetMenuId', { id: id }).done((menu) => {
		or.debuger('^4 GetMenuID', menu)
		tunning.loadmenu(menu)
		return
	  })
	} 
	if (type == 'win' || type == 'neon') tunning.post('Set_modificatios', {id:id, menu:type});
	if (type == 'perl' || type == 'wheel') {
		tunning.post('perls', {t:type, id:id})
	}
})


$(document).on('click', '.input-cont i.fa-arrow-left, .input-cont i.fa-arrow-right', function() {
	var valor = $(this).closest('.input-cont').find('input').val();
	or.debuger('^1valor^0', valor)
	if ($(this).hasClass('fa-arrow-left')) {
	  valor--;
	} else {
	  valor++;
	}
	var minimo = $(this).closest('.input-cont').find('input').attr('min');
	var maximo = $(this).closest('.input-cont').find('input').attr('max');
  
	if (valor < minimo) {
	  valor = minimo;
	} else if (valor > maximo) {
	  valor = maximo;
	}
	$(this).closest('.input-cont').find('input').val(valor);
	or.debuger('^6 send event', $(this).closest('.input-cont').data('id'), $(this).closest('.input-cont').data('menu'))
	tunning.post('Set_modificatios',{
		id:$(this).closest('.input-cont').data('id'),
		value: valor,
		menu: $(this).closest('.input-cont').data('menu'),
		wid: $(this).closest('.input-cont').data('wid')
	})
});  

$(document).on('change', '.input-cont input', function() {
	var valor = $(this).closest('.input-cont').find('input').val();  
	var minimo = $(this).closest('.input-cont').find('input').attr('min');
	var maximo = $(this).closest('.input-cont').find('input').attr('max');
  
	if (valor < minimo) {
	  valor = minimo;
	} else if (valor > maximo) {
	  valor = maximo;
	}
	$(this).closest('.input-cont').find('input').val(valor);
	or.debuger('^6 send event ^1INPUT^0', $(this).closest('.input-cont').data('id'), $(this).closest('.input-cont').data('menu'))
	tunning.post('Set_modificatios',{
		id:$(this).closest('.input-cont').data('id'),
		value: valor,
		menu: $(this).closest('.input-cont').data('menu'),
		wid: $(this).closest('.input-cont').data('wid')
	})
})

var camrot = false

$(document).on('click', '.camtouch', function() {
	tunning.post('camrot', !camrot)
	camrot = !camrot
})