$(document).on(
	'mouseenter',
	'.list-item, .radio-button, .duty-button, .tabs-list .tab, .btn-cancel, .btn-modal, .item-flex-box, .button-settings, .delete-item, .back-section, .secondary-box, .btn-action, .btn-search, .white-block, .btn, .shape-block, .shape-button, .leaflet-draw-toolbar a, .leaflet-draw-actions li a',
	function () {
		PlayOver()
	}
);

$(document).on(
	'click',
	'.list-item, .radio-button, .duty-button, .tabs-list .tab, .btn-cancel, .btn-modal, .item-flex-box, .button-settings, .delete-item, .back-section, .secondary-box, .btn-action, .btn-search, .white-block, .btn, .shape-button, .leaflet-draw-actions li a',
	function () {
		PlayClick();
	}
);

$(document).on(
	'click',
	'.police-tab, .ref, .color, .com-item, .action-police, .switch',
	function () {
		PlayClick();
	}
);

$(document).on(
	'mouseenter',
	'.police-tab, .ref, .color, .com-item, .action-police',
	function () {
		PlayOver()
	}
);