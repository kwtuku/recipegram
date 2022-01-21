module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: ['airbnb-base', 'prettier'],
  parserOptions: {
    ecmaVersion: 13,
    sourceType: 'module',
  },
  rules: {
    'consistent-return': 'off',
    'func-names': 'off',
    'import/first': 'off',
    'import/newline-after-import': 'off',
    'import/no-unresolved': 'off',
    'no-param-reassign': 'off',
    'no-restricted-globals': 'off',
    'no-undef': 'off',
    'no-unused-expressions': 'off',
    'no-use-before-define': 'off',
    'object-shorthand': 'off',
    'prefer-arrow-callback': 'off',
    'prefer-const': 'off',
    'prefer-destructuring': 'off',
    'prefer-template': 'off',
    radix: 'off',
  },
};
