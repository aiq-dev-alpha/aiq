import { Component, Input, Output, EventEmitter } from '@angular/core';

interface BrandPalette {
  light: string;
  main: string;
  dark: string;
  contrast: string;
}

type SurfaceType = 'matte' | 'glossy' | 'metallic' | 'frosted';
type SizeScale = 'xs' | 'sm' | 'md' | 'lg' | 'xl' | 'xxl';

@Component({
  selector: 'app-button',
  template: `
    <button [ngStyle]="dynamicStyles" [disabled]="isDisabled" [ngClass]="classList" (click)="emit($event)" class="btn-root">
      <span *ngIf="isLoading" class="loader-ring"></span>
      <ng-container *ngIf="!isLoading">
        <span *ngIf="leading" class="lead-content">{{ leading }}</span>
        <span class="main-text"><ng-content></ng-content></span>
        <span *ngIf="trailing" class="trail-content">{{ trailing }}</span>
      </ng-container>
    </button>
  `,
  styles: [`
    .btn-root { border: none; font-family: inherit; cursor: pointer; position: relative; overflow: hidden; outline: none; transition: all 0.25s ease; display: inline-flex; align-items: center; justify-content: center; gap: 0.625rem; }
    .btn-root:disabled { cursor: not-allowed; opacity: 0.5; }
    .btn-root::before { content: ''; position: absolute; inset: 0; opacity: 0; transition: opacity 0.3s; }
    .btn-root:hover:not(:disabled)::before { opacity: 0.1; background: currentColor; }
    .btn-root:active:not(:disabled) { transform: scale(0.96); }
    .loader-ring { width: 18px; height: 18px; border: 3px solid currentColor; border-top-color: transparent; border-radius: 50%; animation: ring-spin 0.7s linear infinite; }
    @keyframes ring-spin { to { transform: rotate(360deg); } }
    .main-text { font-weight: inherit; letter-spacing: 0.3px; }
    .lead-content, .trail-content { display: flex; align-items: center; font-size: 1.1em; }
  `]
})
export class ButtonComponent {
  @Input() surface: SurfaceType = 'matte';
  @Input() scale: SizeScale = 'md';
  @Input() palette: Partial<BrandPalette> = {};
  @Input() isDisabled = false;
  @Input() isLoading = false;
  @Input() leading?: string;
  @Input() trailing?: string;
  @Input() elevated = false;
  @Input() pill = false;
  @Output() btnClick = new EventEmitter<MouseEvent>();

  private basePalette: BrandPalette = {
    light: '#a78bfa',
    main: '#8b5cf6',
    dark: '#6d28d9',
    contrast: '#ffffff'
  };

  get brand(): BrandPalette {
    return { ...this.basePalette, ...this.palette };
  }

  get scaleStyles(): Record<string, string> {
    const scales = {
      xs: { padding: '5px 11px', fontSize: '11px', minHeight: '26px' },
      sm: { padding: '7px 15px', fontSize: '12px', minHeight: '32px' },
      md: { padding: '11px 22px', fontSize: '14px', minHeight: '42px' },
      lg: { padding: '13px 26px', fontSize: '16px', minHeight: '50px' },
      xl: { padding: '15px 32px', fontSize: '18px', minHeight: '58px' },
      xxl: { padding: '18px 40px', fontSize: '20px', minHeight: '66px' }
    };
    return scales[this.scale];
  }

  get surfaceStyles(): Record<string, string> {
    const b = this.brand;
    const surfaces = {
      matte: { background: b.main, color: b.contrast, boxShadow: 'none' },
      glossy: { background: `linear-gradient(135deg, ${b.light}, ${b.dark})`, color: b.contrast, boxShadow: `0 8px 16px ${b.main}40` },
      metallic: { background: `linear-gradient(180deg, ${b.light}, ${b.main}, ${b.dark})`, color: b.contrast, boxShadow: `inset 0 1px 0 ${b.light}60, inset 0 -1px 0 ${b.dark}60` },
      frosted: { background: `${b.main}cc`, backdropFilter: 'blur(10px)', color: b.contrast, boxShadow: `0 4px 24px ${b.main}30`, border: `1px solid ${b.light}50` }
    };
    return surfaces[this.surface];
  }

  get dynamicStyles(): Record<string, string> {
    return {
      ...this.scaleStyles,
      ...this.surfaceStyles,
      borderRadius: this.pill ? '999px' : '11px',
      boxShadow: this.elevated ? `0 6px 20px ${this.brand.main}35` : this.surfaceStyles.boxShadow,
      fontWeight: '600'
    };
  }

  get classList(): string[] {
    return [`surface-${this.surface}`, `scale-${this.scale}`, this.pill ? 'pill' : '', this.elevated ? 'elevated' : ''].filter(Boolean);
  }

  emit(event: MouseEvent): void {
    if (!this.isDisabled && !this.isLoading) {
      this.btnClick.emit(event);
    }
  }
}
