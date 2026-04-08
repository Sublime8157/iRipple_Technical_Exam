import { fileURLToPath, URL } from "node:url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  server: {
    watch: {
      usePolling: true, // Force Vite to poll for changes
      interval: 100, // Check every 100ms (adjust if needed)
    },
    strictPort: true, // Avoid port conflicts
    hmr: true, // Ensure HMR is enabled
  },
});
