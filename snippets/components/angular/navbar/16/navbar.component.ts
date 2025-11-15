// Frosted Glass Navbar with Blur
import { Component } from '@angular/core';

@Component({
  selector: 'app-navbar',
  template: `<nav class="frosted-nav"><ng-content></ng-content></nav>`,
  styles: [`
    .frosted-nav { background: rgba(255, 255, 255, 0.15); backdrop-filter: blur(30px) saturate(200%); border-bottom: 1px solid rgba(255, 255, 255, 0.25); padding: 16px 32px; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
  `]
})
export class NavbarComponent {}