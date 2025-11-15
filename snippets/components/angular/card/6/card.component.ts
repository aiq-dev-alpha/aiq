// Glassmorphism Card with Backdrop Blur
import { Component, Input } from '@angular/core';
@Component({
  selector: 'app-card',
  template: `<div class="glass-card" [ngStyle]="cardStyles"><ng-content></ng-content></div>`,
  styles: [`
  .glass-card { background: rgba(255, 255, 255, 0.25); backdrop-filter: blur(12px) saturate(180%); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 16px; padding: 24px; box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15); }
  `]
})
export class CardComponent {
  @Input() theme: any = {};
  get cardStyles() { return {}; }
}
