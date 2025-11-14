import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-welcome-screen',
  template: `
    <ion-content class="welcome-container">
      <div class="content-wrapper" [style.opacity]="contentOpacity" [style.transform]="'translateY(' + contentOffset + 'px)'">
        <!-- Header -->
        <div class="header">
          <ion-chip color="primary" class="welcome-badge">
            <ion-label>Welcome!</ion-label>
          </ion-chip>

          <h1 class="main-title">
            Ready to test your<br>AI intelligence?
          </h1>

          <p class="subtitle">
            Join thousands of users discovering their AI potential. Let's get you started
            on your journey to understanding artificial intelligence.
          </p>
        </div>

        <!-- Illustration -->
        <div class="illustration-container" [style.transform]="'scale(' + illustrationScale + ')'">
          <div class="illustration">
            <ion-icon name="bulb" class="illustration-icon"></ion-icon>
            <!-- Floating elements -->
            <div class="floating-element element-1">✨</div>
            <div class="floating-element element-2">🎉</div>
            <div class="floating-element element-3">⭐</div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="buttons-container" [style.opacity]="buttonsOpacity">
          <ion-button
            expand="block"
            fill="solid"
            color="primary"
            class="primary-button"
            (click)="startTutorial()"
          >
            Start Tutorial
            <ion-icon name="arrow-forward" slot="end"></ion-icon>
          </ion-button>

          <ion-button
            expand="block"
            fill="outline"
            color="medium"
            class="secondary-button"
            (click)="skipTutorial()"
          >
            Skip Tutorial
          </ion-button>
        </div>
      </div>
    </ion-content>
  `,
  styles: [`
    .welcome-container {
      --background: #ffffff;
    }

    .content-wrapper {
      display: flex;
      flex-direction: column;
      height: 100vh;
      padding: 24px;
      padding-top: 80px;
      transition: all 0.8s ease-out;
    }

    .header {
      margin-bottom: 40px;
    }

    .welcome-badge {
      margin-bottom: 24px;
      --background: rgba(99, 102, 241, 0.1);
      --color: #6366F1;
    }

    .main-title {
      font-size: 32px;
      font-weight: 700;
      color: #1F2937;
      line-height: 1.2;
      margin-bottom: 16px;
    }

    .subtitle {
      font-size: 16px;
      color: #6B7280;
      line-height: 1.5;
    }

    .illustration-container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: transform 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .illustration {
      position: relative;
      width: 200px;
      height: 200px;
      background: linear-gradient(135deg, #6366F1, #8B5CF6);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 20px 40px rgba(99, 102, 241, 0.3);
    }

    .illustration-icon {
      font-size: 80px;
      color: white;
    }

    .floating-element {
      position: absolute;
      font-size: 20px;
      animation: float 3s ease-in-out infinite;
    }

    .element-1 {
      top: -10px;
      left: -10px;
      animation-delay: 0s;
    }

    .element-2 {
      top: -5px;
      right: -15px;
      animation-delay: 1s;
    }

    .element-3 {
      bottom: -10px;
      left: -5px;
      animation-delay: 2s;
    }

    @keyframes float {
      0%, 100% { transform: translateY(0px); }
      50% { transform: translateY(-10px); }
    }

    .buttons-container {
      display: flex;
      flex-direction: column;
      gap: 16px;
      transition: opacity 0.6s ease-out;
    }

    .primary-button, .secondary-button {
      --border-radius: 16px;
      height: 56px;
      margin: 0;
      font-weight: 600;
    }

    .primary-button {
      --background: #6366F1;
    }

    .secondary-button {
      --border-color: #E5E7EB;
      --color: #6B7280;
    }
  `]
})
export class WelcomeScreenComponent implements OnInit {
  contentOpacity = 0;
  contentOffset = 30;
  illustrationScale = 0.8;
  buttonsOpacity = 0;

  constructor(private router: Router) {}

  ngOnInit() {
    this.startAnimations();
  }

  private startAnimations() {
    // Content fade in
    setTimeout(() => {
      this.contentOpacity = 1;
      this.contentOffset = 0;
    }, 100);

    // Illustration scale
    setTimeout(() => {
      this.illustrationScale = 1;
    }, 400);

    // Buttons fade in
    setTimeout(() => {
      this.buttonsOpacity = 1;
    }, 800);
  }

  startTutorial() {
    this.router.navigate(['/tutorial']);
  }

  skipTutorial() {
    this.router.navigate(['/main']);
  }
}