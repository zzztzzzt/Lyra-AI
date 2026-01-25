import React from 'react';

interface Props {
  gradient: string;
}

const ShowcaseArea: React.FC<Props> = (({ gradient }) => {
  return(
    <div className='relative flex justify-center items-center w-full h-200 lg:h-full'>
      <div className='w-1/2 h-1/2 rounded-xl' style={{ backgroundImage: gradient }}></div>
    </div>
  );
});

export default ShowcaseArea;