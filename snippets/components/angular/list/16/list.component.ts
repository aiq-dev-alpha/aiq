import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ListItem {
  id: string | number;
  content: string;
  icon?: string;
  metadata?: any;
}

interface ListTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  hoverColor: string;
}

@Component({
  selector: 'app-list',
  template: `
    <div class="list-container" [ngStyle]="containerStyles">
      <div *ngIf="loading" class="skeleton-loader">
        <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item slide-bounce"></div>
      </div>
      <div *ngIf="!loading" class="list-items">
        <div *ngFor="let item of items"
             class="list-item yellow-slide"
             [class.selected]="isSelected(item)"
             [ngStyle]="getItemStyles(item)"
             (click)="onItemClick(item)">
          <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
          <span class="item-content">{{ item.content }}</span>
          <span *ngIf="item.metadata" class="item-metadata">{{ item.metadata }}</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .list-container { width: 100%; }
    .list-items { display: flex; flex-direction: column; gap: 13px; }
    .list-item {
      padding: 16px 24px;
      cursor: pointer;
      transition: all 0.4s ease;
      display: flex;
      align-items: center;
      gap: 12px;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(234, 179, 8, 0.05), rgba(234, 179, 8, 0.03));
      border: 1px solid #fef08a;
    }
    .yellow-slide:hover {
      background: linear-gradient(135deg, rgba(234, 179, 8, 0.15), rgba(234, 179, 8, 0.1));
      box-shadow: 0 14px 21px rgba(234, 179, 8, 0.3);
      transform: translateY(-3px) scale(1.01);
      border-color: #eab308;
    }
    .item-icon { font-size: 1.4rem; flex-shrink: 0; color: #eab308; }
    .item-content { flex: 1; font-weight: 600; }
    .item-metadata { font-size: 0.875rem; opacity: 0.75; }
    .selected {
      background: linear-gradient(135deg, rgba(234, 179, 8, 0.2), rgba(234, 179, 8, 0.15));
      border-color: #eab308;
      box-shadow: 0 0 0 3px rgba(234, 179, 8, 0.4);
    }
    .skeleton-loader { display: flex; flex-direction: column; gap: 12px; }
    .skeleton-item {
      height: 76px;
      border-radius: 10px;
      background: linear-gradient(90deg, #fef9c3, #fef08a, #fef9c3);
      background-size: 200% 100%;
    }
    @keyframes slide-bounce {
      0% { background-position: -200% 0; opacity: 0.6; }
      50% { opacity: 1; }
      100% { background-position: 200% 0; opacity: 0.6; }
    }
    .slide-bounce { animation: slide-bounce 1.6s ease-in-out infinite; }
  `]
})
export class ListComponent {
  @Input() items: ListItem[] = [];
  @Input() theme: Partial<ListTheme> = {};
  @Input() variant: 'default' | 'bordered' | 'striped' | 'card' | 'compact' | 'detailed' = 'default';
  @Input() selectable: boolean = false;
  @Input() multiSelect: boolean = false;
  @Input() loading: boolean = false;
  @Output() itemClicked = new EventEmitter<ListItem>();
  @Output() selectionChanged = new EventEmitter<ListItem[]>();

  selectedItems: Set<string | number> = new Set();

  private defaultTheme: ListTheme = {
    primaryColor: '#eab308',
    secondaryColor: '#ca8a04',
    backgroundColor: '#fefce8',
    textColor: '#713f12',
    borderColor: '#fef08a',
    hoverColor: '#fef9c3'
  };

  get appliedTheme(): ListTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
    return {
      backgroundColor: this.appliedTheme.backgroundColor,
      color: this.appliedTheme.textColor,
      padding: '17px',
      borderRadius: '20px'
    };
  }

  getItemStyles(item: ListItem) {
    return {
      color: this.appliedTheme.textColor
    };
  }

  isSelected(item: ListItem): boolean {
    return this.selectedItems.has(item.id);
  }

  onItemClick(item: ListItem) {
    this.itemClicked.emit(item);
    if (this.selectable) {
      if (this.multiSelect) {
        if (this.selectedItems.has(item.id)) {
          this.selectedItems.delete(item.id);
        } else {
          this.selectedItems.add(item.id);
        }
      } else {
        this.selectedItems.clear();
        this.selectedItems.add(item.id);
      }
      this.selectionChanged.emit(Array.from(this.selectedItems).map(id =>
        this.items.find(i => i.id === id)!
      ));
    }
  }
}
