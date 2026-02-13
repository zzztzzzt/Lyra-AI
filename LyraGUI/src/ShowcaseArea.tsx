import React, { useState } from 'react';

interface Props {
  gradient: string;
  midColor: string;
  accentM: string;
  accentA: string;
  accentB: string;
}

const ShowcaseArea: React.FC<Props> = (({ gradient, midColor, accentM, accentA, accentB }) => {
  const [paletteMode, setPaletteMode] = useState<boolean>(false);

  return(
    <div className='relative flex flex-col-reverse lg:flex-row justify-center items-center w-full h-120 lg:h-full'>
      {!paletteMode && (
        <>
          <div className='w-9/10 max-lg:max-w-90 lg:w-1/2 h-2/3 lg:h-1/2 flex justify-center items-center rounded-xl' style={{ backgroundImage: gradient }}>
            <div className='w-2/3 h-2/3 flex justify-center items-center bg-white rounded-lg'>
              <div className='w-2/5 h-1/3 rounded-md flex justify-end items-center' style={{ backgroundImage: `linear-gradient(90deg in oklab, ${midColor}, white)` }}>
                <div className='w-8/10 h-1/3 rounded-sm bg-white'></div>
              </div>
            </div>
          </div>

          <div
            className='max-lg:mb-6 lg:ml-6 h-10 lg:h-1/2 w-1/3 max-lg:max-w-92 lg:w-1/9 xl:w-1/12 rounded-md'
            style={{ backgroundImage: `linear-gradient(270deg in oklab, ${accentM}, white)` }}
          >
          </div>
        </>
      )}

      {paletteMode && (
        <div className='w-full h-full flex flex-col lg:flex-row justify-center items-center gap-10'>
          <div className='w-1/5 h-auto aspect-square rounded-xl' style={{ backgroundColor: accentM }}></div>
          <div className='w-1/5 h-auto aspect-square rounded-xl' style={{ backgroundColor: accentA }}></div>
          <div className='w-1/5 h-auto aspect-square rounded-xl' style={{ backgroundColor: accentB }}></div>
        </div>
      )}

      <div
        className='absolute top-0 lg:top-5.5 right-5 lg:right-10 text-transparent bg-clip-text font-prosto-one text-lg hover:text-gray-500 duration-600 cursor-pointer'
        style={{ backgroundImage: gradient }}
        onClick={() => setPaletteMode(!paletteMode)}
      >
        {paletteMode ? 'Gradient Mode' : 'Palette Mode'}
      </div>
    </div>
  );
});

export default ShowcaseArea;