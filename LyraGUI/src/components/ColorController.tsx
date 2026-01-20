import React, { useMemo } from 'react';

interface OklchState {
    l: number;
    c: number;
    h: number;
}

interface ControlRowProps {
    val: number;
    max: number;
    step: number;
    onChange: (v: string) => void;
    grad: string;
}

interface ControllerProps {
    color: OklchState;
    setColor: React.Dispatch<React.SetStateAction<OklchState>>;
}

const ColorController: React.FC<ControllerProps> = ({ color, setColor }) => {
  const update = (key: keyof OklchState, val: string) => {
    setColor((prev) => ({ ...prev, [key]: parseFloat(val) }));
  };

  const hPercent = (color.h / 360) * 100;

  const hueGrad = useMemo(() => {
    const stops = [0, 90, 180, 270, 360].map(h => `oklch(${color.l * 100}% ${color.c} ${h})`).join(', ');
    return `linear-gradient(to right, ${stops})`;
  }, [color.l, color.c]);

  return (
    <div className="font-prosto-one w-full space-y-6">
      <div className="">
        <div className="h-10 rounded-lg relative overflow-hidden bg-gray-200/80">
          
          {/* Use a mask to make the color only appear near the lever */}
          <div 
            className="absolute inset-0 transition-all duration-75" 
            style={{ 
              background: hueGrad,
              WebkitMaskImage: `radial-gradient(circle at ${hPercent}% 50%, black 0%, rgba(0,0,0,0.2) 20%, transparent 0%)`,
              maskImage: `radial-gradient(circle at ${hPercent}% 50%, black 0%, rgba(0,0,0,0.2) 20%, transparent 0%)`
            }} 
          />

          <input 
            type="range" min="0" max="360" value={color.h} 
            onChange={(e) => update('h', e.target.value)}
            className="color-slider absolute -top-[0.0625rem] -left-[0.125rem] inset-0 w-full h-10 bg-transparent z-10"
          />
        </div>
      </div>
      
      <div className="space-y-6">
        <ControlRow 
          val={color.l} max={1} step={0.01} 
          onChange={(v) => update('l', v)}
          grad={`linear-gradient(to right, oklch(0% ${color.c} ${color.h}), oklch(100% ${color.c} ${color.h}))`} 
        />
        <ControlRow 
          val={color.c} max={0.37} step={0.001} 
          onChange={(v) => update('c', v)}
          grad={`linear-gradient(to right, oklch(${color.l * 100}% 0 ${color.h}), oklch(${color.l * 100}% 0.37 ${color.h}))`} 
        />
      </div>
    </div>
  );
};
  
const ControlRow: React.FC<ControlRowProps> = ({ val, max, step, onChange, grad }) => (
    <div className="flex flex-col justify-end">
        <input 
        type="range" min="0" max={max} step={step} value={val} 
        onChange={(e) => onChange(e.target.value)}
        className="color-slider w-full h-10 rounded-lg transition-all duration-300"
        style={{ background: grad }}
        />
    </div>
);

export default ColorController;