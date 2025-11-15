// Icon Button - Button with only icon, no text
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface IconButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  hoverColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <button
      class="icon-btn"
      [ngStyle]="buttonStyles"
      [disabled]="disabled"
      [attr.aria-label]="ariaLabel"
      [class.loading]="loading"
      (click)="handleClick($event)">
      <span *ngIf="loading" class="loading-pulse"></span>
      <span *ngIf="!loading" class="icon-content">{{ icon }}</span>
      <span *ngIf="badge !== undefined" class="badge" [ngStyle]="badgeStyles">
        {{ badge }}
      </span>
    </button>
  `,
  styles: [`
    .icon-btn {
      position: relative;
      border: none;
      cursor: pointer;
      font-family: inherit;
      outline: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      font-size: 20px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .icon-btn:hover:not(:disabled) {
      transform: scale(1.1) rotate(5deg);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }

    .icon-btn:active:not(:disabled) {
      transform: scale(0.95) rotate(0deg);
    }

    .icon-btn:disabled {
      cursor: not-allowed;
      opacity: 0.4;
      filter: grayscale(0.6);
    }

    .icon-btn.loading .icon-content {
      opacity: 0;
    }

    .loading-pulse {
      position: absolute;
      width: 60%;
      height: 60%;
      border: 2px solid currentColor;
      border-radius: 50%;
      border-top-color: transparent;
      animation: pulse-rotate 1s linear infinite;
    }

    @keyframes pulse-rotate {
      0% { transform: rotate(0deg) scale(1); }
      50% { transform: rotate(180deg) scale(1.1); }
      100% { transform: rotate(360deg) scale(1); }
    }

    .icon-content {
      display: flex;
      align-items: center;
      justify-content: center;
      transition: transform 0.2s;
    }

    .badge {
      position: absolute;
      top: -4px;
      right: -4px;
      min-width: 18px;
      height: 18px;
      padding: 0 4px;
      font-size: 10px;
      font-weight: 700;
      border-radius: 9px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
      animation: badge-pop 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    }

    @keyframes badge-pop {
      0% { transform: scale(0); }
      50% { transform: scale(1.2); }
      100% { transform: scale(1); }
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<IconButtonTheme> = {};
  @Input() icon = '⭐';
  @Input() size: 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() variant: 'filled' | 'outlined' | 'ghost' = 'filled';
  @Input() disabled = false;
  @Input() loading = false;
  @Input() ariaLabel?: string;
  @Input() badge?: number | string;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: IconButtonTheme = {
    primaryColor: '#ec4899',
    secondaryColor: '#db2777',
    backgroundColor: '#fdf2f8',
    hoverColor: '#f472b6'
  };

  get appliedTheme(): IconButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { width: '36px', height: '36px', fontSize: '16px' },
      md: { width: '48px', height: '48px', fontSize: '20px' },
      lg: { width: '60px', height: '60px', fontSize: '24px' },
      xl: { width: '72px', height: '72px', fontSize: '28px' }
    };
    const variantMap = {
      filled: {
        background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
        color: '#ffffff',
        border: 'none'
      },
      outlined: {
        background: 'transparent',
        color: t.primaryColor,
        border: `2px solid ${t.primaryColor}`
      },
      ghost: {
        background: t.backgroundColor,
        color: t.primaryColor,
        border: 'none'
      }
    };
    return {
      ...sizeMap[this.size],
      ...variantMap[this.variant]
    };
  }

  get badgeStyles() {
    const t = this.appliedTheme;
    return {
      background: '#ef4444',
      color: '#ffffff'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.loading) {
      this.clicked.emit(event);
    }
  }
}
