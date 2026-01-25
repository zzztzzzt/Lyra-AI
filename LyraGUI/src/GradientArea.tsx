import React from "react";

import type { OklchState } from "./App";
import ColorController from "./components/ColorController";

interface Props {
  colorA: OklchState;
  setColorA: React.Dispatch<React.SetStateAction<OklchState>>;
  colorB: OklchState;
  setColorB: React.Dispatch<React.SetStateAction<OklchState>>;
  gradient: string;
}

const GradientArea: React.FC<Props> = ({ colorA, setColorA, colorB, setColorB, gradient }) => {
  return(
      <div className="flex flex-col items-center pt-8 pb-8 px-5 md:px-10">
        <ColorController color={colorA} setColor={setColorA} />

        <div className='w-full h-15 my-6 rounded-lg' style={{ backgroundImage: gradient }}></div>

        <ColorController color={colorB} setColor={setColorB} />
      </div>
  );
};

export default GradientArea;