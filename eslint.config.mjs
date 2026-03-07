import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(eslint.configs.recommended, ...tseslint.configs.recommended, {
  ignores: [
    'apps/mobile/**', // ignore Angular linting
    'dist/**',
    'node_modules/**',
    'packages/db/prisma/migrations/**',
  ],
});
