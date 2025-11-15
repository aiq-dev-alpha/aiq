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
  class="wave-button">
  <span *ngIf="loading" class="spinner ring-spinner"></span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .wave-button {
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
  box-shadow: 0 4px 20px rgba(59, 130, 246, 0.4);
  }
  .wave-button::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
  }
  .wave-button:hover:not(:disabled)::after {
  width: 300px;
  height: 300px;
  }
  .wave-button:hover:not(:disabled) {
  box-shadow: 0 8px 30px rgba(59, 130, 246, 0.6);
  transform: translateY(-2px);
  }
  .wave-button:active:not(:disabled) {
  transform: translateY(0);
  }
  .wave-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  }
  .ring-spinner {
  width: 1em;
  height: 1em;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-top-color: currentColor;
  border-bottom-color: currentColor;
  border-radius: 50%;
  animation: ringSpin 1s linear infinite;
  }
  @keyframes ringSpin {
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
  border-radius: 0.5rem;
  }
  .btn-md {
  padding: 0.75rem 2rem;
  font-size: 1rem;
  border-radius: 0.75rem;
  }
  .btn-lg {
  padding: 1rem 2.5rem;
  font-size: 1.125rem;
  border-radius: 1rem;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'glass' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#2563eb',
  backgroundColor: '#eff6ff',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#3b82f6',
  accentColor: '#60a5fa'
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
  glass: {
  background: `rgba(59, 130, 246, 0.2)`,
  color: this.appliedTheme.primaryColor,
  border: `1px solid ${this.appliedTheme.primaryColor}`,
  backdropFilter: 'blur(10px)'
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
