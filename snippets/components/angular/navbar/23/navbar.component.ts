import { Component, Input } from '@angular/core';
interface NavLink {
  text: string;
  url: string;
  icon?: string;
}
@Component({
  selector: 'app-navbar',
  template: `
  <header class="header">
  <div class="container">
  <div class="logo">
  <img *ngIf="logoUrl" [src]="logoUrl" alt="Logo" class="logo-img" />
  <span class="logo-text">{{ title }}</span>
  </div>
  <nav class="navigation">
  <a *ngFor="let link of links"
  [href]="link.url"
  class="nav-link">
  <span *ngIf="link.icon">{{ link.icon }}</span>
  {{ link.text }}
  </a>
  </nav>
  </div>
  </header>
  `,
  styles: [`
  .header {
  background: white;
  border-bottom: 1px solid #e5e7eb;
  position: sticky;
  top: 0;
  z-index: 100;
  }
  .container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  }
  .logo {
  display: flex;
  align-items: center;
  gap: 12px;
  }
  .logo-img {
  height: 40px;
  width: auto;
  }
  .logo-text {
  font-size: 20px;
  font-weight: 700;
  color: #1f2937;
  }
  .navigation {
  display: flex;
  gap: 8px;
  }
  .nav-link {
  padding: 8px 16px;
  color: #6b7280;
  text-decoration: none;
  border-radius: 6px;
  transition: all 150ms;
  display: flex;
  align-items: center;
  gap: 6px;
  }
  .nav-link:hover {
  background-color: #f3f4f6;
  color: #3b82f6;
  }
  `]
})
export class NavbarComponent {
  @Input() title = 'App';
  @Input() logoUrl = '';
  @Input() links: NavLink[] = [];
}
