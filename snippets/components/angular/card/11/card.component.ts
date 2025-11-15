// Neumorphic Soft Card
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-card',
  template: `<div class="neu-card"><ng-content></ng-content></div>`,
  styles: [`
    .neu-card { background: #e0e5ec; border-radius: 20px; padding: 28px; box-shadow: 9px 9px 16px rgba(163, 177, 198, 0.6), -9px -9px 16px rgba(255, 255, 255, 0.5); }
  `]
})
export class CardComponent {}