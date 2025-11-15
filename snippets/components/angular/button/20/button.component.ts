import { Component, Input, Output, EventEmitter } from '@angular/core';
interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  accentColor: string;
}
@Component({
  selector: 'app-button',
  template: `
  <button
  [ngClass]="['btn', 'btn-' + variant, 'btn-' + size]"
  [ngStyle]="buttonStyles"
  [disabled]="disabled || loading"
  [attr.aria-label]="ariaLabel"
  [attr.aria-busy]="loading"
  (click)="handleClick($event)"
  class="glow-pulse-button">
  <span *ngIf="loading" class="spinner star-spinner"></span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .glow-pulse-button {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 0 25px rgba(251, 146, 60, 0.5);
  animation: glowPulse 2s ease-in-out infinite;
  }
  @keyframes glowPulse {
  0%, 100% { box-shadow: 0 0 25px rgba(251, 146, 60, 0.5); }
  50% { box-shadow: 0 0 40px rgba(251, 146, 60, 0.8), 0 0 60px rgba(251, 146, 60, 0.4); }
  }
  .glow-pulse-button:hover:not(:disabled) {
  transform: scale(1.05);
  animation: glowPulse 1s ease-in-out infinite;
  }
  .glow-pulse-button:active:not(:disabled) {
  transform: scale(0.98);
  }
  .glow-pulse-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  animation: none;
  }
  .star-spinner {
  width: 1em;
  height: 1em;
  background: currentColor;
  clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
  animation: starRotate 2s linear infinite;
  }
  @keyframes starRotate {
  to { transform: rotate(360deg); }
  }
  .btn-content {
  display: flex;
  align-items: center;
  position: relative;
  z-index: 1;
  }
  .icon-left, .icon-right {
  position: relative;
  z-index: 1;
  }
  .btn-sm {
  padding: 0.5rem 1.5rem;
  font-size: 0.875rem;
  border-radius: 0.625rem;
  }
  .btn-md {
  padding: 0.75rem 2rem;
  font-size: 1rem;
  border-radius: 0.875rem;
  }
  .btn-lg {
  padding: 1rem 2.5rem;
  font-size: 1.125rem;
  border-radius: 1.125rem;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'glowing' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#fb923c',
  secondaryColor: '#f97316',
  backgroundColor: '#fff7ed',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#fb923c',
  accentColor: '#fdba74'
  };
  get appliedTheme(): ButtonTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get buttonStyles() {
  const variantStyles = {
  default: {
  background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
  color: this.appliedTheme.textColor,
  border: 'none'
  },
  outlined: {
  background: 'transparent',
  color: this.appliedTheme.primaryColor,
  border: `2px solid ${this.appliedTheme.primaryColor}`
  },
  filled: {
  background: this.appliedTheme.primaryColor,
  color: this.appliedTheme.textColor,
  border: 'none'
  },
  glowing: {
  background: `radial-gradient(circle, ${this.appliedTheme.accentColor}, ${this.appliedTheme.primaryColor})`,
  color: this.appliedTheme.textColor,
  border: 'none'
  }
  };
  return variantStyles[this.variant];
  }
  handleClick(event: MouseEvent): void {
  if (!this.disabled && !this.loading) {
  this.clicked.emit(event);
  }
  }
}
