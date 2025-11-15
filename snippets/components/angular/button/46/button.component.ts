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
    .btn { border: none; cursor: pointer; font: inherit; outline: none; transition: all 0.2s; display: inline-flex; align-items: center; justify-content: center; gap: 8px; position: relative; }
    .btn:disabled { cursor: not-allowed; opacity: 0.6; }
    .btn:not(:disabled):hover { filter: brightness(1.08); }
    .btn:not(:disabled):active { transform: scale(0.97); }
    .spin { width: 16px; height: 16px; border: 2px solid currentColor; border-top-color: transparent; border-radius: 50%; animation: rotate 0.6s linear infinite; }
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
  @Output() click = new EventEmitter<MouseEvent>();

  private base: ColorPalette = { primary: '#6366f1', secondary: '#a78bfa', tertiary: '#c4b5fd', surface: '#ffffff', onSurface: '#0f172a' };

  get colors(): ColorPalette {
    return { ...this.base, ...this.palette };
  }

  get styles(): Record<string, string> {
    const c = this.colors;
    const sizes = { sm: { padding: '7px 14px', fontSize: '13px' }, md: { padding: '10px 20px', fontSize: '14px' }, lg: { padding: '13px 26px', fontSize: '16px' } };
    const looks = {
      filled: { background: c.primary, color: '#fff', border: 'none' },
      outline: { background: 'transparent', color: c.primary, border: `2px solid ${c.primary}` },
      ghost: { background: 'transparent', color: c.primary, border: 'none' },
      soft: { background: `${c.primary}20`, color: c.primary, border: 'none' }
    };
    return { ...sizes[this.size], ...looks[this.look], borderRadius: this.rounded ? '10px' : '4px', width: this.wide ? '100%' : 'auto', fontWeight: '600' };
  }

  get classes(): string[] {
    return [`look-${this.look}`, `size-${this.size}`];
  }

  emit(e: MouseEvent): void {
    if (!this.disabled && !this.busy) this.click.emit(e);
  }
}
