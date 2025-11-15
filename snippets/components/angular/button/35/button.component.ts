import { Component, Input, Output, EventEmitter } from '@angular/core';

interface BrandTheme {
  name: string;
  palette: {
    base: string;
    contrast: string;
    surface: string;
    accent: string;
  };
  radius: string;
  shadow: string;
}

type Presentation = 'filled' | 'tinted' | 'outlined' | 'text' | 'elevated';
type Density = 'compact' | 'default' | 'comfortable';

@Component({
  selector: 'app-button',
  template: `
    <button
      [ngStyle]="getComputedStyles()"
      [disabled]="disabled || processing"
      [attr.aria-busy]="processing"
      [attr.aria-label]="ariaLabel"
      (click)="onButtonClick($event)">
      <span class="button-inner">
        <span *ngIf="startIcon && !processing" class="start-icon">{{ startIcon }}</span>
        <span *ngIf="processing" class="process-spinner"></span>
        <span *ngIf="label || hasContent" class="button-label">
          <ng-content *ngIf="hasContent; else defaultLabel"></ng-content>
          <ng-template #defaultLabel>{{ label }}</ng-template>
        </span>
        <span *ngIf="endIcon && !processing" class="end-icon">{{ endIcon }}</span>
      </span>
    </button>
  `,
  styles: [`
    button {
      border: none;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      cursor: pointer;
      position: relative;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      outline: none;
      user-select: none;
    }
    button:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }
    button:hover:not(:disabled) {
      transform: translateY(-1px);
    }
    button:active:not(:disabled) {
      transform: translateY(0);
    }
    .button-inner {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }
    .start-icon, .end-icon {
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .process-spinner {
      width: 14px;
      height: 14px;
      border: 2px solid currentColor;
      border-top-color: transparent;
      border-radius: 50%;
      animation: spin-animation 0.7s linear infinite;
    }
    @keyframes spin-animation {
      to { transform: rotate(360deg); }
    }
    .button-label {
      line-height: 1;
    }
  `]
})
export class ButtonComponent {
  @Input() presentation: Presentation = 'filled';
  @Input() density: Density = 'default';
  @Input() brandTheme: Partial<BrandTheme> = {};
  @Input() disabled = false;
  @Input() processing = false;
  @Input() label?: string;
  @Input() startIcon?: string;
  @Input() endIcon?: string;
  @Input() ariaLabel?: string;
  @Input() stretch = false;
  @Input() hasContent = false;
  @Output() clickEvent = new EventEmitter<MouseEvent>();

  private defaultBrand: BrandTheme = {
    name: 'default',
    palette: {
      base: '#6366f1',
      contrast: '#ffffff',
      surface: '#f9fafb',
      accent: '#818cf8'
    },
    radius: '8px',
    shadow: '0 4px 6px rgba(99, 102, 241, 0.2)'
  };

  get brand(): BrandTheme {
    return {
      ...this.defaultBrand,
      ...this.brandTheme,
      palette: { ...this.defaultBrand.palette, ...this.brandTheme.palette }
    };
  }

  getComputedStyles(): Record<string, string> {
    const b = this.brand;
    const densityMap = {
      compact: { padding: '8px 16px', fontSize: '13px', minHeight: '32px' },
      default: { padding: '10px 20px', fontSize: '14px', minHeight: '40px' },
      comfortable: { padding: '14px 28px', fontSize: '15px', minHeight: '48px' }
    };

    const presentationMap = {
      filled: {
        background: b.palette.base,
        color: b.palette.contrast,
        border: 'none',
        boxShadow: b.shadow
      },
      tinted: {
        background: `${b.palette.base}20`,
        color: b.palette.base,
        border: 'none',
        boxShadow: 'none'
      },
      outlined: {
        background: 'transparent',
        color: b.palette.base,
        border: `1.5px solid ${b.palette.base}`,
        boxShadow: 'none'
      },
      text: {
        background: 'transparent',
        color: b.palette.base,
        border: 'none',
        boxShadow: 'none'
      },
      elevated: {
        background: b.palette.surface,
        color: b.palette.base,
        border: `1px solid ${b.palette.base}30`,
        boxShadow: '0 8px 16px rgba(0,0,0,0.1)'
      }
    };

    return {
      ...densityMap[this.density],
      ...presentationMap[this.presentation],
      borderRadius: b.radius,
      fontWeight: '600',
      width: this.stretch ? '100%' : 'auto',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center'
    };
  }

  onButtonClick(event: MouseEvent): void {
    if (!this.disabled && !this.processing) {
      this.clickEvent.emit(event);
    }
  }
}
