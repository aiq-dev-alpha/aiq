// Masonry Grid List with Stagger Animation
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-list',
  template: `<div class="masonry-list"><div class="list-item" *ngFor="let item of items; let i = index" [style.animation-delay.ms]="i * 100"><ng-content></ng-content></div></div>`,
  styles: [`
  .masonry-list { column-count: 3; column-gap: 16px; }
  @media (max-width: 768px) { .masonry-list { column-count: 2; } }
  @media (max-width: 480px) { .masonry-list { column-count: 1; } }
  .list-item { break-inside: avoid; margin-bottom: 16px; background: white; border-radius: 8px; padding: 16px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); animation: fadeInUp 0.5s ease-out backwards; }
  @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
  `]
})
export class ListComponent {
  @Input() items: any[] = [1, 2, 3, 4, 5, 6];
}