# Maplab Web

Client-only Svelte and Vite application using OpenStreetMap through
`svelte-map-leaflet`.

## Requirements

- Node.js 24 LTS
- npm 11 or newer
- A built `maplab-wasm/pkg` artifact
- The Maplab API on port 8000

## Run

For local source development with an adjacent clone of `maplab-wasm`:

```bash
npm ci
npm run wasm:sync -- ../maplab-wasm/pkg
npm run dev
```

Vite serves <http://localhost:5173> and proxies `/api` to FastAPI. The generated
WASM JavaScript and binary under `src/lib/wasm/` are intentionally ignored.

## Verify

```bash
npm run check
npm test
npm run build
```

The setup succeeds when the page shows an OpenStreetMap with API markers, reports
that the Rust WASM module is ready, and all verification commands pass.

## Compatibility note

`svelte-map-leaflet` is a Svelte 3-era package. This environment uses current
Svelte compatibility mode and verifies the production build in CI. Replace or pin
Svelte only through an issue if a future release breaks that verified contract.

## Versioning

See [VERSIONING.md](VERSIONING.md). Use
`./scripts/bump-version.sh patch|minor|major`. The same guide documents consuming
`@marcosousapoza/maplab-wasm` from GitHub Packages or an adjacent source build.
Production image builds use the package version pinned in `WASM_VERSION`.
