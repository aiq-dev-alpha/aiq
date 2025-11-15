// Particle Background Navbar
import { Component } from '@angular/core';

@Component({
  selector: 'app-navbar',
  template: `<nav class="particle-nav"><div class="particles"><span class="particle" *ngFor="let p of [1,2,3,4,5,6,7,8]"></span></div><div class="nav-content"><ng-content></ng-content></div></nav>`,
  styles: [`
  .particle-nav { position: relative; background: #1a202c; padding: 16px 32px; overflow: hidden; }
  .particles { position: absolute; inset: 0; }
  .particle { position: absolute; width: 3px; height: 3px; background: #8b5cf6; border-radius: 50%; animation: float 8s infinite; }
  .particle:nth-child(1) { left: 10%; animation-duration: 6s; }
  .particle:nth-child(2) { left: 20%; animation-duration: 8s; animation-delay: 1s; }
  .particle:nth-child(3) { left: 35%; animation-duration: 7s; animation-delay: 2s; }
  .particle:nth-child(4) { left: 50%; animation-duration: 9s; animation-delay: 0.5s; }
  .particle:nth-child(5) { left: 65%; animation-duration: 6.5s; animation-delay: 1.5s; }
  .particle:nth-child(6) { left: 75%; animation-duration: 8.5s; animation-delay: 3s; }
  .particle:nth-child(7) { left: 85%; animation-duration: 7.5s; animation-delay: 2.5s; }
  .particle:nth-child(8) { left: 95%; animation-duration: 9.5s; animation-delay: 0.8s; }
  @keyframes float { 0%, 100% { transform: translateY(100vh); opacity: 0; } 10%, 90% { opacity: 1; } 50% { transform: translateY(-10vh); } }
  .nav-content { position: relative; z-index: 1; color: white; }
  `]
})
export class NavbarComponent {}