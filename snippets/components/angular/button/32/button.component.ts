import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ColorScheme {
  background: string;
  foreground: string;
  accent: string;
  border: string;
}

type VisualStyle = 'gradient-shift' | 'outlined-thick' | 'soft-shadow' | 'neon-glow';

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="computedStyles"
      [disabled]="isDisabled"
      (click)="onClick($event)"
      (mouseenter)="onHover(true)"
      (mouseleave)="onHover(false)"
      class="btn-base">
      <span *ngIf="iconLeft" class="icon-left">{{ iconLeft }}</span>
      <span class="label"><ng-content></ng-content></span>
      <span *ngIf="iconRight" class="icon-right">{{ iconRight }}</span>
      <span *ngIf="badge" class="badge">{{ badge }}</span>
    </button>
  `,
  styles: [`
    .btn-base {
      position: relative;
      border: none;
      cursor: pointer;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      transition: all 0.4s ease;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }
    .btn-base:disabled {
      cursor: not-allowed;
      filter: grayscale(1);
      opacity: 0.5;
    }
    .icon-left, .icon-right {
      display: inline-flex;
      align-items: center;
      font-size: 1.2em;
    }
    .badge {
      position: absolute;
      top: -8px;
      right: -8px;
      background: #ff4757;
      color: white;
      border-radius: 10px;
      padding: 2px 6px;
      font-size: 10px;
      font-weight: bold;
    }
    .label {
      letter-spacing: 0.5px;
    }
  `]
})
export class ButtonComponent {
  @Input() visualStyle: VisualStyle = 'gradient-shift';
  @Input() colorScheme: Partial<ColorScheme> = {};
  @Input() isDisabled = false;
  @Input() rounded = true;
  @Input() elevated = false;
  @Input() iconLeft?: string;
  @Input() iconRight?: string;
  @Input() badge?: string | number;
  @Input() customClass = '';
  @Output() buttonClick = new EventEmitter<MouseEvent>();

  private isHovered = false;
  private defaultColors: ColorScheme = {
    background: '#3b82f6',
    foreground: '#ffffff',
    accent: '#60a5fa',
    border: '#2563eb'
  };

  get colors(): ColorScheme {
    return { ...this.defaultColors, ...this.colorScheme };
  }

  get computedStyles(): Record<string, string> {
    const styles = this.getStyleVariant();
    return {
      ...styles,
      borderRadius: this.rounded ? '16px' : '4px',
      padding: '14px 28px',
      fontSize: '15px',
      fontWeight: '600',
      boxShadow: this.elevated ? '0 10px 25px rgba(0,0,0,0.15)' : 'none'
    };
  }

  getStyleVariant(): Record<string, string> {
    const c = this.colors;
    const variants = {
      'gradient-shift': {
        background: `linear-gradient(45deg, ${c.background}, ${c.accent})`,
        color: c.foreground,
        border: 'none',
        backgroundSize: '200% 200%',
        backgroundPosition: this.isHovered ? 'right center' : 'left center',
        transition: 'background-position 0.5s ease'
      },
      'outlined-thick': {
        background: this.isHovered ? `${c.background}15` : 'transparent',
        color: c.background,
        border: `3px solid ${c.background}`,
        fontWeight: '700',
        transition: 'all 0.3s ease'
      },
      'soft-shadow': {
        background: c.background,
        color: c.foreground,
        border: 'none',
        boxShadow: this.isHovered ? `0 8px 20px ${c.background}80` : `0 4px 14px ${c.background}66`,
        transition: 'box-shadow 0.3s ease'
      },
      'neon-glow': {
        background: '#0a0a0a',
        color: c.accent,
        border: `2px solid ${c.accent}`,
        boxShadow: this.isHovered
          ? `0 0 30px ${c.accent}, inset 0 0 30px ${c.accent}60`
          : `0 0 20px ${c.accent}80, inset 0 0 20px ${c.accent}40`,
        textShadow: `0 0 10px ${c.accent}`,
        transition: 'all 0.3s ease'
      }
    };
    return variants[this.visualStyle];
  }

  onClick(event: MouseEvent): void {
    if (!this.isDisabled) {
      this.buttonClick.emit(event);
    }
  }

  onHover(state: boolean): void {
    this.isHovered = state;
  }
}
