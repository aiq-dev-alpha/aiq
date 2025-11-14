import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-splash-screen',
  template: `
    <ion-content class="splash-container">
      <div class="content-wrapper">
        <!-- Logo -->
        <div class="logo-container" [style.transform]="'scale(' + logoScale + ')'" [style.opacity]="logoOpacity">
          <div class="logo-card">
            <ion-icon name="rocket" class="logo-icon"></ion-icon>
          </div>
        </div>

        <!-- Title -->
        <div class="title-container" [style.opacity]="textOpacity">
          <h1 class="app-title">AIQ</h1>
          <p class="app-subtitle">Artificial Intelligence Quotient</p>
        </div>

        <!-- Progress Indicator -->
        <div class="progress-container" *ngIf="showProgress" [style.opacity]="progressOpacity">
          <ion-spinner name="crescent" color="light"></ion-spinner>
        </div>
      </div>
    </ion-content>
  `,
  styles: [`
    .splash-container {
      --background: linear-gradient(180deg, #6366F1 0%, rgba(99, 102, 241, 0.8) 100%);
    }

    .content-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      padding: 24px;
      color: white;
    }

    .logo-container {
      margin-bottom: 32px;
      transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    .logo-card {
      width: 120px;
      height: 120px;
      background: white;
      border-radius: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    }

    .logo-icon {
      font-size: 60px;
      color: #6366F1;
    }

    .title-container {
      text-align: center;
      margin-bottom: 80px;
      transition: opacity 0.6s ease-in;
    }

    .app-title {
      font-size: 32px;
      font-weight: 700;
      letter-spacing: 2px;
      margin-bottom: 16px;
    }

    .app-subtitle {
      font-size: 16px;
      opacity: 0.7;
      letter-spacing: 0.5px;
    }

    .progress-container {
      transition: opacity 0.4s ease-in;
    }

    ion-spinner {
      width: 32px;
      height: 32px;
    }
  `]
})
export class SplashScreenComponent implements OnInit {
  logoScale = 0.8;
  logoOpacity = 0;
  textOpacity = 0;
  progressOpacity = 0;
  showProgress = false;

  constructor(private router: Router) {}

  ngOnInit() {
    this.startAnimations();
  }

  private async startAnimations() {
    // Logo fade in
    setTimeout(() => {
      this.logoOpacity = 1;
    }, 100);

    // Logo scale animation
    setTimeout(() => {
      this.logoScale = 1;
    }, 300);

    // Text fade in
    setTimeout(() => {
      this.textOpacity = 1;
    }, 600);

    // Progress indicator
    setTimeout(() => {
      this.showProgress = true;
      this.progressOpacity = 1;
    }, 1000);

    // Navigate to onboarding
    setTimeout(() => {
      this.router.navigate(['/onboarding']);
    }, 3000);
  }
}