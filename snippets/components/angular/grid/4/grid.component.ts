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
        <div *ngFor="let item of [1,2,3,4,5,6]" class="grid-item skeleton" [ngStyle]="skeletonStyles"></div>
      </div>
      <div *ngIf="!loading" class="grid-wrapper card-layout" [ngStyle]="gridStyles">
        <div *ngFor="let item of items"
             class="grid-item card-gradient"
             [ngStyle]="itemStyles"
             (click)="onItemClick(item)">
          <div class="gradient-overlay"></div>
          <img *ngIf="item.image" [src]="item.image" [alt]="item.title" class="background-img">
          <div class="card-body">
            <div class="icon-badge">{{ item.id }}</div>
            <h3 *ngIf="item.title" class="item-title">{{ item.title }}</h3>
            <p class="item-content">{{ item.content }}</p>
            <span *ngIf="item.description" class="item-tag">{{ item.description }}</span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .grid-container { width: 100%; min-height: 100vh; }
    .grid-wrapper { display: grid; width: 100%; }
    .card-layout .grid-item { min-height: 300px; }
    .grid-item { cursor: pointer; transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1); overflow: hidden; position: relative; }
    .grid-item:hover { transform: translateY(-12px) scale(1.02); }
    .card-gradient { background: linear-gradient(135deg, var(--grad-start) 0%, var(--grad-end) 100%); box-shadow: 0 10px 30px -10px rgba(139, 92, 246, 0.3); border-radius: 1.25rem; }
    .card-gradient:hover { box-shadow: 0 20px 50px -10px rgba(139, 92, 246, 0.5); }
    .gradient-overlay { position: absolute; inset: 0; background: linear-gradient(to bottom right, rgba(255,255,255,0.15), transparent); pointer-events: none; }
    .background-img { position: absolute; width: 100%; height: 100%; object-fit: cover; opacity: 0.15; }
    .card-body { position: relative; padding: 2rem; z-index: 1; color: white; }
    .icon-badge { width: 50px; height: 50px; border-radius: 50%; background: rgba(255,255,255,0.25); display: flex; align-items: center; justify-content: center; font-weight: 700; margin-bottom: 1rem; backdrop-filter: blur(10px); }
    .item-title { font-size: 1.5rem; font-weight: 800; margin: 0 0 1rem 0; text-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .item-content { font-size: 1rem; line-height: 1.6; margin: 0 0 1.5rem 0; opacity: 0.95; }
    .item-tag { display: inline-block; padding: 0.375rem 1rem; background: rgba(255,255,255,0.2); border-radius: 2rem; font-size: 0.75rem; font-weight: 600; backdrop-filter: blur(5px); border: 1px solid rgba(255,255,255,0.3); }
    .skeleton { animation: pulse 2s ease-in-out infinite; border-radius: 1.25rem; background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); min-height: 300px; }
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.6; } }
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
  @Input() gap: 'xs' | 'sm' | 'md' | 'lg' | 'xl' = 'lg';
  @Input() variant: 'masonry' | 'uniform' | 'card' | 'minimal' | 'detailed' = 'card';
  @Input() loading: boolean = false;
  @Output() itemClicked = new EventEmitter<GridItem>();

  private defaultTheme: GridTheme = {
    primaryColor: '#8b5cf6',
    backgroundColor: '#faf5ff',
    cardColor: '#8b5cf6',
    textColor: '#ffffff',
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
      '--grad-start': this.appliedTheme.primaryColor,
      '--grad-end': this.appliedTheme.cardColor
    };
  }

  get skeletonStyles() {
    return {
      minHeight: '300px'
    };
  }

  onItemClick(item: GridItem) {
    this.itemClicked.emit(item);
  }
}
