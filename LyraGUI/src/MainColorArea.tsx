import React from 'react';

import type { OklchState } from "./App";
import ColorController from './components/ColorController';

interface Props {
    colorM: OklchState;
    setColorM: React.Dispatch<React.SetStateAction<OklchState>>;
    accentM: string;
}

const MainColorArea: React.FC<Props> = ({ colorM, setColorM, accentM }) => {
    return(
        <div
          className='flex flex-col items-center pb-8 px-5 md:px-10 border-b-solid'
          style={{ borderColor: accentM }}
        >
            <div className='w-full h-15 mt-6 mb-6 rounded-lg' style={{ backgroundColor: accentM }}></div>

            <ColorController color={colorM} setColor={setColorM} />
        </div>
    );
};

export default MainColorArea;