export interface CameraOptions {
  quality?: number;
  destinationType?: number;
  sourceType?: number;
  allowEdit?: boolean;
  encodingType?: number;
  targetWidth?: number;
  targetHeight?: number;
  mediaType?: number;
  correctOrientation?: boolean;
  saveToPhotoAlbum?: boolean;
}

export class CameraService {
  async takePicture(options?: CameraOptions): Promise<string> {
    return new Promise((resolve, reject) => {
      if (!navigator.camera) {
        reject('Camera not available');
        return;
      }

      const defaultOptions: CameraOptions = {
        quality: 75,
        destinationType: Camera.DestinationType.DATA_URL,
        sourceType: Camera.PictureSourceType.CAMERA,
        allowEdit: true,
        encodingType: Camera.EncodingType.JPEG,
        targetWidth: 300,
        targetHeight: 300,
        ...options
      };

      navigator.camera.getPicture(
        (imageData: string) => {
          const imageUrl = 'data:image/jpeg;base64,' + imageData;
          resolve(imageUrl);
        },
        (error: string) => {
          reject(error);
        },
        defaultOptions
      );
    });
  }

  async selectFromGallery(options?: CameraOptions): Promise<string> {
    return this.takePicture({
      ...options,
      sourceType: Camera.PictureSourceType.PHOTOLIBRARY
    });
  }

  cleanup(): void {
    if (navigator.camera && navigator.camera.cleanup) {
      navigator.camera.cleanup(
        () => console.log('Camera cleanup success'),
        (error: string) => console.error('Camera cleanup error:', error)
      );
    }
  }
}