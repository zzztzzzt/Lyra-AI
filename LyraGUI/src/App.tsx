import './App.css'
import { useState, useMemo } from "react";
import MainColorArea from './MainColorArea';
import GradientArea from './GradientArea';
import ShowcaseArea from './ShowcaseArea';

export interface OklchState {
  l: number;
  c: number;
  h: number;
}

const toStr = (col: OklchState) => `oklch(${(col.l * 100).toFixed(0)}% ${col.c.toFixed(3)} ${col.h})`;

function App() {
  const [colorM, setColorM] = useState<OklchState>({ l: 0.7, c: 0.15, h: 250 });
  const [colorA, setColorA] = useState<OklchState>({ l: 0.7, c: 0.15, h: 250 });
  const [colorB, setColorB] = useState<OklchState>({ l: 0.6, c: 0.25, h: 20 });

  const accentM = useMemo(() => toStr(colorM), [colorM]);
  const accentA = useMemo(() => toStr(colorA), [colorA]);
  const accentB = useMemo(() => toStr(colorB), [colorB]);
  const mainGradient = `linear-gradient(90deg, ${accentA}, ${accentB})`;

  return (
    <div className='lg:flex lg:flex-row-reverse'>
      <div className='max-lg:max-w-100 lg:w-1/4 lg:min-w-100 lg:h-screen max-lg:mx-auto overflow-auto lg:border-l-solid border-gray-300 font-prosto-one'>
        <div className='mt-6 text-center text-3xl md:text-2.5xl'>
          <span className='text-transparent bg-clip-text' style={{ backgroundColor: accentM }}>Lyra </span>
          <span className='text-transparent bg-clip-text' style={{ backgroundImage: mainGradient }}>training system</span>
        </div>

        <MainColorArea
          colorM={colorM}
          setColorM={setColorM}
          accentM={accentM}
        />

        <GradientArea
          colorA={colorA}
          setColorA={setColorA}
          colorB={colorB}
          setColorB={setColorB}
          gradient={mainGradient}
        />
      </div>
      <div className='relative w-full lg:h-screen'>
        <ShowcaseArea gradient={mainGradient} />
      </div>
    </div>
  )
}

export default App
