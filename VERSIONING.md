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

Production builds pin `@marcosousapoza/maplab-wasm` exactly in `package.json` and
install the public package from npmjs without registry credentials:

```bash
npm install --save-exact @marcosousapoza/maplab-wasm@X.Y.Z
```

The application imports the package directly. Vite emits its `.wasm` binary as a
hashed static asset served by the web container. The WASM repository's
`publish-package.yml` workflow publishes tagged versions through npm trusted
publishing without a token.

Version tags publish `ghcr.io/marcosousapoza/maplab-web:X.Y.Z`. The runtime image
contains the bundled WASM asset but no npm credentials, Node.js, or build tools.
