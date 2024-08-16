import React, { useRef, useState } from "react";

interface SliderProps {
  children: React.ReactNode;
  className?: string;
}

const Slider: React.FC<SliderProps> = ({ children, className }) => {
  const scrollBarRef = useRef<HTMLDivElement | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const [startX, setStartX] = useState(0);
  const [scrollLeft, setScrollLeft] = useState(0);

  const handleMouseDown = (e: React.MouseEvent<HTMLDivElement>) => {
    if (scrollBarRef.current) {
      setIsDragging(true);
      setStartX(e.pageX - scrollBarRef.current.offsetLeft);
      setScrollLeft(scrollBarRef.current.scrollLeft);
      e.preventDefault();
    }
  };

  const handleMouseMove = (
    e: React.MouseEvent<HTMLDivElement> | MouseEvent
  ) => {
    if (!isDragging) return;
    if (scrollBarRef.current) {
      const x = e.pageX - scrollBarRef.current.offsetLeft;
      const distance = x - startX;
      scrollBarRef.current.scrollLeft = scrollLeft - distance;
      e.preventDefault();
    }
  };

  const handleMouseUp = () => {
    setIsDragging(false);
  };

  return (
    <div
      className={className}
      ref={scrollBarRef}
      onMouseDown={handleMouseDown}
      onMouseMove={handleMouseMove}
      onMouseUp={handleMouseUp}
    >
      {children}
    </div>
  );
};

export default Slider;
