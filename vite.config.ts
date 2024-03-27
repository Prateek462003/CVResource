import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

function multipleBuilds(options) {
  return {
    name: 'multiple-builds',
    configResolved(config) {
      const { builds = [] } = options; 
      builds.forEach((build) => {
        const { input, output, ...otherOptions } = build;
        config.build.outputs.push({
          ...config.build, 
          ...otherOptions, 
          input,
          output: {
            filename: output,
            ...config.build.output, 
          },
        });
      });
    },
  };
}
export default defineConfig({
  plugins: [
    multipleBuilds({
      builds: [
        { 
          input: './app/javascript/enrtypoints/v1',
          output: './public/v1/vite',
        },
        {
          input: './app/javascript/enrtypoints/v2',
          output: './public/v2/vite',
        },
      ],
    }),
    RubyPlugin(),
  ],
});
