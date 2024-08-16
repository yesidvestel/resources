import "./index.sass";
import useData from "../../hooks/useData";
import classNames from "classnames";
import { useState, useEffect } from "react";
import Slider from "../SliderHandler";
import { CarStatsProps } from "../../types/DataProviderTypes";
import { formatNumberWithComma } from "../../utils/misc";

const svg_selected_car = "images/catalog_selected_bottom.svg";
const svg_compare_yellow_half = "images/compare_yellow_half.svg";
const svg_red_fire = "images/red-fire.svg";

const BottomMenu = () => {
  const {
    carCategories,
    OpenedGallery,
    selectedCategory,
    setSelectedCategory,
    selectedCar,
    setSelectedCar,
    isCompareActive,
    setIsCompareActive,
    setComparedVehicle,
    comparedVehicle,
  } = useData();

  const [catalogVehicles, setCatalogVehicles] = useState(
    (OpenedGallery.vehicles && OpenedGallery.vehicles[selectedCategory]) || []
  );

  useEffect(() => {
    const loadImages = async () => {
      if (
        !OpenedGallery.vehicles ||
        !OpenedGallery.vehicles[selectedCategory]
      ) {
        setCatalogVehicles([]);
        return;
      }
      const _cVehicles = OpenedGallery.vehicles[selectedCategory];
      const imageLoadPromises = _cVehicles.map(async (vehicle) => {
        const loadImage = async (src: string) => {
          return new Promise<string>((resolve, reject) => {
            const img = new Image();
            img.src = src;
            img.onload = () => {
              vehicle.model = src;
              resolve(src);
            };
            img.onerror = () => {
              reject();
            };
          });
        };
        const specifyMdl = `images/vehicles/${vehicle.name}.png`;
        const webMdl = `https://docs.fivem.net/vehicles/${vehicle.name}.webp`;
        const errMdl = "images/catalog_vehicle_bg.svg";
        try {
          await loadImage(specifyMdl);
          vehicle.model = specifyMdl;
        } catch (error) {
          try {
            await loadImage(webMdl);
            vehicle.model = webMdl;
          } catch (error) {
            vehicle.model = errMdl;
          }
        }
      });
      await Promise.all(imageLoadPromises);
      setCatalogVehicles(_cVehicles);
    };
    loadImages();
  }, [selectedCategory, OpenedGallery.vehicles]);

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (["arrowright", "arrowleft"].includes(e.key.toLowerCase())) {
        let fIndexCar = catalogVehicles.findIndex(
          (x) => x?.name?.toLowerCase() == selectedCar?.name?.toLowerCase()
        );
        if (e.key.toLowerCase() == "arrowright") {
          if (fIndexCar + 1 >= catalogVehicles.length) fIndexCar = 0;
          else fIndexCar += 1;
        } else if (e.key.toLowerCase() == "arrowleft") {
          if (fIndexCar - 1 < 0) {
            fIndexCar = catalogVehicles.length - 1;
          } else fIndexCar -= 1;
        }
        setSelectedCar(catalogVehicles[fIndexCar]);
      }
    };
    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  }, [
    carCategories,
    selectedCategory,
    setSelectedCategory,
    selectedCar,
    setSelectedCar,
    catalogVehicles,
  ]);

  const handleSetSelectedCar = (vehicle: CarStatsProps) => {
    if (selectedCar.name == vehicle.name) return;
    if (isCompareActive) {
      setIsCompareActive(false);
      setComparedVehicle({} as CarStatsProps);
    }
    setSelectedCar(vehicle);
  };

  const handleSetComparedVehicle = (vehicle: CarStatsProps) => {
    if (comparedVehicle && comparedVehicle.name == vehicle.name) return;
    setComparedVehicle(vehicle);
  };

  return (
    <div>
      <div className="car-category-slider flex items-center justify-between px-2 mb-1.5">
        <Slider className="categories flex items-center justify-between w-full gap-4 no-scrollbar mx-2">
          {carCategories.map((category, i) => (
            <button
              className={classNames(
                "category flex items-center justify-center",
                { active: category.toLowerCase() == selectedCategory }
              )}
              key={i}
              onClick={() => setSelectedCategory(category.toLowerCase())}
            >
              <span className="no-selection">{category}</span>
            </button>
          ))}
        </Slider>
      </div>
      <Slider className="catalog flex items-center pb-4 h-[199px]">
        {catalogVehicles.map((vehicle, i) => (
          <div
            key={i}
            className={classNames("vehicle relative shadow-lg", {
              active: vehicle.name == selectedCar.name,
            })}
          >
            <div
              className="cursor-pointer w-full h-full"
              onClick={() => {
                handleSetSelectedCar(vehicle);
              }}
            >
              <div className="title no-selection">
                <div className="flex">
                  <div className="name flex items-center px-2 overflow-hidden text-ellipsis">
                    <span>{vehicle.label}</span>
                  </div>
                  <div className="index no-selection">
                    <span className="p-1">{i + 1}</span>
                  </div>
                </div>
              </div>
              <div className="price no-selection flex items-center">
                <div>
                  <span
                    className={classNames("dollar", {
                      "!text-gray-900": vehicle.name == selectedCar.name,
                    })}
                  >
                    $
                  </span>
                  <span
                    className={classNames({
                      "text-white": vehicle.name != selectedCar.name,
                      "text-gray-900": vehicle.name == selectedCar.name,
                    })}
                  >
                    {formatNumberWithComma(vehicle.price)}
                  </span>
                </div>
                {OpenedGallery.discount.active && (
                  <span className="discount-fire-image mx-1">
                    <img src={svg_red_fire} alt="discount fire" />
                  </span>
                )}
              </div>
              <div className="div-car-image">
                <img
                  className={classNames(
                    "car-image bg-cover bg-no-repeat no-selection",
                    {
                      active: vehicle.name == selectedCar.name,
                      "no-vehicle-image":
                        vehicle.model.includes("catalog_vehicle_bg"),
                      "yes-vehicle-image":
                        !vehicle.model.includes("catalog_vehicle_bg"),
                    },
                    selectedCategory
                  )}
                  src={vehicle.model}
                />
              </div>
              <div
                className={classNames("active-img", {
                  hidden: vehicle.name != selectedCar.name,
                })}
              >
                <img src={svg_selected_car} alt="active img" />
              </div>
            </div>
            {isCompareActive && vehicle.name !== selectedCar.name && (
              <button
                className="compare-svg top-0 right-0 absolute z-10 hover:w-12"
                onClick={() => handleSetComparedVehicle(vehicle)}
              >
                <img
                  className="w-full h-full"
                  src={svg_compare_yellow_half}
                  alt="svg compare half active"
                />
              </button>
            )}
          </div>
        ))}
      </Slider>
    </div>
  );
};

export default BottomMenu;
