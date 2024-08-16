import classNames from "classnames";
import useLocales from "../../../hooks/useLocales";
import useData from "../../../hooks/useData";

const ChoosingRentalDay = () => {
  const days = [];
  for (let i = 1; i <= 35; i++) {
    days.push(i);
  }
  const { locale } = useLocales();
  const { setSelectedRentDay, selectedRentDay } = useData();

  const handleChooseRentalDay = (event: React.MouseEvent<HTMLLIElement>) => {
    const target = event.currentTarget;
    const key = parseInt(target.getAttribute("data-day") || "0", 10);
    if (key > 30) return;
    setSelectedRentDay(key);
    const allLiElements = document.querySelectorAll("li[data-day]");
    allLiElements.forEach((li) => li.classList.remove("active"));
    allLiElements.forEach((li) => {
      const liDay = parseInt(li.getAttribute("data-day") || "0", 10);
      if (liDay <= key) {
        li.classList.add("active");
      }
    });
  };

  return (
    <div className="flex flex-col justify-center">
      <div className="choosing-rental-day">
        <div className="title flex items-center justify-center gap-4 py-2 mb-2">
          <div className="stick"></div>
          <div className="text">{locale.choosing_rental_day}</div>
          <div className="stick"></div>
        </div>
        <ul className="days grid grid-cols-7 text-center gap-4 px-3">
          {days.map((day) => (
            <li
              className={classNames(
                "day",
                { active: day <= selectedRentDay },
                { little: day > 9 },
                { "cursor-pointer": day <= 30 }
              )}
              key={day}
              data-day={day}
              onClick={handleChooseRentalDay}
            >
              {day <= 30 ? day : ""}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};
export default ChoosingRentalDay;
