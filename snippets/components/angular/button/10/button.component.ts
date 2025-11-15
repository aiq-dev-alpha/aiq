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
  class="bounce-button">
  <span *ngIf="loading" class="spinner dots-spinner">
  <span class="dot"></span>
  <span class="dot"></span>
  <span class="dot"></span>
  </span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .bounce-button {
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
  box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
  }

  .bounce-button:hover:not(:disabled) {
  animation: bounce 0.6s ease;
  box-shadow: 0 8px 25px rgba(16, 185, 129, 0.5);
  }

  .bounce-button:active:not(:disabled) {
  transform: scale(0.95);
  }

  .bounce-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  }

  @keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-12px); }
  60% { transform: translateY(-6px); }
  }

  .dots-spinner {
  display: flex;
  gap: 0.25rem;
  align-items: center;
  }

  .dot {
  width: 0.4em;
  height: 0.4em;
  background: currentColor;
  border-radius: 50%;
  animation: dotBounce 1.4s infinite ease-in-out both;
  }

  .dot:nth-child(1) { animation-delay: -0.32s; }
  .dot:nth-child(2) { animation-delay: -0.16s; }

  @keyframes dotBounce {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
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
  padding: 1rem 2.75rem;
  font-size: 1.125rem;
  border-radius: 3rem;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'soft' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
  primaryColor: '#10b981',
  secondaryColor: '#059669',
  backgroundColor: '#ecfdf5',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#10b981',
  accentColor: '#34d399'
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
  soft: {
  background: this.appliedTheme.backgroundColor,
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
