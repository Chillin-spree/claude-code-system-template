import js from "@eslint/js";
import globals from "globals";

// Flat ESLint config for the vanilla stack (browser ES modules + Node test files).
export default [
  { ignores: ["node_modules", "dist"] },
  js.configs.recommended,
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: { ...globals.browser, ...globals.node },
    },
  },
];
