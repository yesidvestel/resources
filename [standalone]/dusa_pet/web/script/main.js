let table;
let isPetHere = false;
let petfocus = false;
var clothes = {
  clothes: [],
};
var firstOpen = false;

window.addEventListener("message", function (event) {
  var item = event.data;
  switch (item.type) {
    case "o_shop":
      if (item.action === "open") {
        app.openInterface("shop", true);
        app.shopData(item.dataShop, item.shopType);
        app.openInterface("hud", false);
      } else {
        app.openInterface("shop", false);
      }
      break;
    case "o_petshop":
      if (item.action === "open") {
        app.openInterface("petshop", true);
        app.petShopData(item.petshopData);
        if (item.isPolice) {
          app.k9ShopData(item.k9data);
        }
        app.openInterface("hud", false);
        // app.emoteData(item.menuList, item.menuType, item.petData, item.status);
      } else {
        app.openInterface("petshop", false);
      }
      break;
    case "o_petmenu":
      if (item.action === "open") {
        app.openInterface("petmenu", true);
        app.petinvData(item.petinvData);
        app.openInterface("hud", false);
        // app.emoteData(item.menuList, item.menuType, item.petData, item.status);
      } else if (item.action == "close") {
        app.openInterface("petmenu", false);
      } else if (item.action == "sendPet") {
        app.petsGoSleep();
      } else if (item.action == "updatePetName") {
        app.petinvData(item.petinvData);
      }
      break;
    case "o_wardrobe":
      if (item.action === "open") {
        app.openInterface("wardrobe", true);
        app.wardrobeData(item.inventory, item.clothes);
        app.openInterface("hud", false);
      } else {
        clothes = {
          clothes: [],
        };
        if (!item.cleardata) {
          app.openInterface("wardrobe", false, false);
          return;
        }
        app.openInterface("wardrobe", false, true);
      }
      break;
    case "o_emote":
      if (item.action === "open") {
        app.openInterface("emote", true);
        app.emoteData(item.menuList, item.menuType, item.name, item.status);
        app.openInterface("hud", false);
      } else {
        app.openInterface("emote", false);
      }
      break;
    case "o_hud":
      if (item.action === "open") {
        app.openInterface("hud", true);
        app.hudData(item.status);
      } else if (item.action === "close") {
        app.openInterface("hud", false);
      } else if (item.action === "update") {
        app.hudData(item.status);
      }
      break;
    case "translate":
      app.TranslateUI(item.translate);
      break;
    case "notification":
      app.openInterface("notification", item.action, item.text);
      break;
  }
});

