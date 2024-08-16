import "./index.sass";
import { useState } from "react";
import useData from "../../hooks/useData";
import useLocales from "../../hooks/useLocales";
import classNames from "classnames";
import ChoosingRentalDay from "./ChoosingRentalDay";
import useRouter from "../../hooks/useRouter";

const LeftMenu: React.FC = () => {
  const { locale } = useLocales();
  const { setRouter } = useRouter();
  const { OpenedGallery, selectedRentDay } = useData();
  const [activeHeaderButton, setActiveHeaderButton] = useState<"buy" | "rent">(
    "buy"
  );

  const handleActiveHeaderButton = (
    event: React.MouseEvent<HTMLButtonElement>
  ) => {
    const clickedButton = event.currentTarget as HTMLButtonElement;
    const id = clickedButton.id as "buy" | "rent";
    if (id == activeHeaderButton) {
      switch (id) {
        case "buy":
          setRouter("buy");
          break;
        case "rent":
          if (selectedRentDay > 0) setRouter("rent");
          break;
        default:
          setRouter("buy");
          break;
      }
      return;
    }
    setActiveHeaderButton(id);
  };
  return (
    <div>
      <div className="g_header">
        <p>
          {OpenedGallery.name} / {locale.buy_and_rent}
        </p>
      </div>
      <div className="g_header_buttons mt-6">
        <div className="flex items-center">
          <button
            id="buy"
            className={classNames({ active: activeHeaderButton == "buy" })}
            onClick={handleActiveHeaderButton}
          >
            <span>{locale.buy_text}</span>
          </button>
          {OpenedGallery?.vehiclesBeRented?.active && (
            <button
              id="rent"
              className={classNames({ active: activeHeaderButton == "rent" })}
              onClick={handleActiveHeaderButton}
            >
              <span>{locale.rent_text}</span>
            </button>
          )}
        </div>
      </div>
      <div className="my-4">
        {activeHeaderButton == "rent" && <ChoosingRentalDay />}
      </div>
    </div>
  );
};
export default LeftMenu;
