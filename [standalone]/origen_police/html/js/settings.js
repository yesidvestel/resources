let settingsLoaded = false;
let currentTab = "station";
let currentStation = null;

const Markers = [
    {
        name: "RequestVehicle",
        fields: ["coords", "spawn"],
        icon: "fas fa-car"
    },
    {
        name: "ModifyVehicle",
        fields: ["coords"],
        icon: "fa-solid fa-screwdriver-wrench"
    },
    {
        name: "SaveVehicle",
        fields: ["coords"],
        icon: "fa-solid fa-floppy-disk"
    },
    {
        name: "RequestBoat",
        fields: ["coords", "spawn"],
        icon: "fa-solid fa-ship"
    },
    {
        name: "SaveBoat",
        fields: ["coords"],
        icon: "fa-solid fa-anchor"
    },
    {
        name: "RequestHelicopter",
        fields: ["coords", "spawn"],
        icon: "fa-solid fa-helicopter"
    },
    {
        name: "SaveHelicopter",
        fields: ["coords"],
        icon: "fa-solid fa-helicopter-symbol"
    },
    {
        name: "DressingRoom",
        fields: ["coords"],
        icon: "fa-solid fa-vest"
    },
    {
        name: "Inventory/Armoury",
        fields: ["coords"],
        icon: "fa-solid fa-layer-group"
    },
    {
        name: "EvidenceReport",
        fields: ["coords"],
        icon: "fa-solid fa-file-invoice"
    },
    {
        name: "Duty",
        fields: ["coords"],
        icon: "fa-solid fa-id-card-clip"
    },
    {
        name: "Finger",
        fields: ["coords"],
        icon: "fa-solid fa-fingerprint"
    },
    {
        name: "CriminalClothes",
        fields: ["coords"],
        icon: "fa-solid fa-handcuffs"
    },
    {
        name: "Pertenences",
        fields: ["coords"],
        icon: "fa-brands fa-dropbox"
    },
    {
        name: "ConfiscatedVehicles",
        fields: ["coords"],
        icon: "fa-solid fa-truck-pickup"
    },
    {
        name: "BillsNPC",
        fields: ["coords"],
        icon: "fa-solid fa-money-bills"
    },
    {
        name: "SpawnConfiscatedVehicles",
        fields: ["coords"],
        icon: "fa-solid unknown"
    },
]

function GetMarkerData(markerName) {
    for(let i = 0; i < Markers.length; i++) {
        if(Markers[i].name == markerName) return Markers[i];
    }
    return null;
}

