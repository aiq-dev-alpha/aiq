// Neon Glow Card
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-card',
  template: `<div class="neon-card"><div class="neon-glow"></div><ng-content></ng-content></div>`,
  styles: [`
  .neon-card { position: relative; background: #0a0a0a; border: 2px solid #00ffff; border-radius: 12px; padding: 24px; box-shadow: 0 0 20px rgba(0, 255, 255, 0.5), inset 0 0 20px rgba(0, 255, 255, 0.1); }
  .neon-glow { position: absolute; inset: -2px; background: linear-gradient(45deg, #00ffff, #ff00ff); border-radius: 12px; opacity: 0.3; filter: blur(20px); z-index: -1; animation: glow-pulse 2s ease-in-out infinite; }
  @keyframes glow-pulse { 0%, 100% { opacity: 0.3; } 50% { opacity: 0.6; } }
  `]
})
export class CardComponent {
  @Input() theme: unknown = {};
}
