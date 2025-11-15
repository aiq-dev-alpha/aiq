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
    button::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      width: 0;
      height: 0;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.4);
      transform: translate(-50%, -50%);
      transition: width 0.6s, height 0.6s;
    }
    button:active::before {
      width: 300px;
      height: 300px;
    }
    button:disabled {
      cursor: not-allowed;
      opacity: 0.5;
      filter: grayscale(0.4);
    }
    button:hover:not(:disabled) {
      transform: translateY(-3px);
      filter: brightness(1.05);
    }
    button:active:not(:disabled) {
      transform: translateY(-1px);
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
        background: `linear-gradient(135deg, ${t.primaryColor}dd, ${t.secondaryColor}dd)`,
        backdropFilter: 'blur(16px) saturate(180%)',
        border: '1px solid rgba(255, 255, 255, 0.18)',
        boxShadow: `0 8px 32px ${t.shadowColor}, inset 0 1px 0 rgba(255, 255, 255, 0.3)`,
        WebkitBackdropFilter: 'blur(16px) saturate(180%)'
      },
      neumorphic: {
        background: 'linear-gradient(145deg, #f0f0f0, #cacaca)',
        color: '#444',
        boxShadow: '10px 10px 20px #a3a3a3, -10px -10px 20px #ffffff',
        border: '1px solid #e0e0e0'
      },
      brutalist: {
        background: t.primaryColor,
        border: '4px solid #000',
        boxShadow: '8px 8px 0 #000',
        borderRadius: '0',
        textTransform: 'uppercase',
        letterSpacing: '2px'
      },
      minimal: {
        background: 'transparent',
        color: t.primaryColor,
        border: `2px solid ${t.primaryColor}`,
        boxShadow: 'none',
        position: 'relative',
        overflow: 'hidden'
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
