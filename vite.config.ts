import { defineConfig, ConfigEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'url'
import vueI18n from '@intlify/vite-plugin-vue-i18n'
import vuetify from 'vite-plugin-vuetify'

const proxyUrl: string = 'http://localhost:3000'

export default ({ command }: ConfigEnv) => {
  const version = process.env.VITE_BUILD_VERSION;
  const entryDir = `./src/v${version}`;

  return defineConfig({
    plugins: [
      vue(),
      vuetify({ autoImport: true }),
      vueI18n({
        include: fileURLToPath(
          new URL(entryDir + '/locales/**', import.meta.url)
        ),
      }),
    ],
    resolve: {
      alias: {
        '#': fileURLToPath(new URL(entryDir, import.meta.url)),
        '@': fileURLToPath(new URL(entryDir + '/components', import.meta.url)),
      },
    },
    base: '/simulatorvue/',
    build: {
      outDir:  `../public/simulatorvue-${version}`, // Conditionally set for builds
      assetsDir: 'assets',
      chunkSizeWarningLimit: 1600,
    },
    server: {
      port: 4000,
      proxy: {
        '^/(?!(simulatorvue)).*': {
          target: proxyUrl,
          changeOrigin: true,
          headers: {
            origin: proxyUrl,
          },
        },
      },
    },
  })
}
