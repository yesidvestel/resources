import "./index.sass";
import "react-color-palette/css";
import { useEffect } from "react";
import useData from "../../hooks/useData";
import classNames from "classnames";
import { fetchNui } from "../../utils/fetchNui";
import VehicleInfo from "./VehicleInfo";
import useLocales from "../../hooks/useLocales";
import { CarStatsProps } from "../../types/DataProviderTypes";

const svg_music_stop = "images/music_stop.svg";
const svg_music_resume = "images/music_resume.svg";
const svg_music_volume = "images/music_volume.svg";
const svg_red_fire = "images/red-fire.svg";
const svg_music_volume_on = "images/music_volume_on.svg";
const svg_test_drive = "images/test_drive.svg";
const svg_compare = "images/compare.svg";
const svg_compare_yellow = "images/compare_yellow.svg";
const svg_compare_transparent = "images/compare_transparent.svg";
const svg_cross = "images/cross.svg";

const RightMenu: React.FC = () => {
  const { locale } = useLocales();

  const {
    OpenedGallery,
    playingSong,
    setPlayingSong,
    bankBalance,
    selectedCar,
    setSelectedCar,
    isCompareActive,
    setIsCompareActive,
    comparedVehicle,
    setComparedVehicle,
    startTestDrive,
    setOpenedGallery,
    calani,
    setCalani,
  } = useData();

  useEffect(() => {
    if (selectedCar.name && !selectedCar.is_load) {
      const fetchData = async (data?: any, mockData?: any) => {
        const response = await fetchNui("showVehicle", data, mockData);
        return response;
      };
      fetchData(selectedCar, { status: true, vehicle: selectedCar }).then(
        (r) => {
          if (r.status) {
            setSelectedCar(() => {
              return {
                ...r.vehicle,
                is_load: true,
              };
            });
          }
        }
      );
    }
  }, [setSelectedCar, selectedCar]);

  useEffect(() => {
    if (
      selectedCar.is_load &&
      !isCompareActive &&
      OpenedGallery.currentCam !== "selected"
    ) {
      setOpenedGallery((prevState) => {
        return {
          ...prevState,
          currentCam: "selected",
        };
      });
    }
  }, [selectedCar, setOpenedGallery, OpenedGallery, isCompareActive]);

  useEffect(() => {
    if (comparedVehicle.name && !comparedVehicle.is_load) {
      const fetchData = async (data?: any, mockData?: any) => {
        const response = await fetchNui("showComparedVehicle", data, mockData);
        return response;
      };
      fetchData(comparedVehicle, {
        status: true,
        vehicle: comparedVehicle,
      }).then((r) => {
        setComparedVehicle(() => {
          return {
            ...r.vehicle,
            is_load: true,
          };
        });
      });
    }
  }, [comparedVehicle, setComparedVehicle]);

  const handleSetIsCompareActive = () => {
    setIsCompareActive(isCompareActive ? false : true);
  };

  const handleClearCompare = () => {
    setComparedVehicle({} as CarStatsProps);
    setIsCompareActive(false);
    fetchNui("onToggleCompareActive", false);
  };

  const handleTestDrive = () => {
    startTestDrive();
  };

  const handleToggleMusic = async () => {
    const newMusic = calani || new Audio(`music/${playingSong.file}`);
    if (newMusic) {
      if (playingSong.on) {
        newMusic.pause();
        setCalani(null);
      } else {
        newMusic.volume = playingSong.volume;
        newMusic.play().catch((error) => {
          console.error("Error playing audio:", error);
        });
        setCalani(newMusic);
      }
      setPlayingSong((prev) => {
        return {
          ...prev,
          on: !prev.on,
        };
      });
    }
  };

  return (
    <div>
      <div className="flex justify-end gap-2">
        <div className="music-widget flex items-center justify-between px-4">
          <div className="interaction-buttons cursor-pointer">
            {playingSong.on ? (
              <button onClick={handleToggleMusic}>
                <img
                  className="playing"
                  src={svg_music_stop}
                  alt="music stop"
                />
              </button>
            ) : (
              <button onClick={handleToggleMusic}>
                <img src={svg_music_resume} alt="music resume" />
              </button>
            )}
          </div>
          <div className={classNames("song-info", { playing: playingSong.on })}>
            <div className="author">{playingSong?.author}</div>
            <div className="title">{playingSong?.name}</div>
          </div>
          <div>
            {playingSong.on ? (
              <img src={svg_music_volume_on} alt="music volume on" />
            ) : (
              <img src={svg_music_volume} alt="music volume" />
            )}
          </div>
        </div>
        <div className="discount-percentage-widget flex items-center justify-center gap-1">
          <div className="widget-image">
            <img src={svg_red_fire} alt="discount fire" />
          </div>
          <div className="content">
            <span className="p">%</span>
            <span className="discount">
              {(OpenedGallery?.discount?.active &&
                OpenedGallery?.discount?.percentage) ||
                "0"}
            </span>
          </div>
        </div>
        <div className="amount-bank-account-widget flex justify-center items-center px-2">
          <div>
            <span className="i mr-0.5">$</span>
          </div>
          <div>
            <span className="amount">{bankBalance}</span>
          </div>
        </div>
      </div>
      <div className="flex">
        <div className="mt-auto w-full flex flex-col gap-2 mr-2">
          <button
            className="compare cursor-pointer ml-auto"
            onClick={() => handleSetIsCompareActive()}
          >
            <div>
              <img
                src={isCompareActive ? svg_compare_yellow : svg_compare}
                alt="Compare"
              />
            </div>
          </button>
          {!isCompareActive && OpenedGallery?.testDrive?.active && (
            <button
              className="test-drive flex justify-center items-center gap-3 bg-white"
              onClick={handleTestDrive}
            >
              <div>
                <img src={svg_test_drive} alt="Test drive" />
              </div>
              <div className="text">{locale.test_drive_text}</div>
            </button>
          )}
        </div>
        <div>
          <div className="flex">
            {isCompareActive && comparedVehicle.is_load && (
              <>
                <VehicleInfo
                  vehicle={comparedVehicle}
                  isCompareVehicle={true}
                />
                <div className="m-auto flex flex-col items-center mx-3">
                  <button
                    className="svg_cursor m-3"
                    onClick={handleClearCompare}
                  >
                    <img src={svg_cross} alt="svg_cross" className="m-auto" />
                  </button>
                  <div className="svg_compare_transparent">
                    <img
                      src={svg_compare_transparent}
                      alt="svg_compare_transparent"
                    />
                  </div>
                  <button
                    className="svg_cursor m-3"
                    onClick={handleClearCompare}
                  >
                    <img src={svg_cross} alt="svg_cross" className="m-auto" />
                  </button>
                </div>
              </>
            )}
            <VehicleInfo vehicle={selectedCar} />
          </div>
        </div>
      </div>
    </div>
  );
};
export default RightMenu;
