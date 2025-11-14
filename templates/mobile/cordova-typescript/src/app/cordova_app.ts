import { DeviceService } from '../services/DeviceService';
import { CameraService } from '../services/CameraService';
import { LocationService } from '../services/LocationService';
import { NetworkService } from '../services/NetworkService';
import { DialogService } from '../services/DialogService';

export class CordovaApp {
  constructor(
    private deviceService: DeviceService,
    private cameraService: CameraService,
    private locationService: LocationService,
    private networkService: NetworkService,
    private dialogService: DialogService
  ) {}

  initialize(): void {
    console.log('Initializing Cordova App');
    this.setupStatusBar();
    this.setupSplashScreen();
  }

  private setupStatusBar(): void {
    if (window.StatusBar) {
      window.StatusBar.styleDefault();
    }
  }

  private setupSplashScreen(): void {
    if (navigator.splashscreen) {
      setTimeout(() => {
        navigator.splashscreen.hide();
      }, 2000);
    }
  }
}