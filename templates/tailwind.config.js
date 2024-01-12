/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{html,js}"],
  theme: {
    extend: {
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
      'cancel': '#829094',
      'delete': '#F06543'
    }
  },
  plugins: [],
}
