export interface ScrollbarProps {
  ref: React.RefObject<HTMLDivElement>;
  setIsDragging: React.Dispatch<React.SetStateAction<boolean>>;
  setStartX: React.Dispatch<React.SetStateAction<number>>;
  setScrollLeft: React.Dispatch<React.SetStateAction<number>>;
}
