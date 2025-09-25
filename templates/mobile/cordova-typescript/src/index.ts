import './styles.css';
import { CordovaApp } from './app/CordovaApp';
import { DeviceService } from './services/DeviceService';
import { CameraService } from './services/CameraService';
import { LocationService } from './services/LocationService';
import { NetworkService } from './services/NetworkService';
import { DialogService } from './services/DialogService';

declare global {
  interface Window {
    cordova: any;
    device: any;
  }
}

class Application {
  private app: CordovaApp;
  private deviceService: DeviceService;
  private cameraService: CameraService;
  private locationService: LocationService;
  private networkService: NetworkService;
  private dialogService: DialogService;

  constructor() {
    this.deviceService = new DeviceService();
    this.cameraService = new CameraService();
    this.locationService = new LocationService();
    this.networkService = new NetworkService();
    this.dialogService = new DialogService();
    this.app = new CordovaApp(
      this.deviceService,
      this.cameraService,
      this.locationService,
      this.networkService,
      this.dialogService
    );
  }

  initialize(): void {
    document.addEventListener('deviceready', () => {
      console.log('Device is ready');
      this.onDeviceReady();
    }, false);

    // For browser testing
    if (!window.cordova) {
      window.addEventListener('load', () => {
        console.log('Running in browser mode');
        this.onDeviceReady();
      });
    }
  }

  private onDeviceReady(): void {
    this.app.initialize();
    this.bindEvents();
    this.updateDeviceInfo();
    this.updateNetworkStatus();
  }

  private bindEvents(): void {
    const cameraBtn = document.getElementById('btn-camera');
    const locationBtn = document.getElementById('btn-location');
    const dialogBtn = document.getElementById('btn-dialog');
    const vibrateBtn = document.getElementById('btn-vibrate');

    cameraBtn?.addEventListener('click', () => this.handleCamera());
    locationBtn?.addEventListener('click', () => this.handleLocation());
    dialogBtn?.addEventListener('click', () => this.handleDialog());
    vibrateBtn?.addEventListener('click', () => this.handleVibrate());

    // Network events
    document.addEventListener('online', () => this.updateNetworkStatus(), false);
    document.addEventListener('offline', () => this.updateNetworkStatus(), false);
  }

  private async handleCamera(): Promise<void> {
    try {
      const imageUrl = await this.cameraService.takePicture();
      this.updateOutput(`Photo captured: ${imageUrl}`);
    } catch (error) {
      this.updateOutput(`Camera error: ${error}`);
    }
  }

  private async handleLocation(): Promise<void> {
    try {
      const position = await this.locationService.getCurrentPosition();
      this.updateOutput(`Location: ${position.coords.latitude}, ${position.coords.longitude}`);
    } catch (error) {
      this.updateOutput(`Location error: ${error}`);
    }
  }

  private async handleDialog(): Promise<void> {
    await this.dialogService.showAlert('Hello Cordova!', 'This is a TypeScript Cordova app');
    const confirmed = await this.dialogService.showConfirm('Confirm', 'Do you like this app?');
    this.updateOutput(`User confirmed: ${confirmed}`);
  }

  private handleVibrate(): void {
    if (navigator.vibrate) {
      navigator.vibrate(200);
      this.updateOutput('Device vibrated for 200ms');
    } else {
      this.updateOutput('Vibration not supported');
    }
  }

  private updateDeviceInfo(): void {
    const info = this.deviceService.getDeviceInfo();
    const deviceElement = document.getElementById('device-details');
    if (deviceElement) {
      deviceElement.innerHTML = `
        <p><strong>Platform:</strong> ${info.platform}</p>
        <p><strong>Version:</strong> ${info.version}</p>
        <p><strong>Model:</strong> ${info.model}</p>
        <p><strong>UUID:</strong> ${info.uuid}</p>
      `;
    }
  }

  private updateNetworkStatus(): void {
    const status = this.networkService.getConnectionType();
    const statusElement = document.getElementById('network-status');
    if (statusElement) {
      statusElement.innerHTML = `<p><strong>Connection:</strong> ${status}</p>`;
    }
  }

  private updateOutput(message: string): void {
    const outputElement = document.getElementById('output');
    if (outputElement) {
      const timestamp = new Date().toLocaleTimeString();
      outputElement.innerHTML = `<p><strong>[${timestamp}]</strong> ${message}</p>` + outputElement.innerHTML;
    }
  }
}

// Initialize the application
const app = new Application();
app.initialize();