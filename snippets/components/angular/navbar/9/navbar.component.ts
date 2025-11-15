// Glassmorphism Floating Navbar
import { Component } from '@angular/core';
@Component({
  selector: 'app-navbar',
  template: `<nav class="glass-nav"><ng-content></ng-content></nav>`,
  styles: [`
  .glass-nav { background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(20px) saturate(180%); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 16px; padding: 12px 24px; margin: 16px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
  `]
})
export class NavbarComponent {}
