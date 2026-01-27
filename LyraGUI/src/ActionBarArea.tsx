import React from "react";

import type { OklchState } from "./App";
import GradientBtnBasic from "./components/GradientBtnBasic";
import BtnCopyCss from "./components/BtnCopyCSS";

interface Props {
  gradient: string;
  colorA: OklchState;
  colorB: OklchState;
}

const ActionBarArea: React.FC<Props> = ({ gradient, colorA, colorB }) => {
  return(
      <div className="px-5">
        <div className="my-8 bg-black w-full h-120"></div>
        <div className="flex flex-col items-centers space-y-8">
            <GradientBtnBasic gradient={gradient} btnText={"Add"} />
            <GradientBtnBasic gradient={gradient} btnText={"Undo"} />
            <GradientBtnBasic gradient={gradient} btnText={"Train"} />
            <GradientBtnBasic gradient={gradient} btnText={"Json"} />

            <BtnCopyCss colorA={colorA} colorB={colorB} bgColor="bg-for-uno" btnText="UnoCSS" />
            <BtnCopyCss colorA={colorA} colorB={colorB} bgColor="bg-for-tailwind" btnText="TailwindCSS" />
            <BtnCopyCss colorA={colorA} colorB={colorB} bgColor="bg-for-panda" btnText="PandaCSS" />
        </div>
      </div>
  );
};

export default ActionBarArea;