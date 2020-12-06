// tailwind.config.js
module.exports = {
  purge: [
    './source/**/*.erb',
    './source/**/*.haml',
    './source/**/*.html',
    './source/**/*.js',
    './source/**/*.slim',
  ],
  darkMode: 'media',
  theme: {
    extend: {},
  },
  variants: {},
  plugins: [ require('@tailwindcss/typography') ],
}
