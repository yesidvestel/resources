import { createContext, useEffect, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import { LocaleContextProps, LocaleProps } from "../types/LocaleProviderTypes";
import { isEnvBrowser } from "../utils/misc";

debugData<LocaleProps>([
  {
    action: "setLocale",
    data: {
      buy_and_rent: "Buy and Rent",
      buy_text: "Buy",
      rent_text: "Rent",
      choosing_rental_day: "DAY",
      car_stats_tier: "Car Tier",
      car_stats_handling: "Handling",
      car_stats_grip: "Grip",
      car_stats_drift: "Drift",
      car_stats_traction: "Traction",
      car_stats_road: "Road",
      car_stats_top_speed: "Top Speed",
      test_drive_text: "Test Drive",
      vehicle_stats_text: "Vehicle Stats",
      vehicle_color_text: "Vehicle Color",
      vehicle_text: "Vehicle",
      class_text: "Class",
      payment_text: "Payment",
      choose_payment_text: "Choose a payment",
      cash_text: "Cash",
      bank_text: "Bank",
      black_money_text: "Black Money",
      plate_text: "Plate",
      custom_plate_error_1: "At least 4 characters Max",
      custom_plate_error_2: "Max 8 characters",
      cancel_text: "Cancel",
      rent_day_text: "Rent Day",
      day_text: "Day",
      purchase_with_coin_text: "ExCoin",
    },
  },
]);

export const LocaleCtx = createContext<LocaleContextProps>(
  {} as LocaleContextProps
);

export const LocaleProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [locale, setLocale] = useState<LocaleProps>({} as LocaleProps);

  useEffect(() => {
    if (isEnvBrowser()) return;
    fetchNui("loadLocaleFile");
  }, []);

  useNuiEvent("setLocale", async (data: LocaleProps) => setLocale(data));

  const value = {
    locale,
    setLocale,
  };

  return <LocaleCtx.Provider value={value}>{children}</LocaleCtx.Provider>;
};

export default LocaleProvider;
