// Magnetic Button - Follows cursor on hover
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `<button class="magnetic-btn" (click)="handleClick()" [disabled]="disabled" (mousemove)="onMouseMove($event)" (mouseleave)="onMouseLeave()" [style.transform]="transform"><ng-content></ng-content></button>`,
  styles: [`
  .magnetic-btn { padding: 14px 32px; font-size: 15px; font-weight: 600; border: none; border-radius: 12px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; cursor: pointer; transition: transform 0.1s ease; box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4); }
  .magnetic-btn:active { transform: scale(0.95) !important; }
  `]
})
export class ButtonComponent {
  @Input() disabled = false;
  @Output() clicked = new EventEmitter<void>();
  transform = '';
  handleClick(): void { if (!this.disabled) this.clicked.emit(); }
  onMouseMove(e: MouseEvent): void {
  const rect = (e.target as HTMLElement).getBoundingClientRect();
  const x = e.clientX - rect.left - rect.width / 2;
  const y = e.clientY - rect.top - rect.height / 2;
  this.transform = `translate(${x * 0.3}px, ${y * 0.3}px)`;
  }
  onMouseLeave(): void { this.transform = ''; }
}
