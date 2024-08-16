import React, {
  createContext,
  useState,
  useEffect,
  useMemo,
  useCallback,
} from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import {
  CarStatsProps,
  DataContextProps,
  OpenedGalleryProps,
  SongProps,
} from "../types/DataProviderTypes";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import { IColor } from "react-color-palette";
import { debugLog, formatNumberWithComma } from "../utils/misc";
import useRouter from "../hooks/useRouter";
import { useVisibility } from "../hooks/useVisibility";

debugData([
  {
    action: "load_gallery",
    data: {
      name: "RIDES",
      vehicles: {
        sportclassics: [
          {
            name: "buffalo",
            label: "Buffalo",
            drift: 40,
            grip: 60,
            road: "OFF-ROAD",
            sec_0_100: 2.8,
            top_speed: 318,
            traction: "AWD",
            logo: "bmw",
            price: 192000,
            coinPrice: 1000,
            model: "",
          },
          {
            name: "buffalo2",
            label: "Buffalo GT",
            drift: 50,
            grip: 50,
            road: "OFF-ROAD",
            sec_0_100: 1.8,
            top_speed: 300,
            traction: "AMD",
            logo: "bmw",
            price: 192000,
            coinPrice: 1000,
          },
        ],
      },
      vehiclesBeRented: {
        active: true,
        percentageOfRentalFee: 10,
      },
      discount: {
        active: true,
        percentage: 12,
      },
      buyWithBlackMoney: {
        active: true,
        multiplier: 2.0,
      },
      buyWithCoin: {
        active: true,
      },
      customPlate: {
        active: true,
        price: 1500,
      },
    },
  },
]);
debugData([
  {
    action: "setPlayingSong",
    data: {
      on: true,
      file: "",
      author: "UZI",
      name: "HELIKOPTER",
    } as SongProps,
  },
]);
debugData([
  {
    action: "setBankBalance",
    data: "250,000",
  },
]);

export const DataCtx = createContext<DataContextProps>({} as DataContextProps);

