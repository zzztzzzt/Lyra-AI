import './App.css'
import { useState, useMemo, type Dispatch, type SetStateAction } from "react";
import MainColorArea from './MainColorArea';
import GradientArea from './GradientArea';
import MiddleColorArea from './MiddleColorArea';
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
  // Convert OKLCH to OKLab (a, b)
  const toRad = (deg: number) => (deg * Math.PI) / 180;
  const toDeg = (rad: number) => (rad * 180) / Math.PI;

  const a1 = colorA.c * Math.cos(toRad(colorA.h));
  const b1 = colorA.c * Math.sin(toRad(colorA.h));
  
  const a2 = colorB.c * Math.cos(toRad(colorB.h));
  const b2 = colorB.c * Math.sin(toRad(colorB.h));

  // Linearly interpolate in OKLab space ( matches how CSS linear-gradient(in oklab, ...) )
  const midL = (colorA.l + colorB.l) / 2;
  const midA = (a1 + a2) / 2;
  const midB = (b1 + b2) / 2;

  // Convert back to OKLCH
  const midC = Math.sqrt(midA * midA + midB * midB);
  let midH = toDeg(Math.atan2(midB, midA));
  
  // Normalize hue to the range [0, 360)
  midH = (midH + 360) % 360;

  return { l: midL, c: midC, h: midH };
};

function App() {
  const [colorData, setColorData] = useState<ColorData>({ palettes: [] });
  const [colorM, setColorM] = useState<OklchState>({ l: 0.92, c: 0.141, h: 252 });
  const [colorA, setColorA] = useState<OklchState>({ l: 0.8, c: 0.186, h: 266 });
  const [colorB, setColorB] = useState<OklchState>({ l: 1, c: 0.06, h: 225 });
  const [colorMidCustom, setColorMidCustom] = useState<OklchState>(getMidColor(colorA, colorB));
  const [useCustomMid, setUseCustomMid] = useState<boolean>(false);

  // Derived State
  const mainColorLock = useMemo(() => {
    const lastPalette = colorData.palettes[colorData.palettes.length - 1];
    const currentCount = lastPalette ? lastPalette.length : 0;

    return currentCount > 0 && currentCount < 7;
  }, [colorData]);

  const accentM = useMemo(() => toStr(colorM), [colorM]);
  const accentA = useMemo(() => toStr(colorA), [colorA]);
  const accentB = useMemo(() => toStr(colorB), [colorB]);
  const mainGradient = `linear-gradient(90deg in oklab, ${accentA}, ${accentB})`;
  
  const midColor = useMemo(() => getMidColor(colorA, colorB), [colorA, colorB]);
  const activeMidColor = useMemo(() => (useCustomMid ? colorMidCustom : midColor), [useCustomMid, colorMidCustom, midColor]);
  const accentMid = useMemo(() => toStr(activeMidColor), [activeMidColor]);

  const setMidColorFromController: Dispatch<SetStateAction<OklchState>> = (next) => {
    const resolved = typeof next === "function"
      ? (next as (prev: OklchState) => OklchState)(useCustomMid ? colorMidCustom : midColor)
      : next;

    setColorMidCustom(resolved);
    setUseCustomMid(true);
  };

  const backToDefaultMid = () => {
    setUseCustomMid(false);
  };

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

        <MiddleColorArea
          colorMid={activeMidColor}
          setColorMid={setMidColorFromController}
          accentMid={accentMid}
          accentM={accentM}
          useCustomMid={useCustomMid}
          onBackToDefault={backToDefaultMid}
        />

        <div className='mb-6 text-center text-3xl lg:text-2.5xl'>
          <span className='text-transparent bg-clip-text' style={{ backgroundImage: mainGradient }}>middle color area</span>
        </div>
      </div>
      <div className='relative w-full max-lg:max-w-100 lg:h-screen max-lg:mx-auto'>
        <ShowcaseArea
          gradient={mainGradient}
          midColor={accentMid}
          accentM={accentM}
          accentA={accentA}
          accentB={accentB}
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
