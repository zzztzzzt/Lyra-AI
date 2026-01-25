import { defineConfig } from 'unocss'

export default defineConfig({
  theme: {
    fontFamily: {
      'prosto-one': ['Prosto One', 'sans-serif']
    },
    fontSize: {
      '2.5xl': ['1.7rem'], 
    },
  },
  shortcuts: {
    'color-slider': `
      appearance-none
      outline-none
      m-0 p-0
      select-none
      touch-none
    `,
  },
  preflights: [
    {
      getCSS: () => `
        .color-slider::-webkit-slider-thumb {
          -webkit-appearance: none;
          width: 8px;
          height: 8px;
          background: white;
          border-radius: 50%;
          box-shadow: 0 0 10px rgba(255,255,255,0.8);
          cursor: grab;
          border: 2px solid transparent;
        }

        .color-slider::-webkit-slider-thumb:active {
          transform: scale(1.4);
          cursor: grabbing;
        }
      `,
    },
  ],
})