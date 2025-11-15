import { Component, Input, Output, EventEmitter } from '@angular/core';

interface DesignTokens {
  spacing: { xs: string; sm: string; md: string; lg: string; xl: string };
  colors: { primary: string; secondary: string; accent: string; text: string };
  typography: { size: string; weight: string; family: string };
  effects: { shadow: string; blur: string; glow: string };
}

type ButtonMode = 'flat' | 'raised' | 'stroked' | 'icon';
type ButtonTone = 'primary' | 'secondary' | 'success' | 'warning' | 'error';

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="styles"
      [disabled]="isDisabled"
      [type]="type"
      (click)="emitClick($event)"
      class="custom-button">
      <span *ngIf="leadingIcon && !isLoading" class="leading">{{ leadingIcon }}</span>
      <span *ngIf="isLoading" class="loading-indicator"></span>
      <span *ngIf="!iconOnly" class="content"><ng-content></ng-content></span>
      <span *ngIf="trailingIcon && !isLoading" class="trailing">{{ trailingIcon }}</span>
    </button>
  `,
  styles: [`
    .custom-button {
      border: none;
      cursor: pointer;
      font-family: inherit;
      position: relative;
      overflow: hidden;
      transition: all 0.25s ease-in-out;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      white-space: nowrap;
    }
    .custom-button:disabled {
      cursor: not-allowed;
      opacity: 0.5;
      filter: saturate(0.5);
    }
    .custom-button:hover:not(:disabled) {
      filter: brightness(1.1);
    }
    .custom-button:active:not(:disabled) {
      transform: scale(0.98);
    }
    .loading-indicator {
      width: 14px;
      height: 14px;
      border: 2px solid currentColor;
      border-top-color: transparent;
      border-radius: 50%;
      animation: spin 0.6s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    .leading, .trailing {
      display: inline-flex;
      font-size: 1.1em;
    }
    .content {
      font-weight: inherit;
    }
  `]
})
export class ButtonComponent {
  @Input() mode: ButtonMode = 'flat';
  @Input() tone: ButtonTone = 'primary';
  @Input() tokens: Partial<DesignTokens> = {};
  @Input() isDisabled = false;
  @Input() isLoading = false;
  @Input() iconOnly = false;
  @Input() leadingIcon?: string;
  @Input() trailingIcon?: string;
  @Input() type: 'button' | 'submit' | 'reset' = 'button';
  @Input() fullWidth = false;
  @Output() buttonClicked = new EventEmitter<MouseEvent>();

  private defaultTokens: DesignTokens = {
    spacing: { xs: '4px', sm: '8px', md: '12px', lg: '16px', xl: '20px' },
    colors: { primary: '#10b981', secondary: '#3b82f6', accent: '#f59e0b', text: '#ffffff' },
    typography: { size: '14px', weight: '600', family: 'Inter, system-ui, sans-serif' },
    effects: { shadow: '0 2px 8px rgba(0,0,0,0.1)', blur: '8px', glow: '0 0 16px' }
  };

  get designTokens(): DesignTokens {
    return {
      spacing: { ...this.defaultTokens.spacing, ...this.tokens.spacing },
      colors: { ...this.defaultTokens.colors, ...this.tokens.colors },
      typography: { ...this.defaultTokens.typography, ...this.tokens.typography },
      effects: { ...this.defaultTokens.effects, ...this.tokens.effects }
    };
  }

  get styles(): Record<string, string> {
    const dt = this.designTokens;
    const toneColors = {
      primary: dt.colors.primary,
      secondary: dt.colors.secondary,
      success: '#10b981',
      warning: '#f59e0b',
      error: '#ef4444'
    };

    const modeStyles = {
      flat: {
        background: toneColors[this.tone],
        color: dt.colors.text,
        border: 'none',
        boxShadow: 'none'
      },
      raised: {
        background: toneColors[this.tone],
        color: dt.colors.text,
        border: 'none',
        boxShadow: dt.effects.shadow
      },
      stroked: {
        background: 'transparent',
        color: toneColors[this.tone],
        border: `2px solid ${toneColors[this.tone]}`,
        boxShadow: 'none'
      },
      icon: {
        background: 'transparent',
        color: toneColors[this.tone],
        border: 'none',
        boxShadow: 'none',
        padding: dt.spacing.sm
      }
    };

    const padding = this.iconOnly
      ? `${dt.spacing.md} ${dt.spacing.md}`
      : `${dt.spacing.md} ${dt.spacing.xl}`;

    return {
      ...modeStyles[this.mode],
      padding,
      fontSize: dt.typography.size,
      fontWeight: dt.typography.weight,
      fontFamily: dt.typography.family,
      borderRadius: '10px',
      width: this.fullWidth ? '100%' : 'auto',
      minHeight: '42px'
    };
  }

  emitClick(event: MouseEvent): void {
    if (!this.isDisabled && !this.isLoading) {
      this.buttonClicked.emit(event);
    }
  }
}
