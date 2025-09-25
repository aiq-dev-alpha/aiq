import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatGridListModule } from '@angular/material/grid-list';
import { CounterService } from '@core/services/counter.service';

interface Feature {
  icon: string;
  title: string;
  description: string;
}

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatGridListModule
  ],
  template: `
    <div class="home-container">
      <!-- Hero Section -->
      <section class="hero-section text-center mb-5">
        <h1 class="hero-title">
          Welcome to Angular TypeScript Starter
        </h1>
        <p class="hero-subtitle">
          A modern, fully-featured Angular starter template with Material UI, routing, and services!
        </p>
      </section>

      <!-- Demo Cards -->
      <section class="demo-section mb-5">
        <div class="demo-grid">
          <!-- Counter Demo -->
          <mat-card class="demo-card">
            <mat-card-header>
              <mat-card-title>Service Demo (Counter)</mat-card-title>
              <mat-card-subtitle>Injectable service with reactive state</mat-card-subtitle>
            </mat-card-header>
            <mat-card-content>
              <div class="counter-display">
                <div class="counter-value">{{ counterService.count() }}</div>
                <div class="counter-actions">
                  <button mat-raised-button color="primary" (click)="counterService.increment()">
                    <mat-icon>add</mat-icon>
                    Increment
                  </button>
                  <button mat-raised-button color="accent" (click)="counterService.decrement()">
                    <mat-icon>remove</mat-icon>
                    Decrement
                  </button>
                  <button mat-raised-button (click)="counterService.reset()">
                    <mat-icon>refresh</mat-icon>
                    Reset
                  </button>
                </div>
              </div>
            </mat-card-content>
          </mat-card>

          <!-- Info Card -->
          <mat-card class="demo-card">
            <mat-card-header>
              <mat-card-title>Angular 17 Features</mat-card-title>
              <mat-card-subtitle>Modern Angular development</mat-card-subtitle>
            </mat-card-header>
            <mat-card-content>
              <div class="feature-list">
                <div class="feature-item">
                  <mat-icon>code</mat-icon>
                  <span>Standalone Components</span>
                </div>
                <div class="feature-item">
                  <mat-icon>signal_wifi_4_bar</mat-icon>
                  <span>Signals (Reactive Primitives)</span>
                </div>
                <div class="feature-item">
                  <mat-icon>route</mat-icon>
                  <span>Functional Route Guards</span>
                </div>
                <div class="feature-item">
                  <mat-icon>speed</mat-icon>
                  <span>Improved Performance</span>
                </div>
              </div>
            </mat-card-content>
          </mat-card>
        </div>
      </section>

      <!-- Features Grid -->
      <section class="features-section">
        <h2 class="features-title text-center mb-4">Features Included</h2>
        <mat-grid-list [cols]="getGridCols()" rowHeight="300px" gutterSize="16px">
          <mat-grid-tile *ngFor="let feature of features">
            <mat-card class="feature-card">
              <mat-card-content>
                <div class="feature-icon">
                  <mat-icon>{{ feature.icon }}</mat-icon>
                </div>
                <h3 class="feature-title">{{ feature.title }}</h3>
                <p class="feature-description">{{ feature.description }}</p>
              </mat-card-content>
            </mat-card>
          </mat-grid-tile>
        </mat-grid-list>
      </section>
    </div>
  `,
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  counterService = inject(CounterService);

  features: Feature[] = [
    {
      icon: 'code',
      title: 'TypeScript',
      description: 'Full TypeScript support with strict type checking and modern ES features'
    },
    {
      icon: 'design_services',
      title: 'Material UI',
      description: 'Google\'s Material Design components for consistent and beautiful UI'
    },
    {
      icon: 'route',
      title: 'Angular Router',
      description: 'Advanced routing with lazy loading and route guards'
    },
    {
      icon: 'build',
      title: 'Angular CLI',
      description: 'Powerful command-line interface for development and building'
    },
    {
      icon: 'bug_report',
      title: 'Testing Setup',
      description: 'Jasmine and Karma configured for unit testing'
    },
    {
      icon: 'settings',
      title: 'ESLint & Prettier',
      description: 'Code linting and formatting for consistent code style'
    }
  ];

  ngOnInit(): void {
    console.log('HomeComponent initialized');
  }

  getGridCols(): number {
    if (typeof window !== 'undefined') {
      return window.innerWidth <= 768 ? 1 : window.innerWidth <= 1024 ? 2 : 3;
    }
    return 3;
  }
}