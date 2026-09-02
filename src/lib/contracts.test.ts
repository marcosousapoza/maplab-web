import { describe, expect, it, vi } from 'vitest';
import { formatDistance, loadLocations } from './contracts';

describe('frontend contracts', () => {
  it('formats a WASM distance', () => {
    expect(formatDistance(78.36)).toBe('78.4 km');
  });

  it('loads the API envelope', async () => {
    const fetcher = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ locations: [{ id: 'bern' }] })
    });
    await expect(loadLocations(fetcher)).resolves.toEqual([{ id: 'bern' }]);
  });
});
