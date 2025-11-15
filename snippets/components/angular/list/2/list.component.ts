import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
interface ListItem {
  id: string | number;
  content: string;
  icon?: string;
  metadata?: unknown;
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
  standalone: true,
  imports: [CommonModule],
  selector: 'app-list',
  template: `
  <div class="list-container" [ngStyle]="containerStyles">
  <div *ngIf="loading" class="skeleton-loader">
  <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item shimmer"></div>
  </div>
  <div *ngIf="!loading" class="list-items">
  <div *ngFor="let item of items"
  class="list-item emerald-glow"
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
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 16px;
  border-radius: 16px;
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.05), rgba(5, 150, 105, 0.05));
  border-left: 5px solid transparent;
  }
  .emerald-glow:hover {
  border-left-color: #10b981;
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(5, 150, 105, 0.15));
  box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3), inset 0 0 20px rgba(16, 185, 129, 0.1);
  transform: scale(1.02);
  }
  .item-icon { font-size: 1.75rem; flex-shrink: 0; filter: drop-shadow(0 2px 4px rgba(16, 185, 129, 0.3)); }
  .item-content { flex: 1; font-weight: 600; font-size: 1.1rem; }
  .item-metadata { font-size: 0.9rem; opacity: 0.8; font-weight: 500; }
  .selected {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.25), rgba(5, 150, 105, 0.25));
  border-left-color: #10b981;
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.2);
  }
  .skeleton-loader { display: flex; flex-direction: column; gap: 12px; }
  .skeleton-item {
  height: 70px;
  border-radius: 16px;
  background: linear-gradient(90deg, #d1fae5 0%, #a7f3d0 50%, #d1fae5 100%);
  background-size: 200% 100%;
  }
  @keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
  }
  .shimmer { animation: shimmer 2s linear infinite; }
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
  primaryColor: '#10b981',
  secondaryColor: '#059669',
  backgroundColor: '#f0fdf4',
  backdropFilter: 'blur(10px)',
  textColor: '#064e3b',
  borderColor: '#d1fae5',
  hoverColor: '#a7f3d0'
  };
  get appliedTheme(): ListTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get containerStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor,
  color: this.appliedTheme.textColor,
  padding: '20px',
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
