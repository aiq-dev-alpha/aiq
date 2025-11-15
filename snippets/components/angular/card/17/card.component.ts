import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ElevationSystem {
  flat: string;
  low: string;
  medium: string;
  high: string;
  ultra: string;
}

interface CardDesign {
  bg: string;
  fg: string;
  accent: string;
  muted: string;
}

type LayoutMode = 'stacked' | 'horizontal' | 'overlay' | 'masonry';

@Component({
  selector: 'app-card',
  template: `
  <article [ngStyle]="cardStyle" [ngClass]="modeClass" class="card-element" (click)="handleCardClick()">
  <div *ngIf="tag" class="card-tag" [ngStyle]="tagStyle">{{ tag }}</div>

  <div *ngIf="cover" class="card-cover" [ngStyle]="coverStyle">
  <img [src]="cover" [alt]="coverAlt" />
  <div *ngIf="mode === 'overlay'" class="overlay-scrim"></div>
  </div>

  <div class="card-main" [ngClass]="{'overlay-positioned': mode === 'overlay'}">
  <header *ngIf="heading || meta" class="card-head">
  <small *ngIf="meta" class="meta-text">{{ meta }}</small>
  <h3 *ngIf="heading" class="heading-text">{{ heading }}</h3>
  </header>

  <div class="card-content">
  <p *ngIf="excerpt" class="excerpt-text">{{ excerpt }}</p>
  <ng-content></ng-content>
  </div>

  <footer *ngIf="showFooter" class="card-foot">
  <ng-content select="[cardFooter]"></ng-content>
  </footer>
  </div>
  </article>
  `,
  styles: [`
  .card-element { position: relative; overflow: hidden; transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1); font-family: system-ui, sans-serif; }
  .card-element:hover { transform: translateY(-3px); }
  .card-tag { position: absolute; top: 16px; left: 16px; padding: 6px 14px; border-radius: 8px; font-size: 12px; font-weight: 700; z-index: 2; text-transform: uppercase; letter-spacing: 0.8px; }
  .card-cover { position: relative; overflow: hidden; }
  .card-cover img { width: 100%; height: 220px; object-fit: cover; display: block; transition: transform 0.4s ease; }
  .card-element:hover .card-cover img { transform: scale(1.05); }
  .overlay-scrim { position: absolute; inset: 0; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent); }
  .stacked .card-main { padding: 20px; }
  .horizontal { display: flex; gap: 20px; }
  .horizontal .card-cover { flex-shrink: 0; width: 180px; }
  .horizontal .card-cover img { height: 100%; }
  .horizontal .card-main { flex: 1; padding: 20px; }
  .overlay .card-main.overlay-positioned { position: absolute; bottom: 0; left: 0; right: 0; padding: 24px; color: white; z-index: 1; }
  .meta-text { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; opacity: 0.7; margin-bottom: 8px; }
  .heading-text { margin: 0 0 12px; font-size: 22px; font-weight: 800; line-height: 1.25; }
  .excerpt-text { margin: 0 0 16px; font-size: 14px; line-height: 1.7; opacity: 0.85; }
  .card-foot { margin-top: 20px; padding-top: 16px; border-top: 1px solid; opacity: 0.15; }
  .card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  
  
  @keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
  }
  
  @keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
  }
  
  @keyframes scaleIn {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
  }
  `]
})
export class CardComponent {
  @Input() mode: LayoutMode = 'stacked';
  @Input() design: Partial<CardDesign> = {};
  @Input() elevation: keyof ElevationSystem = 'medium';
  @Input() heading?: string;
  @Input() meta?: string;
  @Input() excerpt?: string;
  @Input() cover?: string;
  @Input() coverAlt = '';
  @Input() tag?: string;
  @Input() showFooter = false;
  @Input() interactive = false;
  @Output() cardClick = new EventEmitter<void>();

  private defaultDesign: CardDesign = {
  bg: '#ffffff',
  fg: '#0f172a',
  accent: '#3b82f6',
  muted: '#64748b'
  };

  private shadows: ElevationSystem = {
  flat: 'none',
  low: '0 1px 3px rgba(0,0,0,0.08)',
  medium: '0 4px 12px rgba(0,0,0,0.12)',
  high: '0 12px 24px rgba(0,0,0,0.15)',
  ultra: '0 24px 48px rgba(0,0,0,0.2)'
  };

  get cardDesign(): CardDesign {
  return { ...this.defaultDesign, ...this.design };
  }

  get modeClass(): string {
  return this.mode;
  }

  get cardStyle(): Record<string, string> {
  const d = this.cardDesign;
  return {
  background: d.bg,
  color: d.fg,
  borderRadius: '18px',
  boxShadow: this.shadows[this.elevation],
  cursor: this.interactive ? 'pointer' : 'default'
  };
  }

  get tagStyle(): Record<string, string> {
  return {
  background: this.cardDesign.accent,
  color: '#ffffff'
  };
  }

  get coverStyle(): Record<string, string> {
  return {
  borderRadius: this.mode === 'stacked' ? '18px 18px 0 0' : this.mode === 'horizontal' ? '18px 0 0 18px' : '18px'
  };
  }

  handleCardClick(): void {
  if (this.interactive) {
  this.cardClick.emit();
  }
  }
}
