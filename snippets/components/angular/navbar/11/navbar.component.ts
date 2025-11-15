// Expanding Blob Navbar
import { Component } from '@angular/core';

@Component({
  selector: 'app-navbar',
  template: `<nav class="blob-nav"><div class="blob"></div><div class="nav-content"><ng-content></ng-content></div></nav>`,
  styles: [`
  .blob-nav { position: relative; background: transparent; padding: 16px 32px; overflow: hidden; }
  .blob { position: absolute; inset: 0; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; transform: scale(0.8); animation: blob-morph 8s ease-in-out infinite; z-index: 0; }
  @keyframes blob-morph { 0%, 100% { border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%; } 50% { border-radius: 30% 60% 70% 40% / 50% 60% 30% 60%; } }
  .nav-content { position: relative; z-index: 1; color: white; }
  `]
})
export class NavbarComponent {}