import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { trigger, transition, style, animate, query, stagger } from '@angular/animations';

interface ListItem {
  id: string | number;
  content: string;
  icon?: string;
  subtitle?: string;
  badge?: string;
  disabled?: boolean;
  metadata?: Record<string, unknown>;
}

interface GroupedList {
  [category: string]: ListItem[];
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-list',
  animations: [
    trigger('listAnimation', [
      transition('* => *', [
        query(':enter', [
          style({ opacity: 0, transform: 'translateY(-15px)' }),
          stagger(50, [
            animate('300ms ease-out', style({ opacity: 1, transform: 'translateY(0)' }))
          ])
        ], { optional: true })
      ])
    ])
  ],
  template: `
    <div class="list-container" [@listAnimation]="items.length">
      <div *ngIf="loading" class="skeleton-loader">
        <div *ngFor="let i of [1,2,3,4,5]" class="skeleton-item"></div>
      </div>

      <div *ngIf="!loading && groupBy" class="grouped-list">
        <div *ngFor="let group of groupedItems | keyvalue" class="list-group">
          <h3 class="group-header">{{ group.key }}</h3>
          <div class="list-items">
            <div *ngFor="let item of group.value; trackBy: trackByFn"
                 class="list-item"
                 [class.disabled]="item.disabled"
                 [class.selected]="isSelected(item)"
                 (click)="!item.disabled && onItemClick(item)">
              <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
              <div class="item-content">
                <span class="item-title">{{ item.content }}</span>
                <span *ngIf="item.subtitle" class="item-subtitle">{{ item.subtitle }}</span>
              </div>
              <span *ngIf="item.badge" class="item-badge">{{ item.badge }}</span>
            </div>
          </div>
        </div>
      </div>

      <div *ngIf="!loading && !groupBy" class="list-items">
        <div *ngFor="let item of items; trackBy: trackByFn"
             class="list-item"
             [class.disabled]="item.disabled"
             [class.selected]="isSelected(item)"
             (click)="!item.disabled && onItemClick(item)">
          <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
          <div class="item-content">
            <span class="item-title">{{ item.content }}</span>
            <span *ngIf="item.subtitle" class="item-subtitle">{{ item.subtitle }}</span>
          </div>
          <span *ngIf="item.badge" class="item-badge">{{ item.badge }}</span>
        </div>
      </div>

      <div *ngIf="!loading && items.length === 0" class="empty-state">
        <p>No items to display</p>
      </div>
    </div>
  `,
  styles: [`
    .list-container { width: 100%; }
    .list-items { display: flex; flex-direction: column; gap: 8px; }
    .list-item {
      padding: 14px 18px;
      cursor: pointer;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      gap: 12px;
      border-radius: 8px;
      background: #ffffff;
      border: 1px solid #e5e7eb;
    }
    .list-item:hover:not(.disabled) {
      background: #f9fafb;
      border-color: #3b82f6;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }
    .list-item.selected {
      background: #eff6ff;
      border-color: #3b82f6;
    }
    .list-item.disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }
    .item-icon { font-size: 1.25rem; flex-shrink: 0; color: #6b7280; }
    .item-content { flex: 1; display: flex; flex-direction: column; gap: 2px; }
    .item-title { font-weight: 500; color: #111827; }
    .item-subtitle { font-size: 0.875rem; color: #6b7280; }
    .item-badge {
      padding: 2px 8px;
      background: #3b82f6;
      color: white;
      border-radius: 12px;
      font-size: 0.75rem;
      font-weight: 600;
    }
    .grouped-list { display: flex; flex-direction: column; gap: 24px; }
    .list-group { display: flex; flex-direction: column; gap: 8px; }
    .group-header {
      font-size: 0.875rem;
      font-weight: 600;
      color: #6b7280;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin: 0;
      padding: 0 4px;
    }
    .skeleton-loader { display: flex; flex-direction: column; gap: 8px; }
    .skeleton-item {
      height: 58px;
      border-radius: 8px;
      background: linear-gradient(90deg, #f3f4f6 25%, #e5e7eb 50%, #f3f4f6 75%);
      background-size: 200% 100%;
      animation: loading 1.5s ease-in-out infinite;
    }
    @keyframes loading {
      0% { background-position: 200% 0; }
      100% { background-position: -200% 0; }
    }
    .empty-state {
      padding: 32px;
      text-align: center;
      color: #9ca3af;
    }
  `]
})
export class ListComponent implements OnInit {
  @Input() items: ListItem[] = [];
  @Input() selectable: boolean = false;
  @Input() multiSelect: boolean = false;
  @Input() loading: boolean = false;
  @Input() groupBy?: keyof ListItem;
  @Output() itemClicked = new EventEmitter<ListItem>();
  @Output() selectionChanged = new EventEmitter<ListItem[]>();

  selectedItems: Set<string | number> = new Set();
  groupedItems: GroupedList = {};

  ngOnInit() {
    if (this.groupBy) {
      this.updateGroupedItems();
    }
  }

  ngOnChanges() {
    if (this.groupBy) {
      this.updateGroupedItems();
    }
  }

  private updateGroupedItems() {
    this.groupedItems = this.items.reduce((acc, item) => {
      const key = String(item[this.groupBy!] || 'Other');
      if (!acc[key]) acc[key] = [];
      acc[key].push(item);
      return acc;
    }, {} as GroupedList);
  }

  trackByFn(index: number, item: ListItem): string | number {
    return item.id;
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

      this.selectionChanged.emit(
        Array.from(this.selectedItems)
          .map(id => this.items.find(i => i.id === id))
          .filter(Boolean) as ListItem[]
      );
    }
  }
}
