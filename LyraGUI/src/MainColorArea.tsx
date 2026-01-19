import React, { useState, useMemo } from 'react';

import ColorController from './components/ColorController';

interface OklchState {
    l: number;
    c: number;
    h: number;
}

const toStr = (col: OklchState) => `oklch(${(col.l * 100).toFixed(0)}% ${col.c.toFixed(3)} ${col.h})`;

const MainColorArea: React.FC = () => {
    const [colorA, setColorA] = useState<OklchState>({ l: 0.7, c: 0.15, h: 250 });

    const accentA = useMemo(() => toStr(colorA), [colorA]);

    return(
        <div className='flex flex-col items-center py-5 px-3 font-prosto-one'>
            <div className='text-2xl text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary'>
                Lyra training system
            </div>
            <div className='w-full h-10 mt-6 mb-2 rounded-lg' style={{ backgroundColor: accentA }}></div>

            <ColorController color={colorA} setColor={setColorA} />
        </div>
    );
};

export default MainColorArea;