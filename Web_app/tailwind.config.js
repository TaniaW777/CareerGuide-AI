// tailwind.config.js
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#1E3A8A", // deep blue (education)
        accent: "#F59E0B", // amber highlight
        secondary: "#10B981", // teal for success
        surface: "rgba(255,255,255,0.8)",
        background: "#F3F4F6",
      },
      backdropBlur: {
        xs: "2px",
      },
    },
  },
  plugins: [],
};
