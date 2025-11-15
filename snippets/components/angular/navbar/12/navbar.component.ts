// Neon Cyberpunk Navbar
import { Component } from '@angular/core';
@Component({
  selector: 'app-navbar',
  template: `<nav class="cyber-nav"><div class="scan-line"></div><ng-content></ng-content></nav>`,
  styles: [`
  .cyber-nav { position: relative; background: linear-gradient(90deg, #0a0e1a 0%, #151b2d 100%); border-top: 2px solid #00ff9f; border-bottom: 2px solid #ff006e; padding: 16px 32px; font-family: 'Courier New', monospace; }
  .scan-line { position: absolute; top: 0; left: 0; width: 100%; height: 2px; background: linear-gradient(90deg, transparent, #00ff9f, transparent); animation: scan 2s linear infinite; }
  @keyframes scan { 0% { transform: translateX(-100%); } 100% { transform: translateX(100%); } }
  `]
})
export class NavbarComponent {}
