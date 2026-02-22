import React, { useState } from "react";

import type { OklchState } from "../App";
import type { ColorData } from "../App";

interface Props {
  gradient: string;
  colorData: ColorData;
  setColorData: React.Dispatch<React.SetStateAction<ColorData>>;
  colorA: OklchState;
  colorB: OklchState;
  colorMid: OklchState;
  colorM: OklchState;
  btnText: string;
}

const GradientBtnBasic: React.FC<Props> = ({ gradient, colorData, setColorData, colorA, colorB, colorMid, colorM, btnText }) => {
  const [isTraining, setIsTraining] = useState(false);
  const [trainMessage, setTrainMessage] = useState("Train");

  const handleAdd = () => {
    setColorData(prev => {
      const lastPalette = prev.palettes[prev.palettes.length - 1];
      const currentCount = lastPalette ? lastPalette.length : 0;
      const isNewPalette = currentCount === 0 || currentCount === 10;
      
      let newColors: number[][] = [];
      
      if (isNewPalette) {
        newColors = [
          [colorM.l, colorM.c, colorM.h],
          [colorA.l, colorA.c, colorA.h],
          [colorMid.l, colorMid.c, colorMid.h],
          [colorB.l, colorB.c, colorB.h]
        ];
        return {
          ...prev,
          palettes: [...prev.palettes, newColors]
        };
      } else {
        newColors = [
          [colorA.l, colorA.c, colorA.h],
          [colorMid.l, colorMid.c, colorMid.h],
          [colorB.l, colorB.c, colorB.h]
        ];
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
      
      // 4 colors, delete whole arr
      if (lastPalette.length <= 4) {
        return {
          ...prev,
          palettes: prev.palettes.slice(0, -1)
        };
      } 

      // More than 4 colors, delete the last 3
      const updatedPalette = lastPalette.slice(0, -3);
      return {
        ...prev,
        palettes: [...prev.palettes.slice(0, -1), updatedPalette]
      };
    });
  };

  const handleTrain = async () => {
    if (isTraining) return;

    setIsTraining(true);
    setTrainMessage("...");

    try {
      const response = await fetch('http://localhost:8000/api/train', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(colorData),
      });
  
      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to submit training data');
      }
  
      const result = await response.json();
      console.log('Training data submitted successfully:', result);

      setTrainMessage("Finished");

      setTimeout(() => {
        setTrainMessage("Train");
        setIsTraining(false);
      }, 1000);

      return result;
    } catch (error) {
      console.error('Error submitting training data:', error);

      setTrainMessage("Failed");
      setTimeout(() => {
        setTrainMessage("Train");
        setIsTraining(false);
      }, 1000);

      throw error;
    }
  };

  const handleClick = () => {
    if (btnText === "Add") {
      handleAdd();
    }
    if (btnText === "Undo") {
      handleUndo();
    }
    if (btnText === "Train") {
      handleTrain();
    }
  };

  return(
    <div
      className="h-12 lg:h-10 p-1.5 lg:p-1 rounded-lg font-prosto-one cursor-pointer" style={{ backgroundImage: gradient }}
      onClick={ handleClick }
    >
        <div className={`bg-white lg:w-40 h-full flex justify-center items-center text-center text-2.5xl lg:text-lg rounded-md
          ${ btnText !== "Train" ? "text-gray-500" : "" }
          ${ btnText === "Train" && !isTraining ? "text-gray-500" : "" }
          
          ${ isTraining && trainMessage.includes("Finished") ? "text-green-400" : "" }
          ${ isTraining && trainMessage.includes("Failed") ? "text-red-400" : "" }

          ${ isTraining ? "cursor-not-allowed" : "" }
        `}>
          {btnText === "Train" ? trainMessage : btnText}
        </div>
    </div>
  );
};

export default GradientBtnBasic;
