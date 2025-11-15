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
  class="elastic-button">
  <span *ngIf="loading" class="spinner diamond-spinner"></span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .elastic-button {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  font-weight: 600;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 6px 20px rgba(132, 204, 22, 0.4);
  }

  .elastic-button:hover:not(:disabled) {
  transform: scale(1.1);
  box-shadow: 0 10px 35px rgba(132, 204, 22, 0.6);
  }

  .elastic-button:active:not(:disabled) {
  transform: scale(0.9);
  transition: all 0.1s ease;
  }

  .elastic-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  }

  .diamond-spinner {
  width: 1em;
  height: 1em;
  background: currentColor;
  transform: rotate(45deg);
  animation: diamondPulse 1.2s ease-in-out infinite;
  }

  @keyframes diamondPulse {
  0%, 100% { transform: rotate(45deg) scale(1); }
  50% { transform: rotate(225deg) scale(0.7); }
  }

  .btn-content {
  display: flex;
  align-items: center;
  }

  .btn-sm {
  padding: 0.5rem 1.5rem;
  font-size: 0.875rem;
  border-radius: 2rem;
  }

  .btn-md {
  padding: 0.75rem 2rem;
  font-size: 1rem;
  border-radius: 2.5rem;
  }

  .btn-lg {
  padding: 1rem 2.5rem;
  font-size: 1.125rem;
  border-radius: 3rem;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'elastic' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
  primaryColor: '#84cc16',
  secondaryColor: '#65a30d',
  backgroundColor: '#f7fee7',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#84cc16',
  accentColor: '#a3e635'
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
  elastic: {
  background: `linear-gradient(90deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.accentColor}, ${this.appliedTheme.primaryColor})`,
  color: this.appliedTheme.textColor,
  border: 'none',
  backgroundSize: '200% 100%'
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
