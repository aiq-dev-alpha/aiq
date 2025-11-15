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
      class="shake-button">
      <span *ngIf="loading" class="spinner cross-spinner"></span>
      <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="btn-content">
        <ng-content></ng-content>
      </span>
      <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
    </button>
  `,
  styles: [`
    .shake-button {
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
      box-shadow: 0 5px 20px #be123c66;
    }

    .shake-button:hover:not(:disabled) {
      box-shadow: 0 8px 35px #be123c99;
      transform: translateY(-2px) scale(1.02);
      animation: shakeAnim 0.5s ease;
    }

    .shake-button:active:not(:disabled) {
      transform: translateY(0) scale(0.98);
    }

    .shake-button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    @keyframes shakeAnim {
      0%, 100% { transform: translateY(-2px) scale(1.02); }
      50% { transform: translateY(-4px) scale(1.04) rotate(1deg); }
    }

    .cross-spinner {
      width: 1em;
      height: 1em;
      border: 2px solid rgba(255, 255, 255, 0.3);
      border-top-color: currentColor;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'shake' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#be123c',
    secondaryColor: '#9f1239',
    backgroundColor: '#fff1f2',
    textColor: '#ffffff',
    borderColor: '#be123c',
    accentColor: '#fb7185'
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
      shake: {
        background: `linear-gradient(90deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.accentColor})`,
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
