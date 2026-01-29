import React from "react";

import type { OklchState } from "./App";
import type { ColorData } from "./App";
import GradientBtnBasic from "./components/GradientBtnBasic";
import BtnCopyCss from "./components/BtnCopyCSS";

interface Props {
  gradient: string;
  colorA: OklchState;
  colorB: OklchState;
  colorM: OklchState;
  accentM: string;
  colorData: ColorData;
  setColorData: React.Dispatch<React.SetStateAction<ColorData>>;
}

const ActionBarArea: React.FC<Props> = ({ gradient, colorA, colorB, colorM, accentM, colorData, setColorData }) => {
  return(
    <div
      className="lg:absolute lg:h-3/7 lg:w-full lg:left-0 lg:bottom-0 lg:backdrop-blur-lg lg:border-t-solid border-2 overflow-y-auto"
      style={{ borderColor: accentM }}
    >
      <div className="px-5 lg:flex lg:flex-col-reverse">
        <div className="my-8 w-full h-120 space-y-3 max-lg:overflow-auto">
          {colorData.palettes
            .slice() // Copy the array first to avoid modifying the original data
            .reverse() // The latest information will be at the top
            .map((palette, i) => (
              <div key={i} className="flex gap-3">
                {palette.map((color, j) => (
                  <div
                    key={j}
                    className="flex w-35 text-xs gap-1.5 items-center font-prosto-one"
                  >
                    <div
                      className="flex-1 w-8 min-w-8 max-w-8 h-8 min-h-8 rounded"
                      style={{ backgroundColor: `oklch(${color[0]} ${color[1]} ${color[2]})` }}
                    />
                    <div className="text-center">
                      { `${color[0]} ${color[1]} ${color[2]}` }
                    </div>
                  </div>
                ))}
              </div>
            ))}

          <details open>
            <summary className="cursor-pointer text-lg text-gray-700 font-prosto-one">
              Developer Data ( JSON )
            </summary>
            <pre className="mt-2 p-3 bg-gray-50 rounded text-xs overflow-x-auto">
              {`{\n  "palettes": [\n${colorData.palettes.map(palette => 
                `    ${JSON.stringify(palette)}`
              ).join(',\n')}\n  ]\n}`}
            </pre>
          </details>
        </div>

        <div className="lg:mt-8 flex flex-col 2xl:flex-row-reverse lg:items-start lg:justify-center 2xl:justify-end max-lg:space-y-8 max-2xl:space-y-3 2xl:gap-3">
            <div className="max-lg:space-y-8 lg:gap-3 lg:flex lg:flex-row-reverse">
              <GradientBtnBasic gradient={gradient} setColorData={setColorData} colorA={colorA} colorB={colorB} colorM={colorM} btnText={"Add"} />
              <GradientBtnBasic gradient={gradient} setColorData={setColorData} colorA={colorA} colorB={colorB} colorM={colorM} btnText={"Undo"} />
              <GradientBtnBasic gradient={gradient} setColorData={setColorData} colorA={colorA} colorB={colorB} colorM={colorM} btnText={"Train"} />
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