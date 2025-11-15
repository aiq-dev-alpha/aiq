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
      class="gradient-shift-button">
      <span *ngIf="loading" class="spinner pulse-ring-spinner">
        <span class="pulse-ring"></span>
      </span>
      <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="btn-content">
        <ng-content></ng-content>
      </span>
      <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
    </button>
  `,
  styles: [`
    .gradient-shift-button {
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
      box-shadow: 0 6px 25px rgba(236, 72, 153, 0.4);
      background-size: 200% 200%;
      animation: gradientShift 3s ease infinite;
    }

    @keyframes gradientShift {
      0%, 100% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
    }

    .gradient-shift-button:hover:not(:disabled) {
      box-shadow: 0 10px 40px rgba(236, 72, 153, 0.6);
      transform: translateY(-3px) scale(1.02);
    }

    .gradient-shift-button:active:not(:disabled) {
      transform: translateY(-1px) scale(0.99);
    }

    .gradient-shift-button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
      animation: none;
    }

    .pulse-ring-spinner {
      width: 1.2em;
      height: 1.2em;
      position: relative;
      display: inline-block;
    }

    .pulse-ring {
      width: 100%;
      height: 100%;
      border: 2px solid currentColor;
      border-radius: 50%;
      animation: pulseRing 1.5s ease-out infinite;
    }

    @keyframes pulseRing {
      0% { transform: scale(0.5); opacity: 1; }
      100% { transform: scale(1.2); opacity: 0; }
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'animated' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#ec4899',
    secondaryColor: '#db2777',
    backgroundColor: '#fdf2f8',
        backdropFilter: 'blur(10px)',
    textColor: '#ffffff',
    borderColor: '#ec4899',
    accentColor: '#f472b6'
  };

  get appliedTheme(): ButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const variantStyles = {
      default: {
        background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor}, ${this.appliedTheme.accentColor})`,
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
      animated: {
        background: `linear-gradient(45deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.accentColor}, ${this.appliedTheme.secondaryColor})`,
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
