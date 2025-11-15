// Morphing Shape Button - Changes shape on interaction
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `<button class="morph-btn" [class.active]="isActive" (click)="handleClick()" (mousedown)="isActive=true" (mouseup)="isActive=false" (mouseleave)="isActive=false" [disabled]="disabled"><ng-content></ng-content></button>`,
  styles: [`
  .morph-btn { padding: 14px 28px; font-size: 15px; font-weight: 600; border: 3px solid #10b981; background: transparent; color: #10b981; cursor: pointer; border-radius: 8px; transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); position: relative; overflow: hidden; }
  .morph-btn::before { content: ''; position: absolute; inset: 0; background: #10b981; transform: scale(0); transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); border-radius: 50%; }
  .morph-btn.active { border-radius: 50px; }
  .morph-btn.active::before { transform: scale(1); border-radius: 8px; }
  .morph-btn.active { color: white; }
  `]
})
export class ButtonComponent {
  @Input() disabled = false;
  @Output() clicked = new EventEmitter<void>();
  isActive = false;
  handleClick(): void { if (!this.disabled) this.clicked.emit(); }
}
