// Holographic Shine Card
import { Component, Input } from '@angular/core';
@Component({
  selector: 'app-card',
  template: `<div class="holo-card"><div class="holo-shine"></div><ng-content></ng-content></div>`,
  styles: [`
  .holo-card { position: relative; background: linear-gradient(135deg, #1e3a8a 0%, #312e81 100%); border-radius: 16px; padding: 24px; overflow: hidden; color: white; }
  .holo-shine { position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.1) 50%, transparent 70%); transform: rotate(45deg); animation: shine-move 3s ease-in-out infinite; }
  @keyframes shine-move { 0%, 100% { transform: translateX(-100%) rotate(45deg); } 50% { transform: translateX(100%) rotate(45deg); } }
  `]
})
export class CardComponent {}
