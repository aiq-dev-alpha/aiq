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
      class="shimmer-button">
      <span *ngIf="loading" class="spinner double-ring-spinner">
        <span class="ring-outer"></span>
        <span class="ring-inner"></span>
      </span>
      <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="btn-content">
        <ng-content></ng-content>
      </span>
      <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
    </button>
  `,
  styles: [`
    .shimmer-button {
      position: relative;
      overflow: hidden;
      cursor: pointer;
      transition: all 0.3s ease;
      font-weight: 600;
      border: none;
      outline: none;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      box-shadow: 0 5px 20px rgba(20, 184, 166, 0.4);
    }

    .shimmer-button::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
      transition: left 0.7s;
    }

    .shimmer-button:hover:not(:disabled)::before {
      left: 100%;
    }

    .shimmer-button:hover:not(:disabled) {
      box-shadow: 0 8px 30px rgba(20, 184, 166, 0.6);
      transform: scale(1.03);
    }

    .shimmer-button:active:not(:disabled) {
      transform: scale(0.98);
    }

    .shimmer-button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .double-ring-spinner {
      width: 1.2em;
      height: 1.2em;
      position: relative;
      display: inline-block;
    }

    .ring-outer, .ring-inner {
      position: absolute;
      border: 2px solid transparent;
      border-radius: 50%;
    }

    .ring-outer {
      width: 100%;
      height: 100%;
      border-top-color: currentColor;
      animation: spinOuter 1.5s linear infinite;
    }

    .ring-inner {
      width: 70%;
      height: 70%;
      top: 15%;
      left: 15%;
      border-bottom-color: currentColor;
      animation: spinInner 1s linear infinite reverse;
    }

    @keyframes spinOuter {
      to { transform: rotate(360deg); }
    }

    @keyframes spinInner {
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'neon' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#14b8a6',
    secondaryColor: '#0d9488',
    backgroundColor: '#f0fdfa',
    textColor: '#ffffff',
    borderColor: '#14b8a6',
    accentColor: '#2dd4bf'
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
      neon: {
        background: this.appliedTheme.primaryColor,
        color: this.appliedTheme.textColor,
        border: 'none',
        boxShadow: `0 0 20px ${this.appliedTheme.primaryColor}`
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
