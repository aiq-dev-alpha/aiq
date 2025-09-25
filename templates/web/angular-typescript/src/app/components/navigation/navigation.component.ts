import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';

interface NavItem {
  label: string;
  path: string;
  icon?: string;
}

@Component({
  selector: 'app-navigation',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatToolbarModule,
    MatButtonModule,
    MatIconModule,
    MatMenuModule
  ],
  template: `
    <mat-toolbar color="primary" class="navigation-toolbar">
      <div class="nav-container">
        <div class="nav-brand">
          <button mat-button routerLink="/" class="brand-button">
            <mat-icon>code</mat-icon>
            <span class="brand-text">Angular TS Starter</span>
          </button>
        </div>

        <!-- Desktop Navigation -->
        <nav class="nav-links hide-mobile">
          <button
            *ngFor="let item of navItems"
            mat-button
            [routerLink]="item.path"
            routerLinkActive="active-link"
            [routerLinkActiveOptions]="{exact: item.path === '/'}"
            class="nav-button"
          >
            <mat-icon *ngIf="item.icon" class="nav-icon">{{ item.icon }}</mat-icon>
            {{ item.label }}
          </button>
        </nav>

        <!-- Mobile Navigation Menu -->
        <div class="hide-desktop">
          <button
            mat-icon-button
            [matMenuTriggerFor]="mobileMenu"
            aria-label="Open mobile menu"
          >
            <mat-icon>menu</mat-icon>
          </button>
          <mat-menu #mobileMenu="matMenu">
            <button
              *ngFor="let item of navItems"
              mat-menu-item
              [routerLink]="item.path"
              (click)="navigateAndClose(item.path)"
            >
              <mat-icon *ngIf="item.icon">{{ item.icon }}</mat-icon>
              <span>{{ item.label }}</span>
            </button>
          </mat-menu>
        </div>
      </div>
    </mat-toolbar>
  `,
  styleUrls: ['./navigation.component.scss']
})
export class NavigationComponent {
  private router = inject(Router);

  navItems: NavItem[] = [
    { label: 'Home', path: '/', icon: 'home' },
    { label: 'About', path: '/about', icon: 'info' },
    { label: 'Users', path: '/users', icon: 'people' },
    { label: 'Contact', path: '/contact', icon: 'contact_mail' }
  ];

  navigateAndClose(path: string): void {
    this.router.navigate([path]);
  }
}