import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  accentColor: string;
}

@Component({
  selector: 'app-button',
  template: `
  <button
  [ngStyle]="buttonStyles"
  [disabled]="disabled || busy"
  (click)="handleClick($event)"
  [attr.aria-label]="ariaLabel"
  class="btn">
  <span class="wave-effect"></span>
  <span *ngIf="busy" class="orbit-loader">
  <span class="orbit"></span>
  <span class="orbit"></span>
  </span>
  <ng-container *ngIf="!busy">
  <span *ngIf="leadingIcon" class="leading">{{ leadingIcon }}</span>
  <span class="text"><ng-content></ng-content></span>
  <span *ngIf="trailingIcon" class="trailing">{{ trailingIcon }}</span>
  </ng-container>
  </button>
  `,
  styles: [`
  .btn {
  border: none;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: inherit;
  outline: none;
  position: relative;
  overflow: hidden;
  }
  .wave-effect {
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at center, rgba(255,255,255,0.4) 0%, transparent 70%);
  opacity: 0;
  transform: scale(0);
  transition: transform 0.5s, opacity 0.5s;
  }
  .btn:active:not(:disabled) .wave-effect {
  opacity: 1;
  transform: scale(2);
  transition: 0s;
  }
  .btn:hover:not(:disabled) {
  transform: perspective(500px) rotateX(5deg) translateY(-3px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  .btn:active:not(:disabled) {
  transform: perspective(500px) rotateX(2deg) translateY(-1px);
  }
  .btn:disabled {
  cursor: not-allowed;
  opacity: 0.5;
  }
  .orbit-loader {
  display: inline-block;
  position: relative;
  width: 24px;
  height: 24px;
  }
  .orbit {
  position: absolute;
  width: 100%;
  height: 100%;
  border: 2px solid transparent;
  border-top-color: currentColor;
  border-radius: 50%;
  animation: orbit 1.2s linear infinite;
  }
  .orbit:nth-child(2) {
  border-top-color: transparent;
  border-bottom-color: currentColor;
  animation-direction: reverse;
  animation-duration: 0.8s;
  }
  @keyframes orbit {
  to { transform: rotate(360deg); }
  }
  .text {
  display: inline-flex;
  align-items: center;
  position: relative;
  z-index: 1;
  }
  .leading, .trailing {
  display: inline-flex;
  align-items: center;
  position: relative;
  z-index: 1;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'elevated' | 'tonal' | 'text' | 'outlined' = 'elevated';
  @Input() size: 'compact' | 'standard' | 'large' = 'standard';
  @Input() disabled = false;
  @Input() busy = false;
  @Input() leadingIcon?: string;
  @Input() trailingIcon?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Input() rounded = true;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
  primaryColor: '#10b981',
  secondaryColor: '#059669',
  backgroundColor: '#d1fae5',
  backdropFilter: 'blur(10px)',
  textColor: '#065f46',
  borderColor: '#6ee7b7',
  accentColor: '#34d399'
  };

  get appliedTheme(): ButtonTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
  const t = this.appliedTheme;
  const sizeMap = {
  compact: { padding: '8px 16px', fontSize: '13px', minHeight: '34px', gap: '6px' },
  standard: { padding: '12px 28px', fontSize: '15px', minHeight: '44px', gap: '8px' },
  large: { padding: '16px 36px', fontSize: '17px', minHeight: '52px', gap: '10px' }
  };

  const variantMap = {
  elevated: {
  background: `linear-gradient(to bottom, ${t.accentColor}, ${t.primaryColor})`,
  color: '#ffffff',
  border: 'none',
  boxShadow: `0 6px 18px ${t.primaryColor}50, 0 2px 4px rgba(0, 0, 0, 0.1)`
  },
  tonal: {
  background: t.backgroundColor,
  color: t.textColor,
  border: 'none',
  boxShadow: '0 2px 6px rgba(0, 0, 0, 0.08)'
  },
  text: {
  background: 'transparent',
  color: t.primaryColor,
  border: 'none',
  boxShadow: 'none'
  },
  outlined: {
  background: 'transparent',
  color: t.primaryColor,
  border: `2px solid ${t.borderColor}`,
  boxShadow: 'none'
  }
  };

  return {
  ...sizeMap[this.size],
  ...variantMap[this.variant],
  borderRadius: this.rounded ? '12px' : '6px',
  fontWeight: '700',
  width: this.fullWidth ? '100%' : 'auto',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  letterSpacing: '0.4px'
  };
  }

  handleClick(event: MouseEvent): void {
  if (!this.disabled && !this.busy) {
  this.clicked.emit(event);
  }
  }
}
