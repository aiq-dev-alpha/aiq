import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ThemeConfig {
  primaryColor: string;
  secondaryColor: string;
  textColor: string;
  borderRadius: string;
  fontSize: string;
  fontWeight: string;
  shadowColor: string;
}

type ButtonStyle = 'glass' | 'neumorphic' | 'brutalist' | 'minimal';
type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="getButtonStyles()"
      [disabled]="disabled || loading"
      (click)="handleClick($event)"
      [attr.aria-label]="ariaLabel"
      [class.pulse]="pulse">
      <span *ngIf="loading" class="loader"></span>
      <span *ngIf="prefixIcon && !loading" class="icon-prefix">{{ prefixIcon }}</span>
      <span class="button-content"><ng-content></ng-content></span>
      <span *ngIf="suffixIcon && !loading" class="icon-suffix">{{ suffixIcon }}</span>
    </button>
  `,
  styles: [`
    button {
      border: none;
      cursor: pointer;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
      font-family: inherit;
    }
    button:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }
    button:hover:not(:disabled) {
      transform: translateY(-2px);
    }
    button:active:not(:disabled) {
      transform: translateY(0);
    }
    .pulse {
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.8; }
    }
    .loader {
      display: inline-block;
      width: 14px;
      height: 14px;
      border: 2px solid rgba(255,255,255,0.3);
      border-radius: 50%;
      border-top-color: #fff;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    .button-content {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
    }
    .icon-prefix, .icon-suffix {
      display: inline-flex;
      align-items: center;
    }
  `]
})
export class ButtonComponent {
  @Input() styleVariant: ButtonStyle = 'glass';
  @Input() size: ButtonSize = 'md';
  @Input() theme: Partial<ThemeConfig> = {};
  @Input() disabled = false;
  @Input() loading = false;
  @Input() fullWidth = false;
  @Input() pulse = false;
  @Input() prefixIcon?: string;
  @Input() suffixIcon?: string;
  @Input() ariaLabel?: string;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ThemeConfig = {
    primaryColor: '#667eea',
    secondaryColor: '#764ba2',
    textColor: '#ffffff',
    borderRadius: '12px',
    fontSize: '16px',
    fontWeight: '600',
    shadowColor: 'rgba(102, 126, 234, 0.4)'
  };

  get appliedTheme(): ThemeConfig {
    return { ...this.defaultTheme, ...this.theme };
  }

  getButtonStyles(): Record<string, string> {
    const t = this.appliedTheme;
    const sizeMap = {
      xs: { padding: '6px 12px', fontSize: '12px', minHeight: '28px' },
      sm: { padding: '8px 16px', fontSize: '14px', minHeight: '32px' },
      md: { padding: '12px 24px', fontSize: '16px', minHeight: '40px' },
      lg: { padding: '16px 32px', fontSize: '18px', minHeight: '48px' },
      xl: { padding: '20px 40px', fontSize: '20px', minHeight: '56px' }
    };

    const styleMap = {
      glass: {
        background: `linear-gradient(135deg, ${t.primaryColor}cc, ${t.secondaryColor}cc)`,
        backdropFilter: 'blur(10px)',
        border: '1px solid rgba(255, 255, 255, 0.2)',
        boxShadow: `0 8px 32px ${t.shadowColor}`
      },
      neumorphic: {
        background: '#e0e5ec',
        color: '#666',
        boxShadow: '8px 8px 16px #a3b1c6, -8px -8px 16px #ffffff',
        border: 'none'
      },
      brutalist: {
        background: t.primaryColor,
        border: '3px solid #000',
        boxShadow: '6px 6px 0 #000',
        borderRadius: '0'
      },
      minimal: {
        background: 'transparent',
        color: t.primaryColor,
        border: `1px solid ${t.primaryColor}`,
        boxShadow: 'none'
      }
    };

    return {
      ...sizeMap[this.size],
      ...styleMap[this.styleVariant],
      color: this.styleVariant === 'neumorphic' ? '#666' : t.textColor,
      borderRadius: this.styleVariant === 'brutalist' ? '0' : t.borderRadius,
      fontWeight: t.fontWeight,
      width: this.fullWidth ? '100%' : 'auto',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: '8px'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.loading) {
      this.clicked.emit(event);
    }
  }
}
