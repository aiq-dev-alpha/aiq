// Glowing Border Panel
import { Component } from '@angular/core';
@Component({
  selector: 'app-panel',
  template: `<div class="glow-panel"><div class="glow-border"></div><div class="panel-content"><ng-content></ng-content></div></div>`,
  styles: [`
  .glow-panel { position: relative; background: #1a202c; border-radius: 12px; padding: 24px; overflow: hidden; }
  .glow-border { position: absolute; inset: -2px; background: linear-gradient(45deg, #667eea, #764ba2, #667eea); background-size: 200% 200%; border-radius: 12px; animation: border-glow 3s linear infinite; opacity: 0.5; z-index: 0; }
  @keyframes border-glow { 0%, 100% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } }
  .panel-content { position: relative; z-index: 1; color: white; }
  `]
})
export class PanelComponent {}
