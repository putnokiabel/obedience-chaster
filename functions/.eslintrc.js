module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    "ecmaVersion": 2023,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "object-curly-spacing": "off",
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    "quotes": ["error", "double", {"allowTemplateLiterals": true}],
    "jsdoc/no-undefined-types": 1,
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
  plugins: [
    "jsdoc",
  ],
};
