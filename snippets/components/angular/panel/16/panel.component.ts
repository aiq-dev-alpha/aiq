// Glassmorphic Panel
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-panel',
  template: `<div class="glass-panel"><ng-content></ng-content></div>`,
  styles: [`
  .glass-panel { background: rgba(255, 255, 255, 0.2); backdrop-filter: blur(16px) saturate(180%); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 16px; padding: 24px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
  `]
})
export class PanelComponent {}
