import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  glowColor: string;
}

@Component({
  selector: 'app-button',
  template: `
  <button
  [ngStyle]="buttonStyles"
  [ngClass]="buttonClasses"
  [disabled]="disabled || isLoading"
  (click)="handleClick($event)"
  [attr.aria-label]="ariaLabel"
  class="btn">
  <span *ngIf="isLoading" class="loader"></span>
  <ng-container *ngIf="!isLoading">
  <span *ngIf="leftIcon" class="icon icon-left">{{ leftIcon }}</span>
  <span class="text"><ng-content></ng-content></span>
  <span *ngIf="rightIcon" class="icon icon-right">{{ rightIcon }}</span>
  </ng-container>
  <span class="ripple" *ngIf="enableRipple"></span>
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
  .btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  .btn:active:not(:disabled) {
  transform: translateY(0);
  }
  .btn:disabled {
  cursor: not-allowed;
  opacity: 0.6;
  }
  .btn.glow:hover:not(:disabled) {
  filter: drop-shadow(0 0 12px currentColor);
  }
  .loader {
  width: 18px;
  height: 18px;
  border: 3px solid rgba(255,255,255,0.2);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  }
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  .text {
  display: inline-flex;
  align-items: center;
  }
  .icon {
  display: inline-flex;
  align-items: center;
  }
  .ripple {
  position: absolute;
  inset: 0;
  background: radial-gradient(circle, rgba(255,255,255,0.3) 0%, transparent 70%);
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.4s;
  }
  .btn:active .ripple {
  opacity: 1;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'neon' = 'default';
  @Input() size: 'xs' | 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled = false;
  @Input() isLoading = false;
  @Input() leftIcon?: string;
  @Input() rightIcon?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Input() rounded: boolean = true;
  @Input() enableRipple = false;
  @Input() glow = false;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: ButtonTheme = {
  primaryColor: '#14b8a6',
  secondaryColor: '#0d9488',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#0f172a',
  borderColor: '#cbd5e1',
  glowColor: 'rgba(20, 184, 166, 0.4)'
  };

  get appliedTheme(): ButtonTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
  const t = this.appliedTheme;
  const sizeMap = {
  xs: { padding: '6px 14px', fontSize: '12px', minHeight: '30px', gap: '5px' },
  sm: { padding: '9px 18px', fontSize: '13px', minHeight: '36px', gap: '6px' },
  md: { padding: '12px 26px', fontSize: '15px', minHeight: '44px', gap: '8px' },
  lg: { padding: '15px 34px', fontSize: '17px', minHeight: '52px', gap: '10px' }
  };

  const variantMap = {
  default: {
  background: t.backgroundColor,
  color: t.textColor,
  border: `2px solid ${t.borderColor}`,
  boxShadow: '0 2px 6px rgba(0, 0, 0, 0.08)'
  },
  outlined: {
  background: 'transparent',
  color: t.primaryColor,
  border: `2px solid ${t.primaryColor}`,
  boxShadow: `inset 0 0 0 0 ${t.primaryColor}`
  },
  filled: {
  background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
  color: '#ffffff',
  border: 'none',
  boxShadow: `0 6px 16px ${t.glowColor}`
  },
  neon: {
  background: t.backgroundColor,
  color: t.primaryColor,
  border: `2px solid ${t.primaryColor}`,
  boxShadow: `0 0 20px ${t.glowColor}, inset 0 0 10px ${t.glowColor}`
  }
  };

  return {
  ...sizeMap[this.size],
  ...variantMap[this.variant],
  borderRadius: this.rounded ? '12px' : '4px',
  fontWeight: '700',
  width: this.fullWidth ? '100%' : 'auto',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  letterSpacing: '0.4px',
  textTransform: 'none' as any
  };
  }

  get buttonClasses(): string[] {
  const classes = [];
  if (this.glow) classes.push('glow');
  return classes;
  }

  handleClick(event: MouseEvent): void {
  if (!this.disabled && !this.isLoading) {
  this.clicked.emit(event);
  }
  }
}
