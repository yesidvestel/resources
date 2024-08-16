import "./index.sass";
import { SlArrowLeft } from "react-icons/sl";
import useRouter from "../../hooks/useRouter";
import classNames from "classnames";
import { LiaUserSecretSolid } from "react-icons/lia";
import { useCallback, useEffect, useState } from "react";
import useLocales from "../../hooks/useLocales";
import useData from "../../hooks/useData";
import { formatNumberWithComma } from "../../utils/misc";

const RentVehicle: React.FC = () => {
  const { OpenedGallery, selectedCar, selectedRentDay, ConfirmRentVehicle } =
    useData();
  const { setRouter } = useRouter();
  const { locale } = useLocales();

  const [paymentMethod, setPaymentMethod] = useState<string>("");
  const [paymentError, setPaymentError] = useState<boolean>(false);
  const [customPlate, setCustomPlate] = useState<string>("");
  const [plateError, setPlateError] = useState<boolean>(false);
  const [totalPrice, setTotalPrice] = useState<number>(selectedCar.price);
  const [rentError, setRentError] = useState<boolean | string>(false);

  const handleGoBack = () => {
    setRouter("home");
  };

  const calculateTotalPrice = useCallback((): number => {
    const vehiclePrice =
      Math.floor(
        (selectedCar.price *
          OpenedGallery.vehiclesBeRented.percentageOfRentalFee) /
          100
      ) * selectedRentDay;
    let platePrice = 0;
    if (OpenedGallery?.customPlate.active) {
      if (customPlate.length >= 4) {
        platePrice = OpenedGallery?.customPlate?.price ?? 0;
      }
    }
    return vehiclePrice + platePrice;
  }, [selectedCar, OpenedGallery, customPlate, selectedRentDay]);

  const handlePaymentMethodChange = (event: any) => {
    setPaymentMethod(event.target.value);
  };

  const handleChangeCustomPlate = (event: any) => {
    const newValue = event.target.value.replace(/\s+/g, " ");
    setCustomPlate(newValue);
    if (newValue.length < 4 || newValue.length > 8) {
      if (newValue.length == 0) {
        setPlateError(false);
      } else {
        setPlateError(true);
      }
    } else {
      setPlateError(false);
    }
  };

  const handleRentClick = async () => {
    if (paymentMethod == "") {
      setPaymentError(true);
      return;
    }
    if (plateError) {
      return;
    }
    const r = await ConfirmRentVehicle(
      selectedCar,
      customPlate.trim(),
      paymentMethod,
      selectedRentDay
    );
    if (typeof r != "boolean") setRentError(r);
    else {
      setRentError(false);
      setRouter("home");
    }
  };

  useEffect(() => {
    if (paymentError) {
      setTimeout(() => {
        setPaymentError(false);
      }, 1700);
    }
  }, [paymentError]);

  useEffect(() => {
    setTotalPrice(calculateTotalPrice());
  }, [paymentMethod, customPlate, calculateTotalPrice]);

  return (
    <div className="h-full w-full flex items-center justify-center bg-black bg-opacity-40 page-rent">
      <div className="relative flex w-[32rem] bg-opacity-40 flex-col rounded-md _card p-4">
        <div className="p-3">
          <hr className="border-white/10 mb-2" />
          <h5 className="header mb-4 antialiased w-full flex items-center justify-between">
            <div className="flex gap-2 items-center">
              <button className="group" onClick={handleGoBack}>
                <SlArrowLeft className="w-4 h-4 fill-gray-500 group-hover:fill-white" />
              </button>
              <span>{locale.rent_text}</span>
            </div>
            <div className="price">
              {paymentMethod == "black_money" && (
                <LiaUserSecretSolid className="float-left mt-1 mr-0.5 text-[#FF0008]" />
              )}
              {formatNumberWithComma(totalPrice)}
              <span
                className={classNames("dollar", {
                  devil: paymentMethod == "black_money",
                })}
              >
                $
              </span>
            </div>
          </h5>
          <div className="flex flex-col gap-2 content">
            <div className="border-b border-white border-opacity-20 flex items-center justify-between line">
              <p className="block text-white text-opacity-60 title uppercase">
                {locale.rent_day_text}
              </p>
              <p className="block text-white content">
                {selectedRentDay} {locale.day_text}
              </p>
            </div>
            <div className="border-b border-white border-opacity-20 flex items-center justify-between line">
              <p className="block text-white text-opacity-60 title uppercase">
                {locale.vehicle_text}
              </p>
              <p className="block text-white content">{selectedCar.label}</p>
            </div>
            <div className="border-b border-white border-opacity-20 flex items-center justify-between line">
              <p className="block text-white text-opacity-60 title uppercase">
                {locale.class_text}
              </p>
              <p className="block text-white content">{selectedCar.road}</p>
            </div>
            {OpenedGallery?.customPlate?.active && (
              <>
                <div className="border-b border-white border-opacity-20 flex items-center justify-between line">
                  <p className="block text-white text-opacity-60 title uppercase">
                    {locale.plate_text}{" "}
                    <span className="text-xs text-white text-opacity-50">
                      [{OpenedGallery.customPlate.price}$]
                    </span>
                  </p>
                  <div className="custom-plate my-1">
                    <input
                      maxLength={8}
                      minLength={8}
                      id="customplate"
                      type="input"
                      className="icustom-plate"
                      placeholder={locale.plate_text}
                      value={customPlate}
                      onChange={handleChangeCustomPlate}
                    />
                    <label
                      htmlFor="customplate"
                      className="lcustom-plate sr-only"
                    >
                      {locale.plate_text}
                    </label>
                  </div>
                </div>
                {plateError && (
                  <div className="flex flex-col">
                    <p className="flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1">
                      * {locale.custom_plate_error_1}
                    </p>
                    <p className="flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1">
                      * {locale.custom_plate_error_2}
                    </p>
                  </div>
                )}
              </>
            )}
            <div
              className={classNames(
                "border-b border-white border-opacity-20 flex items-center justify-between line",
                {
                  "border-b-red-500 !border-opacity-100 animate-bounce":
                    paymentError,
                }
              )}
            >
              <p className="block text-white text-opacity-60 title uppercase">
                {locale.payment_text}
              </p>
              <div>
                <label htmlFor="payment_method" className="sr-only">
                  {locale.payment_text}
                </label>
                <select
                  id="payment_method"
                  className="cursor-pointer block text-right px-2 bg-transparent text-white content uppercase py-2 focus:outline-none focus:ring-0"
                  value={paymentMethod}
                  onChange={handlePaymentMethodChange}
                >
                  <option value="" disabled>
                    {locale.choose_payment_text}
                  </option>
                  <option value="cash">{locale.cash_text}</option>
                  <option value="bank">{locale.bank_text}</option>
                </select>
              </div>
            </div>
          </div>
          {typeof rentError != "boolean" && (
            <div>
              <div className="flex flex-col">
                <p className="flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1">
                  * {rentError}
                </p>
              </div>
            </div>
          )}
        </div>
        <div className="px-1 py-3 confirm flex items-center justify-around">
          <button
            onClick={handleRentClick}
            type="button"
            className="select-none rounded-lg py-2 px-8 border border-white/40 border-opacity-40 hover:border-ocean_green/60 hover:bg-ocean_green/60 font-bold uppercase shadow shadow-white/10 transition-all hover:shadow-lg hover:shadow-ocean_green/40"
          >
            {locale.rent_text}
          </button>
          <button
            onClick={handleGoBack}
            type="button"
            className="select-none rounded-lg py-2 px-8 border border-white/40 border-opacity-40 hover:border-red-600/60 hover:bg-red-600/60 font-bold uppercase shadow shadow-white/10 transition-all hover:shadow-lg hover:shadow-red-600/40"
          >
            {locale.cancel_text}
          </button>
        </div>
      </div>
    </div>
  );
};

export default RentVehicle;
