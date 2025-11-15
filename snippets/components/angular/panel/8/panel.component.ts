// Neon Frame Panel
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-panel',
  template: `<div class="neon-panel"><ng-content></ng-content></div>`,
  styles: [`
  .neon-panel { background: #0a0a0a; border: 2px solid #ff00ff; border-radius: 8px; padding: 24px; box-shadow: 0 0 20px rgba(255, 0, 255, 0.5), inset 0 0 20px rgba(255, 0, 255, 0.1); color: white; }
  `]
})
export class PanelComponent {}
