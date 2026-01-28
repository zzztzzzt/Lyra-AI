import React from "react";

import type { OklchState } from "../App";
import type { ColorData } from "../ActionBarArea";

interface Props {
  gradient: string;
  setColorData: React.Dispatch<React.SetStateAction<ColorData>>;
  colorA: OklchState;
  colorB: OklchState;
  colorM: OklchState;
  btnText: string;
}

const GradientBtnBasic: React.FC<Props> = ({ gradient, setColorData, colorA, colorB, colorM, btnText }) => {
  const handleClick = () => {
    if (btnText === "Add") {
      setColorData(prev => {
        const lastPalette = prev.palettes[prev.palettes.length - 1];
        
        const currentCount = lastPalette ? lastPalette.length : 0;
        
        let newColors: number[][] = [];
        
        if (currentCount === 0 || currentCount === 7) {
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