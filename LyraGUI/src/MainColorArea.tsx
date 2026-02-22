import React from 'react';

import type { OklchState } from "./App";
import ColorController from './components/ColorController';

interface Props {
    colorM: OklchState;
    setColorM: React.Dispatch<React.SetStateAction<OklchState>>;
    accentM: string;
    mainColorLock: boolean;
}

const MainColorArea: React.FC<Props> = ({ colorM, setColorM, accentM, mainColorLock }) => {
    return(
        <div className='relative'>
            <div
              className='flex flex-col items-center pb-8 px-5 lg:px-10 border-b-solid border-2'
              style={{ borderColor: accentM }}
            >
                <div className='w-full h-15 mt-6 mb-6 rounded-lg' style={{ backgroundColor: accentM }}></div>

                <ColorController color={colorM} setColor={setColorM} />
            </div>
            
            {mainColorLock && (
                <div className='absolute inset-0 overflow-hidden z-30'>
                    <div className='absolute inset-0 backdrop-blur-sm'></div>
                    
                    <div className='absolute inset-0 flex items-center justify-center cursor-not-allowed'>
                        <div className='backdrop-blur-md px-8 py-5 shadow-xl flex items-center gap-4 bg-white/20'>
                            <span className='text-lg'>Main Color is locked. Please add to 10 colors first ( Main Color + 3 Three-color Gradients )</span>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default MainColorArea;
