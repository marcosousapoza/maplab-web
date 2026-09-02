<script lang="ts">
  import { onMount } from 'svelte';
  import { Map, Marker, Popup, TileLayer } from 'svelte-map-leaflet';
  import { formatDistance, loadLocations, type Location } from './lib/contracts';

  const mapOptions = { center: [46.8, 7.5], zoom: 8, zoomControl: true };
  const tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  const tileOptions = {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19
  };

  let locations: Location[] = [];
  let selected: Location[] = [];
  let distance: number | null = null;
  let loading = true;
  let error = '';
  let wasmReady = false;
  let calculateDistance: typeof import('./lib/wasm/maplab_wasm.js').haversine_distance_km;

  onMount(async () => {
    try {
      const wasm = await import('./lib/wasm/maplab_wasm.js');
      await wasm.default();
      calculateDistance = wasm.haversine_distance_km;
      wasmReady = true;
      locations = await loadLocations();
    } catch (reason) {
      error = reason instanceof Error ? reason.message : 'Unable to initialize Maplab';
    } finally {
      loading = false;
    }
  });

  function toggle(location: Location) {
    const exists = selected.some(({ id }) => id === location.id);
    selected = exists
      ? selected.filter(({ id }) => id !== location.id)
      : [...selected.slice(-1), location];

    distance =
      selected.length === 2
        ? calculateDistance(
            selected[0].latitude,
            selected[0].longitude,
            selected[1].latitude,
            selected[1].longitude
          )
        : null;
  }
</script>

<svelte:head><meta name="description" content="Maplab full-stack testing environment" /></svelte:head>

<main>
  <header>
    <div>
      <span class="eyebrow">Svelte · FastAPI · Rust/WASM</span>
      <h1>Maplab</h1>
      <p>Explore API-provided places and measure distance in the browser with Rust.</p>
    </div>
    <span class:ready={wasmReady} class="status">{wasmReady ? 'WASM ready' : 'WASM loading'}</span>
  </header>

  {#if error}
    <section class="notice error" role="alert"><strong>Setup error</strong><span>{error}</span></section>
  {:else if loading}
    <section class="notice" aria-live="polite">Loading the Maplab environment…</section>
  {:else}
    <section class="workspace">
      <div class="map" aria-label="OpenStreetMap showing Maplab locations">
        <Map options={mapOptions}>
          <TileLayer url={tileUrl} options={tileOptions} />
          {#each locations as location (location.id)}
            <Marker latLng={[location.latitude, location.longitude]}>
              <Popup><strong>{location.name}</strong><br />{location.description}</Popup>
            </Marker>
          {/each}
        </Map>
      </div>

      <aside>
        <h2>Distance lab</h2>
        <p>Select two places. The result is calculated by WebAssembly.</p>
        <div class="places">
          {#each locations as location (location.id)}
            <button
              class:selected={selected.some(({ id }) => id === location.id)}
              onclick={() => toggle(location)}
            >
              <span>{location.name}</span><small>{location.description}</small>
            </button>
          {/each}
        </div>
        <div class="result" aria-live="polite">
          {#if distance !== null}
            <span>{selected[0].name} to {selected[1].name}</span>
            <strong>{formatDistance(distance)}</strong>
          {:else}
            <span>Select two locations</span>
          {/if}
        </div>
      </aside>
    </section>
  {/if}
</main>
