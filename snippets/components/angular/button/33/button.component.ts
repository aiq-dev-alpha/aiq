import { Component, Input, Output, EventEmitter } from '@angular/core';

interface AnimationConfig {
  duration: string;
  easing: string;
  hoverScale: number;
  activeScale: number;
}

interface StyleTheme {
  primary: string;
  secondary: string;
  text: string;
  shadow: string;
}

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="buttonStyle"
      [disabled]="disabled"
      (click)="handleClick($event)"
      [ngClass]="computedClasses">
      <span *ngIf="loading" class="spinner"></span>
      <ng-container *ngIf="!loading">
        <span *ngIf="icon && iconPosition === 'start'" class="btn-icon">{{ icon }}</span>
        <span class="btn-text"><ng-content></ng-content></span>
        <span *ngIf="icon && iconPosition === 'end'" class="btn-icon">{{ icon }}</span>
      </ng-container>
    </button>
  `,
  styles: [`
    button {
      border: none;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      font-family: system-ui, -apple-system, sans-serif;
      outline: none;
    }
    button:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }
    button::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      width: 0;
      height: 0;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.3);
      transform: translate(-50%, -50%);
      transition: width 0.6s, height 0.6s;
    }
    button:active::before {
      width: 300px;
      height: 300px;
    }
    .spinner {
      width: 16px;
      height: 16px;
      border: 3px solid rgba(255,255,255,0.2);
      border-top-color: #fff;
      border-radius: 50%;
      animation: rotate 0.8s linear infinite;
    }
    @keyframes rotate {
      to { transform: rotate(360deg); }
    }
    .btn-text {
      position: relative;
      z-index: 1;
    }
    .btn-icon {
      position: relative;
      z-index: 1;
      display: inline-flex;
      align-items: center;
    }
  `]
})
export class ButtonComponent {
  @Input() variant: 'solid' | 'outline' | 'ghost' | 'link' = 'solid';
  @Input() theme: Partial<StyleTheme> = {};
  @Input() animation: Partial<AnimationConfig> = {};
  @Input() disabled = false;
  @Input() loading = false;
  @Input() block = false;
  @Input() icon?: string;
  @Input() iconPosition: 'start' | 'end' = 'start';
  @Input() shape: 'rounded' | 'pill' | 'square' = 'rounded';
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: StyleTheme = {
    primary: '#8b5cf6',
    secondary: '#a78bfa',
    text: '#ffffff',
    shadow: 'rgba(139, 92, 246, 0.3)'
  };

  private defaultAnimation: AnimationConfig = {
    duration: '0.3s',
    easing: 'cubic-bezier(0.4, 0, 0.2, 1)',
    hoverScale: 1.05,
    activeScale: 0.95
  };

  get appliedTheme(): StyleTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get appliedAnimation(): AnimationConfig {
    return { ...this.defaultAnimation, ...this.animation };
  }

  get computedClasses(): string[] {
    return [
      `variant-${this.variant}`,
      `shape-${this.shape}`,
      this.block ? 'block' : '',
      this.loading ? 'loading' : ''
    ].filter(Boolean);
  }

  get buttonStyle(): Record<string, string> {
    const t = this.appliedTheme;
    const a = this.appliedAnimation;

    const shapeStyles = {
      rounded: '8px',
      pill: '50px',
      square: '0'
    };

    const variantStyles = {
      solid: {
        background: `linear-gradient(135deg, ${t.primary}, ${t.secondary})`,
        color: t.text,
        border: 'none',
        boxShadow: `0 4px 12px ${t.shadow}`
      },
      outline: {
        background: 'transparent',
        color: t.primary,
        border: `2px solid ${t.primary}`,
        boxShadow: 'none'
      },
      ghost: {
        background: `${t.primary}15`,
        color: t.primary,
        border: 'none',
        boxShadow: 'none'
      },
      link: {
        background: 'transparent',
        color: t.primary,
        border: 'none',
        boxShadow: 'none',
        textDecoration: 'underline'
      }
    };

    return {
      ...variantStyles[this.variant],
      padding: '12px 24px',
      fontSize: '14px',
      fontWeight: '600',
      borderRadius: shapeStyles[this.shape],
      transition: `all ${a.duration} ${a.easing}`,
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: '8px',
      width: this.block ? '100%' : 'auto',
      minHeight: '44px'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.loading) {
      this.clicked.emit(event);
    }
  }
}
