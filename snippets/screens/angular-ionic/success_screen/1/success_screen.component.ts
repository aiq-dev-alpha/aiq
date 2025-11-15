import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-success-screen',
  template: `
    <ion-content class="success-container">
      <div class="content-wrapper">
        <!-- Success Icon -->
        <div class="icon-container" [style.transform]="'scale(' + iconScale + ')'">
          <div class="success-circle">
            <ion-icon name="checkmark" class="success-icon"></ion-icon>
          </div>
        </div>

        <!-- Content -->
        <div class="content" [style.opacity]="contentOpacity">
          <h1 class="title">{{ title || 'Success!' }}</h1>
          <p class="message">
            {{ message || "Your profile has been created successfully. You're ready to start your AIQ journey!" }}
          </p>
        </div>

        <!-- Floating Elements -->
        <div class="floating-elements" [style.opacity]="contentOpacity">
          <div class="particle particle-1">✨</div>
          <div class="particle particle-2">🎉</div>
          <div class="particle particle-3">⭐</div>
          <div class="particle particle-4">🚀</div>
        </div>

        <!-- Continue Button -->
        <div class="button-container" [style.opacity]="contentOpacity">
          <ion-button
            expand="block"
            fill="solid"
            color="light"
            class="continue-button"
            (click)="continue()"
          >
            {{ buttonText || 'Get Started' }}
            <ion-icon name="arrow-forward" slot="end"></ion-icon>
          </ion-button>
        </div>
      </div>
    </ion-content>
  `,
  styles: [`
    .success-container {
      --background: linear-gradient(180deg, #10B981 0%, #059669 100%);
      color: white;
    }

    .content-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 24px;
      text-align: center;
      position: relative;
    }

    .icon-container {
      margin-bottom: 40px;
      transition: transform 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .success-circle {
      width: 120px;
      height: 120px;
      background: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
    }

    .success-icon {
      font-size: 60px;
      color: #10B981;
    }

    .content {
      margin-bottom: 60px;
      transition: opacity 0.6s ease-out;
    }

    .title {
      font-size: 32px;
      font-weight: 700;
      margin-bottom: 16px;
      line-height: 1.2;
    }

    .message {
      font-size: 16px;
      opacity: 0.8;
      line-height: 1.5;
      max-width: 320px;
    }

    .floating-elements {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      pointer-events: none;
      transition: opacity 0.4s ease-out;
    }

    .particle {
      position: absolute;
      font-size: 20px;
      animation: float-up 2s ease-out forwards;
    }

    .particle-1 {
      top: 20%;
      left: 20%;
      animation-delay: 0.2s;
    }

    .particle-2 {
      top: 15%;
      right: 15%;
      animation-delay: 0.4s;
    }

    .particle-3 {
      bottom: 40%;
      left: 15%;
      animation-delay: 0.6s;
    }

    .particle-4 {
      bottom: 35%;
      right: 20%;
      animation-delay: 0.8s;
    }

    @keyframes float-up {
      0% {
        transform: translateY(20px);
        opacity: 0;
      }
      50% {
        opacity: 1;
      }
      100% {
        transform: translateY(-20px);
        opacity: 0.5;
      }
    }

    .button-container {
      width: 100%;
      max-width: 320px;
      transition: opacity 0.6s ease-out;
    }

    .continue-button {
      --border-radius: 16px;
      --background: white;
      --color: #10B981;
      height: 56px;
      margin: 0;
      font-weight: 600;
    }
  `]
})
export class SuccessScreenComponent implements OnInit {
  @Input() title?: string;
  @Input() message?: string;
  @Input() buttonText?: string;

  iconScale = 0;
  contentOpacity = 0;

  constructor(private router: Router) {}

  ngOnInit() {
    this.startAnimations();
  }

  private startAnimations() {
    // Icon scale animation
    setTimeout(() => {
      this.iconScale = 1;
    }, 200);

    // Content fade in
    setTimeout(() => {
      this.contentOpacity = 1;
    }, 400);
  }

  continue() {
    this.router.navigate(['/main']);
  }
}