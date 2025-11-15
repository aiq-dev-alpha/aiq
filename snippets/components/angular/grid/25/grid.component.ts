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
  template: \`
    <div class="grid-container" [ngStyle]="containerStyles">
      <div *ngIf="loading" class="grid-wrapper" [ngStyle]="gridStyles">
        <div *ngFor="let item of [1,2,3,4,5,6]" class="grid-item skeleton"></div>
      </div>
      <div *ngIf="!loading" class="grid-wrapper" [ngStyle]="gridStyles">
        <div *ngFor="let item of items"
             class="grid-item"
             [ngStyle]="itemStyles"
             (click)="onItemClick(item)">
          <img *ngIf="item.image" [src]="item.image" [alt]="item.title" class="item-image">
          <div class="item-content">
            <h3 *ngIf="item.title" class="item-title">{{ item.title }}</h3>
            <p class="item-text">{{ item.content }}</p>
            <span *ngIf="item.description" class="item-meta">{{ item.description }}</span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .grid-container { width: 100%; min-height: 100vh; }
    .grid-wrapper { display: grid; width: 100%; }
    .grid-item { cursor: pointer; transition: all 0.3s ease; border-radius: 1rem; overflow: hidden; }
    .grid-item:hover { transform: scale(1.05); box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
    .item-image { width: 100%; height: 180px; object-fit: cover; }
    .item-content { padding: 1.5rem; }
    .item-title { font-size: 1.25rem; font-weight: 700; margin: 0 0 0.75rem 0; }
    .item-text { font-size: 1rem; line-height: 1.6; margin: 0; }
    .item-meta { font-size: 0.875rem; opacity: 0.7; }
    .skeleton { animation: pulse 2s ease-in-out infinite; background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%); background-size: 200% 100%; min-height: 250px; }
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
  `]
})
export class GridComponent {
  @Input() items: GridItem[] = [];
  @Input() theme: Partial<GridTheme> = {};
  @Input() columns: 1 | 2 | 3 | 4 | 6 | 12 = 4;
  @Input() gap: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() variant: 'masonry' | 'uniform' | 'card' | 'minimal' | 'detailed' = 'uniform';
  @Input() loading: boolean = false;
  @Output() itemClicked = new EventEmitter<GridItem>();

  private defaultTheme: GridTheme = {
    primaryColor: '#06b6d4',
    backgroundColor: '#ecfeff',
    cardColor: '#a5f3fc',
    textColor: '#0e7490',
    borderColor: '#e5e7eb',
    shadowColor: 'rgba(0,0,0,0.1)'
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
      borderRadius: '1rem'
    };
  }

  onItemClick(item: GridItem) {
    this.itemClicked.emit(item);
  }
}
