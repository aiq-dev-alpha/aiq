export enum ConnectionType {
  UNKNOWN = 'Unknown',
  ETHERNET = 'Ethernet',
  WIFI = 'WiFi',
  CELL_2G = '2G',
  CELL_3G = '3G',
  CELL_4G = '4G',
  CELL = 'Cellular',
  NONE = 'No Connection'
}

export class NetworkService {
  getConnectionType(): ConnectionType {
    if (!navigator.connection) {
      return navigator.onLine ? ConnectionType.UNKNOWN : ConnectionType.NONE;
    }

    const connection = navigator.connection;
    const type = connection.type;

    switch (type) {
      case Connection.UNKNOWN:
        return ConnectionType.UNKNOWN;
      case Connection.ETHERNET:
        return ConnectionType.ETHERNET;
      case Connection.WIFI:
        return ConnectionType.WIFI;
      case Connection.CELL_2G:
        return ConnectionType.CELL_2G;
      case Connection.CELL_3G:
        return ConnectionType.CELL_3G;
      case Connection.CELL_4G:
        return ConnectionType.CELL_4G;
      case Connection.CELL:
        return ConnectionType.CELL;
      case Connection.NONE:
        return ConnectionType.NONE;
      default:
        return ConnectionType.UNKNOWN;
    }
  }

  isOnline(): boolean {
    if (navigator.connection) {
      return this.getConnectionType() !== ConnectionType.NONE;
    }
    return navigator.onLine;
  }

  isOffline(): boolean {
    return !this.isOnline();
  }

  isWifi(): boolean {
    return this.getConnectionType() === ConnectionType.WIFI;
  }

  isCellular(): boolean {
    const type = this.getConnectionType();
    return [
      ConnectionType.CELL,
      ConnectionType.CELL_2G,
      ConnectionType.CELL_3G,
      ConnectionType.CELL_4G
    ].includes(type);
  }

  onConnectionChange(callback: (type: ConnectionType) => void): void {
    document.addEventListener('online', () => {
      callback(this.getConnectionType());
    }, false);

    document.addEventListener('offline', () => {
      callback(ConnectionType.NONE);
    }, false);
  }
}