# Versioning and Releases

Maplab Web follows [Semantic Versioning](https://semver.org/). `package.json` is the
source of truth and `package-lock.json` must contain the same application version.

## Compatibility

- Patch: visual or behavioral fixes with unchanged API/WASM requirements.
- Minor: backward-compatible user-facing functionality.
- Major: incompatible API, WASM, browser, or deployment requirements.

## Bump and Release

```bash
./scripts/bump-version.sh patch  # or minor / major
npm run check
npm test
npm run build
git add package.json package-lock.json
git commit -m "Bump web version to X.Y.Z"
git tag vX.Y.Z
git push origin main vX.Y.Z
gh release create vX.Y.Z --generate-notes
```

The tag workflow rejects a tag that does not match `package.json`.

## WASM Package Versions

Production consumers should pin `@marcosousapoza/maplab-wasm` from GitHub Packages.
Copy `.npmrc.github.example` to `.npmrc` and provide `NODE_AUTH_TOKEN`:

```bash
NODE_AUTH_TOKEN="$(gh auth token)" \
  npm install --no-save @marcosousapoza/maplab-wasm@X.Y.Z
npm run wasm:sync -- node_modules/@marcosousapoza/maplab-wasm
```

For unpublished local development, build the adjacent Rust repository and run:

```bash
npm run wasm:sync -- ../maplab-wasm/pkg
```

The generated package is copied into `src/lib/wasm` before Vite builds. Vite emits
the `.wasm` binary as a hashed static asset served by the web container.
