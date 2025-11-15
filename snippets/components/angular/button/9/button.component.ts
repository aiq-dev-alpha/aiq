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
  class="neon-pulse-button">
  <span *ngIf="loading" class="spinner neon-spinner"></span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .neon-pulse-button {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
  }
  .neon-pulse-button:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 0 40px rgba(139, 92, 246, 0.6), 0 0 80px rgba(236, 72, 153, 0.4);
  animation: neonPulse 1.5s ease-in-out infinite;
  }
  .neon-pulse-button:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
  }
  .neon-pulse-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  }
  @keyframes neonPulse {
  0%, 100% { box-shadow: 0 0 40px rgba(139, 92, 246, 0.6), 0 0 80px rgba(236, 72, 153, 0.4); }
  50% { box-shadow: 0 0 60px rgba(139, 92, 246, 0.8), 0 0 120px rgba(236, 72, 153, 0.6); }
  }
  .neon-spinner {
  width: 1em;
  height: 1em;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: neonSpin 0.8s linear infinite;
  }
  @keyframes neonSpin {
  to { transform: rotate(360deg); }
  }
  .btn-content {
  display: flex;
  align-items: center;
  }
  .btn-sm {
  padding: 0.5rem 1.25rem;
  font-size: 0.875rem;
  border-radius: 0.75rem;
  }
  .btn-md {
  padding: 0.75rem 1.75rem;
  font-size: 1rem;
  border-radius: 1rem;
  }
  .btn-lg {
  padding: 1rem 2.5rem;
  font-size: 1.125rem;
  border-radius: 1.25rem;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'ghost' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#8b5cf6',
  secondaryColor: '#ec4899',
  backgroundColor: '#1e1b4b',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#8b5cf6',
  accentColor: '#a78bfa'
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
  ghost: {
  background: 'rgba(139, 92, 246, 0.1)',
  color: this.appliedTheme.primaryColor,
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
