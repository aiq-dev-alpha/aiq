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
      class="morphing-button">
      <span *ngIf="loading" class="spinner triangle-spinner">
        <span class="triangle"></span>
      </span>
      <span *ngIf="!loading && iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="btn-content">
        <ng-content></ng-content>
      </span>
      <span *ngIf="!loading && iconRight" class="icon-right">{{ iconRight }}</span>
    </button>
  `,
  styles: [`
    .morphing-button {
      position: relative;
      overflow: hidden;
      cursor: pointer;
      transition: all 0.5s cubic-bezier(0.68, -0.6, 0.32, 1.6);
      font-weight: 600;
      border: none;
      outline: none;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      box-shadow: 0 5px 20px rgba(6, 182, 212, 0.4);
    }

    .morphing-button:hover:not(:disabled) {
      border-radius: 2rem;
      box-shadow: 0 8px 35px rgba(6, 182, 212, 0.6);
      transform: scale(1.05);
    }

    .morphing-button:active:not(:disabled) {
      transform: scale(0.97);
    }

    .morphing-button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .triangle-spinner {
      width: 1em;
      height: 1em;
      position: relative;
      display: inline-block;
    }

    .triangle {
      width: 0;
      height: 0;
      border-left: 0.5em solid transparent;
      border-right: 0.5em solid transparent;
      border-bottom: 1em solid currentColor;
      animation: triangleSpin 1.2s linear infinite;
    }

    @keyframes triangleSpin {
      to { transform: rotate(360deg); }
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
  @Input() variant: 'default' | 'outlined' | 'filled' | 'morphing' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
  @Input() loading: boolean = false;
  @Input() iconLeft: string = '';
  @Input() iconRight: string = '';
  @Input() ariaLabel: string = '';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#06b6d4',
    secondaryColor: '#0891b2',
    backgroundColor: '#ecfeff',
    textColor: '#ffffff',
    borderColor: '#06b6d4',
    accentColor: '#22d3ee'
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
      morphing: {
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
