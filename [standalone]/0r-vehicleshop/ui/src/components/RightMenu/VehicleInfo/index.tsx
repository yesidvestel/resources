import { useState } from "react";
import useLocales from "../../../hooks/useLocales";
import { ColorPicker, IColor, useColor } from "react-color-palette";
import { colors } from "../../../utils/misc";
import { CarStatsProps } from "../../../types/DataProviderTypes";
import { FaArrowsToEye } from "react-icons/fa6";
import useData from "../../../hooks/useData";

const svg_right_menu_amblem = "images/right_menu_amblem.svg";
const svg_stats_bg = "images/car-info-bg.svg";
const svg_ellipse_2 = "images/ellipse-2.svg";
const svg_ellipse_3 = "images/ellipse-3.svg";
const svg_category_g = "images/stats-category-g.svg";
const svg_category_v = "images/stats-category-v.svg";
const svg_wheel_drive = "images/wheel_drive.svg";

const VehicleInfo: React.FC<{
  vehicle: CarStatsProps;
  isCompareVehicle?: boolean;
}> = ({ vehicle, isCompareVehicle }) => {
  const { updateCompareCamera, changeVehicleColor } = useData();
  const { locale } = useLocales();
  const [activePage, setActivePage] = useState<"stats" | "color-picker">(
    "stats"
  );
  const [color, setColor] = useColor("#561ecb");

  const handlePageChanger = (newPage: "stats" | "color-picker") => {
    return setActivePage(newPage);
  };

  const handleUpdateCompareCamera = () => {
    updateCompareCamera();
  };

  let canChangeColor = true;
  const handleChangeVehicleColor = (color: IColor) => {
    if (canChangeColor) {
      canChangeColor = false;
      changeVehicleColor(vehicle, color);
      setColor(color);
      setTimeout(() => {
        canChangeColor = true;
      }, 1000);
    }
  };

  return (
    <div>
      <div className="current-car-info">
        {isCompareVehicle && (
          <div className="absolute text-neutral-900 font-medium left-2 ribbon">
            <div className="pow down">
              <button
                className="content flex items-center justify-center"
                onClick={handleUpdateCompareCamera}
              >
                <FaArrowsToEye />
              </button>
            </div>
          </div>
        )}
        <div className="title flex flex-col items-center justify-center w-full h-full">
          <div className="logo m-1">
            <img src={svg_right_menu_amblem} alt="_amblem" />
          </div>
          <div className="name">{vehicle.label}</div>
          <div className="category">{vehicle.road} CLASS</div>
        </div>
      </div>
      <div
        className="stats-page py-8 px-3"
        style={{ backgroundImage: `url(${svg_stats_bg})` }}
      >
        {activePage == "stats" ? (
          <>
            <div className="tier mb-4">
              <p>{locale.car_stats_tier}</p>
            </div>
            <div className="category-info flex items-center justify-start flex-wrap gap-4 mb-8">
              <div className="category py-0.5 px-2 overflow-hidden text-ellipsis">
                {vehicle.road}
              </div>
              <div className="svg2">
                <img src={svg_category_v} alt="svg category v" />
              </div>
              <div className="svg1">
                <img src={svg_category_g} alt="svg category g" />
              </div>
            </div>
            <div className="mb-10">
              <div className="handling-info">
                <div className="flex items-center justify-between">
                  <div>{locale.car_stats_handling}</div>
                  <div>
                    <span className="grip">%{vehicle.grip}</span>{" "}
                    {locale.car_stats_grip}
                  </div>
                </div>
              </div>
              <div>
                <div className="wall"></div>
                <div className="slider">
                  <div
                    className="ball"
                    style={{ right: vehicle.grip + "%" }}
                  ></div>
                </div>
                <div className="wall"></div>
              </div>
              <div className="handling-info">
                <div className="flex items-center justify-between">
                  <div>{locale.car_stats_grip}</div>
                  <div className="drift">{locale.car_stats_drift}</div>
                </div>
              </div>
            </div>
            <div>
              <div className="traction-info">
                <div className="flex items-center justify-between">
                  <div>{locale.car_stats_traction}</div>
                  <div className="wheel-drive flex items-center justify-center gap-2">
                    <img src={svg_wheel_drive} alt="wheel drive" />
                    <div className="traction-type">{vehicle.traction}</div>
                  </div>
                </div>
                <div className="idk my-3">
                  <div className="flex justify-between items-center">
                    <div></div>
                    <div className="active"></div>
                    <div></div>
                    <div></div>
                  </div>
                </div>
                <div className="handling-info mb-8">
                  <div className="flex items-center justify-between">
                    <div>{locale.car_stats_road}</div>
                    <div className="drift">{vehicle.road}</div>
                  </div>
                </div>
                <div className="speed-info mb-2">
                  <div className="flex items-center justify-between">
                    <div className="text">
                      {locale.car_stats_top_speed} <span>[km/h]</span>
                    </div>
                    <div className="content flex items-center justify-center">
                      {vehicle.top_speed}
                    </div>
                  </div>
                </div>
                <div className="speed-info">
                  <div className="flex items-center justify-between">
                    <div className="text">
                      0 - 97 <span>km/h [s] </span>
                    </div>
                    <div className="content flex items-center justify-center">
                      {vehicle.sec_0_100}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </>
        ) : (
          <>
            <div className="tier mb-4">
              <p>{locale.vehicle_color_text}</p>
              <p className="float-right">{color.hex}</p>
            </div>
            <div className="custom-layout-color">
              <ColorPicker
                height={133}
                color={color}
                onChange={(color) => handleChangeVehicleColor(color)}
                hideAlpha={true}
                hideInput={true}
              />
              <div className="ready-colors">
                <ul className="boxes flex text-center justify-around gap-1.5 p-3 pt-0">
                  {colors.map((color, i) => (
                    <li
                      className="box cursor-pointer"
                      data-color={color.hex}
                      key={i}
                      style={{ backgroundColor: color.hex }}
                      onClick={() => handleChangeVehicleColor(color)}
                    ></li>
                  ))}
                </ul>
              </div>
            </div>
          </>
        )}
      </div>
      <div className="bottom flex justify-between items-center px-4">
        <div className="info-text">
          <span>
            {activePage == "stats"
              ? locale.vehicle_stats_text
              : locale.vehicle_color_text}
          </span>
        </div>
        <div className="ellipses flex items-center gap-2">
          <button
            className="vehicle-stats"
            onClick={() => handlePageChanger("stats")}
          >
            {activePage === "stats" ? (
              <img src={svg_ellipse_2} alt="ellipse 2" />
            ) : (
              <img src={svg_ellipse_3} alt="ellipse 3" />
            )}
          </button>
          <button
            className="vehicle-colors"
            onClick={() => handlePageChanger("color-picker")}
          >
            {activePage === "color-picker" ? (
              <img src={svg_ellipse_2} alt="ellipse 2" />
            ) : (
              <img src={svg_ellipse_3} alt="ellipse 3" />
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default VehicleInfo;
