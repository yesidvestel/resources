import { IColor } from "react-color-palette";

export type OpenedGalleryProps = {
  name: string;
  vehicles: {
    [category: string]: CarStatsProps[];
  };
  vehiclesBeRented: {
    active: boolean;
    percentageOfRentalFee: number;
  };
  testDrive: {
    active: boolean;
  };
  discount: {
    active: boolean;
    percentage: number;
  };
  currentCam: "selected" | "compared";
  buyWithBlackMoney: {
    active: boolean;
    multiplier: number;
  };
  buyWithCoin: {
    active: boolean;
  };
  customPlate: {
    active: boolean;
    price: number;
  };
};

export type SongProps = {
  on: boolean;
  file: string;
  author: string;
  name: string;
  volume: number;
};

export type CarStatsProps = {
  entity: number;
  is_load: boolean;
  model: string;
  label: string;
  name: string;
  grip: number;
  drift: number;
  traction: string;
  road: string;
  top_speed: number;
  sec_0_100: number;
  price: number;
  coinPrice: number;
  color: string;
};

export type DataContextProps = {
  setOpenedGallery: React.Dispatch<React.SetStateAction<OpenedGalleryProps>>;
  OpenedGallery: OpenedGalleryProps;
  playingSong: SongProps;
  setPlayingSong: React.Dispatch<React.SetStateAction<SongProps>>;
  bankBalance: string;
  setBankBalance: React.Dispatch<React.SetStateAction<string>>;
  selectedCar: CarStatsProps;
  setSelectedCar: React.Dispatch<React.SetStateAction<CarStatsProps>>;
  selectedRentDay: number;
  setSelectedRentDay: React.Dispatch<React.SetStateAction<number>>;
  carCategories: string[];
  setSelectedCategory: React.Dispatch<React.SetStateAction<string>>;
  selectedCategory: string;
  isCompareActive: boolean;
  setIsCompareActive: React.Dispatch<React.SetStateAction<boolean>>;
  comparedVehicle: CarStatsProps;
  setComparedVehicle: React.Dispatch<React.SetStateAction<CarStatsProps>>;
  updateCompareCamera: () => void;
  changeVehicleColor: (vehicle: CarStatsProps, color: IColor) => void;
  startTestDrive: () => void;
  startRotatingVehicle: () => void;
  stopRotatingVehicle: () => void;
  ConfirmBuyVehicle: (
    vehicle: CarStatsProps,
    plate: string,
    paymentMethod: string
  ) => Promise<boolean | string>;
  ConfirmRentVehicle: (
    vehicle: CarStatsProps,
    plate: string,
    paymentMethod: string,
    rentedDay: number
  ) => Promise<boolean | string>;
  calani: HTMLAudioElement | null;
  setCalani: React.Dispatch<React.SetStateAction<HTMLAudioElement | null>>;
};
