/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: { DEFAULT: '#0f6b3f', dark: '#0a4a2c', soft: '#e7f4ec' },
        accent: { DEFAULT: '#f5a524', soft: '#fff3dc' },
        ink: '#1c1917',
      },
      fontFamily: { sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'] },
      boxShadow: { card: '0 10px 30px -12px rgba(28,25,23,.25)' },
    },
  },
  plugins: [],
}
