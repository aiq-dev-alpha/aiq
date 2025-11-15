// Ripple Effect Interactive Panel
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-panel',
  template: `<div class="ripple-panel" (click)="createRipple($event)"><span class="ripple-effect" *ngIf="showRipple" [style.left.px]="rippleX" [style.top.px]="rippleY"></span><ng-content></ng-content></div>`,
  styles: [`
  .ripple-panel { position: relative; background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 24px; overflow: hidden; cursor: pointer; transition: all 0.3s; }
  .ripple-panel:hover { border-color: #6366f1; box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2); }
  .ripple-effect { position: absolute; width: 10px; height: 10px; background: rgba(99, 102, 241, 0.4); border-radius: 50%; transform: translate(-50%, -50%); animation: ripple-expand 0.6s ease-out forwards; pointer-events: none; }
  @keyframes ripple-expand { 0% { width: 10px; height: 10px; opacity: 0.8; } 100% { width: 400px; height: 400px; opacity: 0; } }
  `]
})
export class PanelComponent {
  showRipple = false;
  rippleX = 0;
  rippleY = 0;
  createRipple(e: MouseEvent): void {
  this.rippleX = e.offsetX;
  this.rippleY = e.offsetY;
  this.showRipple = true;
  setTimeout(() => this.showRipple = false, 600);
  }
}
