import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  shadowColor: string;
}

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="buttonStyles"
      [disabled]="disabled || loading"
      (click)="handleClick($event)"
      [attr.aria-label]="ariaLabel"
      class="btn">
      <span *ngIf="loading" class="spinner"></span>
      <ng-container *ngIf="!loading">
        <span *ngIf="iconLeft" class="icon-left">{{ iconLeft }}</span>
        <span class="content"><ng-content></ng-content></span>
        <span *ngIf="iconRight" class="icon-right">{{ iconRight }}</span>
      </ng-container>
    </button>
  `,
  styles: [`
    .btn {
      border: none;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      font-family: inherit;
      outline: none;
      position: relative;
      overflow: hidden;
    }
    .btn:hover:not(:disabled) {
      transform: translateY(-1px);
      filter: brightness(1.05);
    }
    .btn:active:not(:disabled) {
      transform: translateY(0);
    }
    .btn:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }
    .spinner {
      width: 14px;
      height: 14px;
      border: 2px solid rgba(255,255,255,0.3);
      border-top-color: #fff;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    .content {
      display: inline-flex;
      align-items: center;
    }
    .icon-left, .icon-right {
      display: inline-flex;
      align-items: center;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled = false;
  @Input() loading = false;
  @Input() iconLeft?: string;
  @Input() iconRight?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#8b5cf6',
    backgroundColor: '#ffffff',
    textColor: '#0f172a',
    borderColor: '#e2e8f0',
    shadowColor: 'rgba(59, 130, 246, 0.2)'
  };

  get appliedTheme(): ButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { padding: '8px 16px', fontSize: '14px', minHeight: '32px', gap: '6px' },
      md: { padding: '12px 24px', fontSize: '15px', minHeight: '40px', gap: '8px' },
      lg: { padding: '16px 32px', fontSize: '16px', minHeight: '48px', gap: '10px' }
    };

    const variantMap = {
      default: {
        background: t.backgroundColor,
        color: t.textColor,
        border: `1px solid ${t.borderColor}`,
        boxShadow: '0 1px 2px rgba(0, 0, 0, 0.05)'
      },
      outlined: {
        background: 'transparent',
        color: t.primaryColor,
        border: `2px solid ${t.primaryColor}`,
        boxShadow: 'none'
      },
      filled: {
        background: `linear-gradient(180deg, ${t.primaryColor}, ${t.secondaryColor})`,
        color: '#ffffff',
        border: 'none',
        boxShadow: `0 4px 12px ${t.shadowColor}`
      }
    };

    return {
      ...sizeMap[this.size],
      ...variantMap[this.variant],
      borderRadius: '10px',
      fontWeight: '600',
      width: this.fullWidth ? '100%' : 'auto',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.loading) {
      this.clicked.emit(event);
    }
  }
}
