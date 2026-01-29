import './App.css'
import { useState, useMemo } from "react";
import MainColorArea from './MainColorArea';
import GradientArea from './GradientArea';
import ShowcaseArea from './ShowcaseArea';
import ActionBarArea from './ActionBarArea';

export interface OklchState {
  l: number;
  c: number;
  h: number;
}

export interface ColorData {
  palettes: number[][][];
}

const toStr = (col: OklchState) => `oklch(${(col.l * 100).toFixed(0)}% ${col.c.toFixed(3)} ${col.h})`;

const getMidColor = (colorA: OklchState, colorB: OklchState): OklchState => {
  let h1 = colorA.h;
  let h2 = colorB.h;

  let diff = h2 - h1;
  if (diff > 180) {
    h2 -= 360;
  } else if (diff < -180) {
    h2 += 360;
  }

  let hMid = (h1 + h2) / 2;
  // Ensure the result returns to the positive range of 0-360
  hMid = (hMid + 360) % 360;

  return { l: (colorA.l + colorB.l) / 2, c: (colorA.c + colorB.c) / 2, h: hMid };
};

function App() {
  const [colorData, setColorData] = useState<ColorData>({ palettes: [] });
  const [colorM, setColorM] = useState<OklchState>({ l: 0.92, c: 0.141, h: 252 });
  const [colorA, setColorA] = useState<OklchState>({ l: 0.8, c: 0.186, h: 266 });
  const [colorB, setColorB] = useState<OklchState>({ l: 1, c: 0.06, h: 225 });

  // Derived State
  const mainColorLock = useMemo(() => {
    const lastPalette = colorData.palettes[colorData.palettes.length - 1];
    const currentCount = lastPalette ? lastPalette.length : 0;

    return currentCount > 0 && currentCount < 7;
  }, [colorData]);

  const accentM = useMemo(() => toStr(colorM), [colorM]);
  const accentA = useMemo(() => toStr(colorA), [colorA]);
  const accentB = useMemo(() => toStr(colorB), [colorB]);
  const mainGradient = `linear-gradient(90deg in oklch, ${accentA}, ${accentB})`;
  
  const midColor = useMemo(() => getMidColor(colorA, colorB), [colorA, colorB]);
  const accentMid = useMemo(() => toStr(midColor), [midColor]);

  return (
    <div className='lg:flex lg:flex-row-reverse'>
      <div
        className='max-lg:max-w-100 lg:w-1/4 lg:min-w-100 lg:h-screen max-lg:mx-auto overflow-auto lg:border-l-solid border-2 font-prosto-one'
        style={{ borderColor: accentM }}
      >
        <div className='mt-6 text-center text-3xl lg:text-2.5xl'>
          <span className='text-transparent bg-clip-text' style={{ backgroundColor: accentM }}>Lyra </span>
          <span className='text-transparent bg-clip-text' style={{ backgroundImage: mainGradient }}>training system</span>
        </div>

        <MainColorArea
          colorM={colorM}
          setColorM={setColorM}
          accentM={accentM}
          mainColorLock={mainColorLock}
        />

        <GradientArea
          colorA={colorA}
          setColorA={setColorA}
          colorB={colorB}
          setColorB={setColorB}
          gradient={mainGradient}
        />
      </div>
      <div className='relative w-full max-lg:max-w-100 lg:h-screen max-lg:mx-auto'>
        <ShowcaseArea
          gradient={mainGradient}
          midColor={accentMid}
          accentM={accentM}
        />

        <ActionBarArea
          gradient={mainGradient}
          colorA={colorA}
          colorB={colorB}
          colorM={colorM}
          accentM={accentM}
          colorData={colorData}
          setColorData={setColorData}
        />
      </div>
    </div>
  )
}

export default App