var app = new Vue({
  el: "#app",
  data: {
    notifyText: {
      error: "Error!",
      success: "Success!",
      info: "Info!",
      hunger: "Yummy!",
      quest: "Quest!",
    },
    notifyDelay: 6000,
    shop: {
      enabled: false,
      info: {
        shop_p: "Buy some things for your animals",
        add_card: "Add",
        paytocard: "PAY TO CARD",
        paytocash: "PAY TO CASH",
      },
      active_shop: 1,
      inactiveClass: "inactive_shop",
      activeClass: "active_shop",
      food: [],
      dress: [],
      cat: [],
      dog: [],
      products: [],
      card: [],
    },
    wardrobe: {
      enabled: false,
      info: {
        wardrobe_p: "Buy some things for your animals",
        info_h1: "INFO!",
        info_p: "Use drag and drop to dress the pet",
      },
      wardrobe: [],
      slots: [{ item: [] }, { item: [] }],
      cat_svg: `<svg width="14" height="14" viewBox="0 0 14 14" fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
          d="M13.383 0.103086C13.1824 0.00838675 12.9575 -0.0220693 12.739 0.0158796C12.5204 0.0538285 12.3189 0.158331 12.162 0.315107C12.1526 0.32453 12.1445 0.33328 12.1365 0.342703L10.9747 1.68214C9.7836 0.936876 8.40688 0.541669 7.00183 0.541669C5.59678 0.541669 4.22007 0.936876 3.02896 1.68214L1.86385 0.342703C1.85577 0.33328 1.8477 0.32453 1.83827 0.315107C1.68136 0.158331 1.47988 0.0538285 1.26134 0.0158796C1.0428 -0.0220693 0.817875 0.00838675 0.617299 0.103086C0.430035 0.195043 0.272663 0.338186 0.163424 0.515924C0.0541839 0.693661 -0.0024515 0.898717 8.13858e-05 1.10733V6.9995C8.13858e-05 10.2976 2.69645 13.0323 6.16283 13.4153C6.2006 13.4195 6.23882 13.4157 6.27498 13.404C6.31115 13.3924 6.34444 13.3732 6.37266 13.3478C6.40089 13.3223 6.42342 13.2912 6.43876 13.2565C6.4541 13.2217 6.46191 13.1841 6.46168 13.1461V10.9922L5.55841 10.0883C5.456 9.9889 5.39595 9.85379 5.39081 9.71118C5.38567 9.56857 5.43583 9.42949 5.53081 9.32299C5.58019 9.27039 5.63964 9.22825 5.70563 9.19908C5.77162 9.1699 5.84279 9.15429 5.91493 9.15316C5.98707 9.15203 6.0587 9.16541 6.12557 9.1925C6.19243 9.21959 6.25317 9.25984 6.30418 9.31087L7.00015 10.0068L7.69612 9.3102C7.74713 9.25917 7.80787 9.21892 7.87473 9.19183C7.9416 9.16473 8.01323 9.15135 8.08537 9.15248C8.15751 9.15361 8.22869 9.16923 8.29467 9.1984C8.36066 9.22758 8.42011 9.26971 8.46949 9.32231C8.56447 9.42881 8.61463 9.56789 8.60949 9.71051C8.60435 9.85312 8.5443 9.98822 8.4419 10.0876L7.53862 10.9916V13.1454C7.53839 13.1834 7.5462 13.221 7.56154 13.2558C7.57689 13.2905 7.59941 13.3217 7.62764 13.3471C7.65587 13.3725 7.68916 13.3917 7.72532 13.4033C7.76148 13.415 7.7997 13.4188 7.83747 13.4147C11.3038 13.0317 14.0002 10.2976 14.0002 6.9995V1.10733C14.0028 0.898717 13.9461 0.693661 13.8369 0.515924C13.7276 0.338186 13.5703 0.195043 13.383 0.103086ZM4.03858 8.07643C3.87883 8.07643 3.72267 8.02906 3.58985 7.94031C3.45702 7.85156 3.3535 7.72541 3.29237 7.57783C3.23123 7.43024 3.21524 7.26784 3.2464 7.11116C3.27757 6.95448 3.35449 6.81056 3.46745 6.6976C3.58041 6.58464 3.72433 6.50772 3.88101 6.47655C4.03769 6.44539 4.20009 6.46138 4.34768 6.52252C4.49526 6.58365 4.62141 6.68717 4.71016 6.82C4.79891 6.95283 4.84628 7.10899 4.84628 7.26873C4.84628 7.48295 4.76119 7.68839 4.60971 7.83986C4.45824 7.99134 4.2528 8.07643 4.03858 8.07643ZM5.38475 3.7687C5.38475 3.91151 5.32802 4.04847 5.22704 4.14945C5.12605 4.25043 4.98909 4.30717 4.84628 4.30717C4.70347 4.30717 4.56651 4.25043 4.46553 4.14945C4.36455 4.04847 4.30782 3.91151 4.30782 3.7687V2.48984C4.30782 2.34703 4.36455 2.21007 4.46553 2.10909C4.56651 2.0081 4.70347 1.95137 4.84628 1.95137C4.98909 1.95137 5.12605 2.0081 5.22704 2.10909C5.32802 2.21007 5.38475 2.34703 5.38475 2.48984V3.7687ZM7.53862 3.7687C7.53862 3.91151 7.48189 4.04847 7.3809 4.14945C7.27992 4.25043 7.14296 4.30717 7.00015 4.30717C6.85734 4.30717 6.72038 4.25043 6.6194 4.14945C6.51841 4.04847 6.46168 3.91151 6.46168 3.7687V2.1533C6.46168 2.01049 6.51841 1.87353 6.6194 1.77254C6.72038 1.67156 6.85734 1.61483 7.00015 1.61483C7.14296 1.61483 7.27992 1.67156 7.3809 1.77254C7.48189 1.87353 7.53862 2.01049 7.53862 2.1533V3.7687ZM8.61555 3.7687V2.48984C8.61555 2.34703 8.67228 2.21007 8.77326 2.10909C8.87425 2.0081 9.01121 1.95137 9.15402 1.95137C9.29683 1.95137 9.43379 2.0081 9.53477 2.10909C9.63575 2.21007 9.69248 2.34703 9.69248 2.48984V3.7687C9.69248 3.91151 9.63575 4.04847 9.53477 4.14945C9.43379 4.25043 9.29683 4.30717 9.15402 4.30717C9.01121 4.30717 8.87425 4.25043 8.77326 4.14945C8.67228 4.04847 8.61555 3.91151 8.61555 3.7687ZM9.96172 8.07643C9.80197 8.07643 9.64581 8.02906 9.51298 7.94031C9.38016 7.85156 9.27663 7.72541 9.2155 7.57783C9.15437 7.43024 9.13837 7.26784 9.16954 7.11116C9.2007 6.95448 9.27763 6.81056 9.39059 6.6976C9.50355 6.58464 9.64747 6.50772 9.80414 6.47655C9.96082 6.44539 10.1232 6.46138 10.2708 6.52252C10.4184 6.58365 10.5445 6.68717 10.6333 6.82C10.722 6.95283 10.7694 7.10899 10.7694 7.26873C10.7694 7.48295 10.6843 7.68839 10.5328 7.83986C10.3814 7.99134 10.1759 8.07643 9.96172 8.07643Z"
          fill="#A280ED" /></svg>`,
      dog_svg: `<svg width="17" height="16" viewBox="0 0 17 16" fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
          d="M16.9766 7.66849L15.7306 0.990886C15.7002 0.828117 15.6368 0.673296 15.5443 0.535944C15.4518 0.398592 15.3322 0.281613 15.1928 0.192201C15.0534 0.102789 14.8972 0.0428328 14.7338 0.0160208C14.5704 -0.0107913 14.4032 -0.00389287 14.2426 0.0362918L14.2191 0.0431212L10.2338 1.21853H6.76596L2.78064 0.0469152L2.75712 0.0400858C2.59648 -9.88347e-05 2.42931 -0.00699725 2.2659 0.0198148C2.1025 0.0466268 1.9463 0.106583 1.80692 0.195995C1.66754 0.285407 1.54793 0.402386 1.45544 0.539738C1.36294 0.67709 1.29952 0.831911 1.26907 0.99468L0.0230932 7.66849C-0.0301887 7.93577 0.00936178 8.21323 0.135203 8.45498C0.261044 8.69673 0.465635 8.88828 0.715136 8.99794C0.874921 9.07122 1.04852 9.10951 1.2243 9.11025C1.4347 9.11015 1.64121 9.05354 1.82225 8.94634V12.1455C1.82225 12.9505 2.14204 13.7226 2.71126 14.2918C3.28049 14.861 4.05252 15.1808 4.85753 15.1808H12.1422C12.9472 15.1808 13.7192 14.861 14.2885 14.2918C14.8577 13.7226 15.1775 12.9505 15.1775 12.1455V8.9471C15.3583 9.0541 15.5645 9.1107 15.7747 9.11101C15.9506 9.1105 16.1245 9.07247 16.2846 8.99946C16.5344 8.88974 16.7392 8.69795 16.8651 8.45588C16.9909 8.21381 17.0303 7.936 16.9766 7.66849ZM12.1422 13.9667H9.10692V13.0038L10.1435 11.968C10.2574 11.8541 10.3214 11.6996 10.3214 11.5385C10.3214 11.3774 10.2574 11.2229 10.1435 11.109C10.0296 10.9951 9.87506 10.9311 9.71397 10.9311C9.55288 10.9311 9.39839 10.9951 9.28448 11.109L8.49986 11.8944L7.71524 11.109C7.60133 10.9951 7.44684 10.9311 7.28575 10.9311C7.12466 10.9311 6.97017 10.9951 6.85626 11.109C6.74235 11.2229 6.67836 11.3774 6.67836 11.5385C6.67836 11.6996 6.74235 11.8541 6.85626 11.968L7.89281 13.0038V13.9667H4.85753C4.37453 13.9667 3.91131 13.7748 3.56977 13.4333C3.22824 13.0918 3.03636 12.6285 3.03636 12.1455V7.52508L6.97691 2.43264H10.0228L13.9634 7.52508V12.1455C13.9634 12.6285 13.7715 13.0918 13.43 13.4333C13.0884 13.7748 12.6252 13.9667 12.1422 13.9667ZM6.67869 8.80672C6.67869 8.98682 6.62529 9.16287 6.52523 9.31261C6.42518 9.46236 6.28296 9.57907 6.11658 9.64799C5.95019 9.71691 5.7671 9.73494 5.59047 9.69981C5.41383 9.66467 5.25158 9.57795 5.12423 9.4506C4.99689 9.32325 4.91016 9.161 4.87503 8.98437C4.83989 8.80773 4.85792 8.62465 4.92684 8.45826C4.99576 8.29187 5.11247 8.14966 5.26222 8.0496C5.41196 7.94954 5.58802 7.89614 5.76811 7.89614C6.00961 7.89614 6.24122 7.99208 6.41199 8.16284C6.58276 8.33361 6.67869 8.56522 6.67869 8.80672ZM12.1422 8.80672C12.1422 8.98682 12.0888 9.16287 11.9887 9.31261C11.8887 9.46236 11.7465 9.57907 11.5801 9.64799C11.4137 9.71691 11.2306 9.73494 11.054 9.69981C10.8773 9.66467 10.7151 9.57795 10.5877 9.4506C10.4604 9.32325 10.3737 9.161 10.3385 8.98437C10.3034 8.80773 10.3214 8.62465 10.3903 8.45826C10.4593 8.29187 10.576 8.14966 10.7257 8.0496C10.8755 7.94954 11.0515 7.89614 11.2316 7.89614C11.4731 7.89614 11.7047 7.99208 11.8755 8.16284C12.0463 8.33361 12.1422 8.56522 12.1422 8.80672Z"
          fill="#DDAC62" /></svg>`,
    },
    emote: {
      enabled: false,
      info: {
        emotes: "EMOTES",
        actions: "ACTIONS",
        health: "HEALTH",
        hunger: "HUNGER",
      },
      petname: "PET NAME HERE",
      illness: false,
      illnessText: "healthy",
      status: {
        energy: 0,
        health: 0.6,
        hunger: 0.3,
      },
      emotes: [],
      actions: [],
      activeChange: false,
    },
    hud: {
      enabled: false,
      status: {
        energy: 1,
        health: 0.8,
        hunger: 0.4,
      },
    },
    pets: {
      enabled: false,
      info: {
        pets: "PETS",
        select: "CALL",
        selected: "GO SLEEP",
        delete: "RELEASE",
      },
      spawnPed: false,
      spawnPedCode: "",
      pets: [],
    },
    petshop: {
      enabled: false,
      info: {
        shop_p: "Buy some things for your animals",
        add_card: "Add",
        paytocard: "PAY TO CARD",
        paytocash: "PAY TO CASH",
        added: "ADDED",
        deleteCard: "DELETE",
        rotate: "PRESS A-D TO ROTATE",
      },
      active_shop: 1,
      police: false,
      pets: [],
      policePets: [],
      products: [],
      card: [],
    },
    quest: {
      enabled: false,
      deleteItem: {},
      info: {
        title: "Are you sure ?",
        yes: "YES",
        no: "NO",
      },
    },
  },
  mounted() {
    //Shop
    this.shop.products = this.shop.food;
    this.shop.card = [];

    //Petshop
    this.petshop.products = this.petshop.pets;
    this.petshop.card = [];

    //Wardrobe
    $(".cloth-card").draggable({
      revert: "invalid",
      helper: "clone", // Kopya oluşturun
      cursor: "pointer",
      scroll: false, // Kaydırma olmasın
      containment: "window",
      start: function (event, ui) {
        $(this).addClass("clothes-dragging"); // Sürüklenirken stil ekleyin
      },
      stop: function (event, ui) {
        $(this).removeClass("clothes-dragging"); // Sürükleme bittiğinde stil kaldırın
      },
    });

    $(".clothing-main").sortable({
      connectWith: ".clothing-main",
    });

    $(".cloth-slot").droppable({
      accept: ".cloth-card",
      drop: function (event, ui) {
        var dropped = ui.draggable.attr("id");

        var item = app.wardrobe.wardrobe.find(
          (item) => item.item_kod === dropped
        );

        if (app.wardrobe.slots[0].item.length < 1) {
          app.wardrobe.slots[0].item.push(item);
          var index = app.wardrobe.wardrobe.indexOf(item);
          app.wardrobe.wardrobe.splice(index, 1);
          return;
        } else if (app.wardrobe.slots[1].item.length < 1) {
          app.wardrobe.slots[1].item.push(item);
          var index = app.wardrobe.wardrobe.indexOf(item);
          app.wardrobe.wardrobe.splice(index, 1);
          return;
        }
      },
    });

    $(".clothing-main").droppable({
      accept: ".slot-active-item",
      drop: function (event, ui) {
        var dropped = ui.draggable.attr("id");
        // wardrobe.slots find dropped item
        var slot1 =
          app.wardrobe.slots[0].item.length < 1
            ? false
            : app.wardrobe.slots[0].item[0].item_kod == dropped;
        var slot2 =
          app.wardrobe.slots[1].item.length < 1
            ? false
            : app.wardrobe.slots[1].item[0].item_kod == dropped;
        if (slot1) {
          app.wardrobe.wardrobe.push(app.wardrobe.slots[0].item[0]);
          clothes.clothes.splice(0, 1);
          $.post(
            "https://dusa_pet/wearItem",
            JSON.stringify({
              item: app.wardrobe.slots[0].item[0].item_kod,
              action: "takeoff",
              currentData: clothes,
            })
          );
          app.wardrobe.slots[0].item = [];
          app.saveItem();
        } else if (slot2) {
          app.wardrobe.wardrobe.push(app.wardrobe.slots[1].item[0]);
          clothes.clothes.splice(1, 1);
          $.post(
            "https://dusa_pet/wearItem",
            JSON.stringify({
              item: app.wardrobe.slots[1].item[0].item_kod,
              action: "takeoff",
              currentData: clothes,
            })
          );
          app.wardrobe.slots[1].item = [];
          app.saveItem();
        }
      },
    });

    this.$watch("$data.wardrobe.slots", this.onSelectedUpdate, { deep: true });
    window.addEventListener("keydown", this.handleKeyDown);

    //Emote #C88749
    var energybar = new ProgressBar.Circle("#energy", {
      color: "#F27601",
      strokeWidth: 10,
      trailColor: "#D9D9D9",
      trailWidth: 10,
      duration: 2000, // milliseconds
      easing: "easeInOut",
    });
    var healthbar = new ProgressBar.Circle("#health", {
      color: "#9FC849",
      strokeWidth: 10,
      trailColor: "#D9D9D9",
      trailWidth: 10,
      duration: 2000, // milliseconds
      easing: "easeInOut",
    });
    var hungerbar = new ProgressBar.Circle("#hunger", {
      color: "#C84949",
      strokeWidth: 10,
      trailColor: "#D9D9D9",
      trailWidth: 10,
      duration: 2000, // milliseconds
      easing: "easeInOut",
    });

    // Eğer emote menü açıldığında animasyonlu gelmelerini istersen bunları menüyü açtığın fonksiyona yaz
    if (this.emote.illness) {
      this.emote.status.energy = 1;
      this.hud.status.energy = 1;
    }
    energybar.animate(this.emote.status.energy);
    healthbar.animate(this.emote.status.health);
    hungerbar.animate(this.emote.status.hunger);

    this.$watch(
      "$data.emote.status",
      function () {
        energybar.set(this.emote.status.energy);
        healthbar.set(this.emote.status.health);
        hungerbar.set(this.emote.status.hunger);
      },
      { deep: true }
    );

    //Hud #C88749
    let energybarH = new ProgressBar.Circle("#energyH", {
      color: "#F27601",
      strokeWidth: 10,
      trailColor: "#D9D9D9",
      trailWidth: 10,
      duration: 2000, // milliseconds
      easing: "easeInOut",
    });
    let healthbarH = new ProgressBar.Circle("#healthH", {
      color: "#9FC849",
      strokeWidth: 10,
      trailColor: "#D9D9D9",
      trailWidth: 10,
      duration: 2000, // milliseconds
      easing: "easeInOut",
    });
    let hungerbarH = new ProgressBar.Circle("#hungerH", {
      color: "#C84949",
      strokeWidth: 10,
      trailColor: "#D9D9D9",
      trailWidth: 10,
      duration: 2000, // milliseconds
      easing: "easeInOut",
    });
    energybarH.animate(this.hud.status.energy);
    healthbarH.animate(this.hud.status.health);
    hungerbarH.animate(this.hud.status.hunger);
    this.$watch(
      "$data.hud.status",
      function () {
        energybarH.set(this.hud.status.energy);
        healthbarH.set(this.hud.status.health);
        hungerbarH.set(this.hud.status.hunger);
      },
      { deep: true }
    );

    $(".hudC").draggable({
      helper: "original", // Kopya oluşturun
      cursor: "pointer",
      scroll: false, // Kaydırma olmasın
    });
  },
  beforeDestroy() {
    window.removeEventListener("keydown", this.handleKeyDown);
  },
  computed: {
    totalPrice() {
      return this.shop.card.reduce(
        (toplam, urun) => toplam + urun.totalPrice,
        0
      );
    },
    totalPricePet() {
      return this.petshop.card.reduce((toplam, urun) => toplam + urun.price, 0);
    },
    emotesLenght() {
      return this.emote.emotes.length;
    },
    actionsLenght() {
      return this.emote.actions.length;
    },
  },
  methods: {
    // Shop
    shopData(data, type) {
      const dataType = type;
      const array = this.shop[dataType];
      for (let i = 0; i < data.length; i++) {
        const newData = {
          img: data[i].image || "placeholder.png",
          name: data[i].name || "Default Name",
          detail: data[i].detail || "Default Detail",
          price: data[i].price || 0,
          item: data[i].item,
          count: data[i].count || 1,
        };
        if (array.length < data.length) {
          array.push(newData);
        } else {
          return;
        }
      }
    },
    wardrobeData(inventory, activeClothes) {
      this.wardrobe.wardrobe = [];
      if (!firstOpen && activeClothes.clothes !== undefined) {
        firstOpen = true;
        var clothing = JSON.parse(activeClothes.clothes);
      } else {
        var clothing = activeClothes.clothes;
      }
      this.wardrobe.slots = [{ item: [] }, { item: [] }];
      inventory.forEach((element) => {
        if (
          activeClothes.clothes !== undefined &&
          clothing[0] !== undefined &&
          clothing.length > 0 &&
          element.Item === clothing[0].item_kod
        ) {
          this.wardrobeCheckAndPush(element, this.wardrobe.slots[0].item);
        } else if (
          activeClothes.clothes !== undefined &&
          clothing[1] !== undefined &&
          clothing.length > 0 &&
          element.Item === clothing[1].item_kod
        ) {
          this.wardrobeCheckAndPush(element, this.wardrobe.slots[1].item);
        } else {
          this.wardrobeCheckAndPush(element, this.wardrobe.wardrobe);
        }
      });
    },
    wardrobeCheckAndPush(data, type) {
      let image = "assets/img/wardrobe/" + data.Item + ".png";
      if (!imageExists(image)) {
        image = "collarbone.png";
      } else {
        image = data.Item + ".png";
      }
      type.push({
        name: data.Name || "Default Name",
        item_kod: data.Item || 0,
        img: image,
        pet: data.Type || "dog",
      });
    },

    emoteData(data, type, name, status) {
      const dataType = type;
      const array = this.emote[dataType];
      const health = (status.health / 100).toFixed(2);
      const hunger = (status.hunger / 100).toFixed(2);
      this.emote.petname = name;
      if (status.health > 0) {
        this.emote.status.health = health;
        this.emote.info.health = "HEALTH";
      } else {
        this.emote.status.health = 0.0;
        this.emote.info.health = "DEAD";
      }
      this.emote.status.hunger = hunger;
      if (status.illness !== "healthy" || !status.illness) {
        this.updateillness(true, status.illness);
      } else {
        this.updateillness(false, status.illness);
      }

      for (let i = 0; i < data.length; i++) {
        if (type === "emotes") {
          const newData = {
            name: data[i].name || "Emote Name",
            description:
              data[i].description || "Lorem ipsum dolor sit amet, consectetur",
            emote_code: data[i].emote_code || 0,
            selected: false,
          };
          if (array.length < data.length) {
            array.push(newData);
          } else {
            return;
          }
        } else if (type === "actions") {
          const newData = {
            name: data[i].name || "Emote Name",
            description:
              data[i].description || "Lorem ipsum dolor sit amet, consectetur",
            action_code: data[i].action_code || 0,
            icon: data[i].icon || "ball.svg",
            selected: false,
          };
          if (array.length < data.length) {
            array.push(newData);
          } else {
            return;
          }
        }
      }
    },
    petShopData(data) {
      const array = this.petshop["pets"];
      for (let i = 0; i < data.length; i++) {
        const newData = {
          img: data[i].image || "dog.png",
          name: data[i].name || "Default Name",
          pet_code: data[i].pet,
          selected: false,
          price: data[i].price || 0,
        };
        if (array.length < data.length) {
          array.push(newData);
        } else {
          return;
        }
      }
    },
    k9ShopData(data) {
      const k9a = this.petshop["policePets"];
      this.petshop.police = true;
      for (let i = 0; i < data.length; i++) {
        const k9data = {
          img: data[i].image || "dog.png",
          name: data[i].name || "Default Name",
          pet_code: data[i].pet,
          selected: false,
          price: data[i].price || 0,
        };

        if (k9a.length < data.length) {
          k9a.push(k9data);
        } else {
          return;
        }
      }
    },
    petinvData(data) {
      this.pets.pets = [];
      var array = this.pets["pets"];
      if (data) {
        for (let i = 0; i < data.length; i++) {
          let image = "assets/img/pets/" + data[i].modelname + ".png";
          if (!imageExists(image)) {
            image = "dog.png";
          } else {
            image = data[i].modelname + ".png";
          }

          const newData = {
            name: data[i].name || "Default Name",
            img: image || "dog.png",
            pet_code: data[i].modelname,
            selected:
              data[i].modelname == this.pets.spawnPedCode ? true : false,
          };
          if (array.length < data.length) {
            array.push(newData);
          } else {
            return;
          }
        }
      }
    },
    hudData(status) {
      const health = (status.health / 100).toFixed(2);
      const hunger = (status.hunger / 100).toFixed(2);
      this.hud.status.health = health;
      this.hud.status.hunger = hunger;
    },
    shopMenu: function (id, menu) {
      this.changeProducts(menu);
      this.shop.active_shop = id;
    },
    changeProducts: function (menu) {
      this.shop.products = menu;
    },
    addCard: function (index) {
      let item = this.shop.products[index];
      let sepettekiUrun = this.shop.card.find(
        (urun) => urun.name === item.name
      );
      if (sepettekiUrun) {
        sepettekiUrun.count += 1;
        sepettekiUrun.totalPrice += item.price;
      } else {
        this.shop.card.push({
          name: item.name,
          img: item.img,
          price: item.price,
          detail: item.detail,
          item: item.item,
          totalPrice: item.price,
          count: 1,
        });
      }
    },
    minusCard: function (item) {
      if (item.count <= 1) {
        const urunIndeksi = this.shop.card.findIndex((urun) => urun === item);
        this.shop.card.splice(urunIndeksi, 1);
      } else {
        item.count--;
        item.totalPrice -= item.price;
      }
    },
    plusCard: function (item) {
      item.count++;
      item.totalPrice += item.price;
    },

    // Wardrobe
    updateDrag: function () {
      $(".slot-active-item").draggable({
        revert: "invalid",
        helper: "clone", // Kopya oluşturun
        cursor: "pointer",
        scroll: false, // Kaydırma olmasın
        containment: "window",
        start: function (event, ui) {
          $(this).addClass("clothes-dragging"); // Sürüklenirken stil ekleyin
        },
        stop: function (event, ui) {
          $(this).removeClass("clothes-dragging"); // Sürükleme bittiğinde stil kaldırın
        },
      });

      $(".cloth-card").draggable({
        revert: "invalid",
        helper: "clone", // Kopya oluşturun
        cursor: "pointer",
        scroll: false, // Kaydırma olmasın
        containment: "window",
        start: function (event, ui) {
          $(this).addClass("clothes-dragging"); // Sürüklenirken stil ekleyin
        },
        stop: function (event, ui) {
          $(this).removeClass("clothes-dragging"); // Sürükleme bittiğinde stil kaldırın
        },
      });
    },
    onSelectedUpdate: function (newSelected) {
      table = [];
      clothes = {
        clothes: [],
      };
      newSelected.forEach((element) => {
        if (element.item[0] === undefined) {
          return;
        } else {
          table.push(element.item[0]);
          clothes.clothes.push(element.item[0]);
          $.post(
            "https://dusa_pet/wearItem",
            JSON.stringify({
              item: element.item[0].item_kod,
              petType: element.item[0].pet,
              action: "wear",
              currentData: clothes,
            })
          );

          this.saveItem();
        }
      });

      this.updateDrag();
    },

    // Emote
    changeMenu(menu) {
      if (this.emote.activeChange) {
        return;
      } else if (menu === "emotes") {
        this.emote.activeChange = true;
        //Remove class
        $(".button-action").removeClass("active");
        $(".action-icon").removeClass("active");
        $(".action-main").hide("slow", function () {
          $(".emotes-main").show("slow");
        });
        //Add class
        $(".button-emotes").addClass("active");
        $(".emotes-icon").addClass("active");
        setTimeout(() => {
          this.emote.activeChange = false;
        }, 1800);
      } else if (menu === "action") {
        this.emote.activeChange = true;
        //Remove class
        $(".button-emotes").removeClass("active");
        $(".emotes-icon").removeClass("active");
        //Hidden .emotes-list
        $(".emotes-main").hide("slow", function () {
          $(".action-main").show("slow");
        });
        //Add class
        $(".button-action").addClass("active");
        $(".action-icon").addClass("active");
        setTimeout(() => {
          this.emote.activeChange = false;
        }, 1800);
      } else {
        return;
      }
    },
    emoteSelect(item) {
      this.emote.emotes.forEach((element) => {
        element.selected = false;
      });
      item.selected = true;
    },
    emotesPlay(item) {
      $.post(
        "https://dusa_pet/playAction",
        JSON.stringify({ action: item.emote_code })
      );
    },
    actionSelect(item) {
      this.emote.actions.forEach((element) => {
        element.selected = false;
      });
      item.selected = true;
    },
    actionPlay(item) {
      $.post(
        "https://dusa_pet/playAction",
        JSON.stringify({ action: item.action_code })
      );
    },
    updateillness(bool, text) {
      this.emote.illness = bool;
      this.emote.illnessText = text;
      if (this.emote.illness) {
        this.emote.status.energy = 1;
        this.hud.status.energy = 1;
      } else {
        this.emote.status.energy = 0;
        this.hud.status.energy = 0;
      }
    },

    //Notify
    notify: function (type, text) {
      let notify = document.getElementById("notify");
      let delayA = this.notifyDelay / 1000 - 1;
      if (type === "error") {
        // div append innerhtml
        var number = Math.floor(Math.random() * 1000 + 1);
        notify.insertAdjacentHTML(
          "beforeend",
          `
         <div class="notfiyC error" id="${number}">
         <div class="cont">
             <div class="icon">
             <svg width="25" height="25" viewBox="0 0 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
             <path d="M12.44 0C9.9796 0 7.57446 0.729593 5.52871 2.09652C3.48296 3.46344 1.8885 5.4063 0.946944 7.67942C0.00539006 9.95253 -0.240963 12.4538 0.239037 14.8669C0.719037 17.28 1.90383 19.4966 3.6436 21.2364C5.38336 22.9762 7.59996 24.161 10.0131 24.641C12.4262 25.121 14.9275 24.8746 17.2006 23.9331C19.4737 22.9915 21.4166 21.397 22.7835 19.3513C24.1504 17.3055 24.88 14.9004 24.88 12.44C24.8765 9.14177 23.5648 5.97963 21.2326 3.64744C18.9004 1.31524 15.7382 0.00348298 12.44 0ZM16.9447 15.5907C17.0336 15.6796 17.1041 15.7851 17.1523 15.9013C17.2004 16.0175 17.2251 16.142 17.2251 16.2677C17.2251 16.3934 17.2004 16.5179 17.1523 16.6341C17.1041 16.7503 17.0336 16.8558 16.9447 16.9447C16.8558 17.0336 16.7503 17.1041 16.6341 17.1523C16.5179 17.2004 16.3934 17.2251 16.2677 17.2251C16.142 17.2251 16.0175 17.2004 15.9013 17.1523C15.7851 17.1041 15.6796 17.0336 15.5907 16.9447L12.44 13.7928L9.28933 16.9447C9.20043 17.0336 9.09488 17.1041 8.97871 17.1523C8.86255 17.2004 8.73805 17.2251 8.61231 17.2251C8.48658 17.2251 8.36207 17.2004 8.24591 17.1523C8.12974 17.1041 8.0242 17.0336 7.93529 16.9447C7.84638 16.8558 7.77585 16.7503 7.72774 16.6341C7.67962 16.5179 7.65486 16.3934 7.65486 16.2677C7.65486 16.142 7.67962 16.0175 7.72774 15.9013C7.77585 15.7851 7.84638 15.6796 7.93529 15.5907L11.0872 12.44L7.93529 9.28933C7.75573 9.10977 7.65486 8.86624 7.65486 8.61231C7.65486 8.35837 7.75573 8.11484 7.93529 7.93528C8.11485 7.75572 8.35838 7.65485 8.61231 7.65485C8.86624 7.65485 9.10978 7.75572 9.28933 7.93528L12.44 11.0871L15.5907 7.93528C15.6796 7.84637 15.7851 7.77585 15.9013 7.72773C16.0175 7.67962 16.142 7.65485 16.2677 7.65485C16.3934 7.65485 16.5179 7.67962 16.6341 7.72773C16.7503 7.77585 16.8558 7.84637 16.9447 7.93528C17.0336 8.02419 17.1041 8.12974 17.1523 8.2459C17.2004 8.36207 17.2251 8.48657 17.2251 8.61231C17.2251 8.73804 17.2004 8.86254 17.1523 8.97871C17.1041 9.09487 17.0336 9.20042 16.9447 9.28933L13.7929 12.44L16.9447 15.5907Z" fill="#DD6262"/>
             </svg>
             
             </div>
             <div class="text">
                 <h1>${this.notifyText.error}</h1>
                 <p>${text}</p>
             </div>
         </div>
         <svg width="262" height="69" viewBox="0 0 262 69" fill="none" xmlns="http://www.w3.org/2000/svg">
         <g clip-path="url(#clip0_51_1420)">
         <rect width="262" height="68.3478" rx="7.23118" fill="url(#paint0_linear_51_1420)"/>
         <g filter="url(#filter0_f_51_1420)">
         <circle cx="9.5" cy="-55.686" r="93.5" fill="white" fill-opacity="0.25"/>
         </g>
         <g filter="url(#filter1_f_51_1420)">
         <circle cx="111" cy="695.814" r="282" fill="#876544" fill-opacity="0.22"/>
         </g>
         <path d="M25 -16C25 -17.1046 25.8954 -18 27 -18H43C44.1046 -18 45 -17.1046 45 -16V0.763931C45 1.52147 44.572 2.214 43.8944 2.55279L35.8944 6.55279C35.3314 6.83431 34.6686 6.83431 34.1056 6.55279L26.1056 2.55279C25.428 2.214 25 1.52148 25 0.763931V-16Z" fill="#DD6262"/>
         <path d="M45 84C45 85.1046 44.1046 86 43 86L27 86C25.8954 86 25 85.1046 25 84L25 67.2361C25 66.4785 25.428 65.786 26.1056 65.4472L34.1056 61.4472C34.6686 61.1657 35.3314 61.1657 35.8944 61.4472L43.8944 65.4472C44.572 65.786 45 66.4785 45 67.2361L45 84Z" fill="#DD6262"/>
         </g>
         <rect x="0.5" y="0.5" width="261" height="67.3478" rx="6.73118" stroke="#DD6262"/>
         <defs>
         <filter id="filter0_f_51_1420" x="-323" y="-388.186" width="665" height="665" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
         <feFlood flood-opacity="0" result="BackgroundImageFix"/>
         <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
         <feGaussianBlur stdDeviation="119.5" result="effect1_foregroundBlur_51_1420"/>
         </filter>
         <filter id="filter1_f_51_1420" x="-571.994" y="12.8197" width="1365.99" height="1365.99" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
         <feFlood flood-opacity="0" result="BackgroundImageFix"/>
         <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
         <feGaussianBlur stdDeviation="200.497" result="effect1_foregroundBlur_51_1420"/>
         </filter>
         <linearGradient id="paint0_linear_51_1420" x1="4.28828" y1="7.12885" x2="78.5337" y2="158.981" gradientUnits="userSpaceOnUse">
         <stop stop-color="#000103"/>
         <stop offset="1" stop-color="#010104"/>
         </linearGradient>
         <clipPath id="clip0_51_1420">
         <rect width="262" height="68.3478" rx="7.23118" fill="white"/>
         </clipPath>
         </defs>
         </svg>
         
     </div>
          `
        );
        // Delete İtem And Anim
        let item = document.getElementById(number);
        gsap.to(item, { left: 0, duration: 0.5, ease: "power2.out" });
        gsap.to(item, {
          left: "-20vw",
          duration: 0.5,
          ease: "power2.out",
          delay: delayA,
        });
        setTimeout(() => {
          item.remove();
        }, this.notifyDelay);
      } else if (type === "success") {
        // div append innerhtml
        var number = Math.floor(Math.random() * 1000 + 1);
        notify.insertAdjacentHTML(
          "beforeend",
          `<div class="notfiyC success" id="${number}">
          <div class="cont">
              <div class="icon">
              <svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M13 0C10.4288 0 7.91543 0.762437 5.77759 2.1909C3.63975 3.61935 1.97351 5.64968 0.989572 8.02512C0.0056327 10.4006 -0.251811 13.0144 0.249797 15.5362C0.751405 18.0579 1.98953 20.3743 3.80762 22.1924C5.6257 24.0105 7.94208 25.2486 10.4638 25.7502C12.9856 26.2518 15.5995 25.9944 17.9749 25.0104C20.3503 24.0265 22.3807 22.3603 23.8091 20.2224C25.2376 18.0846 26 15.5712 26 13C25.9964 9.5533 24.6256 6.24882 22.1884 3.81163C19.7512 1.37445 16.4467 0.00363977 13 0ZM18.7075 10.7075L11.7075 17.7075C11.6146 17.8005 11.5043 17.8742 11.3829 17.9246C11.2615 17.9749 11.1314 18.0008 11 18.0008C10.8686 18.0008 10.7385 17.9749 10.6171 17.9246C10.4957 17.8742 10.3854 17.8005 10.2925 17.7075L7.29251 14.7075C7.10486 14.5199 6.99945 14.2654 6.99945 14C6.99945 13.7346 7.10486 13.4801 7.29251 13.2925C7.48015 13.1049 7.73464 12.9994 8.00001 12.9994C8.26537 12.9994 8.51987 13.1049 8.70751 13.2925L11 15.5863L17.2925 9.2925C17.3854 9.19959 17.4957 9.12589 17.6171 9.07561C17.7385 9.02532 17.8686 8.99944 18 8.99944C18.1314 8.99944 18.2615 9.02532 18.3829 9.07561C18.5043 9.12589 18.6146 9.19959 18.7075 9.2925C18.8004 9.38541 18.8741 9.49571 18.9244 9.6171C18.9747 9.7385 19.0006 9.8686 19.0006 10C19.0006 10.1314 18.9747 10.2615 18.9244 10.3829C18.8741 10.5043 18.8004 10.6146 18.7075 10.7075Z" fill="#62DD9B"/>
              </svg>
              
              </div>
              <div class="text">
                  <h1>${this.notifyText.success}</h1>
                  <p>${text}</p>
              </div>
          </div>
          <svg width="262" height="69" viewBox="0 0 262 69" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g clip-path="url(#clip0_51_1378)">
          <rect width="262" height="68.3478" rx="7.23118" fill="url(#paint0_linear_51_1378)"/>
          <g filter="url(#filter0_f_51_1378)">
          <circle cx="9.5" cy="-55.686" r="93.5" fill="white" fill-opacity="0.25"/>
          </g>
          <g filter="url(#filter1_f_51_1378)">
          <circle cx="111" cy="695.814" r="282" fill="#876544" fill-opacity="0.22"/>
          </g>
          <path d="M25 -16C25 -17.1046 25.8954 -18 27 -18H43C44.1046 -18 45 -17.1046 45 -16V0.763931C45 1.52147 44.572 2.214 43.8944 2.55279L35.8944 6.55279C35.3314 6.83431 34.6686 6.83431 34.1056 6.55279L26.1056 2.55279C25.428 2.214 25 1.52148 25 0.763931V-16Z" fill="#62DD9B"/>
          <path d="M45 84C45 85.1046 44.1046 86 43 86L27 86C25.8954 86 25 85.1046 25 84L25 67.2361C25 66.4785 25.428 65.786 26.1056 65.4472L34.1056 61.4472C34.6686 61.1657 35.3314 61.1657 35.8944 61.4472L43.8944 65.4472C44.572 65.786 45 66.4785 45 67.2361L45 84Z" fill="#62DD9B"/>
          </g>
          <rect x="0.5" y="0.5" width="261" height="67.3478" rx="6.73118" stroke="#62DD9B"/>
          <defs>
          <filter id="filter0_f_51_1378" x="-323" y="-388.186" width="665" height="665" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="119.5" result="effect1_foregroundBlur_51_1378"/>
          </filter>
          <filter id="filter1_f_51_1378" x="-571.994" y="12.8197" width="1365.99" height="1365.99" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="200.497" result="effect1_foregroundBlur_51_1378"/>
          </filter>
          <linearGradient id="paint0_linear_51_1378" x1="4.28828" y1="7.12885" x2="78.5337" y2="158.981" gradientUnits="userSpaceOnUse">
          <stop stop-color="#000103"/>
          <stop offset="1" stop-color="#010104"/>
          </linearGradient>
          <clipPath id="clip0_51_1378">
          <rect width="262" height="68.3478" rx="7.23118" fill="white"/>
          </clipPath>
          </defs>
          </svg>
          
      </div>
      `
        );

        // Delete İtem And Anim
        let item = document.getElementById(number);
        gsap.to(item, { left: 0, duration: 0.5, ease: "power2.out" });
        gsap.to(item, {
          left: "-20vw",
          duration: 0.5,
          ease: "power2.out",
          delay: delayA,
        });
        setTimeout(() => {
          item.remove();
        }, this.notifyDelay);
      } else if (type === "info") {
        // div append innerhtml
        var number = Math.floor(Math.random() * 1000 + 1);
        notify.insertAdjacentHTML(
          "beforeend",
          `
          <div class="notfiyC info" id="${number}">
          <div class="cont">
              <div class="icon">
              <svg width="25" height="25" viewBox="0 0 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12.4378 0C9.97782 0 7.5731 0.729463 5.52772 2.09614C3.48234 3.46282 1.88816 5.40534 0.946775 7.67804C0.00538907 9.95075 -0.24092 12.4516 0.238994 14.8643C0.718908 17.277 1.90349 19.4932 3.64295 21.2326C5.3824 22.9721 7.5986 24.1566 10.0113 24.6366C12.424 25.1165 14.9248 24.8702 17.1975 23.9288C19.4702 22.9874 21.4127 21.3932 22.7794 19.3478C24.1461 17.3025 24.8756 14.8977 24.8756 12.4378C24.8721 9.14014 23.5605 5.97857 21.2288 3.64679C18.897 1.31501 15.7354 0.00348236 12.4378 0ZM11.9594 5.74051C12.2432 5.74051 12.5207 5.82468 12.7567 5.98237C12.9927 6.14007 13.1767 6.3642 13.2853 6.62644C13.3939 6.88868 13.4223 7.17723 13.367 7.45562C13.3116 7.73401 13.1749 7.98972 12.9742 8.19043C12.7735 8.39113 12.5178 8.52782 12.2394 8.58319C11.961 8.63857 11.6724 8.61015 11.4102 8.50152C11.148 8.3929 10.9238 8.20896 10.7661 7.97295C10.6084 7.73695 10.5243 7.45948 10.5243 7.17564C10.5243 6.79502 10.6755 6.42999 10.9446 6.16085C11.2138 5.89171 11.5788 5.74051 11.9594 5.74051ZM13.3945 19.135C12.887 19.135 12.4003 18.9334 12.0415 18.5746C11.6826 18.2157 11.481 17.729 11.481 17.2215V12.4378C11.2273 12.4378 10.9839 12.337 10.8045 12.1575C10.6251 11.9781 10.5243 11.7348 10.5243 11.481C10.5243 11.2273 10.6251 10.9839 10.8045 10.8045C10.9839 10.6251 11.2273 10.5243 11.481 10.5243C11.9885 10.5243 12.4752 10.7259 12.8341 11.0847C13.1929 11.4436 13.3945 11.9303 13.3945 12.4378V17.2215C13.6483 17.2215 13.8916 17.3223 14.0711 17.5018C14.2505 17.6812 14.3513 17.9245 14.3513 18.1783C14.3513 18.432 14.2505 18.6754 14.0711 18.8548C13.8916 19.0342 13.6483 19.135 13.3945 19.135Z" fill="#D3DD62"/>
              </svg>
              
              </div>
              <div class="text">
                  <h1>${this.notifyText.info}</h1>
                  <p>${text}</p>
              </div>
          </div>
          <svg width="262" height="69" viewBox="0 0 262 69" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g clip-path="url(#clip0_51_1433)">
          <rect width="262" height="68.3478" rx="7.23118" fill="url(#paint0_linear_51_1433)"/>
          <g filter="url(#filter0_f_51_1433)">
          <circle cx="9.5" cy="-55.686" r="93.5" fill="white" fill-opacity="0.25"/>
          </g>
          <g filter="url(#filter1_f_51_1433)">
          <circle cx="111" cy="695.814" r="282" fill="#876544" fill-opacity="0.22"/>
          </g>
          <path d="M25 -16C25 -17.1046 25.8954 -18 27 -18H43C44.1046 -18 45 -17.1046 45 -16V0.763931C45 1.52147 44.572 2.214 43.8944 2.55279L35.8944 6.55279C35.3314 6.83431 34.6686 6.83431 34.1056 6.55279L26.1056 2.55279C25.428 2.214 25 1.52148 25 0.763931V-16Z" fill="#D3DD62"/>
          <path d="M45 84C45 85.1046 44.1046 86 43 86L27 86C25.8954 86 25 85.1046 25 84L25 67.2361C25 66.4785 25.428 65.786 26.1056 65.4472L34.1056 61.4472C34.6686 61.1657 35.3314 61.1657 35.8944 61.4472L43.8944 65.4472C44.572 65.786 45 66.4785 45 67.2361L45 84Z" fill="#D3DD62"/>
          </g>
          <rect x="0.5" y="0.5" width="261" height="67.3478" rx="6.73118" stroke="#D3DD62"/>
          <defs>
          <filter id="filter0_f_51_1433" x="-323" y="-388.186" width="665" height="665" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="119.5" result="effect1_foregroundBlur_51_1433"/>
          </filter>
          <filter id="filter1_f_51_1433" x="-571.994" y="12.8197" width="1365.99" height="1365.99" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="200.497" result="effect1_foregroundBlur_51_1433"/>
          </filter>
          <linearGradient id="paint0_linear_51_1433" x1="4.28828" y1="7.12885" x2="78.5337" y2="158.981" gradientUnits="userSpaceOnUse">
          <stop stop-color="#000103"/>
          <stop offset="1" stop-color="#010104"/>
          </linearGradient>
          <clipPath id="clip0_51_1433">
          <rect width="262" height="68.3478" rx="7.23118" fill="white"/>
          </clipPath>
          </defs>
          </svg>
          
      </div>
          `
        );
        // Delete İtem And Anim
        let item = document.getElementById(number);
        gsap.to(item, { left: 0, duration: 0.5, ease: "power2.out" });
        gsap.to(item, {
          left: "-20vw",
          duration: 0.5,
          ease: "power2.out",
          delay: delayA,
        });
        setTimeout(() => {
          item.remove();
        }, this.notifyDelay);
      } else if (type === "hunger") {
        // div append innerhtml
        var number = Math.floor(Math.random() * 1000 + 1);
        notify.insertAdjacentHTML(
          "beforeend",
          `
          <div class="notfiyC hunger" id="${number}">
          <div class="cont">
              <div class="icon">
              <svg width="22" height="24" viewBox="0 0 22 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M21.469 0.948578V22.4176C21.469 22.6651 21.3706 22.9025 21.1956 23.0776C21.0205 23.2526 20.7831 23.351 20.5355 23.351C20.288 23.351 20.0506 23.2526 19.8755 23.0776C19.7004 22.9025 19.6021 22.6651 19.6021 22.4176V16.8169H14.0015C13.7539 16.8169 13.5165 16.7186 13.3415 16.5436C13.1664 16.3685 13.0681 16.1311 13.0681 15.8835C13.1114 13.6476 13.3938 11.4227 13.9105 9.2468C15.0516 4.52246 17.2148 1.35579 20.168 0.0909863C20.3099 0.0301852 20.4647 0.00554683 20.6186 0.0192796C20.7724 0.0330123 20.9204 0.0846869 21.0493 0.169673C21.1782 0.254659 21.284 0.370302 21.3573 0.506239C21.4305 0.642177 21.4689 0.794163 21.469 0.948578ZM10.2549 0.795728C10.2367 0.673162 10.1941 0.555463 10.1299 0.449496C10.0657 0.343529 9.98095 0.251416 9.88073 0.178529C9.78051 0.105642 9.66678 0.0534408 9.54617 0.0249697C9.42556 -0.00350145 9.30049 -0.00767226 9.17826 0.0127004C9.05602 0.0330731 8.93907 0.0775816 8.83421 0.14363C8.72936 0.209678 8.63871 0.295943 8.56754 0.397394C8.49638 0.498845 8.44613 0.613451 8.41972 0.734527C8.39331 0.855603 8.39128 0.980725 8.41374 1.10259L9.3215 6.54918H6.53404V0.948578C6.53404 0.701016 6.43569 0.463594 6.26064 0.288541C6.08559 0.113488 5.84816 0.0151446 5.6006 0.0151446C5.35304 0.0151446 5.11562 0.113488 4.94056 0.288541C4.76551 0.463594 4.66717 0.701016 4.66717 0.948578V6.54918H1.8797L2.78747 1.10259C2.80992 0.980725 2.80789 0.855603 2.78148 0.734527C2.75508 0.613451 2.70483 0.498845 2.63366 0.397394C2.5625 0.295943 2.47184 0.209678 2.36699 0.14363C2.26214 0.0775816 2.14518 0.0330731 2.02294 0.0127004C1.90071 -0.00767226 1.77564 -0.00350145 1.65503 0.0249697C1.53442 0.0534408 1.42069 0.105642 1.32047 0.178529C1.22025 0.251416 1.13555 0.343529 1.0713 0.449496C1.00705 0.555463 0.96455 0.673162 0.946268 0.795728L0.0128348 6.39633C0.00445774 6.44685 0.000165538 6.49797 0 6.54918C0.00186509 7.8721 0.471288 9.15178 1.32532 10.1621C2.17935 11.1724 3.36302 11.8484 4.66717 12.0704V22.4176C4.66717 22.6651 4.76551 22.9025 4.94056 23.0776C5.11562 23.2526 5.35304 23.351 5.6006 23.351C5.84816 23.351 6.08559 23.2526 6.26064 23.0776C6.43569 22.9025 6.53404 22.6651 6.53404 22.4176V12.0704C7.83818 11.8484 9.02185 11.1724 9.87588 10.1621C10.7299 9.15178 11.1993 7.8721 11.2012 6.54918C11.201 6.49797 11.1967 6.44685 11.1884 6.39633L10.2549 0.795728Z" fill="#DD62D8"/>
              </svg>
              
              
              </div>
              <div class="text">
                  <h1>${this.notifyText.hunger}</h1>
                  <p>${text}</p>
              </div>
          </div>
          <svg width="262" height="69" viewBox="0 0 262 69" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g clip-path="url(#clip0_51_1402)">
          <rect width="262" height="68.3478" rx="7.23118" fill="url(#paint0_linear_51_1402)"/>
          <g filter="url(#filter0_f_51_1402)">
          <circle cx="9.5" cy="-55.686" r="93.5" fill="white" fill-opacity="0.25"/>
          </g>
          <g filter="url(#filter1_f_51_1402)">
          <circle cx="111" cy="695.814" r="282" fill="#876544" fill-opacity="0.22"/>
          </g>
          <path d="M25 -16C25 -17.1046 25.8954 -18 27 -18H43C44.1046 -18 45 -17.1046 45 -16V0.763931C45 1.52147 44.572 2.214 43.8944 2.55279L35.8944 6.55279C35.3314 6.83431 34.6686 6.83431 34.1056 6.55279L26.1056 2.55279C25.428 2.214 25 1.52148 25 0.763931V-16Z" fill="#DD62D8"/>
          <path d="M45 84C45 85.1046 44.1046 86 43 86L27 86C25.8954 86 25 85.1046 25 84L25 67.2361C25 66.4785 25.428 65.786 26.1056 65.4472L34.1056 61.4472C34.6686 61.1657 35.3314 61.1657 35.8944 61.4472L43.8944 65.4472C44.572 65.786 45 66.4785 45 67.2361L45 84Z" fill="#DD62D8"/>
          </g>
          <rect x="0.5" y="0.5" width="261" height="67.3478" rx="6.73118" stroke="#DD62D8"/>
          <defs>
          <filter id="filter0_f_51_1402" x="-323" y="-388.186" width="665" height="665" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="119.5" result="effect1_foregroundBlur_51_1402"/>
          </filter>
          <filter id="filter1_f_51_1402" x="-571.994" y="12.8197" width="1365.99" height="1365.99" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="200.497" result="effect1_foregroundBlur_51_1402"/>
          </filter>
          <linearGradient id="paint0_linear_51_1402" x1="4.28828" y1="7.12885" x2="78.5337" y2="158.981" gradientUnits="userSpaceOnUse">
          <stop stop-color="#000103"/>
          <stop offset="1" stop-color="#010104"/>
          </linearGradient>
          <clipPath id="clip0_51_1402">
          <rect width="262" height="68.3478" rx="7.23118" fill="white"/>
          </clipPath>
          </defs>
          </svg>           
      </div>
          `
        );
        // Delete İtem And Anim
        let item = document.getElementById(number);
        gsap.to(item, { left: 0, duration: 0.5, ease: "power2.out" });
        gsap.to(item, {
          left: "-20vw",
          duration: 0.5,
          ease: "power2.out",
          delay: delayA,
        });
        setTimeout(() => {
          item.remove();
        }, this.notifyDelay);
      } else if (type === "quest") {
        // div append innerhtml
        var number = Math.floor(Math.random() * 1000 + 1);
        notify.insertAdjacentHTML(
          "beforeend",
          `
          <div class="notfiyC quest" id="${number}">
          <div class="cont">
              <div class="icon">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M11.7464 0C9.42322 0 7.15216 0.688917 5.22047 1.97963C3.28878 3.27035 1.78321 5.10489 0.89415 7.25127C0.00508955 9.39765 -0.227529 11.7595 0.22571 14.0381C0.678949 16.3166 1.79769 18.4097 3.44046 20.0524C5.08323 21.6952 7.17624 22.8139 9.45483 23.2672C11.7334 23.7204 14.0952 23.4878 16.2416 22.5987C18.388 21.7097 20.2225 20.2041 21.5133 18.2724C22.804 16.3407 23.4929 14.0697 23.4929 11.7464C23.4896 8.6321 22.251 5.64626 20.0488 3.44408C17.8466 1.24191 14.8608 0.0032888 11.7464 0ZM11.7464 18.975C11.4784 18.975 11.2163 18.8955 10.9934 18.7466C10.7706 18.5977 10.5968 18.386 10.4943 18.1383C10.3917 17.8907 10.3648 17.6182 10.4171 17.3552C10.4694 17.0923 10.5985 16.8508 10.7881 16.6613C10.9776 16.4717 11.2191 16.3426 11.482 16.2903C11.7449 16.238 12.0175 16.2649 12.2651 16.3675C12.5128 16.4701 12.7245 16.6438 12.8734 16.8667C13.0223 17.0896 13.1018 17.3516 13.1018 17.6197C13.1018 17.9791 12.959 18.3239 12.7048 18.578C12.4506 18.8322 12.1059 18.975 11.7464 18.975ZM12.65 13.4723V13.5536C12.65 13.7932 12.5548 14.0231 12.3854 14.1925C12.2159 14.362 11.9861 14.4572 11.7464 14.4572C11.5068 14.4572 11.277 14.362 11.1075 14.1925C10.9381 14.0231 10.8429 13.7932 10.8429 13.5536V12.65C10.8429 12.4104 10.9381 12.1805 11.1075 12.0111C11.277 11.8416 11.5068 11.7464 11.7464 11.7464C13.2407 11.7464 14.4572 10.7299 14.4572 9.48751C14.4572 8.2451 13.2407 7.22858 11.7464 7.22858C10.2522 7.22858 9.03573 8.2451 9.03573 9.48751V9.93929C9.03573 10.1789 8.94053 10.4088 8.77108 10.5782C8.60162 10.7477 8.3718 10.8429 8.13216 10.8429C7.89251 10.8429 7.66269 10.7477 7.49323 10.5782C7.32378 10.4088 7.22858 10.1789 7.22858 9.93929V9.48751C7.22858 7.24552 9.25484 5.42143 11.7464 5.42143C14.238 5.42143 16.2643 7.24552 16.2643 9.48751C16.2643 11.4505 14.7102 13.0939 12.65 13.4723Z" fill="#D2D2D2"/>
              </svg>              
              </div>
              <div class="text">
                  <h1>${this.notifyText.quest}</h1>
                  <p>${text}</p>
              </div>
          </div>
          <svg width="262" height="69" viewBox="0 0 262 69" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g clip-path="url(#clip0_51_1446)">
          <rect width="262" height="68.3478" rx="7.23118" fill="url(#paint0_linear_51_1446)"/>
          <g filter="url(#filter0_f_51_1446)">
          <circle cx="9.5" cy="-55.686" r="93.5" fill="white" fill-opacity="0.25"/>
          </g>
          <g filter="url(#filter1_f_51_1446)">
          <circle cx="111" cy="695.814" r="282" fill="#876544" fill-opacity="0.22"/>
          </g>
          <path d="M25 -16C25 -17.1046 25.8954 -18 27 -18H43C44.1046 -18 45 -17.1046 45 -16V0.763931C45 1.52147 44.572 2.214 43.8944 2.55279L35.8944 6.55279C35.3314 6.83431 34.6686 6.83431 34.1056 6.55279L26.1056 2.55279C25.428 2.214 25 1.52148 25 0.763931V-16Z" fill="#D2D2D2"/>
          <path d="M45 84C45 85.1046 44.1046 86 43 86L27 86C25.8954 86 25 85.1046 25 84L25 67.2361C25 66.4785 25.428 65.786 26.1056 65.4472L34.1056 61.4472C34.6686 61.1657 35.3314 61.1657 35.8944 61.4472L43.8944 65.4472C44.572 65.786 45 66.4785 45 67.2361L45 84Z" fill="#D2D2D2"/>
          </g>
          <rect x="0.5" y="0.5" width="261" height="67.3478" rx="6.73118" stroke="#D2D2D2"/>
          <defs>
          <filter id="filter0_f_51_1446" x="-323" y="-388.186" width="665" height="665" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="119.5" result="effect1_foregroundBlur_51_1446"/>
          </filter>
          <filter id="filter1_f_51_1446" x="-571.994" y="12.8197" width="1365.99" height="1365.99" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
          <feFlood flood-opacity="0" result="BackgroundImageFix"/>
          <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
          <feGaussianBlur stdDeviation="200.497" result="effect1_foregroundBlur_51_1446"/>
          </filter>
          <linearGradient id="paint0_linear_51_1446" x1="4.28828" y1="7.12885" x2="78.5337" y2="158.981" gradientUnits="userSpaceOnUse">
          <stop stop-color="#000103"/>
          <stop offset="1" stop-color="#010104"/>
          </linearGradient>
          <clipPath id="clip0_51_1446">
          <rect width="262" height="68.3478" rx="7.23118" fill="white"/>
          </clipPath>
          </defs>
          </svg>                  
      </div>
          `
        );
        // Delete İtem And Anim
        let item = document.getElementById(number);
        gsap.to(item, { left: 0, duration: 0.5, ease: "power2.out" });
        gsap.to(item, {
          left: "-20vw",
          duration: 0.5,
          ease: "power2.out",
          delay: delayA,
        });
        setTimeout(() => {
          item.remove();
        }, this.notifyDelay);
      }
    },

    // Pets
    petsSelect: function (item) {
      // Pets Select
      if (item.selected) {
        item.selected = false;
        this.pets.spawnPed = false;
        this.pets.spawnPedCode = "";
        isPetHere = false;
        firstOpen = false;
        this.openInterface("hud", false);
        this.petsClose(item);
        return;
      }
      if (this.pets.spawnPed) {
        return;
      }
      this.pets.pets.forEach((item) => {
        item.selected = false;
      });
      this.pets.spawnPed = true;
      item.selected = true;
      this.pets.spawnPedCode = item.pet_code;
      isPetHere = true;
      this.petsClose(item);
    },
    petsClose: function (item) {
      // Pets Close
      $.post("https://dusa_pet/callPet", JSON.stringify({ pet: item }));
      // this.openInterface("petmenu", false);
      // $.post("https://dusa_pet/closeUI", JSON.stringify({}));
    },
    petsGoSleep() {
      this.pets.spawnPedCode = "";
      this.pets.spawnPed = false;
      this.pets.pets.forEach((item) => {
        item.selected = false;
      });
    },
    petsDelete: function (item, type) {
      if (type === "quest") {
        this.pets.enabled = false;
        this.quest.enabled = true;
        this.quest.deleteItem = item;
      }
      if (type === "yes") {
        this.quest.enabled = false;
        this.pets.enabled = true;
        //Pet delete Mert
        $.post(
          "https://dusa_pet/deletePet",
          JSON.stringify({ pet: this.quest.deleteItem })
        );
        this.pets.pets.splice(this.pets.pets.indexOf(this.quest.deleteItem), 1);
        this.quest.deleteItem = null;
      }
      if (type === "no") {
        this.quest.enabled = false;
        this.pets.enabled = true;
        this.quest.deleteItem = null;
      }
    },
    //PetShop
    petshopMenu: function (id, menu) {
      // PetShop Menu
      this.petshop.active_shop = id;
      this.petshop.products = menu;
    },
    addCardPet: function (item) {
      // Add Card Pet
      item.selected = true;
      this.petshop.card.push(item);
    },
    deleteCardPet: function (item) {
      // Delete Card Pet
      item.selected = false;
      this.petshop.card.splice(this.petshop.card.indexOf(item), 1);
    },
    payPet: function (type) {
      this.petshop.card.forEach((item) => {
        item.selected = false;
      });
      $.post(
        "https://dusa_pet/buyPet",
        JSON.stringify({
          cart: this.petshop.card,
          price: this.totalPricePet,
          type: type,
        })
      );
      this.petshop.card = [];
    },
    focuspet: function (item) {
      $.post(
        "https://dusa_pet/previewPet",
        JSON.stringify({ pet: item.pet_code })
      );
      petfocus = true;
      // Kapama Açma Animasyonu
      gsap.to(".petshop-cont", {
        opacity: 0,
        pointerEvents: "none",
        duration: 1,
        ease: "power2.out",
      });
      gsap.to(".back-button-petshop", {
        opacity: 1,
        pointerEvents: "all",
        duration: 1,
        ease: "power2.out",
      });
    },
    closefocus: function () {
      // Kapama Açma Animasyonu
      $.post("https://dusa_pet/destroyPreview", JSON.stringify({}));
      petfocus = false;
      gsap.to(".petshop-cont", {
        opacity: 1,
        pointerEvents: "all",
        duration: 1,
        ease: "power2.out",
      });
      gsap.to(".back-button-petshop", {
        opacity: 0,
        pointerEvents: "none",
        duration: 1,
        ease: "power2.out",
      });
    },

    //Hud

    buyItem: function (payType) {
      $.post(
        "https://dusa_pet/itemData",
        JSON.stringify({ data: this.shop.card, account: payType })
      );
      this.shop.card = [];
    },
    openInterface: function (type, bool, notifytext) {
      if (type === "shop") {
        this.shop.enabled = bool;
      } else if (type === "wardrobe") {
        this.wardrobe.enabled = bool;
        // if (!bool && notifytext) {
        //   $.post(
        //     "https://dusa_pet/saveItem",
        //     JSON.stringify({
        //       clothes: this.wardrobe.slots
        //     })
        //   );
        // }
      } else if (type === "emote") {
        this.emote.enabled = bool;
      } else if (type === "hud") {
        this.hud.enabled = bool;
        hudstatus = bool;
      } else if (type === "petmenu") {
        this.pets.enabled = bool;
      } else if (type === "petshop") {
        this.petshop.products = this.petshop.pets;
        this.petshop.enabled = bool;
      } else if (type === "notification") {
        // bool equals to success, error etc.
        this.notify(bool, notifytext);
      }
    },
    saveItem() {
      $.post(
        "https://dusa_pet/saveItem",
        JSON.stringify({
          clothes: this.wardrobe.slots,
        })
      );
    },
    handleKeyDown(event) {
      if (event.keyCode == 27) {
        this.openInterface("shop", false);
        if (this.wardrobe.enabled) {
          this.openInterface("wardrobe", false, true);
        }
        this.openInterface("emote", false);
        this.openInterface("petshop", false);
        this.openInterface("petmenu", false);
        $.post("https://dusa_pet/closeUI", JSON.stringify({}));
        this.petshop["pets"] = [];
        // hud açık değilse çalıştır
        if (!hudstatus) {
          this.openInterface("hud", true);
        }
        // pet yanında değilse çalıştır
        if (petfocus) {
          this.closefocus();
        }
        if (!isPetHere) {
          this.openInterface("hud", false);
        }
      } else if (event.keyCode == 68) {
        $.post("https://dusa_pet/rotate", JSON.stringify({ key: "left" }));
      } else if (event.keyCode == 65) {
        $.post("https://dusa_pet/rotate", JSON.stringify({ key: "right" }));
      }
    },
    TranslateUI(translate) {
      this.notifyText.error = translate.notifyError;
      this.notifyText.success = translate.notifySuccess;
      this.notifyText.info = translate.notifyInfo;
      this.notifyText.hunger = translate.notifyHunger;

      this.shop.info.shop_p = translate.store_header;
      this.shop.info.add_card = translate.store_addcart;
      this.shop.info.paytocard = translate.store_paycard;
      this.shop.info.paytocash = translate.store_paycash;

      this.wardrobe.info.wardrobe_p = translate.wardrobe_header;
      this.wardrobe.info.info_h1 = translate.wardrobe_info;
      this.wardrobe.info.info_p = translate.wardrobe_infop;

      this.emote.info.emotes = translate.emote_emotes;
      this.emote.info.actions = translate.emote_actions;
      this.emote.info.health = translate.emote_health;
      this.emote.info.hunger = translate.emote_hunger;
      this.emote.illnessText = translate.emote_healthy;

      this.pets.info.pets = translate.petmenu_pets;
      this.pets.info.select = translate.petmenu_call;
      this.pets.info.selected = translate.petmenu_sleep;
      this.pets.info.delete = translate.petmenu_delete;

      this.petshop.info.shop_p = translate.petshop_header;
      this.petshop.info.add_card = translate.petshop_addcart;
      this.petshop.info.paytocard = translate.petshop_paycard;
      this.petshop.info.paytocash = translate.petshop_paycash;
      this.petshop.info.added = translate.petshop_added;
      this.petshop.info.deleteCard = translate.petshop_delete;
      this.petshop.info.rotate = translate.petshop_rotate;

      this.quest.info.title = translate.release_title;
      this.quest.info.yes = translate.release_yes;
      this.quest.info.no = translate.release_no;
    },
  },
});

function imageExists(url) {
  var http = new XMLHttpRequest();
  http.open("HEAD", url, false);
  http.send();
  return http.status != 404;
}

function toarray(data) {
  var dataObject = JSON.parse(data);
  var dataArray = [];
  for (var key in dataObject) {
    if (dataObject.hasOwnProperty(key)) {
      dataArray.push(dataObject[key]);
    }
  }
  return dataArray;
}
