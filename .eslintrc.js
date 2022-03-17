module.exports = {
  env: {
    browser: true,
    es2021: true,
    jest: true,
    jquery: true,
  },
  extends: ['airbnb-base', 'prettier'],
  parserOptions: {
    ecmaVersion: 13,
    sourceType: 'module',
  },
  rules: {
    'consistent-return': 'off',
    'import/no-unresolved': 'off',
    'no-param-reassign': 'off',
    'no-unused-expressions': [
      'error',
      {
        allowShortCircuit: true,
      },
    ],
  },
};
