// Slide-in Mobile Navbar
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-navbar',
  template: `<nav class="slide-nav"><button class="menu-toggle" (click)="menuOpen = !menuOpen">☰</button><div class="menu" [class.open]="menuOpen"><ng-content></ng-content></div></nav>`,
  styles: [`
  .slide-nav { position: relative; background: #1f2937; padding: 16px; }
  .menu-toggle { background: none; border: none; color: white; font-size: 24px; cursor: pointer; }
  .menu { position: fixed; top: 0; left: 0; height: 100vh; width: 280px; background: #111827; transform: translateX(-100%); transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); padding: 80px 24px; z-index: 1000; }
  .menu.open { transform: translateX(0); }
  `]
})
export class NavbarComponent {
  menuOpen = false;
}
