import React from 'react';

import type { OklchState } from "./App";
import ColorController from './components/ColorController';

interface Props {
    colorMid: OklchState;
    setColorMid: React.Dispatch<React.SetStateAction<OklchState>>;
    accentMid: string;
    accentM: string;
    useCustomMid: boolean;
    onBackToDefault: () => void;
}

const MiddleColorArea: React.FC<Props> = ({
    colorMid,
    setColorMid,
    accentMid,
    accentM,
    useCustomMid,
    onBackToDefault
}) => {
    return(
        <div className='relative'>
            <div
              className='flex flex-col items-center pt-2 pb-8 px-5 lg:px-10 border-t-solid border-2'
              style={{ borderColor: accentM }}
            >
                <button
                  type="button"
                  className='w-full h-15 mt-6 mb-6 rounded-lg text-white hover:text-black text-center text-xl font-prosto-one duration-600 border-none cursor-pointer'
                  style={{ backgroundColor: accentMid }}
                  onClick={onBackToDefault}
                  disabled={!useCustomMid}
                >
                    back to Auto
                </button>

                <ColorController color={colorMid} setColor={setColorMid} />
            </div>
        </div>
    );
};

export default MiddleColorArea;
