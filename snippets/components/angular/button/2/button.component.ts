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
  [disabled]="disabled || processing"
  (click)="handleClick($event)"
  [attr.aria-label]="ariaLabel"
  [attr.aria-busy]="processing"
  class="btn">
  <span *ngIf="processing" class="loading-dots">
  <span class="dot"></span>
  <span class="dot"></span>
  <span class="dot"></span>
  </span>
  <ng-container *ngIf="!processing">
  <span *ngIf="prefix" class="prefix">{{ prefix }}</span>
  <span class="label"><ng-content></ng-content></span>
  <span *ngIf="suffix" class="suffix">{{ suffix }}</span>
  </ng-container>
  </button>
  `,
  styles: [`
  .btn {
  border: none;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  font-family: inherit;
  outline: none;
  position: relative;
  overflow: visible;
  }
  .btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  }
  .btn:active:not(:disabled) {
  transform: translateY(-1px) scale(0.99);
  }
  .btn:disabled {
  cursor: not-allowed;
  opacity: 0.5;
  filter: saturate(0.7);
  }
  .loading-dots {
  display: inline-flex;
  gap: 4px;
  align-items: center;
  }
  .dot {
  width: 6px;
  height: 6px;
  background: currentColor;
  border-radius: 50%;
  animation: bounce 1.4s infinite ease-in-out;
  }
  .dot:nth-child(1) { animation-delay: -0.32s; }
  .dot:nth-child(2) { animation-delay: -0.16s; }
  @keyframes bounce {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
  }
  .label {
  display: inline-flex;
  align-items: center;
  }
  .prefix, .suffix {
  display: inline-flex;
  align-items: center;
  }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' | 'minimal' = 'default';
  @Input() size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() disabled = false;
  @Input() processing = false;
  @Input() prefix?: string;
  @Input() suffix?: string;
  @Input() ariaLabel?: string;
  @Input() fullWidth = false;
  @Input() rounded: 'sm' | 'md' | 'lg' | 'full' = 'md';
  @Output() clicked = new EventEmitter<MouseEvent>();
  private defaultTheme: ButtonTheme = {
  primaryColor: '#f97316',
  secondaryColor: '#ea580c',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#1c1917',
  borderColor: '#e7e5e4',
  accentColor: '#fb923c'
  };
  get appliedTheme(): ButtonTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get buttonStyles() {
  const t = this.appliedTheme;
  const sizeMap = {
  xs: { padding: '6px 12px', fontSize: '12px', minHeight: '28px', gap: '4px' },
  sm: { padding: '8px 16px', fontSize: '13px', minHeight: '32px', gap: '6px' },
  md: { padding: '12px 24px', fontSize: '15px', minHeight: '40px', gap: '8px' },
  lg: { padding: '16px 32px', fontSize: '17px', minHeight: '48px', gap: '10px' },
  xl: { padding: '20px 40px', fontSize: '19px', minHeight: '56px', gap: '12px' }
  };
  const roundedMap = {
  sm: '6px',
  md: '10px',
  lg: '16px',
  full: '9999px'
  };
  const variantMap = {
  default: {
  background: t.backgroundColor,
  color: t.textColor,
  border: `2px solid ${t.borderColor}`,
  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.06)'
  },
  outlined: {
  background: 'transparent',
  color: t.primaryColor,
  border: `2px solid ${t.primaryColor}`,
  boxShadow: 'none'
  },
  filled: {
  background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
  color: '#ffffff',
  border: 'none',
  boxShadow: `0 4px 14px ${t.primaryColor}50, 0 2px 4px ${t.primaryColor}30`
  },
  minimal: {
  background: `${t.primaryColor}12`,
  color: t.primaryColor,
  border: 'none',
  boxShadow: 'none'
  }
  };
  return {
  ...sizeMap[this.size],
  ...variantMap[this.variant],
  borderRadius: roundedMap[this.rounded],
  fontWeight: '600',
  width: this.fullWidth ? '100%' : 'auto',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  letterSpacing: '0.3px'
  };
  }
  handleClick(event: MouseEvent): void {
  if (!this.disabled && !this.processing) {
  this.clicked.emit(event);
  }
  }
}
