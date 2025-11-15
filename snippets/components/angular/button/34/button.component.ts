import { Component, Input, Output, EventEmitter } from '@angular/core';
interface ColorPalette {
  primary: string;
  secondary: string;
  tertiary: string;
  surface: string;
  onSurface: string;
}
@Component({
  selector: 'app-button',
  template: `
  <button [ngStyle]="styles" [disabled]="disabled || busy" [ngClass]="classes" (click)="emit($event)" class="btn">
  <span *ngIf="busy" class="spin"></span>
  <ng-container *ngIf="!busy">
  <i *ngIf="icon && iconPos === 'left'" class="icon-left">{{ icon }}</i>
  <span><ng-content></ng-content></span>
  <i *ngIf="icon && iconPos === 'right'" class="icon-right">{{ icon }}</i>
  </ng-container>
  </button>
  `,
  styles: [`
  .btn { border: none; cursor: pointer; font: inherit; outline: none; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); display: inline-flex; align-items: center; justify-content: center; gap: 8px; position: relative; overflow: hidden; }
  .btn:disabled { cursor: not-allowed; opacity: 0.55; filter: grayscale(0.3); }
  .btn:not(:disabled):hover { transform: translateY(-2px); filter: brightness(1.12); }
  .btn:not(:disabled):active { transform: translateY(0) scale(0.98); }
  .btn.look-outline:hover { box-shadow: inset 0 0 0 2px currentColor !important; }
  .spin { width: 16px; height: 16px; border: 2px solid currentColor; border-top-color: transparent; border-radius: 50%; animation: rotate 0.7s linear infinite; }
  @keyframes rotate { to { transform: rotate(360deg); } }
  `]
})
export class ButtonComponent {
  @Input() palette: Partial<ColorPalette> = {};
  @Input() look: 'filled' | 'outline' | 'ghost' | 'soft' = 'filled';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled = false;
  @Input() busy = false;
  @Input() icon?: string;
  @Input() iconPos: 'left' | 'right' = 'left';
  @Input() wide = false;
  @Input() rounded = true;
  @Input() ripple = true;
  @Output() click = new EventEmitter<MouseEvent>();
  private base: ColorPalette = { primary: '#10b981', secondary: '#059669', tertiary: '#047857', surface: '#ffffff', onSurface: '#111827' };
  get colors(): ColorPalette {
  return { ...this.base, ...this.palette };
  }
  get styles(): Record<string, string> {
  const c = this.colors;
  const sizes = { sm: { padding: '7px 16px', fontSize: '13px', minHeight: '34px' }, md: { padding: '11px 22px', fontSize: '14px', minHeight: '42px' }, lg: { padding: '14px 28px', fontSize: '16px', minHeight: '50px' } };
  const looks = {
  filled: { background: `linear-gradient(135deg, ${c.primary}, ${c.secondary})`, color: '#fff', border: 'none', boxShadow: `0 3px 8px ${c.primary}40` },
  outline: { background: 'transparent', color: c.primary, border: `2px solid ${c.primary}`, boxShadow: `inset 0 0 0 0 ${c.primary}` },
  ghost: { background: 'transparent', color: c.primary, border: 'none', boxShadow: 'none' },
  soft: { background: `${c.primary}18`, color: c.secondary, border: `1px solid ${c.primary}30`, boxShadow: '0 2px 4px rgba(0,0,0,0.04)' }
  };
  return { ...sizes[this.size], ...looks[this.look], borderRadius: this.rounded ? '12px' : '5px', width: this.wide ? '100%' : 'auto', fontWeight: '600', letterSpacing: '0.3px' };
  }
  get classes(): string[] {
  return [`look-${this.look}`, `size-${this.size}`];
  }
  emit(e: MouseEvent): void {
  if (!this.disabled && !this.busy) this.click.emit(e);
  }
}
