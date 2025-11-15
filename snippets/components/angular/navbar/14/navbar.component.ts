// Wave Effect Navbar
import { Component } from '@angular/core';
@Component({
  selector: 'app-navbar',
  template: `<nav class="wave-nav"><svg class="wave" viewBox="0 0 1200 60" preserveAspectRatio="none"><path d="M0,30 Q300,0 600,30 T1200,30 L1200,60 L0,60 Z" fill="rgba(99, 102, 241, 0.3)"/><path d="M0,35 Q300,5 600,35 T1200,35 L1200,60 L0,60 Z" fill="rgba(99, 102, 241, 0.2)"/></svg><div class="nav-content"><ng-content></ng-content></div></nav>`,
  styles: [`
  .wave-nav { position: relative; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px 32px; overflow: hidden; }
  .wave { position: absolute; bottom: 0; left: 0; width: 100%; height: 60px; animation: wave-flow 8s linear infinite; }
  @keyframes wave-flow { 0% { transform: translateX(0); } 100% { transform: translateX(-600px); } }
  .nav-content { position: relative; z-index: 1; color: white; }
  `]
})
export class NavbarComponent {}
