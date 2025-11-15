// Striped Pattern Panel
import { Component } from '@angular/core';

@Component({
  selector: 'app-panel',
  template: `<div class="stripe-panel"><ng-content></ng-content></div>`,
  styles: [`
  .stripe-panel { background: repeating-linear-gradient(45deg, #f3f4f6, #f3f4f6 10px, #e5e7eb 10px, #e5e7eb 20px); border-radius: 12px; padding: 24px; border: 2px solid #d1d5db; }
  `]
})
export class PanelComponent {}