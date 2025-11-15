// Liquid Fill Button - Fills with color on hover
import { Component, Input, Output, EventEmitter } from '@angular/core';
@Component({
  selector: 'app-button',
  template: `<button class="liquid-btn" (click)="handleClick()" [disabled]="disabled"><span class="liquid-fill"></span><span class="btn-text"><ng-content></ng-content></span></button>`,
  styles: [`
  .liquid-btn { position: relative; padding: 14px 32px; font-size: 15px; font-weight: 600; border: 2px solid #f59e0b; background: transparent; color: #f59e0b; cursor: pointer; border-radius: 50px; overflow: hidden; transition: color 0.5s; }
  .liquid-fill { position: absolute; bottom: 0; left: 0; width: 100%; height: 0; background: #f59e0b; transition: height 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55); z-index: 0; border-radius: 50% 50% 0 0; }
  .liquid-btn:hover .liquid-fill { height: 100%; border-radius: 0; }
  .liquid-btn:hover { color: white; }
  .btn-text { position: relative; z-index: 1; }
  `]
})
export class ButtonComponent {
  @Input() disabled = false;
  @Output() clicked = new EventEmitter<void>();
  handleClick(): void { if (!this.disabled) this.clicked.emit(); }
}
