import { Component, Input, Output, EventEmitter } from '@angular/core';

interface GridItem {
  id: string | number;
  content: string;
  image?: string;
  title?: string;
  description?: string;
}

interface GridTheme {
  primaryColor: string;
  backgroundColor: string;
  cardColor: string;
  textColor: string;
  borderColor: string;
  shadowColor: string;
}

@Component({
  selector: 'app-grid',
  template: `
    <div class="grid-container" [ngStyle]="containerStyles">
      <div *ngIf="loading" class="grid-wrapper" [ngStyle]="gridStyles">
        <div *ngFor="let item of [1,2,3,4,5,6]" class="grid-item skeleton" [ngStyle]="skeletonStyles">
          <div class="skeleton-image"></div>
          <div class="skeleton-text"></div>
          <div class="skeleton-text short"></div>
        </div>
      </div>
      <div *ngIf="!loading" class="grid-wrapper masonry" [ngStyle]="gridStyles">
        <div *ngFor="let item of items"
             class="grid-item card-elevated"
             [ngStyle]="itemStyles"
             (click)="onItemClick(item)">
          <img *ngIf="item.image" [src]="item.image" [alt]="item.title" class="item-image">
          <div class="item-content">
            <h3 *ngIf="item.title" class="item-title">{{ item.title }}</h3>
            <p *ngIf="item.description" class="item-description">{{ item.description }}</p>
            <div class="item-text">{{ item.content }}</div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .grid-container { width: 100%; height: 100%; }
    .grid-wrapper { display: grid; width: 100%; }
    .masonry { grid-auto-rows: 10px; }
    .grid-item { cursor: pointer; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); overflow: hidden; }
    .grid-item:hover { transform: translateY(-8px); }
    .card-elevated { box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06); }
    .card-elevated:hover { box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04); }
    .item-image { width: 100%; height: 200px; object-fit: cover; }
    .item-content { padding: 1.5rem; }
    .item-title { font-size: 1.25rem; font-weight: 700; margin: 0 0 0.5rem 0; }
    .item-description { font-size: 0.875rem; opacity: 0.7; margin: 0 0 1rem 0; }
    .item-text { font-size: 1rem; line-height: 1.6; }
    .skeleton { animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite; }
    .skeleton-image { width: 100%; height: 200px; background: rgba(0,0,0,0.1); border-radius: 0.5rem; margin-bottom: 1rem; }
    .skeleton-text { width: 100%; height: 1rem; background: rgba(0,0,0,0.1); border-radius: 0.25rem; margin-bottom: 0.5rem; }
    .skeleton-text.short { width: 60%; }
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
  `]
})
export class GridComponent {
  @Input() items: GridItem[] = [];
  @Input() theme: Partial<GridTheme> = {};
  @Input() columns: 1 | 2 | 3 | 4 | 6 | 12 = 3;
  @Input() gap: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() variant: 'masonry' | 'uniform' | 'card' | 'minimal' | 'detailed' = 'masonry';
  @Input() loading: boolean = false;
  @Output() itemClicked = new EventEmitter<GridItem>();

  private defaultTheme: GridTheme = {
    primaryColor: '#6366f1',
    backgroundColor: '#f8fafc',
    cardColor: '#ffffff',
    textColor: '#1e293b',
    borderColor: '#e2e8f0',
    shadowColor: 'rgba(99, 102, 241, 0.1)'
  };

  get appliedTheme(): GridTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
    return {
      backgroundColor: this.appliedTheme.backgroundColor,
      padding: '2rem'
    };
  }

  get gridStyles() {
    const gapMap = { xs: '0.5rem', sm: '1rem', md: '1.5rem', lg: '2rem', xl: '3rem' };
    return {
      gap: gapMap[this.gap],
      gridTemplateColumns: `repeat(${this.columns}, 1fr)`
    };
  }

  get itemStyles() {
    return {
      backgroundColor: this.appliedTheme.cardColor,
      color: this.appliedTheme.textColor,
      borderRadius: '1rem',
      gridRowEnd: `span ${Math.floor(Math.random() * 20) + 20}`
    };
  }

  get skeletonStyles() {
    return {
      backgroundColor: this.appliedTheme.cardColor,
      borderRadius: '1rem',
      padding: '1.5rem'
    };
  }

  onItemClick(item: GridItem) {
    this.itemClicked.emit(item);
  }
}
