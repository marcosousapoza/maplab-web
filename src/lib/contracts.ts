export interface Location {
  id: string;
  name: string;
  latitude: number;
  longitude: number;
  description: string;
}

export interface LocationCollection {
  locations: Location[];
}

export async function loadLocations(fetcher: typeof fetch = fetch): Promise<Location[]> {
  const response = await fetcher('/api/locations');
  if (!response.ok) throw new Error(`API returned ${response.status}`);
  const body = (await response.json()) as LocationCollection;
  return body.locations;
}

export function formatDistance(distance: number): string {
  return `${distance.toFixed(1)} km`;
}
