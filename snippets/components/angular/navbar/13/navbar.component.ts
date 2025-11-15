// Split Reveal Navbar
import { Component } from '@angular/core';

@Component({
  selector: 'app-navbar',
  template: `<nav class="split-nav"><div class="split-left"><ng-content select="[left]"></ng-content></div><div class="split-divider"></div><div class="split-right"><ng-content select="[right]"></ng-content></div></nav>`,
  styles: [`
  .split-nav { display: flex; align-items: center; justify-content: space-between; background: #111827; padding: 16px 32px; gap: 24px; }
  .split-left, .split-right { flex: 1; color: white; }
  .split-divider { width: 2px; height: 40px; background: linear-gradient(180deg, transparent, #8b5cf6, transparent); animation: glow 2s ease-in-out infinite; }
  @keyframes glow { 0%, 100% { box-shadow: 0 0 10px #8b5cf6; } 50% { box-shadow: 0 0 20px #8b5cf6; } }
  `]
})
export class NavbarComponent {}