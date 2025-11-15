import { Component, Input, OnInit } from '@angular/core';
import { Location } from '@angular/common';

@Component({
  selector: 'app-error-screen',
  template: `
    <ion-content class="error-container">
      <div class="content-wrapper">
        <!-- Error Icon -->
        <div class="icon-container">
          <div class="error-circle">
            <ion-icon name="alert-circle-outline" class="error-icon"></ion-icon>
          </div>
        </div>

        <!-- Content -->
        <div class="content">
          <h1 class="title">{{ title || 'Oops! Something went wrong' }}</h1>
          <p class="message">
            {{ message || "We encountered an unexpected error. Don't worry, it happens to the best of us! Please try again." }}
          </p>
        </div>

        <!-- Error Illustration -->
        <div class="illustration">
          <div class="robot">🤖</div>
        </div>

        <!-- Action Buttons -->
        <div class="buttons-container">
          <ion-button
            expand="block"
            fill="solid"
            color="primary"
            class="retry-button"
            (click)="retry()"
          >
            <ion-icon name="refresh" slot="start"></ion-icon>
            {{ buttonText || 'Try Again' }}
          </ion-button>

          <ion-button
            expand="block"
            fill="outline"
            color="medium"
            class="back-button"
            (click)="goBack()"
          >
            <ion-icon name="arrow-back" slot="start"></ion-icon>
            Go Back
          </ion-button>
        </div>

        <p class="help-text">
          If the problem persists, please contact our support team
        </p>
      </div>
    </ion-content>
  `,
  styles: [`
    .error-container {
      --background: #ffffff;
    }

    .content-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 24px;
      text-align: center;
    }

    .icon-container {
      margin-bottom: 40px;
    }

    .error-circle {
      width: 120px;
      height: 120px;
      background: rgba(239, 68, 68, 0.1);
      border: 2px solid rgba(239, 68, 68, 0.2);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .error-icon {
      font-size: 60px;
      color: #EF4444;
    }

    .content {
      margin-bottom: 40px;
    }

    .title {
      font-size: 28px;
      font-weight: 700;
      color: #1F2937;
      margin-bottom: 16px;
      line-height: 1.2;
    }

    .message {
      font-size: 16px;
      color: #6B7280;
      line-height: 1.5;
      max-width: 320px;
    }

    .illustration {
      margin-bottom: 40px;
    }

    .robot {
      font-size: 60px;
    }

    .buttons-container {
      width: 100%;
      max-width: 320px;
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 20px;
    }

    .retry-button, .back-button {
      --border-radius: 16px;
      height: 56px;
      margin: 0;
      font-weight: 600;
    }

    .retry-button {
      --background: #6366F1;
    }

    .back-button {
      --border-color: #E5E7EB;
      --color: #6B7280;
    }

    .help-text {
      font-size: 12px;
      color: rgba(107, 114, 128, 0.8);
    }
  
    
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    @keyframes slideIn {
      from { transform: translateX(-20px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes scaleIn {
      from { transform: scale(0.95); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }
  `]
})
export class ErrorScreenComponent implements OnInit {
  @Input() title?: string;
  @Input() message?: string;
  @Input() buttonText?: string;

  constructor(private location: Location) {}

  ngOnInit() {}

  retry() {
    // Implement retry logic
    window.location.reload();
  }

  goBack() {
    this.location.back();
  }
}