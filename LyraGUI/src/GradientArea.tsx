import React, { useState, useMemo } from "react";

import ColorController from "./components/ColorController";

interface OklchState {
    l: number;
    c: number;
    h: number;
}

const toStr = (col: OklchState) => `oklch(${(col.l * 100).toFixed(0)}% ${col.c.toFixed(3)} ${col.h})`;

const GradientArea: React.FC = () => {
  const [colorA, setColorA] = useState<OklchState>({ l: 0.7, c: 0.15, h: 250 });
  const [colorB, setColorB] = useState<OklchState>({ l: 0.6, c: 0.25, h: 20 });

  const accentA = useMemo(() => toStr(colorA), [colorA]);
  const accentB = useMemo(() => toStr(colorB), [colorB]);
  const mainGradient = `linear-gradient(90deg, ${accentA}, ${accentB})`;

  return(
      <div className="flex flex-col items-center pt-8 pb-8 px-5 md:px-10">
        <ColorController color={colorA} setColor={setColorA} />

        <div className='w-full h-15 my-6 rounded-lg' style={{ backgroundImage: mainGradient }}></div>

        <ColorController color={colorB} setColor={setColorB} />
      </div>
  );
};

export default GradientArea;