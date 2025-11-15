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
        <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item rotate-glow"></div>
      </div>
      <div *ngIf="!loading" class="list-items">
        <div *ngFor="let item of items"
             class="list-item blue-rotate"
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
    .list-items { display: flex; flex-direction: column; gap: 12px; }
    .list-item {
      padding: 18px 20px;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      gap: 14px;
      border-radius: 16px;
      background: linear-gradient(135deg, rgba(59, 130, 246, 0.05), rgba(59, 130, 246, 0.03));
      border: 1px solid #bfdbfe;
    }
    .blue-rotate:hover {
      background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(59, 130, 246, 0.1));
      box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
      transform: translateY(-2px) scale(1.00);
      border-color: #3b82f6;
    }
    .item-icon { font-size: 1.5999999999999999rem; flex-shrink: 0; color: #3b82f6; }
    .item-content { flex: 1; font-weight: 500; }
    .item-metadata { font-size: 0.875rem; opacity: 0.75; }
    .selected {
      background: linear-gradient(135deg, rgba(59, 130, 246, 0.2), rgba(59, 130, 246, 0.15));
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.4);
    }
    .skeleton-loader { display: flex; flex-direction: column; gap: 12px; }
    .skeleton-item {
      height: 70px;
      border-radius: 16px;
      background: linear-gradient(90deg, #dbeafe, #bfdbfe, #dbeafe);
      background-size: 200% 100%;
    }
    @keyframes rotate-glow {
      0% { background-position: -200% 0; opacity: 0.6; }
      50% { opacity: 1; }
      100% { background-position: 200% 0; opacity: 0.6; }
    }
    .rotate-glow { animation: rotate-glow 1.5s ease-in-out infinite; }
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
    primaryColor: '#3b82f6',
    secondaryColor: '#2563eb',
    backgroundColor: '#eff6ff',
    textColor: '#1e3a8a',
    borderColor: '#bfdbfe',
    hoverColor: '#dbeafe'
  };

  get appliedTheme(): ListTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
    return {
      backgroundColor: this.appliedTheme.backgroundColor,
      color: this.appliedTheme.textColor,
      padding: '16px',
      borderRadius: '14px'
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
