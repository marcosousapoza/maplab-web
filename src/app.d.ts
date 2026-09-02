declare module 'svelte-map-leaflet' {
  import type { Component } from 'svelte';

  export const Map: Component<Record<string, unknown>>;
  export const TileLayer: Component<Record<string, unknown>>;
  export const Marker: Component<Record<string, unknown>>;
  export const Popup: Component<Record<string, unknown>>;
}
