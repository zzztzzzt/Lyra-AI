import React from "react";

interface Props {
  gradient: string;
  btnText: string;
}

const GradientBtnBasic: React.FC<Props> = ({ gradient, btnText }) => {
  return(
    <div className="h-12 lg:h-10 p-1.5 lg:p-1 rounded-lg font-prosto-one cursor-pointer" style={{ backgroundImage: gradient }}>
        <div className="bg-white lg:w-40 h-full flex justify-center items-center text-center text-2.5xl lg:text-lg text-gray-500 rounded-md">{btnText}</div>
    </div>
  );
};

export default GradientBtnBasic;