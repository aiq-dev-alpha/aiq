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
        </div>
      </div>
      <div *ngIf="!loading" class="grid-wrapper uniform" [ngStyle]="gridStyles">
        <div *ngFor="let item of items"
             class="grid-item card-bordered"
             [ngStyle]="itemStyles"
             (click)="onItemClick(item)">
          <div class="card-header" *ngIf="item.image" [ngStyle]="{'background-image': 'url(' + item.image + ')'}"></div>
          <div class="item-content">
            <h3 *ngIf="item.title" class="item-title">{{ item.title }}</h3>
            <p class="item-text">{{ item.content }}</p>
            <p *ngIf="item.description" class="item-description">{{ item.description }}</p>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .grid-container { width: 100%; height: 100%; min-height: 100vh; }
    .grid-wrapper { display: grid; width: 100%; }
    .uniform .grid-item { height: 350px; }
    .grid-item { cursor: pointer; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); overflow: hidden; position: relative; }
    .grid-item:hover { transform: scale(1.05); }
    .card-bordered { border: 2px solid; }
    .card-header { width: 100%; height: 160px; background-size: cover; background-position: center; }
    .item-content { padding: 1.25rem; }
    .item-title { font-size: 1.125rem; font-weight: 600; margin: 0 0 0.75rem 0; }
    .item-text { font-size: 0.9375rem; line-height: 1.5; margin: 0 0 0.5rem 0; }
    .item-description { font-size: 0.8125rem; opacity: 0.6; margin: 0; }
    .skeleton { animation: pulse 2s ease-in-out infinite; }
    .skeleton-image { width: 100%; height: 160px; background: rgba(0,0,0,0.08); margin-bottom: 1rem; }
    .skeleton-text { width: 100%; height: 0.875rem; background: rgba(0,0,0,0.08); margin-bottom: 0.5rem; }
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }
      .card:hover {
      transform: translateY(-4px);
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
    }
  `]
})
export class GridComponent {
  @Input() items: GridItem[] = [];
  @Input() theme: Partial<GridTheme> = {};
  @Input() columns: 1 | 2 | 3 | 4 | 6 | 12 = 4;
  @Input() gap: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'lg';
  @Input() variant: 'masonry' | 'uniform' | 'card' | 'minimal' | 'detailed' = 'uniform';
  @Input() loading: boolean = false;
  @Output() itemClicked = new EventEmitter<GridItem>();

  private defaultTheme: GridTheme = {
    primaryColor: '#ec4899',
    backgroundColor: '#fdf2f8',
        backdropFilter: 'blur(10px)',
    cardColor: '#ffffff',
    textColor: '#831843',
    borderColor: '#f9a8d4',
    shadowColor: 'rgba(236, 72, 153, 0.15)'
  };

  get appliedTheme(): GridTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
    return {
      backgroundColor: this.appliedTheme.backgroundColor,
      padding: '2.5rem'
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
      borderColor: this.appliedTheme.borderColor,
      borderRadius: '0.75rem'
    };
  }

  get skeletonStyles() {
    return {
      backgroundColor: this.appliedTheme.cardColor,
      borderRadius: '0.75rem',
      padding: '1.25rem'
    };
  }

  onItemClick(item: GridItem) {
    this.itemClicked.emit(item);
  }
}
