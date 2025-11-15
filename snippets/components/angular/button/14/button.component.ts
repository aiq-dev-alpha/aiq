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
      class="flip-button">
      <span *ngIf="loading" class="spinner flip-spinner">
        <span class="flip-box"></span>
      </span>
      <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="btn-content">
        <ng-content></ng-content>
      </span>
      <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
    </button>
  `,
  styles: [`
    .flip-button {
      position: relative;
      overflow: hidden;
      cursor: pointer;
      transition: transform 0.6s;
      transform-style: preserve-3d;
      font-weight: 600;
      border: none;
      outline: none;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      box-shadow: 0 6px 20px rgba(168, 85, 247, 0.4);
    }

    .flip-button:hover:not(:disabled) {
      transform: rotateY(10deg) scale(1.02);
      box-shadow: 0 10px 35px rgba(168, 85, 247, 0.6);
    }

    .flip-button:active:not(:disabled) {
      transform: rotateY(0deg) scale(0.98);
    }

    .flip-button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .flip-spinner {
      width: 1em;
      height: 1em;
      display: inline-block;
      perspective: 100px;
    }

    .flip-box {
      width: 100%;
      height: 100%;
      background: currentColor;
      animation: flip 1.2s infinite ease-in-out;
    }

    @keyframes flip {
      0%, 100% { transform: rotateY(0deg); }
      50% { transform: rotateY(180deg); }
    }

    .btn-content {
      display: flex;
      align-items: center;
    }

    .btn-sm {
      padding: 0.5rem 1.5rem;
      font-size: 0.875rem;
      border-radius: 0.75rem;
    }

    .btn-md {
      padding: 0.75rem 2rem;
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'vibrant' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#a855f7',
    secondaryColor: '#9333ea',
    backgroundColor: '#faf5ff',
    textColor: '#ffffff',
    borderColor: '#a855f7',
    accentColor: '#c084fc'
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
      vibrant: {
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
