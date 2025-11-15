// Morphing Menu Navbar
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-navbar',
  template: `<nav class="morph-nav"><button class="morph-btn" (click)="open=!open" [class.active]="open"><span class="line"></span><span class="line"></span><span class="line"></span></button><div class="menu" [class.open]="open"><ng-content></ng-content></div></nav>`,
  styles: [`
  .morph-nav { background: #2d3748; padding: 16px 24px; }
  .morph-btn { background: none; border: none; cursor: pointer; padding: 0; width: 30px; height: 24px; position: relative; }
  .line { display: block; width: 100%; height: 3px; background: white; border-radius: 3px; transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); margin: 6px 0; }
  .morph-btn.active .line:nth-child(1) { transform: translateY(9px) rotate(45deg); }
  .morph-btn.active .line:nth-child(2) { opacity: 0; }
  .morph-btn.active .line:nth-child(3) { transform: translateY(-9px) rotate(-45deg); }
  .menu { max-height: 0; overflow: hidden; transition: max-height 0.4s; }
  .menu.open { max-height: 500px; }
  `]
})
export class NavbarComponent {
  open = false;
}
