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
      class="ripple-button">
      <span *ngIf="loading" class="spinner square-spinner">
        <span class="square"></span>
      </span>
      <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="btn-content">
        <ng-content></ng-content>
      </span>
      <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
      <span class="ripple"></span>
    </button>
  `,
  styles: [`
    .ripple-button {
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
      box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
    }

    .ripple-button:hover:not(:disabled) {
      box-shadow: 0 8px 30px rgba(99, 102, 241, 0.6);
      transform: translateY(-2px);
    }

    .ripple-button:active:not(:disabled) .ripple {
      animation: rippleEffect 0.6s ease-out;
    }

    .ripple-button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .ripple {
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.6);
      transform: scale(0);
      pointer-events: none;
    }

    @keyframes rippleEffect {
      to {
        transform: scale(4);
        opacity: 0;
      }
    }

    .square-spinner {
      width: 1em;
      height: 1em;
      display: inline-block;
    }

    .square {
      width: 100%;
      height: 100%;
      background: currentColor;
      animation: squareRotate 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
    }

    @keyframes squareRotate {
      0%, 100% { transform: rotate(0deg) scale(1); }
      50% { transform: rotate(180deg) scale(0.8); }
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'elevated' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#6366f1',
    secondaryColor: '#4f46e5',
    backgroundColor: '#eef2ff',
        backdropFilter: 'blur(10px)',
    textColor: '#ffffff',
    borderColor: '#6366f1',
    accentColor: '#818cf8'
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
      elevated: {
        background: this.appliedTheme.primaryColor,
        color: this.appliedTheme.textColor,
        border: 'none',
        boxShadow: `0 8px 20px rgba(99, 102, 241, 0.4)`
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
