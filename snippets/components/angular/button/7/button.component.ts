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
      [attr.aria-busy]="loading"
      class="btn">
      <span class="btn-glow"></span>
      <span *ngIf="loading" class="pulse-loader">
        <span class="pulse-dot"></span>
        <span class="pulse-dot"></span>
        <span class="pulse-dot"></span>
      </span>
      <ng-container *ngIf="!loading">
        <span *ngIf="startIcon" class="start-icon">{{ startIcon }}</span>
        <span class="btn-label"><ng-content></ng-content></span>
        <span *ngIf="endIcon" class="end-icon">{{ endIcon }}</span>
      </ng-container>
    </button>
  `,
  styles: [`
    .btn {
      border: none;
      cursor: pointer;
      transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
      font-family: inherit;
      outline: none;
      position: relative;
      overflow: hidden;
    }
    .btn-glow {
      position: absolute;
      inset: -2px;
      background: inherit;
      filter: blur(8px);
      opacity: 0;
      transition: opacity 0.3s;
      z-index: -1;
    }
    .btn:hover:not(:disabled) .btn-glow {
      opacity: 0.6;
    }
    .btn:hover:not(:disabled) {
      transform: translateY(-4px) scale(1.04);
    }
    .btn:active:not(:disabled) {
      transform: translateY(-2px) scale(1.02);
    }
    .btn:disabled {
      cursor: not-allowed;
      opacity: 0.4;
      filter: grayscale(0.7);
    }
    .pulse-loader {
      display: inline-flex;
      gap: 5px;
      align-items: center;
    }
    .pulse-dot {
      width: 8px;
      height: 8px;
      background: currentColor;
      border-radius: 50%;
      animation: pulse 1.5s ease-in-out infinite;
    }
    .pulse-dot:nth-child(2) { animation-delay: 0.2s; }
    .pulse-dot:nth-child(3) { animation-delay: 0.4s; }
    @keyframes pulse {
      0%, 100% { transform: scale(0.8); opacity: 0.5; }
      50% { transform: scale(1.2); opacity: 1; }
    }
    .btn-label {
      display: inline-flex;
      align-items: center;
      position: relative;
      z-index: 1;
    }
    .start-icon, .end-icon {
      display: inline-flex;
      align-items: center;
      position: relative;
      z-index: 1;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'solid' | 'outline' | 'ghost' | 'neumorphic' = 'solid';
  @Input() size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() disabled = false;
  @Input() loading = false;
  @Input() startIcon?: string;
  @Input() endIcon?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Input() shape: 'square' | 'rounded' | 'pill' = 'rounded';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#f59e0b',
    secondaryColor: '#d97706',
    backgroundColor: '#fffbeb',
    textColor: '#78350f',
    borderColor: '#fcd34d',
    shadowColor: 'rgba(245, 158, 11, 0.4)'
  };

  get appliedTheme(): ButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      xs: { padding: '6px 14px', fontSize: '12px', minHeight: '30px', gap: '5px' },
      sm: { padding: '9px 20px', fontSize: '13px', minHeight: '38px', gap: '7px' },
      md: { padding: '13px 30px', fontSize: '15px', minHeight: '46px', gap: '9px' },
      lg: { padding: '17px 40px', fontSize: '17px', minHeight: '54px', gap: '11px' },
      xl: { padding: '21px 50px', fontSize: '19px', minHeight: '62px', gap: '13px' }
    };

    const shapeMap = {
      square: '4px',
      rounded: '14px',
      pill: '9999px'
    };

    const variantMap = {
      solid: {
        background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
        color: '#ffffff',
        border: 'none',
        boxShadow: `0 8px 24px ${t.shadowColor}`
      },
      outline: {
        background: 'transparent',
        color: t.primaryColor,
        border: `2px solid ${t.primaryColor}`,
        boxShadow: 'none'
      },
      ghost: {
        background: `${t.primaryColor}10`,
        color: t.primaryColor,
        border: 'none',
        boxShadow: 'none'
      },
      neumorphic: {
        background: t.backgroundColor,
        color: t.textColor,
        border: 'none',
        boxShadow: `8px 8px 16px ${t.shadowColor}, -8px -8px 16px rgba(255, 255, 255, 0.7)`
      }
    };

    return {
      ...sizeMap[this.size],
      ...variantMap[this.variant],
      borderRadius: shapeMap[this.shape],
      fontWeight: '700',
      width: this.fullWidth ? '100%' : 'auto',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      letterSpacing: '0.5px'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.loading) {
      this.clicked.emit(event);
    }
  }
}
