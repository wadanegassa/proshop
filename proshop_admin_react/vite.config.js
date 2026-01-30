import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      'react-simple-maps': path.resolve(process.cwd(), 'node_modules/react-simple-maps/dist/index.es.js'),
    },
  },
})
