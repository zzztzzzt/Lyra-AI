import React from "react";

import type { OklchState } from "../App";
import type { ColorData } from "../App";

interface Props {
  gradient: string;
  setColorData: React.Dispatch<React.SetStateAction<ColorData>>;
  colorA: OklchState;
  colorB: OklchState;
  colorM: OklchState;
  btnText: string;
}

const GradientBtnBasic: React.FC<Props> = ({ gradient, setColorData, colorA, colorB, colorM, btnText }) => {
  const handleAdd = () => {
    setColorData(prev => {
      const lastPalette = prev.palettes[prev.palettes.length - 1];
      const currentCount = lastPalette ? lastPalette.length : 0;
      const isNewPalette = currentCount === 0 || currentCount === 7;
      
      let newColors: number[][] = [];
      
      if (isNewPalette) {
        newColors = [ [colorM.l, colorM.c, colorM.h], [colorA.l, colorA.c, colorA.h], [colorB.l, colorB.c, colorB.h] ];
        return {
          ...prev,
          palettes: [...prev.palettes, newColors]
        };
      } else {
        newColors = [ [colorA.l, colorA.c, colorA.h], [colorB.l, colorB.c, colorB.h] ];
        const updatedPalette = [...lastPalette, ...newColors];
        return {
          ...prev,
          palettes: [...prev.palettes.slice(0, -1), updatedPalette]
        };
      }
    });
  };

  const handleUndo = () => {
    setColorData(prev => {
      if (prev.palettes.length === 0) return prev;

      const lastPalette = prev.palettes[prev.palettes.length - 1];
      
      // 3 colors, delete whole arr
      if (lastPalette.length <= 3) {
        return {
          ...prev,
          palettes: prev.palettes.slice(0, -1)
        };
      } 

      // More than 3 colors, delete the last 2
      const updatedPalette = lastPalette.slice(0, -2);
      return {
        ...prev,
        palettes: [...prev.palettes.slice(0, -1), updatedPalette]
      };
    });
  };

  const handleClick = () => {
    if (btnText === "Add") {
      handleAdd();
    }
    if (btnText === "Undo") {
      handleUndo();
    }
  };

  return(
    <div
      className="h-12 lg:h-10 p-1.5 lg:p-1 rounded-lg font-prosto-one cursor-pointer" style={{ backgroundImage: gradient }}
      onClick={ handleClick }
    >
        <div className="bg-white lg:w-40 h-full flex justify-center items-center text-center text-2.5xl lg:text-lg text-gray-500 rounded-md">{btnText}</div>
    </div>
  );
};

export default GradientBtnBasic;