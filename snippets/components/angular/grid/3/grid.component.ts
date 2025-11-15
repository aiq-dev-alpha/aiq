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
  <div *ngFor="let item of [1,2,3,4,5,6]" class="grid-item skeleton" [ngStyle]="skeletonStyles"></div>
  </div>
  <div *ngIf="!loading" class="grid-wrapper minimal" [ngStyle]="gridStyles">
  <div *ngFor="let item of items"
  class="grid-item card-flat"
  [ngStyle]="itemStyles"
  (click)="onItemClick(item)">
  <div class="overlay" *ngIf="item.image" [ngStyle]="{'background-image': 'url(' + item.image + ')'}">
  <div class="overlay-content">
  <h3 *ngIf="item.title" class="item-title">{{ item.title }}</h3>
  <p class="item-text">{{ item.content }}</p>
  </div>
  </div>
  <div *ngIf="!item.image" class="no-image-content">
  <h3 *ngIf="item.title" class="item-title">{{ item.title }}</h3>
  <p class="item-text">{{ item.content }}</p>
  </div>
  </div>
  </div>
  </div>
  `,
  styles: [`
  .grid-container { width: 100%; height: 100%; min-height: 100vh; }
  .grid-wrapper { display: grid; width: 100%; }
  .minimal .grid-item { aspect-ratio: 1; }
  .grid-item { cursor: pointer; transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); overflow: hidden; }
  .grid-item:hover { transform: rotate(-2deg) scale(1.08); }
  .card-flat { box-shadow: none; }
  .overlay { width: 100%; height: 100%; background-size: cover; background-position: center; position: relative; }
  .overlay::after { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.7) 100%); }
  .overlay-content { position: absolute; bottom: 0; left: 0; right: 0; padding: 1.5rem; z-index: 1; color: white; }
  .no-image-content { padding: 1.5rem; }
  .item-title { font-size: 1.375rem; font-weight: 700; margin: 0 0 0.5rem 0; }
  .item-text { font-size: 0.9375rem; line-height: 1.5; margin: 0; }
  .skeleton { animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite; border-radius: 0.5rem; }
  @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
  .card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  `]
})
export class GridComponent {
  @Input() items: GridItem[] = [];
  @Input() theme: Partial<GridTheme> = {};
  @Input() columns: 1 | 2 | 3 | 4 | 6 | 12 = 3;
  @Input() gap: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'sm';
  @Input() variant: 'masonry' | 'uniform' | 'card' | 'minimal' | 'detailed' = 'minimal';
  @Input() loading: boolean = false;
  @Output() itemClicked = new EventEmitter<GridItem>();

  private defaultTheme: GridTheme = {
  primaryColor: '#f59e0b',
  backgroundColor: '#fffbeb',
  backdropFilter: 'blur(10px)',
  cardColor: '#fef3c7',
  textColor: '#78350f',
  borderColor: '#fcd34d',
  shadowColor: 'rgba(245, 158, 11, 0.2)'
  };

  get appliedTheme(): GridTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor,
  padding: '1.5rem'
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
  borderRadius: '0.5rem'
  };
  }

  get skeletonStyles() {
  return {
  backgroundColor: this.appliedTheme.cardColor,
  minHeight: '300px'
  };
  }

  onItemClick(item: GridItem) {
  this.itemClicked.emit(item);
  }
}
