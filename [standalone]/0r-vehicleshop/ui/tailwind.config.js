/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  darkMode: "class",
  theme: {
    extend: {
      transitionProperty: {
        width: "width",
      },
      colors: {
        ocean: "#00799F",
        ocean_green: "#00FF75",
      },
      fontFamily: {
        Microgramma_D_Extended: "Microgramma D Extended",
        HighriseBold: "HighriseBold",
        Mashetic: "Mashetic",
        SF_PRO_DISPLAY: "SF PRO DISPLAY",
        Antonio: "Antonio",
      },
    },
  },
  plugins: [],
};
