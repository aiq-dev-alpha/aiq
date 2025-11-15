// Layered Shadow Depth Panel
import { Component } from '@angular/core';

@Component({
  selector: 'app-panel',
  template: `<div class="depth-panel"><ng-content></ng-content></div>`,
  styles: [`
    .depth-panel { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 2px 4px rgba(0,0,0,0.05), 0 4px 8px rgba(0,0,0,0.05), 0 8px 16px rgba(0,0,0,0.05), 0 16px 32px rgba(0,0,0,0.05); transition: transform 0.3s, box-shadow 0.3s; }
    .depth-panel:hover { transform: translateY(-4px); box-shadow: 0 4px 8px rgba(0,0,0,0.08), 0 8px 16px rgba(0,0,0,0.08), 0 16px 32px rgba(0,0,0,0.08), 0 32px 64px rgba(0,0,0,0.08); }
  `]
})
export class PanelComponent {}