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
  class="slide-button">
  <span *ngIf="loading" class="spinner bar-spinner">
  <span class="bar"></span>
  <span class="bar"></span>
  <span class="bar"></span>
  <span class="bar"></span>
  </span>
  <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
  <span class="btn-content">
  <ng-content></ng-content>
  </span>
  <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
  </button>
  `,
  styles: [`
  .slide-button {
  position: relative;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  font-weight: 600;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 6px 20px rgba(239, 68, 68, 0.3);
  }
  .slide-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.2);
  transition: left 0.5s ease;
  }
  .slide-button:hover:not(:disabled)::before {
  left: 100%;
  }
  .slide-button:hover:not(:disabled) {
  transform: translateX(4px);
  box-shadow: 0 8px 30px rgba(239, 68, 68, 0.5);
  }
  .slide-button:active:not(:disabled) {
  transform: translateX(2px);
  }
  .slide-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  }
  .bar-spinner {
  display: flex;
  gap: 0.2rem;
  align-items: center;
  }
  .bar {
  width: 0.2em;
  height: 1em;
  background: currentColor;
  animation: barStretch 1s infinite ease-in-out;
  }
  .bar:nth-child(1) { animation-delay: 0s; }
  .bar:nth-child(2) { animation-delay: 0.1s; }
  .bar:nth-child(3) { animation-delay: 0.2s; }
  .bar:nth-child(4) { animation-delay: 0.3s; }
  @keyframes barStretch {
  0%, 40%, 100% { transform: scaleY(0.4); }
  20% { transform: scaleY(1); }
  }
  .btn-content {
  display: flex;
  align-items: center;
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'gradient' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#ef4444',
  secondaryColor: '#dc2626',
  backgroundColor: '#fef2f2',
  backdropFilter: 'blur(10px)',
  textColor: '#ffffff',
  borderColor: '#ef4444',
  accentColor: '#f87171'
  };
  get appliedTheme(): ButtonTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get buttonStyles() {
  const variantStyles = {
  default: {
  background: `linear-gradient(90deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
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
  gradient: {
  background: `linear-gradient(45deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.accentColor})`,
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
