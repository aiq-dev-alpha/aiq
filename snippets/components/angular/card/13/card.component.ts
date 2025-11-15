// Parallax Depth Card
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-card',
  template: `<div class="parallax-card" (mousemove)="onMouseMove($event)" (mouseleave)="onMouseLeave()" [style.transform]="transform"><div class="card-layer layer-1"></div><div class="card-layer layer-2"></div><div class="card-content"><ng-content></ng-content></div></div>`,
  styles: [`
    .parallax-card { position: relative; border-radius: 16px; overflow: hidden; transition: transform 0.1s; }
    .card-layer { position: absolute; inset: 0; border-radius: 16px; }
    .layer-1 { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    .layer-2 { background: linear-gradient(45deg, rgba(255,255,255,0.2), transparent); transform: translate(10px, 10px); }
    .card-content { position: relative; z-index: 1; padding: 24px; color: white; }
  `]
})
export class CardComponent {
  transform = '';
  onMouseMove(e: MouseEvent): void {
    const rect = (e.currentTarget as HTMLElement).getBoundingClientRect();
    const x = (e.clientX - rect.left - rect.width / 2) / 20;
    const y = (e.clientY - rect.top - rect.height / 2) / 20;
    this.transform = `perspective(1000px) rotateX(${-y}deg) rotateY(${x}deg)`;
  }
  onMouseLeave(): void { this.transform = ''; }
}