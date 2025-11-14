import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-loading-screen',
  template: `
    <ion-content [style.--background]="backgroundGradient" class="loading-container">
      <div class="content-wrapper">
        <!-- Loading Animation -->
        <div class="animation-container">
          <div class="pulse-ring" [style.transform]="'scale(' + pulseScale + ')'"></div>
          <div class="spinner-ring">
            <ion-spinner name="crescent" color="light"></ion-spinner>
          </div>
          <div class="inner-icon">
            <ion-icon name="bulb" [style.color]="primaryColor"></ion-icon>
          </div>
        </div>

        <!-- Title -->
        <h1 class="title">{{ title || 'Loading' }}</h1>

        <!-- Message -->
        <div class="message-container">
          <p class="message">{{ currentMessage }}</p>
        </div>

        <!-- Progress -->
        <div class="progress-container">
          <div *ngIf="showProgress" class="progress-section">
            <div *ngIf="progress !== undefined" class="progress-text">
              {{ Math.round(progress * 100) }}%
            </div>
            <ion-progress-bar
              [value]="progress || 0"
              color="light"
              class="progress-bar"
            ></ion-progress-bar>
          </div>

          <div *ngIf="!showProgress" class="dots-container">
            <div class="dot" *ngFor="let dot of [0,1,2]; let i = index" [style.animation-delay]="(i * 0.2) + 's'"></div>
          </div>
        </div>
      </div>
    </ion-content>
  `,
  styles: [`
    .loading-container {
      color: white;
    }

    .content-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 32px;
      text-align: center;
    }

    .animation-container {
      position: relative;
      width: 80px;
      height: 80px;
      margin-bottom: 40px;
    }

    .pulse-ring {
      position: absolute;
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.2);
      animation: pulse 1.5s ease-in-out infinite alternate;
    }

    @keyframes pulse {
      from { transform: scale(1); }
      to { transform: scale(1.2); }
    }

    .spinner-ring {
      position: absolute;
      top: 8px;
      left: 8px;
      width: 64px;
      height: 64px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .inner-icon {
      position: absolute;
      top: 16px;
      left: 16px;
      width: 48px;
      height: 48px;
      background: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .inner-icon ion-icon {
      font-size: 24px;
    }

    .title {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 16px;
    }

    .message-container {
      height: 48px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 40px;
    }

    .message {
      font-size: 16px;
      opacity: 0.8;
      line-height: 1.4;
      max-width: 280px;
    }

    .progress-container {
      width: 100%;
      max-width: 280px;
    }

    .progress-section {
      width: 100%;
    }

    .progress-text {
      text-align: right;
      font-size: 14px;
      opacity: 0.7;
      margin-bottom: 8px;
      font-weight: 500;
    }

    .progress-bar {
      --background: rgba(255, 255, 255, 0.3);
      --progress-background: white;
      height: 4px;
      border-radius: 2px;
    }

    .dots-container {
      display: flex;
      justify-content: center;
      gap: 8px;
    }

    .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.6);
      animation: dot-pulse 1.4s ease-in-out infinite;
    }

    @keyframes dot-pulse {
      0%, 80%, 100% { opacity: 0.4; }
      40% { opacity: 1; }
    }
  `]
})
export class LoadingScreenComponent implements OnInit {
  @Input() title?: string;
  @Input() message?: string;
  @Input() showProgress = false;
  @Input() progress?: number;
  @Input() primaryColor = '#6366F1';

  currentMessageIndex = 0;
  pulseScale = 1;

  private loadingMessages = [
    'Preparing your experience...',
    'Loading AI challenges...',
    'Setting up your profile...',
    'Almost ready...'
  ];

  ngOnInit() {
    if (!this.message) {
      this.startMessageCycle();
    }
    this.startPulseAnimation();
  }

  get currentMessage(): string {
    return this.message || this.loadingMessages[this.currentMessageIndex];
  }

  get backgroundGradient(): string {
    return `linear-gradient(180deg, ${this.primaryColor} 0%, ${this.primaryColor}CC 100%)`;
  }

  private startMessageCycle() {
    setInterval(() => {
      this.currentMessageIndex = (this.currentMessageIndex + 1) % this.loadingMessages.length;
    }, 2000);
  }

  private startPulseAnimation() {
    setInterval(() => {
      this.pulseScale = this.pulseScale === 1 ? 1.2 : 1;
    }, 1500);
  }

  Math = Math;
}