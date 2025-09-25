export class DialogService {
  async showAlert(message: string, title?: string, buttonName?: string): Promise<void> {
    return new Promise((resolve) => {
      if (navigator.notification) {
        navigator.notification.alert(
          message,
          () => resolve(),
          title || 'Alert',
          buttonName || 'OK'
        );
      } else {
        // Fallback for browser
        alert(`${title || 'Alert'}: ${message}`);
        resolve();
      }
    });
  }

  async showConfirm(message: string, title?: string, buttonLabels?: string[]): Promise<boolean> {
    return new Promise((resolve) => {
      if (navigator.notification) {
        navigator.notification.confirm(
          message,
          (buttonIndex: number) => {
            resolve(buttonIndex === 1);
          },
          title || 'Confirm',
          buttonLabels || ['OK', 'Cancel']
        );
      } else {
        // Fallback for browser
        const result = confirm(`${title || 'Confirm'}: ${message}`);
        resolve(result);
      }
    });
  }

  async showPrompt(
    message: string,
    title?: string,
    buttonLabels?: string[],
    defaultText?: string
  ): Promise<string | null> {
    return new Promise((resolve) => {
      if (navigator.notification) {
        navigator.notification.prompt(
          message,
          (result: any) => {
            if (result.buttonIndex === 1) {
              resolve(result.input1);
            } else {
              resolve(null);
            }
          },
          title || 'Input',
          buttonLabels || ['OK', 'Cancel'],
          defaultText || ''
        );
      } else {
        // Fallback for browser
        const result = prompt(`${title || 'Input'}: ${message}`, defaultText || '');
        resolve(result);
      }
    });
  }

  beep(times: number = 1): void {
    if (navigator.notification) {
      navigator.notification.beep(times);
    } else {
      // Fallback for browser - play a simple beep sound
      const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
      for (let i = 0; i < times; i++) {
        setTimeout(() => {
          const oscillator = audioContext.createOscillator();
          oscillator.connect(audioContext.destination);
          oscillator.frequency.value = 800;
          oscillator.start();
          oscillator.stop(audioContext.currentTime + 0.1);
        }, i * 200);
      }
    }
  }
}