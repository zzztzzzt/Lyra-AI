import React from "react";

import type { OklchState } from "./App";
import GradientBtnBasic from "./components/GradientBtnBasic";
import BtnCopyCss from "./components/BtnCopyCSS";

interface Props {
  gradient: string;
  colorA: OklchState;
  colorB: OklchState;
  accentM: string;
}

const ActionBarArea: React.FC<Props> = ({ gradient, colorA, colorB, accentM }) => {
  return(
    <div className="lg:absolute lg:h-3/7 lg:w-full lg:left-0 lg:bottom-0 lg:backdrop-blur-lg lg:border-t-solid border-2 overflow-y-auto" style={{ borderColor: accentM }}>
      <div className="px-5 lg:flex lg:flex-col-reverse">
        <div className="my-8 w-full h-120 max-lg:border-solid border-2 border-gray-300 rounded-lg"></div>
        <div className="lg:mt-8 flex flex-col 2xl:flex-row-reverse lg:items-start lg:justify-center 2xl:justify-end max-lg:space-y-8 max-2xl:space-y-3 2xl:gap-3">
            <div className="max-lg:space-y-8 lg:gap-3 lg:flex lg:flex-row-reverse">
              <GradientBtnBasic gradient={gradient} btnText={"Add"} />
              <GradientBtnBasic gradient={gradient} btnText={"Undo"} />
              <GradientBtnBasic gradient={gradient} btnText={"Train"} />
            </div>

            <div className="max-lg:space-y-8 lg:gap-3 lg:flex lg:flex-row-reverse">
              <BtnCopyCss colorA={colorA} colorB={colorB} bgColor="bg-for-uno" btnText="UnoCSS" />
              <BtnCopyCss colorA={colorA} colorB={colorB} bgColor="bg-for-tailwind" btnText="TailwindCSS" />
              <BtnCopyCss colorA={colorA} colorB={colorB} bgColor="bg-for-panda" btnText="PandaCSS" />
            </div>
        </div>
      </div>
    </div>
  );
};

export default ActionBarArea;