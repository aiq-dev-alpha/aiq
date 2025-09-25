export interface DeviceInfo {
  platform: string;
  version: string;
  model: string;
  uuid: string;
  manufacturer: string;
  isVirtual: boolean;
  serial: string;
}

export class DeviceService {
  getDeviceInfo(): DeviceInfo {
    if (window.device) {
      return {
        platform: window.device.platform || 'Unknown',
        version: window.device.version || 'Unknown',
        model: window.device.model || 'Unknown',
        uuid: window.device.uuid || 'Unknown',
        manufacturer: window.device.manufacturer || 'Unknown',
        isVirtual: window.device.isVirtual || false,
        serial: window.device.serial || 'Unknown'
      };
    }

    // Fallback for browser testing
    return {
      platform: 'Browser',
      version: navigator.userAgent,
      model: 'Web Browser',
      uuid: 'browser-' + Date.now(),
      manufacturer: 'Unknown',
      isVirtual: true,
      serial: 'N/A'
    };
  }

  isAndroid(): boolean {
    return this.getDeviceInfo().platform === 'Android';
  }

  isIOS(): boolean {
    return this.getDeviceInfo().platform === 'iOS';
  }

  isBrowser(): boolean {
    return this.getDeviceInfo().platform === 'Browser';
  }
}