declare interface Window {
  StatusBar: any;
  device: any;
  cordova: any;
}

declare const Camera: any;
declare const Connection: any;

declare namespace navigator {
  let camera: any;
  let notification: any;
  let splashscreen: any;
  let connection: any;
}