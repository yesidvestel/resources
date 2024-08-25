const center_x = 117.3;
const center_y = 172.8;
const scale_x = 0.02072;
const scale_y = 0.0205;

CUSTOM_CRS = L.extend({}, L.CRS.Simple, {
	projection: L.Projection.LonLat,
	scale: function (zoom) {
		return Math.pow(2, zoom);
	},
	zoom: function (sc) {
		return Math.log(sc) / 0.6931471805599453;
	},
	distance: function (pos1, pos2) {
		var x_difference = pos2.lng - pos1.lng;
		var y_difference = pos2.lat - pos1.lat;
		return Math.sqrt(x_difference * x_difference + y_difference * y_difference);
	},
	transformation: new L.Transformation(scale_x, center_x, -scale_y, center_y),
	infinite: true
});

var mapStatic = L.tileLayer('img/mapStyles/{z}/{x}/{y}.jpg', {
	minZoom: 0,
	maxZoom: 5,
	noWrap: true,
	id: 'styleAtlas map'
});

var mapStatic2 = L.tileLayer('img/mapStyles/{z}/{x}/{y}.jpg', {
	minZoom: 0,
	maxZoom: 5,
	noWrap: true,
	id: 'styleAtlas map'
});

var CentralGroup = L.layerGroup();

let central = [];

let Blips = {};
let BlipsAdmin = [];

let Circles = {};

var Icons = {
	Central: CentralGroup
};

var mapCentral;
var mapShapes;
var mapAnkle;

let pendingblips = {};

let editableDrawings = {
	'marker': { name: true, editable: true, },
	'polyline': {name: true, editable: true },
	'circle': { name: true, editable: true },
	'rectangle': {name: true, editable: true },
	'polygon': {name: true, editable: true },
};
var editableLayers = new L.FeatureGroup();
var currentLayer