export const DataProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const { visible } = useVisibility();
  const { setRouter } = useRouter();
  const [OpenedGallery, setOpenedGallery] = useState<OpenedGalleryProps>(
    {} as OpenedGalleryProps
  );
  const [calani, setCalani] = useState<HTMLAudioElement | null>(null);
  const [playingSong, setPlayingSong] = useState<SongProps>({} as SongProps);
  const [bankBalance, setBankBalance] = useState<string>("0");
  const [selectedCategory, setSelectedCategory] = useState<string>("");
  const [selectedCar, setSelectedCar] = useState<CarStatsProps>(
    {} as CarStatsProps
  );
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [selectedRentDay, setSelectedRentDay] = useState<number>(0);
  const [carCategories, setCarCategories] = useState<string[]>([]);
  const [isCompareActive, setIsCompareActive] = useState<boolean>(false);
  const [comparedVehicle, setComparedVehicle] = useState<CarStatsProps>(
    {} as CarStatsProps
  );

  useNuiEvent<OpenedGalleryProps>("load_gallery", (gallery) => {
    if (!gallery.vehicles) {
      debugLog("Gallery vehicles not found !", "load_gallery");
      return;
    }
    setOpenedGallery(gallery);
    const _categories = Object.keys(gallery.vehicles);
    setCarCategories(_categories);
    setSelectedCategory(_categories[0]);
    setSelectedCar(gallery.vehicles[_categories[0]][0]);
  });

  useNuiEvent<SongProps>("setPlayingSong", setPlayingSong);
  useNuiEvent<number>("setBankBalance", (balance) => {
    setBankBalance(formatNumberWithComma(balance));
  });
  useNuiEvent<CarStatsProps>("setSelectedCar", setSelectedCar);
  useNuiEvent<string[]>("setCarCategories", setCarCategories);
  useNuiEvent<string>("setSelectedCategory", setSelectedCategory);
  useNuiEvent("resetFrame", () => {
    setRouter("home");
    setComparedVehicle({} as CarStatsProps);
    setIsCompareActive(false);
    setSelectedRentDay(0);
    setSelectedCar({} as CarStatsProps);
    setSelectedCategory("");
    setPlayingSong({} as SongProps);
    setCarCategories([]);
  });

  useEffect(() => {
    if (isLoading) {
      const timeoutId = setTimeout(() => {
        setIsLoading(false);
      }, 1000);
      return () => {
        clearTimeout(timeoutId);
      };
    }
  }, [isLoading]);

  useEffect(() => {
    if (visible) return;
    if (calani && !calani.paused) {
      calani.pause();
      setCalani(null);
      setPlayingSong((prev) => {
        return {
          ...prev,
          on: false,
        };
      });
    }
  }, [visible, calani]);

  const updateCompareCamera = async () => {
    const response = await fetchNui("setCompareCameraCoords");
    setOpenedGallery((prevState) => {
      return {
        ...prevState,
        currentCam: response.currentCam,
      };
    });
  };

  const changeVehicleColor = (vehicle: CarStatsProps, color: IColor): void => {
    const toInteger = (value: any) =>
      Math.round(Math.min(255, Math.max(0, value)));
    const integerColorObject = {
      r: toInteger(color.rgb.r),
      g: toInteger(color.rgb.g),
      b: toInteger(color.rgb.b),
      a: toInteger(color.rgb.a),
    };
    fetchNui("setVehicleColor", {
      vehicle: vehicle.entity,
      color: integerColorObject,
    });
  };

  const startTestDrive = useCallback(() => {
    fetchNui("testDrive", {
      vehicle: selectedCar,
    });
  }, [selectedCar]);

  const startRotatingVehicle = () => {
    fetchNui("startRotatingVehicle");
  };

  const stopRotatingVehicle = () => {
    fetchNui("stopRotatingVehicles");
  };

  const ConfirmBuyVehicle = async (
    vehicle: CarStatsProps,
    customPlate: string,
    paymentMethod: string
  ): Promise<boolean | string> => {
    try {
      const response = await fetchNui("BuyAVehicle", {
        vehicle: vehicle,
        customPlate: customPlate,
        paymentMethod: paymentMethod,
      });
      if (response.status == false) {
        return response.error as string;
      }
      return true;
    } catch (error) {
      return false;
    }
  };

  const ConfirmRentVehicle = async (
    vehicle: CarStatsProps,
    customPlate: string,
    paymentMethod: string,
    rentedDay: number
  ): Promise<boolean | string> => {
    try {
      const response = await fetchNui("RentAVehicle", {
        vehicle: vehicle,
        customPlate: customPlate,
        paymentMethod: paymentMethod,
        rentedDay: rentedDay,
      });
      if (response.status == false) {
        return response.error as string;
      }
      return true;
    } catch (error) {
      return false;
    }
  };

  const value = useMemo(
    () => ({
      playingSong,
      setPlayingSong,
      setOpenedGallery,
      OpenedGallery,
      bankBalance,
      setBankBalance,
      selectedCar,
      setSelectedCar,
      selectedRentDay,
      setSelectedRentDay,
      carCategories,
      selectedCategory,
      setSelectedCategory,
      isCompareActive,
      setIsCompareActive,
      comparedVehicle,
      setComparedVehicle,
      updateCompareCamera,
      changeVehicleColor,
      startTestDrive,
      startRotatingVehicle,
      stopRotatingVehicle,
      ConfirmBuyVehicle,
      ConfirmRentVehicle,
      calani,
      setCalani,
    }),
    [
      playingSong,
      OpenedGallery,
      bankBalance,
      selectedCar,
      selectedRentDay,
      carCategories,
      selectedCategory,
      isCompareActive,
      comparedVehicle,
      startTestDrive,
      calani,
    ]
  );

  return <DataCtx.Provider value={value}>{children}</DataCtx.Provider>;
};
