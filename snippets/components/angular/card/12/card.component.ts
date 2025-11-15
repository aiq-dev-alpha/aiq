// Gradient Border Animated Card
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-card',
  template: `<div class="gradient-border-card"><div class="card-content"><ng-content></ng-content></div></div>`,
  styles: [`
  .gradient-border-card { position: relative; padding: 3px; background: linear-gradient(45deg, #ff0080, #ff8c00, #40e0d0, #ff0080); background-size: 400% 400%; border-radius: 16px; animation: gradient-shift 6s ease infinite; }
  @keyframes gradient-shift { 0%, 100% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } }
  .card-content { background: white; border-radius: 14px; padding: 24px; }
  `]
})
export class CardComponent {}