function loadDrawPlugins(mapId) {
	mapId.addLayer(editableLayers);
	var drawPluginOptions = {
		draw: {
			polygon: {
				allowIntersection: true,
				drawError: { color: '#e1e100', message: 'Error' },
				shapeOptions: { color: '#FF0000' }
			},
			polyline: { shapeOptions: { color: '#FF0000' } },
			circle: { shapeOptions: { color: '#FF0000' } },
			rectangle: { shapeOptions: { color: '#FF0000' } },
			marker: true
		},
		edit: {
			featureGroup: editableLayers,
			remove: false
		}
	};
	var drawControl = new L.Control.Draw(drawPluginOptions);
	mapId.addControl(drawControl);
	mapId.addLayer(editableLayers);
	
	mapId.on('draw:created', function(e) {
		var type = e.layerType
		currentLayer = e.layer

		if (editableDrawings[type] && editableDrawings[type].name) {
			if(HasPermissionMenu("CreateShape")) {
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
			OpenModal(
				Translations.CreateNewShape,
				`
				<div class="row">
					<div class="col-12">
						<input class="form-control w-200 map-new-point" placeholder="${Translations.Title}">
					</div>
				</div>
				`,
				`<button class="btn-modal" onclick="centralFunctions.createShape($('.map-new-point').val())">${Translations.Save}</button>`,
				Translations.Cancel
			);
		}
	});
}

function saveShapes(layers, title) {
    var shape
    layers.eachLayer(function(layer) {
        var shapeData = {
            title: title || "",
            type: getLayerType(layer),
            data: [],
            radius: 0
        };
        if (shapeData.type === 'circle') {
			shapeData.data = layer.toGeoJSON().geometry;
            shapeData.radius = layer.getRadius();
		} else if (shapeData.type === 'marker') {
			shapeData.data = layer.toGeoJSON().geometry;
        } else if (shapeData.type === 'rectangle') {
			var bounds = layer.getBounds();
			shapeData.data = layer.toGeoJSON().geometry;
			shapeData.data.coordinates = [
				[bounds.getNorthWest().lat, bounds.getNorthWest().lng],
				[bounds.getSouthEast().lat, bounds.getSouthEast().lng]
			];
        } else if (shapeData.type === 'polyline') {
			var latLngs = layer.getLatLngs();
			shapeData.data = {
				type: 'LineString',
				coordinates: latLngs.map(function(latlng) {
					return [latlng.lat, latlng.lng];
				})
			};
		} else if (shapeData.type === 'polygon') {
			var latLngs = layer.getLatLngs();
			shapeData.data = {
				type: 'Polygon',
				coordinates: [
					latLngs[0].map(function(latlng) {
						return [latlng.lat, latlng.lng];
					})
				]
			};
		}
		shape = shapeData;
    });
    return shape;
}

function getLayerType(layer) {
    if (layer instanceof L.Marker) {
        return 'marker';
    } else if (layer instanceof L.Circle) {
        return 'circle';
    } else if (layer instanceof L.Rectangle) {
        return 'rectangle';
    } else if (layer instanceof L.Polyline) {
		var latLngs = layer.getLatLngs();
        var firstPoint = latLngs[0];
        var lastPoint = latLngs[latLngs.length - 1];
        if (firstPoint.lat === lastPoint.lat && firstPoint.lng === lastPoint.lng) {
            return 'polygon';
        } else {
            return 'polyline';
        }
    } else {
        return 'unknown';
    }
}

function GetDataShapes(data) {
    var layer;
    switch (data.type) {
        case 'marker':
            layer = L.marker(data.data.coordinates.reverse());
            break;
        case 'circle':
            layer = L.circle(data.data.coordinates.reverse(), data.radius);
            break;
        case 'rectangle':
            layer = L.rectangle(data.data.coordinates);
            break;
        case 'polygon':
            layer = L.polygon(data.data.coordinates);
            break;
        case 'polyline':
            layer = L.polyline(data.data.coordinates);
            break;
        default:
            console.error('Unknown layer: ', data.type);
            return null;
    }
    return layer;
}

function getCenter(shape) {
	let center;
	let coordinates = shape.data.coordinates;
	switch (shape.type) {
        case 'marker':
			center = coordinates;
			break;
		case 'circle':
			center = coordinates;
			break;
		case 'rectangle':
			const topLeft = coordinates[0];
			const bottomRight = coordinates[1];
			const rectangleCenter = [(topLeft[0] + bottomRight[0]) / 2, (topLeft[1] + bottomRight[1]) / 2];
			center = rectangleCenter;
			break;
		case 'polygon':
			let sumX = 0;
			let sumY = 0;
			const n = coordinates[0].length;
			for (let i = 0; i < n; i++) {
				sumX += coordinates[0][i][0];
				sumY += coordinates[0][i][1];
			}
			const centroidX = sumX / n;
			const centroidY = sumY / n;
			center = [centroidX, centroidY];
			break;
		case 'polyline':
			const polylineCenter = coordinates.reduce((acc, cur) => {
				return [acc[0] + cur[0] / coordinates.length, acc[1] + cur[1] / coordinates.length];
			}, [0, 0]);
			center = polylineCenter;
			break;
		default:
			console.error('Unknown layer: ', data.type);
            return [0, 0];
	}
	return center
}

function calculateZoom(radius) {
    if (!radius) {
        return 4;
    }
    const zoomLevels = [
        { radius: 100, zoom: 5 },
		{ radius: 500, zoom: 5 },
        { radius: 1000, zoom: 4 },
		{ radius: 2000, zoom: 3 },
		{ radius: 4000, zoom: 2 },
    ];
    for (const zoomLevel of zoomLevels) {
        if (radius <= zoomLevel.radius) {
            return zoomLevel.zoom;
        }
    }
    return zoomLevels[zoomLevels.length - 1].zoom;
}

function zoomShape(lat, lng, zoom) {
	mapShapes.setView([lat, lng], zoom);
}

function cargarMapaCentral(heatAlers) {
	if (!mapCentral) {
		heatAlers.forEach((alert) => {
			alert.count = 50;
		});
		var testData = {
			max: 100,
			data: heatAlers
		};
		  
		var heatmapLayer = new HeatmapOverlay({
			radius: 2,
			maxOpacity: 0.4,
			scaleRadius: true,
			useLocalExtrema: false,
			latField: 'y',
			lngField: 'x',
			valueField: 'count'
		});

		mapCentral = L.map('mapCentral', {
			crs: CUSTOM_CRS,
			minZoom: 1.5,
			maxZoom: 5,
			boxZoom: false,
			maxNativeZoom: 5,
			preferCanvas: true,
			layers: [mapStatic, Icons['Central'], heatmapLayer],
			center: [0, 300],
			zoom: 1.5,
			zoomControl: false,
			maxBoundsViscosity: 1.0,
			tms: false,
			noWrap: true,
		});
		heatmapLayer.setData(testData);
	}
	setTimeout(() => {
		mapCentral.invalidateSize();
		var southWest = mapCentral.unproject([0, 8592], mapCentral.getMaxZoom());
		var northEast = mapCentral.unproject([8192, 0], mapCentral.getMaxZoom());
		var bounds = L.latLngBounds(southWest, northEast);
		mapCentral.setMaxBounds(bounds);
	}, 500);
}

function loadShapesMap() {
	let category = policeFunctions.getCategory();
	if (!mapShapes) {
		mapShapes = L.map('mapShapes', {
			crs: CUSTOM_CRS,
			minZoom: 1.5,
			maxZoom: 5,
			boxZoom: false,
			maxNativeZoom: 5,
			preferCanvas: true,
			layers: [mapStatic2],
			center: [1500, 300],
			zoom: 1.5,
			zoomControl: false,
			maxBoundsViscosity: 1.0,
			tms: false,
			noWrap: true,
		});
	}

	setTimeout(() => {
		mapShapes.invalidateSize();
		var southWest = mapShapes.unproject([0, 8592], mapShapes.getMaxZoom());
		var northEast = mapShapes.unproject([8192, 0], mapShapes.getMaxZoom());
		var bounds = L.latLngBounds(southWest, northEast);
		mapShapes.setMaxBounds(bounds);
		if (category == 'police') {
			centralFunctions.updateShapes();
			loadDrawPlugins(mapShapes);
		}
	}, 500);
}

let LastAnkleCoords = null;
let blipMarker = null;

function LoadAnkleMap(data) {
	destruirMapaAnkle();
	mapAnkle = L.map('anklemap', {
		crs: CUSTOM_CRS,
		minZoom: 1.5,
		maxZoom: 5,
		boxZoom: false,
		maxNativeZoom: 5,
		preferCanvas: true,
		layers: [mapStatic2],
		center: [1500, 300],
		zoom: 1.5,
		zoomControl: false,
		maxBoundsViscosity: 1.0,
		tms: false,
		noWrap: true,
	});
	setTimeout(() => {
		mapAnkle.invalidateSize();
		var southWest = mapAnkle.unproject([0, 8592], mapAnkle.getMaxZoom());
		var northEast = mapAnkle.unproject([8192, 0], mapAnkle.getMaxZoom());
		var bounds = L.latLngBounds(southWest, northEast);
		mapAnkle.setMaxBounds(bounds);
		blipMarker = CreateBlipMarker(mapAnkle, 99, { x: data.coords[0], y: data.coords[1] }, './img/signal.png', 'Ankle Monitor', false);
		ZoomAnkleBlip();
		LastAnkleCoords = [data.coords[0], data.coords[1]];
	}, 500);
}

function ZoomAnkleBlip() {
	if(LastAnkleCoords == null) return;
	mapAnkle.setView([LastAnkleCoords[1], LastAnkleCoords[0]], 10);
}

function removeShapesMap() {
	if (mapShapes) {
		mapShapes.remove();
		mapShapes = null;
	}
}

function destruirMapaCentral() {
	clearInterval(intervalAlert);
	mapFunctions.alerts = [];
	if (mapCentral) {
		mapCentral.remove();
		mapCentral = null;
		Blips = {};
		Icons['Central'].clearLayers();
	}
}

function destruirMapaAnkle() {
	if (mapAnkle) {
		if(blipMarker !== null) {
            blipMarker.remove();
            blipMarker = null;
        }
		mapAnkle.remove();
		mapAnkle = null;
	}
}

function addBlipAtCoords(id, lat, lng, title, street, time, index) {
	central.push([
		id,
		new L.marker([lat, lng], {
			icon: L.icon({
				iconUrl: './img/webp/alert2.webp',
				className: 'alert-blip',
				iconSize: [32, 32],
				iconAnchor: [16, 16],
				popupAnchor: [8, -16]
			})
		})
			.addTo(Icons['Central'])
			.on('click', function () {
				$(
					".police .tab .central .tabla-dispatch tbody tr[index='" +
						index +
						"']"
				).removeClass('new-alert');
				const alert = centralFunctions.alerts[index];
				centralFunctions.setAlertShowing(alert, index);
				mapFunctions.setAlertFocus(id);

				if ($('.police .central .info-mapa').hasClass('show')) {
					$('.police .central .info-mapa').toggleClass('show');
					setTimeout(() => {
						mapFunctions.showCentralAlert(title, street, time, id);
					}, 300);
				} else {
					mapFunctions.showCentralAlert(title, street, time, id);
				}
			})
	]);
	mapCentral.setView([lat, lng]);
}

function CreateBlip(map, blipid, coords, blip, name) {
	if (map) {
		if (Blips[blipid]) {
			mapFunctions.updateBlip(blipid, coords, blip, name);
			return;
		}

		icondata = L.icon({
			iconUrl: blip,
			iconSize: [20, 20],
			iconAnchor: [0, 20],
			popupAnchor: [9, -16]
		});
		Blips[blipid] = L.marker([coords.y, coords.x], { icon: icondata })
			.addTo(map)
			.bindPopup('<b>' + name + '</b>');
	}
}

function CreateBlipMarker(map, blipid, coords, blip, name, save) {
	if (map) {
		if (BlipsAdmin[blipid]) {
			mapFunctions.updateBlip(blipid, coords, blip, name);
			return;
		}

		icondata = L.icon({
			iconUrl: blip,
			iconSize: [20, 20],
			iconAnchor: [0, 20],
			popupAnchor: [9, -16]
		});

		const blipRef = L.marker([coords.y, coords.x], { icon: icondata })
			.addTo(map)
			.bindPopup('<b>' + name + '</b>');
		if (save)
			BlipsAdmin[blipid] = blipRef;
		return blipRef;
	}
}

function CreateReferenceBlip(map, blipid, coords, blip, name, color) {
	if (map) {
		if (Blips[blipid]) {
			mapFunctions.updateBlipRef(blipid, coords, blip, name, color);
			return;
		}

		icondata = L.divIcon({
			iconSize: [20, 20],
			iconAnchor: [10, 10],
			popupAnchor: [5, -5],
			html: `<div class="reference-blip" style="background-color: ${color}"><img src="${blip}"></div>`
		});

		Blips[blipid] = L.marker([coords.y + 5, coords.x + 5], { icon: icondata })
			.addTo(map)
			.bindPopup('<b>' + name + '</b>');
	}
}

const mapFunctions = {
	policeSources: [],
	showCentralAlert: (title, street, time, id) => {
		$('.police .central .info-mapa .info-data .info-title').html(title);
		$('.police .central .info-mapa .info-data .id-label .label').html(id);

		$('.police .central .info-mapa .info-data .location-label .location').html(
			street
		);

		$('.police .central .info-mapa').toggleClass('show');
	},
	setBlipFocus: (blipid) => {
		if (Blips[blipid]) {
			Blips[blipid].openPopup();

			mapCentral.setView(Blips[blipid].getLatLng(), 5);
		}
	},

	setAlertFocus: (alertid) => {
		central.map((alert) => {
			if (alert[0] == parseInt(alertid)) {
				mapCentral.setView(alert[1].getLatLng(), 5);
			}
		});
	},

	destroyBlip: (blipid) => {
		if (Blips[blipid]) {
			mapCentral.removeLayer(Blips[blipid]);
			delete Blips[blipid];
		}
	},

	updateBlip: (blipid, coords, blip, name) => {
		if (Blips[blipid]) {
			Blips[blipid].setLatLng([coords.y, coords.x]);
			Blips[blipid].setIcon(
				L.icon({
					iconUrl: blip,
					iconSize: [20, 20],
					iconAnchor: [0, 20],
					popupAnchor: [9, -16]
				})
			);
			Blips[blipid].bindPopup('<b>' + name + '</b>');
		}
	},
	updateBlipRef: (blipid, coords, blip, name, color) => {
		if (Blips[blipid]) {
			Blips[blipid].setLatLng([coords.y + 5, coords.x - 5]);
			Blips[blipid].setIcon(
				L.divIcon({
					iconSize: [20, 20],
					iconAnchor: [10, 10],
					popupAnchor: [5, -5],
					html: `<div class="reference-blip" style="background-color: ${color}"><img src="${blip}"></div>`
				})
			);
			Blips[blipid].bindPopup('<b>' + name + '</b>');
		}
	},
	checkPoliceSources: (data) => {
		if (data) {
			mapFunctions.policeSources.forEach((element) => {
				if (!data.includes(element)) {
					mapFunctions.destroyBlip(element);
				}
			});
			mapFunctions.policeSources = data;
		}
	},

	CreateCircle: (map, id, coords, radius, color1, color2, type) => {
		if (map) {
			if (Circles[id]) {
				mapFunctions.destroyCircle(id);
			}
			let circle = new L.circle([coords.y, coords.x], {
				radius: radius,
				opacity: 0.9,
				color: color1,
				fillColor: color2,
				fillOpacity: 0.5
			})
				.addTo(map)
				.bindPopup('<b>' + type + '</b>');

			Circles[id] = circle;
		}
	},

	updateCircle: (id, coords, radius, color1, color2, type) => {
		if (Circles[id]) {
			Circles[id].setLatLng([coords.y, coords.x]);
			Circles[id].setRadius(radius);
			Circles[id].setStyle({ color: color1, fillColor: color2 });
			Circles[id].bindPopup('<b>' + type + '</b>');
		}
	},

	destroyCircle: (id) => {
		if (Circles[id]) {
			mapCentral.removeLayer(Circles[id]);
			delete Circles[id];
		}
	},

	destroyAlertBlip: (id) => {
		central.map((alert, i) => {
			if (alert[0] == id) {
				mapCentral.removeLayer(alert[1]);
				delete central[i];
				if (centralFunctions.alerts.length == 0) {
					$('.police .tab .central .tabla-dispatch tbody').html(`
                    <tr>
                        <td colspan="5" class="text-muted text-center no-alerts">No notices have been received.</td>
                    </tr>
                    `);
				}
			}
		});
	}
};

$(document).on('click', '.police .tab .central .info-mapa .close-button', function () {
	$('.police .central .info-mapa').toggleClass('show');
});
