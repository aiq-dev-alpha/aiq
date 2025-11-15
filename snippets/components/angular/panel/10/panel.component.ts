// Animated Gradient Background Panel
import { Component } from '@angular/core';

@Component({
  selector: 'app-panel',
  template: `<div class="gradient-panel"><ng-content></ng-content></div>`,
  styles: [`
    .gradient-panel { background: linear-gradient(135deg, #667eea, #764ba2, #f093fb, #667eea); background-size: 400% 400%; border-radius: 16px; padding: 24px; animation: gradient-move 8s ease infinite; color: white; }
    @keyframes gradient-move { 0%, 100% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } }
  `]
})
export class PanelComponent {}