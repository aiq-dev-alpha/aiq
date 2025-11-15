// Glow Line Navbar
import { Component } from '@angular/core';
@Component({
  selector: 'app-navbar',
  template: `<nav class="glow-line-nav"><div class="glow-line"></div><ng-content></ng-content></nav>`,
  styles: [`
  .glow-line-nav { position: relative; background: #0f172a; padding: 16px 32px; color: white; }
  .glow-line { position: absolute; bottom: 0; left: 0; width: 100%; height: 3px; background: linear-gradient(90deg, transparent, #6366f1, #8b5cf6, #ec4899, transparent); background-size: 200% 100%; animation: glow-slide 3s linear infinite; }
  @keyframes glow-slide { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }
  `]
})
export class NavbarComponent {}
