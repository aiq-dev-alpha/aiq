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
        <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item shake-glow"></div>
      </div>
      <div *ngIf="!loading" class="list-items">
        <div *ngFor="let item of items"
             class="list-item red-shake"
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
    .list-items { display: flex; flex-direction: column; gap: 15px; }
    .list-item {
      padding: 17px 21px;
      cursor: pointer;
      transition: all 0.4s ease;
      display: flex;
      align-items: center;
      gap: 13px;
      border-radius: 15px;
      background: linear-gradient(135deg, rgba(239, 68, 68, 0.05), rgba(239, 68, 68, 0.03));
      border: 2px solid #fecaca;
    }
    .red-shake:hover {
      background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(239, 68, 68, 0.1));
      box-shadow: 0 11px 33px rgba(239, 68, 68, 0.3);
      transform: translateY(-3px) scale(1.01);
      border-color: #ef4444;
    }
    .item-icon { font-size: 1.5rem; flex-shrink: 0; color: #ef4444; }
    .item-content { flex: 1; font-weight: 600; }
    .item-metadata { font-size: 0.875rem; opacity: 0.75; }
    .selected {
      background: linear-gradient(135deg, rgba(239, 68, 68, 0.2), rgba(239, 68, 68, 0.15));
      border-color: #ef4444;
      box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.4);
    }
    .skeleton-loader { display: flex; flex-direction: column; gap: 12px; }
    .skeleton-item {
      height: 73px;
      border-radius: 15px;
      background: linear-gradient(90deg, #fee2e2, #fecaca, #fee2e2);
      background-size: 200% 100%;
    }
    @keyframes shake-glow {
      0% { background-position: -200% 0; opacity: 0.6; }
      50% { opacity: 1; }
      100% { background-position: 200% 0; opacity: 0.6; }
    }
    .shake-glow { animation: shake-glow 1.8s ease-in-out infinite; }
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
    primaryColor: '#ef4444',
    secondaryColor: '#dc2626',
    backgroundColor: '#fef2f2',
    textColor: '#7f1d1d',
    borderColor: '#fecaca',
    hoverColor: '#fee2e2'
  };

  get appliedTheme(): ListTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
    return {
      backgroundColor: this.appliedTheme.backgroundColor,
      color: this.appliedTheme.textColor,
      padding: '19px',
      borderRadius: '17px'
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
