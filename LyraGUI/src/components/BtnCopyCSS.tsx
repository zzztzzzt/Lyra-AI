import React from "react";

import type { OklchState } from "../App";

interface Props {
  colorA: OklchState;
  colorB: OklchState;
  bgColor: string;
  btnText: string;
}

const toOklchStr = (col: OklchState) => `oklch(${(col.l * 100).toFixed(0)}% ${col.c.toFixed(3)} ${col.h})`;

const BtnCopyCss: React.FC<Props> = ({ colorA, colorB, bgColor, btnText }) => {
  const handleCopy = async () => {
    const cA: string = toOklchStr(colorA);
    const cB: string = toOklchStr(colorB);
    
    const cA_: string = cA.replace(/\s+/g, "_");
    const cB_: string = cB.replace(/\s+/g, "_");

    let result: string = "";

    switch (btnText) {
      case "TailwindCSS":
        result = `bg-gradient-to-r from-[${cA_}] to-[${cB_}]`;
        break;

      case "UnoCSS":
        // This syntax requires additional settings for TypeScript to work in UnoCSS
        //result = `bg="gradient-to-r from-[${cA_}] to-[${cB_}]"`;
        // Use the tailwind syntax temporarily
        result = `bg-gradient-to-r from-[${cA_}] to-[${cB_}]`;
        break;

      case "PandaCSS":
        result = `css({ background: 'linear-gradient(90deg in oklch, ${cA}, ${cB})' })`;
        break;
    }

    try {
      await navigator.clipboard.writeText(result);
      console.log(`Copied: ${result}`);
    } catch (err) {
      console.error("Copy failed", err);
    }
  };

  return (
    <div
      onClick={handleCopy}
      className={`${bgColor} h-12 p-1.5 flex justify-center items-center text-center text-2.5xl text-white rounded-md font-prosto-one cursor-pointer`}
    >
      {btnText}
    </div>
  );
};

export default BtnCopyCss;