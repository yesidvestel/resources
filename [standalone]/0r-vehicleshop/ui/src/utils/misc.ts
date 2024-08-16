import { IColor } from "react-color-palette";

interface CustomWindow extends Window {
  invokeNative?: unknown;
}

// Will return whether the current environment is in a regular browser
// and not CEF
export const isEnvBrowser = (): boolean =>
  !(window as CustomWindow).invokeNative;

// Basic no operation function
export const noop = (): void => {};

export function debugLog(error: any, functionName?: string) {
  const now = new Date();
  const timestamp = now.toISOString();
  const errorMessage = error.message || "No Message.";
  const errorStack = error.stack || "No Stack.";

  const logMessage = `
    Info: ${functionName ?? "?"},
    Time: ${timestamp}
    Error Message: ${errorMessage}
    Error Stack Trace: ${errorStack}
    Error: ${error}
  `;
  console.error(logMessage);
}

export function formatNumberWithComma(number: number) {
  number = number ?? 0;
  return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

export function colorToRgbAndHsv(color: string): IColor {
  const randomColorHex = color;
  const hexToRgb = (hex: string) => {
    hex = hex.replace(/^#/, "");
    return {
      r: parseInt(hex.substring(0, 2), 16),
      g: parseInt(hex.substring(2, 4), 16),
      b: parseInt(hex.substring(4, 6), 16),
      a: 255,
    };
  };
  const hexToHsv = (hex: string) => {
    hex = hex.replace(/^#/, "");
    const rgb = hexToRgb(hex);
    const r = rgb.r / 255;
    const g = rgb.g / 255;
    const b = rgb.b / 255;

    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);

    let h = 0,
      s = 0,
      v = 0;

    if (max === min) {
      h = 0;
    } else if (max === r) {
      h = 60 * ((g - b) / (max - min));
    } else if (max === g) {
      h = 60 * ((b - r) / (max - min) + 2);
    } else {
      h = 60 * ((r - g) / (max - min) + 4);
    }

    if (h < 0) {
      h += 360;
    }

    s = max === 0 ? 0 : (max - min) / max;
    v = max;

    return {
      h: Math.round(h),
      s: Math.round(s * 100),
      v: Math.round(v * 100),
      a: 255,
    };
  };

  const rgbColor = hexToRgb(randomColorHex);
  const hsvColor = hexToHsv(randomColorHex);

  return {
    hex: randomColorHex,
    rgb: rgbColor,
    hsv: hsvColor,
  };
}

export const colors: IColor[] = [
  colorToRgbAndHsv("#000000"),
  colorToRgbAndHsv("#0d1116"),
  colorToRgbAndHsv("#1c1d21"),
  colorToRgbAndHsv("#f0f0f0"),
  colorToRgbAndHsv("#fffff6"),
  colorToRgbAndHsv("#c2c4c6"),
  colorToRgbAndHsv("#588157"),
  colorToRgbAndHsv("#003049"),
  colorToRgbAndHsv("#07505e"),
  colorToRgbAndHsv("#1282a2"),
  colorToRgbAndHsv("#37474f"),
  colorToRgbAndHsv("#555555"),
  colorToRgbAndHsv("#c0392b"),
  colorToRgbAndHsv("#e74c3c"),
  colorToRgbAndHsv("#d35400"),
  colorToRgbAndHsv("#e67e22"),
  colorToRgbAndHsv("#f39c12"),
  colorToRgbAndHsv("#fdda24"),
  colorToRgbAndHsv("#2ecc71"),
  colorToRgbAndHsv("#27ae60"),
  colorToRgbAndHsv("#3498db"),
  colorToRgbAndHsv("#2980b9"),
  colorToRgbAndHsv("#1abc9c"),
  colorToRgbAndHsv("#16a085"),
  colorToRgbAndHsv("#9b59b6"),
  colorToRgbAndHsv("#2c3e50"),
  colorToRgbAndHsv("#e74c3c"),
  colorToRgbAndHsv("#8e44ad"),
  colorToRgbAndHsv("#3498db"),
  colorToRgbAndHsv("#2ecc71"),
  colorToRgbAndHsv("#f39c12"),
  colorToRgbAndHsv("#16a085"),
  colorToRgbAndHsv("#e67e22"),
  colorToRgbAndHsv("#1abc9c"),
  colorToRgbAndHsv("#2c3e50"),
  colorToRgbAndHsv("#752b19"),
  colorToRgbAndHsv("#f21f99"),
  colorToRgbAndHsv("#6b1f7b"),
  colorToRgbAndHsv("#afd6e4"),
  colorToRgbAndHsv("#f8b658"),
  colorToRgbAndHsv("#83c566"),
  colorToRgbAndHsv("#c00e1a"),
  colorToRgbAndHsv("#2446a8"),
  colorToRgbAndHsv("#4271e1"),
  colorToRgbAndHsv("#1f2852"),
  colorToRgbAndHsv("#ffcf20"),
  colorToRgbAndHsv("#916532"),
  colorToRgbAndHsv("#3a2a1b"),
  colorToRgbAndHsv("#621276"),
  colorToRgbAndHsv("#afd6e4"),
  colorToRgbAndHsv("#354158"),
  colorToRgbAndHsv("#253aa7"),
  colorToRgbAndHsv("#2f2d52"),
  colorToRgbAndHsv("#66b81f"),
  colorToRgbAndHsv("#9c1016"),
  colorToRgbAndHsv("#778794"),
  colorToRgbAndHsv("#444e54"),
  colorToRgbAndHsv("#402e2b"),
  colorToRgbAndHsv("#6a747c"),
  colorToRgbAndHsv("#f2ad2e"),
];
