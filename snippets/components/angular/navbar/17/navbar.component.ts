// Sticky Header with Shrink Animation
import { Component, HostListener } from '@angular/core';
@Component({
  selector: 'app-navbar',
  template: `<nav class="sticky-nav" [class.scrolled]="scrolled"><ng-content></ng-content></nav>`,
  styles: [`
  .sticky-nav { position: fixed; top: 0; left: 0; right: 0; background: white; padding: 24px 32px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); z-index: 1000; }
  .sticky-nav.scrolled { padding: 12px 32px; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); }
  `]
})
export class NavbarComponent {
  scrolled = false;
  @HostListener('window:scroll')
  onScroll() { this.scrolled = window.scrollY > 50; }
}
