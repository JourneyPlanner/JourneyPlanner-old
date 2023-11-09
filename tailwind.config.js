/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        'nunito': 'Nunito',
        'nunito-sans': 'Nunito Sans'
      }
    },
    fontSize: {
      'base': '1rem',
      'xl': '1.5rem',
      '2xl': '2.25rem',
      '3xl': '3.375rem',
      '4xl': '5.063rem',
      '5xl': '7.594rem'
    },
    colors: {
      'text-black': '#212121',
      'background': '#ffffff',
      'primary': '#bad9e7',
      'secondary': '#d8eaf3',
      'call-to-action': '#f8d351',
      'placeholder-gray': '#212121',
      'disabled-input': '#ECEAEA',
      'cancel': '#858585',
      'delete': '#F06543'
    }
  },
  plugins: [],
}