function addSpaceBeforeCapitalLetters(str) {
    return str.replace(/([a-z])([A-Z])/g, '$1 $2');
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

settingsFunctions = {
    loadListeners: function() {
        if(settingsLoaded) return;
        settingsLoaded = true;
        $("#station-active-l").on("click", function() {
            $(this).parent().find("input").prop("checked", false);
            $("#station-active").prop("checked", true);
            settingsFunctions.setActiveState(true);
        });
        $("#station-unactive-l").on("click", function() {
            $(this).parent().find("input").prop("checked", false);
            $("#station-unactive").prop("checked", true);
            settingsFunctions.setActiveState(false);
        });
        settingsFunctions.loadStations(true);
    },

    loadStations: function(first = false) {
        if(first) {
            // Markers
            for(let i = 0; i < Markers.length; i++) {
                const marker = Markers[i];
                $(".app.police .setting-container[tab*='station'] .marker-list").append(`
                    <li class="list-group-item list-group-item-action">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center marker-option">
                                <i class="${marker.icon}"></i>
                                <h5>${addSpaceBeforeCapitalLetters(marker.name)}</h5>
                                <div class="marker-fields">
                                    <p>${marker.fields.map(field => field.toUpperCase()).join(', ')}</p>
                                </div>
                                <div class="marker-btn" onclick="settingsFunctions.createMaker('${marker.name}', ${GetMarkerData(marker.name).fields.length > 1})">
                                    <i class="fa-solid fa-plus"></i>
                                </div>
                            </div>
                        </div>
                    </li>
                `);
            }
        }
        TriggerCallback('origen_police:callback:GetStationsList', {}).done((cb) => {
            if(cb) {
                $(".app.police .setting-container[tab*='station'] .station-list").html("");
                for(let i = 0; i < Object.keys(cb).length; i++) {
                    const station = Object.values(cb)[i];
                    $(".app.police .setting-container[tab*='station'] .station-list").append(`
                        <div onclick="settingsFunctions.loadStation('${station.name}')" class="white-block station scale-in" station="${station.name}" style="${!station.active ? "opacity:0.7 !important;" : ""}">
                            <div class="d-flex w-100">
                                <div class="w-50">
                                    <div class="station-name">
                                        <i class="fas fa-building-shield" aria-hidden="true"></i>${station.label}
                                    </div>
                                </div>
                                <div class="w-50">
                                    <div class="station-date" style="display:flex;max-width:15.2vh;align-items:center;margin-top:0.2vh;">
                                        <i class="fas fa-location-dot" aria-hidden="true"></i>
                                        <span style="white-space: nowrap;max-width: 100%;overflow: hidden;text-overflow: ellipsis;">${station.street || "UNKNOWN"}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex w-100">
                                <div class="w-50">
                                    <div class="station-owner">
                                        <i class="fas fa-user" aria-hidden="true"></i>
                                        <span>${station.author}</span>
                                    </div>
                                </div>
                                <div class="w-50">
                                    <div class="station-date">
                                        <i class="fas fa-calendar-alt" aria-hidden="true"></i>
                                        <span>${station.modified}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `);
                }
            }
        });
    },

    gotoMarker: function(x, y, z) {
        fetch('GotoMarker', {x: x, y: y, z: z}).then((data) => {
            if(data) closeMenu();
        });
    },

    loadStation: function(station) {
        $("#station-data-placeholder").fadeOut(200, function() {
            $(this).attr("style", 'height: 73vh;display: none !important;');
        });
        setTimeout(() => {
            $("#station-data").fadeIn(200);
        }, 200);
        TriggerCallback('origen_police:callback:GetStation', {station: station}).done((cb) => {
            if(cb) {
                currentStation = cb.name;
                $("#station-name").html(cb.name);
                $("#station-label").html(cb.label.toUpperCase().replace("-", " "));
                $("#station-user").html(cb.author);
                $("#station-date").html(cb.modified);
                $("#station-active").prop("checked", cb.active);
                $("#station-unactive").prop("checked", !cb.active);
                $(".app.police .setting-container[tab*='station'] .current-marker-list").html("");
                $(".app.police .setting-container[tab*='station'] .job-list").html("");
                for(let i = 0; i < Object.keys(cb.markers).length; i++) {
                    const markerName = Object.keys(cb.markers)[i];
                    const markers = Object.values(cb.markers)[i];
                    for(let j = 0; j < markers.length; j++) {
                        const coords = markers[j].coords;
                        $(".app.police .setting-container[tab*='station'] .current-marker-list").append(`
                            <li class="list-group-item list-group-item-action">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center marker-option">
                                        
                                        <h5>${addSpaceBeforeCapitalLetters(markerName)}</h5>
                                        
                                        <div style="display: flex;right: 0;position: absolute;gap: 2vh;">
                                            <div onclick="settingsFunctions.gotoMarker('${coords[0]}', '${coords[1]}', '${coords[2]}')" class="marker-btn" style="position: relative;">
                                                <i class="fa-solid fa-street-view"></i>
                                            </div>
                                            <div class="marker-btn" style="position: relative;" onclick="settingsFunctions.updateMarkerPosition('${markerName}', ${j}, ${GetMarkerData(markerName).fields.length > 1})">
                                                <i class="fa-solid fa-location-dot"></i>
                                            </div>
                                            <div class="marker-btn" style="position: relative;" onclick="settingsFunctions.removeMarker(this, '${markerName}', ${j})">
                                                <i class="fa-solid fa-trash"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        `);
                    }
                }
                for(let i = 0; i < Object.keys(cb.jobs).length; i++) {
                    const job = Object.values(cb.jobs)[i];
                    const jobCat = Object.keys(cb.jobs)[i];
                    $(".app.police .setting-container[tab*='station'] .job-list").append(`
                        <li class="list-group-item list-group-item-action" jobCat="${jobCat}">
                            <h5>${capitalizeFirstLetter(jobCat)} Category</h5>
                            <ul>
                                ${job.map(j => `<li><p>${capitalizeFirstLetter(j)}</p></li>`).join('')}
                            </ul>
                            <div class="delete-button" onclick="settingsFunctions.removeJobCat(this)">
                                <i class="fa-solid fa-trash"></i>
                            </div>
                        </li>
                    `);
                }
                return;
            }
        });
    },

    addJobCatModal: function(element) {
        const listUl = $(element).parent().parent().find("ul");
        const jobCats = [];
        listUl.find("li").each(function() {
            const jobCat = $(this).attr("jobCat");
            if(jobCat != undefined) jobCats.push(jobCat);
        });
        fetch('GetJobCategories', {}).then((data) => {
            if(!data) return;
            let catList = "";
            for(let i = 0; i < Object.keys(data).length; i++) {
                const job = Object.values(data)[i];
                const jobCat = Object.keys(data)[i];
                if(jobCats.includes(jobCat)) continue;
                catList += `
                    <li class="list-group-item list-group-item-action" jobcat="${jobCat}" style="margin-bottom: 1vh;border-radius:10px;" onclick="settingsFunctions.confirmAddJobCat(this, '${jobCat}')">
                        <h5>${capitalizeFirstLetter(jobCat)} Category</h5>
                        <ul>
                            ${job.map(j => `<li><p>${capitalizeFirstLetter(j)}</p></li>`).join('')}
                        </ul>
                    </li>
                `;
            }

            OpenModal(
                "Add Job Category",
                `Select the category of the job you want to add to the list.
                    <ul class="list-group job-list" style="margin-top: 2vh;">
                        ${catList}
                    </ul>
                `, ``,
                Translations.Cancel
            );
        });
    },

    confirmAddJobCat: function(element, jobCat) {
        if(!currentStation) return console.log("No station selected");
        TriggerCallback('origen_police:callback:AddJobCatStation', {station: currentStation, cat: jobCat}).done((cb) => {
            if(cb) {
                $(".app.police .setting-container[tab*='station'] .job-list").append(`
                    <li class="list-group-item list-group-item-action" jobcat="${jobCat}">
                        ${$(element).html()}
                        <div class="delete-button" onclick="settingsFunctions.removeJobCat(this)">
                            <i class="fa-solid fa-trash"></i>
                        </div>
                    </li>
                `).css("display", "none").fadeIn(300);
                CloseModal();
                sendNotification('success', "Job category added", "The job category has been added to the station correctly.");
            }
        });
    },

    removeJobCat: function(element) {
        const jobCat = $(element).parent().attr("jobCat");
        if(!currentStation) return console.log("No station selected");
        TriggerCallback('origen_police:callback:RemoveJobCatStation', {station: currentStation, cat: jobCat}).done((cb) => {
            if(cb) {
                $(element).parent().fadeOut(300, function() {
                    $(this).remove();
                });
                sendNotification('success', "Job category removed", "The job category has been removed from the station correctly.");
            }
        });
    },

    setActiveState: function(state) {
        if(!currentStation) return console.log("No station selected");
        TriggerCallback('origen_police:callback:SetActiveStation', {station: currentStation, active: state}).done((cb) => {
            if(cb) {
                sendNotification('success', "Station updated", "The station has been updated correctly.");
            }
        });
    },

    updateMarkerPosition: function(markerName, markerIndex, multiple) {
        fetch("SetMarkerPos", {station: currentStation,markerName: markerName, markerIndex: markerIndex, multiple: multiple}).then((data) => {
            if(data) {
                closeMenu();
            }
        });
    },

    removeMarker: function(element, markerName, markerIndex) {
        TriggerCallback('origen_police:callback:RemoveMarker', {station: currentStation, markerName: markerName, markerIndex: markerIndex + 1}).done((cb) => {
            if(cb) {
                $(element).parent().parent().parent().parent().fadeOut(300);
                sendNotification('success', "Marker removed", "The marker has been removed from the station correctly. The changes will be applied in the next script restart.");
            }
        });
    },

    createMaker: function(markerName, multiple) {
        fetch("CreateMarker", {station: currentStation, markerName: markerName, multiple: multiple}).then((data) => {
            if(data) {
                closeMenu();
            }
        });
    },

    deleteStation: function() {
        $("#station-data").fadeOut(200);
        setTimeout(() => {
            $("#station-data-placeholder").fadeIn(200);
        }, 200);
        TriggerCallback('origen_police:callback:DeleteStation', {station: currentStation}).done((cb) => {
            if(cb) {
                settingsFunctions.loadStations();
                sendNotification('success', "Station deleted", "The station has been deleted correctly. The changes will be applied in the next script restart.");
            }
        });
    }
}

$(".app.police .settings-options .setting-option").on("click", function() {
    if($(this).attr("tab") == currentTab) return;
    $(".app.police .settings-options .setting-option").removeClass("active");
    $(this).addClass("active");
    const newTab = $(this).attr("tab");
    $(".app.police .setting-container").each(function() {
        if($(this).attr("tab") == currentTab) {
            $(this).fadeOut(200);
        } else if($(this).attr("tab") == newTab) {
            setTimeout(() => {
                $(this).fadeIn(200);
            }, 200);
        }
    });
    currentTab = newTab;
    PlayClick();
});
$(document).on(
    'mouseenter',
    '.app.police .settings-options .setting-option',
    function () {
        PlayOver()
    }
);
// event on click element with id "station-active"