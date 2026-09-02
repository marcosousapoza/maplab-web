import { cp, mkdir, rm } from 'node:fs/promises';
import { resolve } from 'node:path';

const source = process.argv[2];
if (!source) throw new Error('Usage: npm run wasm:sync -- <path-to-wasm-pack-pkg>');

const destination = resolve('src/lib/wasm');
await mkdir(destination, { recursive: true });
for (const extension of ['js', 'wasm', 'json']) {
  await rm(resolve(destination, extension === 'json' ? 'package.json' : `maplab_wasm.${extension}`), {
    force: true
  });
}
await cp(resolve(source, 'maplab_wasm.js'), resolve(destination, 'maplab_wasm.js'));
await cp(resolve(source, 'maplab_wasm_bg.wasm'), resolve(destination, 'maplab_wasm_bg.wasm'));
await cp(resolve(source, 'package.json'), resolve(destination, 'package.json'));
console.log(`Synchronized WASM package from ${resolve(source)}`);
