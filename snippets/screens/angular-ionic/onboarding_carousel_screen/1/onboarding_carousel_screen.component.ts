import { Component, OnInit, ViewChild } from '@angular/core';
import { IonSlides } from '@ionic/angular';
import { Router } from '@angular/router';

interface OnboardingPage {
  icon: string;
  title: string;
  description: string;
  color: string;
}

@Component({
  selector: 'app-onboarding-carousel',
  template: `
    <ion-content [style.--background]="currentBackgroundGradient" class="onboarding-container">
      <!-- Skip Button -->
      <div class="header">
        <ion-button fill="clear" color="light" (click)="skip()">
          Skip
        </ion-button>
      </div>

      <!-- Slides -->
      <ion-slides #slides pager="false" [options]="slideOpts" (ionSlideDidChange)="onSlideChange()">
        <ion-slide *ngFor="let page of pages">
          <div class="slide-content">
            <!-- Icon -->
            <div class="icon-container">
              <ion-icon [name]="page.icon" class="page-icon"></ion-icon>
            </div>

            <!-- Content -->
            <h1 class="page-title">{{ page.title }}</h1>
            <p class="page-description">{{ page.description }}</p>
          </div>
        </ion-slide>
      </ion-slides>

      <!-- Navigation -->
      <div class="navigation">
        <!-- Page Indicators -->
        <div class="indicators">
          <div
            *ngFor="let page of pages; let i = index"
            class="indicator"
            [class.active]="i === currentIndex"
          ></div>
        </div>

        <!-- Next Button -->
        <ion-button
          expand="block"
          fill="solid"
          color="light"
          class="next-button"
          (click)="nextSlide()"
        >
          <span>{{ isLastSlide ? 'Get Started' : 'Next' }}</span>
          <ion-icon *ngIf="!isLastSlide" name="arrow-forward" slot="end"></ion-icon>
        </ion-button>
      </div>
    </ion-content>
  `,
  styles: [`
    .onboarding-container {
      color: white;
    }

    .header {
      display: flex;
      justify-content: flex-end;
      padding: 16px;
      padding-top: 60px;
    }

    ion-slides {
      height: 60%;
    }

    .slide-content {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: 24px;
      height: 100%;
    }

    .icon-container {
      width: 120px;
      height: 120px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 60px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 48px;
    }

    .page-icon {
      font-size: 60px;
      color: white;
    }

    .page-title {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 24px;
      line-height: 1.2;
    }

    .page-description {
      font-size: 16px;
      opacity: 0.8;
      line-height: 1.5;
      max-width: 320px;
    }

    .navigation {
      padding: 24px;
    }

    .indicators {
      display: flex;
      justify-content: center;
      gap: 8px;
      margin-bottom: 32px;
    }

    .indicator {
      width: 8px;
      height: 8px;
      border-radius: 4px;
      background: rgba(255, 255, 255, 0.4);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .indicator.active {
      width: 24px;
      background: white;
    }

    .next-button {
      --border-radius: 16px;
      --color: var(--current-color);
      margin: 0;
      height: 56px;
      font-weight: 600;
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
export class OnboardingCarouselScreenComponent implements OnInit {
  @ViewChild('slides', { static: true }) slides!: IonSlides;

  currentIndex = 0;
  currentBackgroundGradient = 'linear-gradient(180deg, #6366F1 0%, rgba(99, 102, 241, 0.8) 100%)';

  pages: OnboardingPage[] = [
    {
      icon: 'bulb-outline',
      title: 'Discover Your AI Potential',
      description: 'Explore the fascinating world of artificial intelligence and discover how smart you really are.',
      color: '#6366F1'
    },
    {
      icon: 'help-circle-outline',
      title: 'Take Smart Challenges',
      description: 'Engage with carefully crafted questions designed to test your AI knowledge and reasoning skills.',
      color: '#8B5CF6'
    },
    {
      icon: 'trending-up-outline',
      title: 'Track Your Progress',
      description: 'Monitor your improvement over time and compete with friends to see who has the highest AIQ score.',
      color: '#06B6D4'
    }
  ];

  slideOpts = {
    initialSlide: 0,
    speed: 400,
    spaceBetween: 0,
  };

  constructor(private router: Router) {}

  ngOnInit() {}

  get isLastSlide(): boolean {
    return this.currentIndex === this.pages.length - 1;
  }

  async onSlideChange() {
    const index = await this.slides.getActiveIndex();
    this.currentIndex = index;
    this.updateBackground();
  }

  private updateBackground() {
    const currentColor = this.pages[this.currentIndex].color;
    this.currentBackgroundGradient = `linear-gradient(180deg, ${currentColor} 0%, ${currentColor}CC 100%)`;
  }

  async nextSlide() {
    if (this.isLastSlide) {
      this.router.navigate(['/welcome']);
    } else {
      await this.slides.slideNext();
    }
  }

  skip() {
    this.router.navigate(['/welcome']);
  }
}