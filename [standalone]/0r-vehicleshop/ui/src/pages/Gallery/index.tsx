import "./index.sass";
import { useState } from "react";
import RightMenu from "../../components/RightMenu";
import LeftMenu from "../../components/LeftMenu";
import BottomMenu from "../../components/BottomMenu";
import classNames from "classnames";
import useData from "../../hooks/useData";

const svg_eye = "images/eye.svg";

const Gallery: React.FC = () => {
  const { startRotatingVehicle, stopRotatingVehicle } = useData();
  const [clearPage, setClearPage] = useState<boolean>(false);

  const leftMenuClasses = classNames("_left_menu", {
    hidden: clearPage,
  });

  const rightMenuClasses = classNames("_right_menu", {
    hidden: clearPage,
  });

  const bottomMenuClasses = classNames("_bottom_menu bottom-14", {
    hidden: clearPage,
  });

  const handleSetClearPage = () => {
    if (clearPage) {
      stopRotatingVehicle();
    } else {
      startRotatingVehicle();
    }
    setClearPage(!clearPage);
  };

  return (
    <div className="flex flex-col h-full w-full">
      <div className="absolute top-1 left-1">
        <button
          className="see-full w-8 h-8 flex items-center justify-center rounded"
          onClick={handleSetClearPage}
        >
          <img src={svg_eye} alt="svg eye" className="w-6 h-6" />
        </button>
      </div>
      <div className="flex justify-between mt-10 mx-12 z-10">
        <div className={leftMenuClasses}>
          <LeftMenu />
        </div>
        <div className={rightMenuClasses}>
          <RightMenu />
        </div>
      </div>
      <div className="mx-12 mt-auto mb-12 z-10 no-selection cursor-none">
        <div className={bottomMenuClasses}>
          <BottomMenu />
        </div>
      </div>
      <div className="smuth z-0"></div>
    </div>
  );
};

export default Gallery;
