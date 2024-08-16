import React, { createContext, useEffect, useMemo, useState } from "react";
import { PageTypes, RouterProviderProps } from "../types/RouterProviderTypes";
import Gallery from "../pages/Gallery";
import BuyVehicle from "../pages/Buy";
import RentVehicle from "../pages/Rent";

export const RouterCtx = createContext<RouterProviderProps>(
  {} as RouterProviderProps
);

export const RouterProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [router, setRouter] = useState<PageTypes>("home");
  const [page, setPage] = useState<React.ReactNode | null>(null);

  useEffect(() => {
    if (router == "home") setPage(<Gallery />);
    else if (router == "buy") setPage(<BuyVehicle />);
    else if (router == "rent") setPage(<RentVehicle />);
    else setPage(<Gallery />);
  }, [router]);

  const value = useMemo(() => {
    return {
      router,
      setRouter,
      page,
    };
  }, [router, page]);

  return <RouterCtx.Provider value={value}>{children}</RouterCtx.Provider>;
};

export default RouterProvider;
