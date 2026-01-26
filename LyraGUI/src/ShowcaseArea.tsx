import React from 'react';

interface Props {
  gradient: string;
  midColor: string;
  accentM: string;
}

const ShowcaseArea: React.FC<Props> = (({ gradient, midColor, accentM }) => {
  return(
    <div className='relative flex flex-col-reverse lg:flex-row justify-center items-center w-full h-200 lg:h-full'>
      <div className='w-9/10 max-lg:max-w-140 lg:w-1/2 h-1/2 flex justify-center items-center rounded-xl' style={{ backgroundImage: gradient }}>
        <div className='w-2/3 h-2/3 flex justify-center items-center bg-white rounded-lg'>
          <div className='w-5/6 h-5/6 rounded-lg' style={{ backgroundImage: `linear-gradient(90deg in oklch, ${midColor}, white)` }}></div>
        </div>
      </div>

      <div className='max-lg:mb-6 lg:ml-6 h-10 lg:h-30 w-9/10 max-lg:max-w-140 lg:w-15 rounded-md' style={{ backgroundColor: accentM }}></div>
    </div>
  );
});

export default ShowcaseArea;