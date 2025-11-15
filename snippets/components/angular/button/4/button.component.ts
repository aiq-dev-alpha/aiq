import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  accentColor: string;
  shadowColor: string;
}
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
  <button
  [ngStyle]="buttonStyles"
  [disabled]="disabled || loading"
  (click)="handleClick($event)"
  [attr.aria-label]="ariaLabel"
  class="btn">
  <span class="btn-shine"></span>
  <span *ngIf="loading" class="spinner-dual">
  <span class="spinner-ring"></span>
  <span class="spinner-ring"></span>
  </span>
  <ng-container *ngIf="!loading">
  <span *ngIf="iconStart" class="icon-start">{{ iconStart }}</span>
  <span class="btn-text"><ng-content></ng-content></span>
  <span *ngIf="iconEnd" class="icon-end">{{ iconEnd }}</span>
  </ng-container>
  </button>
  `,
  styles: [`
  .btn {
  border: none;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  font-family: inherit;
  outline: none;
  position: relative;
  overflow: hidden;
  }
  .btn-shine {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
  transition: left 0.5s;
  }
  .btn:hover:not(:disabled) .btn-shine {
  left: 100%;
  }
  .btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.03);
  }
  .btn:active:not(:disabled) {
  transform: translateY(-1px) scale(1.01);
  }
  .btn:disabled {
  cursor: not-allowed;
  opacity: 0.5;
  filter: grayscale(0.5);
  }
  .spinner-dual {
  display: inline-flex;
  position: relative;
  width: 20px;
  height: 20px;
  }
  .spinner-ring {
  position: absolute;
  width: 100%;
  height: 100%;
  border: 2.5px solid transparent;
  border-top-color: currentColor;
  border-radius: 50%;
  animation: spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
  }
  .spinner-ring:nth-child(2) {
  border-color: transparent;
  border-bottom-color: currentColor;
  animation-direction: reverse;
  animation-duration: 0.8s;
  }
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  .btn-text {
  display: inline-flex;
  align-items: center;
  position: relative;
  z-index: 1;
  }
  .icon-start, .icon-end {
  display: inline-flex;
  align-items: center;
  position: relative;
  z-index: 1;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'glass' = 'default';
  @Input() size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() disabled = false;
  @Input() loading = false;
  @Input() iconStart?: string;
  @Input() iconEnd?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Input() rounded: 'none' | 'sm' | 'md' | 'lg' | 'full' = 'md';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#8b5cf6',
  secondaryColor: '#7c3aed',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#1e1b4b',
  borderColor: '#c4b5fd',
  accentColor: '#a78bfa',
  shadowColor: 'rgba(139, 92, 246, 0.3)'
  };
  get appliedTheme(): ButtonTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get buttonStyles() {
  const t = this.appliedTheme;
  const sizeMap = {
  xs: { padding: '6px 12px', fontSize: '12px', minHeight: '28px', gap: '4px' },
  sm: { padding: '8px 18px', fontSize: '13px', minHeight: '34px', gap: '6px' },
  md: { padding: '12px 28px', fontSize: '15px', minHeight: '42px', gap: '8px' },
  lg: { padding: '16px 36px', fontSize: '17px', minHeight: '50px', gap: '10px' },
  xl: { padding: '20px 44px', fontSize: '19px', minHeight: '58px', gap: '12px' }
  };
  const roundedMap = {
  none: '0',
  sm: '6px',
  md: '12px',
  lg: '18px',
  full: '9999px'
  };
  const variantMap = {
  default: {
  background: t.backgroundColor,
  color: t.textColor,
  border: `2px solid ${t.borderColor}`,
  boxShadow: `0 2px 8px rgba(0, 0, 0, 0.06)`
  },
  outlined: {
  background: 'transparent',
  color: t.primaryColor,
  border: `2px solid ${t.primaryColor}`,
  boxShadow: 'none'
  },
  filled: {
  background: `linear-gradient(135deg, ${t.primaryColor} 0%, ${t.secondaryColor} 100%)`,
  color: '#ffffff',
  border: 'none',
  boxShadow: `0 6px 20px ${t.shadowColor}`
  },
  glass: {
  background: `${t.primaryColor}20`,
  color: t.primaryColor,
  border: `1px solid ${t.primaryColor}40`,
  boxShadow: `0 4px 16px ${t.shadowColor}`,
  backdropFilter: 'blur(10px)'
  }
  };
  return {
  ...sizeMap[this.size],
  ...variantMap[this.variant],
  borderRadius: roundedMap[this.rounded],
  fontWeight: '700',
  width: this.fullWidth ? '100%' : 'auto',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  letterSpacing: '0.4px'
  };
  }
  handleClick(event: MouseEvent): void {
  if (!this.disabled && !this.loading) {
  this.clicked.emit(event);
  }
  }
}
