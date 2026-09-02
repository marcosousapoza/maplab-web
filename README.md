# Maplab Web

Client-only Svelte and Vite application using OpenStreetMap through
`svelte-map-leaflet`.

## Requirements

- Node.js 24 LTS
- npm 11 or newer
- The Maplab API on port 8000

## Run

```bash
npm ci
npm run dev
```

Vite serves <http://localhost:5173> and proxies `/api` to FastAPI. The exact
`@marcosousapoza/maplab-wasm` version in `package.json` is installed from npmjs.

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

## Publish WASM

Publish a matching `vX.Y.Z` version tag from `marcosousapoza/maplab-wasm`. Its
`publish-package.yml` workflow is registered as the npm trusted publisher and builds
and publishes the package to npmjs with provenance and no token.

## Versioning

See [VERSIONING.md](VERSIONING.md). Use
`./scripts/bump-version.sh patch|minor|major`. The same guide documents consuming
`@marcosousapoza/maplab-wasm` from npmjs.
