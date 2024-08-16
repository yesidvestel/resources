export type PageTypes = "home" | "buy" | "rent";

export type RouterProviderProps = {
  router: PageTypes;
  setRouter: (router: PageTypes) => void;
  page: React.ReactNode;
};
