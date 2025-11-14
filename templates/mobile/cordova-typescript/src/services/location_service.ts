export interface LocationOptions {
  enableHighAccuracy?: boolean;
  timeout?: number;
  maximumAge?: number;
}

export class LocationService {
  async getCurrentPosition(options?: LocationOptions): Promise<GeolocationPosition> {
    return new Promise((resolve, reject) => {
      if (!navigator.geolocation) {
        reject('Geolocation not available');
        return;
      }

      const defaultOptions: LocationOptions = {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0,
        ...options
      };

      navigator.geolocation.getCurrentPosition(
        (position) => resolve(position),
        (error) => reject(this.handleError(error)),
        defaultOptions
      );
    });
  }

  watchPosition(
    onSuccess: (position: GeolocationPosition) => void,
    onError?: (error: string) => void,
    options?: LocationOptions
  ): number {
    if (!navigator.geolocation) {
      if (onError) onError('Geolocation not available');
      return -1;
    }

    const defaultOptions: LocationOptions = {
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 0,
      ...options
    };

    return navigator.geolocation.watchPosition(
      onSuccess,
      (error) => {
        if (onError) onError(this.handleError(error));
      },
      defaultOptions
    );
  }

  clearWatch(watchId: number): void {
    if (navigator.geolocation && watchId !== -1) {
      navigator.geolocation.clearWatch(watchId);
    }
  }

  private handleError(error: GeolocationPositionError): string {
    switch (error.code) {
      case error.PERMISSION_DENIED:
        return 'Location permission denied';
      case error.POSITION_UNAVAILABLE:
        return 'Location information unavailable';
      case error.TIMEOUT:
        return 'Location request timed out';
      default:
        return 'Unknown location error';
    }
  }

  calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const R = 6371; // Earth's radius in kilometers
    const dLat = this.toRad(lat2 - lat1);
    const dLon = this.toRad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRad(lat1)) * Math.cos(this.toRad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private toRad(value: number): number {
    return value * Math.PI / 180;
  }
}