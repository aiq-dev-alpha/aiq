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
  class="rotate-button">
  <span *ngIf="loading" class="spinner orbit-spinner">
  <span class="orbit"></span>
  </span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .rotate-button {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  font-weight: 600;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 5px 20px rgba(245, 158, 11, 0.3);
  }
  .rotate-button:hover:not(:disabled) {
  transform: rotate(2deg) scale(1.05);
  box-shadow: 0 10px 35px rgba(245, 158, 11, 0.5);
  }
  .rotate-button:active:not(:disabled) {
  transform: rotate(0deg) scale(0.98);
  }
  .rotate-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  }
  .orbit-spinner {
  width: 1.2em;
  height: 1.2em;
  position: relative;
  display: inline-block;
  }
  .orbit {
  position: absolute;
  width: 100%;
  height: 100%;
  border: 2px solid transparent;
  border-top-color: currentColor;
  border-radius: 50%;
  animation: orbitRotate 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
  }
  @keyframes orbitRotate {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
  }
  .btn-content {
  display: flex;
  align-items: center;
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'glow' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#f59e0b',
  secondaryColor: '#d97706',
  backgroundColor: '#fffbeb',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#f59e0b',
  accentColor: '#fbbf24'
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
  glow: {
  background: this.appliedTheme.primaryColor,
  color: this.appliedTheme.textColor,
  border: 'none',
  boxShadow: `0 0 30px ${this.appliedTheme.primaryColor}`
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
