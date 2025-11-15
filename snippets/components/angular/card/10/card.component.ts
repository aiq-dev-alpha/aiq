// 3D Flip Card
import { Component, Input } from '@angular/core';
@Component({
  selector: 'app-card',
  template: `<div class="flip-card" (click)="flipped = !flipped" [class.flipped]="flipped"><div class="flip-inner"><div class="flip-front"><ng-content select="[front]"></ng-content></div><div class="flip-back"><ng-content select="[back]"></ng-content></div></div></div>`,
  styles: [`
  .flip-card { perspective: 1000px; cursor: pointer; }
  .flip-inner { position: relative; width: 100%; height: 300px; transition: transform 0.6s; transform-style: preserve-3d; }
  .flip-card.flipped .flip-inner { transform: rotateY(180deg); }
  .flip-front, .flip-back { position: absolute; width: 100%; height: 100%; backface-visibility: hidden; border-radius: 16px; padding: 24px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; display: flex; align-items: center; justify-content: center; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15); }
  .flip-back { transform: rotateY(180deg); background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
  `]
})
export class CardComponent {
  flipped = false;
}
