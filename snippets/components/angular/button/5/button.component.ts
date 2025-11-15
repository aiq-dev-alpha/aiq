import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  hoverColor: string;
}

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="buttonStyles"
      [disabled]="disabled || isProcessing"
      (click)="handleClick($event)"
      [attr.aria-label]="ariaLabel"
      class="btn">
      <span class="btn-bg"></span>
      <span *ngIf="isProcessing" class="progress-bar"></span>
      <span class="btn-content">
        <span *ngIf="leftAddon" class="addon-left">{{ leftAddon }}</span>
        <span class="content-text"><ng-content></ng-content></span>
        <span *ngIf="rightAddon" class="addon-right">{{ rightAddon }}</span>
      </span>
    </button>
  `,
  styles: [`
    .btn {
      border: none;
      cursor: pointer;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-family: inherit;
      outline: none;
      position: relative;
      overflow: hidden;
    }
    .btn-bg {
      position: absolute;
      inset: 0;
      opacity: 0;
      transition: opacity 0.3s;
      z-index: 0;
    }
    .btn:hover:not(:disabled) .btn-bg {
      opacity: 1;
    }
    .btn:hover:not(:disabled) {
      transform: scale(1.05);
    }
    .btn:active:not(:disabled) {
      transform: scale(0.98);
    }
    .btn:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }
    .progress-bar {
      position: absolute;
      bottom: 0;
      left: 0;
      height: 3px;
      width: 0;
      background: currentColor;
      animation: progress 2s ease-in-out infinite;
      z-index: 1;
    }
    @keyframes progress {
      0% { width: 0; }
      50% { width: 70%; }
      100% { width: 100%; }
    }
    .btn-content {
      display: inline-flex;
      align-items: center;
      position: relative;
      z-index: 1;
    }
    .content-text {
      display: inline-flex;
      align-items: center;
    }
    .addon-left, .addon-right {
      display: inline-flex;
      align-items: center;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'solid' | 'outline' | 'gradient' | 'soft' = 'solid';
  @Input() size: 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() disabled = false;
  @Input() isProcessing = false;
  @Input() leftAddon?: string;
  @Input() rightAddon?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Input() borderRadius: 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
    primaryColor: '#ec4899',
    secondaryColor: '#db2777',
    backgroundColor: '#fdf2f8',
        backdropFilter: 'blur(10px)',
    textColor: '#831843',
    borderColor: '#f9a8d4',
    hoverColor: '#f472b6'
  };

  get appliedTheme(): ButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { padding: '9px 20px', fontSize: '13px', minHeight: '36px', gap: '7px' },
      md: { padding: '13px 28px', fontSize: '15px', minHeight: '44px', gap: '9px' },
      lg: { padding: '17px 36px', fontSize: '17px', minHeight: '52px', gap: '11px' },
      xl: { padding: '21px 44px', fontSize: '19px', minHeight: '60px', gap: '13px' }
    };

    const radiusMap = {
      sm: '8px',
      md: '14px',
      lg: '20px',
      xl: '28px'
    };

    const variantMap = {
      solid: {
        background: t.primaryColor,
        color: '#ffffff',
        border: 'none',
        boxShadow: `0 4px 14px ${t.primaryColor}40`
      },
      outline: {
        background: 'transparent',
        color: t.primaryColor,
        border: `2px solid ${t.primaryColor}`,
        boxShadow: 'none'
      },
      gradient: {
        background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
        color: '#ffffff',
        border: 'none',
        boxShadow: `0 6px 24px ${t.primaryColor}50`
      },
      soft: {
        background: t.backgroundColor,
        color: t.textColor,
        border: `1px solid ${t.borderColor}`,
        boxShadow: '0 2px 6px rgba(0, 0, 0, 0.05)'
      }
    };

    const bgStyle = variantMap[this.variant];
    const btnBg = this.variant === 'outline'
      ? { background: `${t.primaryColor}15` }
      : this.variant === 'soft'
      ? { background: t.hoverColor }
      : { background: t.secondaryColor };

    return {
      ...sizeMap[this.size],
      ...bgStyle,
      borderRadius: radiusMap[this.borderRadius],
      fontWeight: '700',
      width: this.fullWidth ? '100%' : 'auto',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      letterSpacing: '0.5px',
      '--btn-bg': bgStyle.background
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.isProcessing) {
      this.clicked.emit(event);
    }
  }
}
