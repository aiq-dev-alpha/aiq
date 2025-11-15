import { Component, Input, Output, EventEmitter } from '@angular/core';
interface DesignSystem {
  colors: {
  surface: string;
  onSurface: string;
  primary: string;
  secondary: string;
  };
  spacing: {
  xs: string;
  sm: string;
  md: string;
  lg: string;
  };
  typography: {
  headingSize: string;
  bodySize: string;
  captionSize: string;
  };
  effects: {
  elevation: string;
  radius: string;
  };
}
type LayoutStyle = 'vertical' | 'horizontal' | 'compact' | 'feature';
@Component({
  selector: 'app-card',
  template: `
  <article [ngStyle]="computedStyle" [ngClass]="layoutClass" class="card">
  <div *ngIf="badge" class="badge">{{ badge }}</div>
  <div *ngIf="thumbnail" class="thumbnail-section">
  <img [src]="thumbnail" [alt]="thumbnailAlt" class="thumbnail-img">
  </div>
  <div class="content-section">
  <header *ngIf="heading || meta" class="card-header-section">
  <div *ngIf="meta" class="meta-info">{{ meta }}</div>
  <h2 *ngIf="heading" class="heading">{{ heading }}</h2>
  <p *ngIf="description" class="description">{{ description }}</p>
  </header>
  <div class="main-content">
  <ng-content></ng-content>
  </div>
  <footer *ngIf="hasActions" class="card-actions">
  <ng-content select="[actions]"></ng-content>
  </footer>
  </div>
  </article>
  `,
  styles: [`
  .card {
  position: relative;
  display: flex;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: system-ui, -apple-system, sans-serif;
  }
  .card.vertical {
  flex-direction: column;
  }
  .card.horizontal {
  flex-direction: row;
  }
  .card.compact {
  flex-direction: row;
  align-items: center;
  gap: 1rem;
  }
  .card.feature {
  flex-direction: column;
  align-items: center;
  text-align: center;
  }
  .badge {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 4px 12px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  z-index: 1;
  }
  .thumbnail-section {
  flex-shrink: 0;
  overflow: hidden;
  }
  .thumbnail-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  }
  .content-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  }
  .meta-info {
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  opacity: 0.7;
  margin-bottom: 0.5rem;
  }
  .heading {
  margin: 0 0 0.5rem;
  font-weight: 700;
  line-height: 1.3;
  }
  .description {
  margin: 0;
  opacity: 0.8;
  line-height: 1.6;
  }
  .main-content {
  flex: 1;
  margin: 1rem 0;
  }
  .card-actions {
  display: flex;
  gap: 0.75rem;
  align-items: center;
  flex-wrap: wrap;
  }
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
  @Input() layoutStyle: LayoutStyle = 'vertical';
  @Input() designSystem: Partial<DesignSystem> = {};
  @Input() heading?: string;
  @Input() description?: string;
  @Input() meta?: string;
  @Input() thumbnail?: string;
  @Input() thumbnailAlt = '';
  @Input() badge?: string;
  @Input() hasActions = false;
  @Input() interactive = false;
  @Output() interact = new EventEmitter<MouseEvent>();
  private defaults: DesignSystem = {
  colors: {
  surface: '#ffffff',
  onSurface: '#0f172a',
  primary: '#3b82f6',
  secondary: '#8b5cf6'
  },
  spacing: {
  xs: '8px',
  sm: '12px',
  md: '18px',
  lg: '26px'
  },
  typography: {
  headingSize: '1.625rem',
  bodySize: '0.9375rem',
  captionSize: '0.8125rem'
  },
  effects: {
  elevation: '0 10px 20px -3px rgba(0, 0, 0, 0.12), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
  radius: '18px'
  }
  };
  get system(): DesignSystem {
  return {
  colors: { ...this.defaults.colors, ...this.designSystem.colors },
  spacing: { ...this.defaults.spacing, ...this.designSystem.spacing },
  typography: { ...this.defaults.typography, ...this.designSystem.typography },
  effects: { ...this.defaults.effects, ...this.designSystem.effects }
  };
  }
  get layoutClass(): string {
  return this.layoutStyle;
  }
  get computedStyle(): Record<string, string> {
  const s = this.system;
  return {
  background: s.colors.surface,
  color: s.colors.onSurface,
  borderRadius: s.effects.radius,
  boxShadow: s.effects.elevation,
  padding: s.spacing.lg,
  cursor: this.interactive ? 'pointer' : 'default'
  };
  }
}
