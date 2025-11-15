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
  <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item glow-pulse"></div>
  </div>
  <div *ngIf="!loading" class="list-items">
  <div *ngFor="let item of items"
  class="list-item amber-slide"
  [class.selected]="isSelected(item)"
  [ngStyle]="getItemStyles(item)"
  (click)="onItemClick(item)">
  <div class="item-glow"></div>
  <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
  <span class="item-content">{{ item.content }}</span>
  <span *ngIf="item.metadata" class="item-metadata">{{ item.metadata }}</span>
  </div>
  </div>
  </div>
  `,
  styles: [`
  .list-container { width: 100%; }
  .list-items { display: flex; flex-direction: column; gap: 10px; }
  .list-item {
  padding: 16px 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 14px;
  border-radius: 10px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(245, 158, 11, 0.1);
  }
  .item-glow {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(245, 158, 11, 0.3), transparent);
  transition: left 0.5s ease;
  }
  .amber-slide:hover .item-glow {
  left: 100%;
  }
  .amber-slide:hover {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(217, 119, 6, 0.12));
  box-shadow: 0 8px 20px rgba(245, 158, 11, 0.25), 0 0 0 2px rgba(245, 158, 11, 0.4);
  transform: translateX(5px);
  }
  .item-icon { font-size: 1.5rem; flex-shrink: 0; color: #f59e0b; z-index: 1; }
  .item-content { flex: 1; font-weight: 600; z-index: 1; }
  .item-metadata { font-size: 0.875rem; opacity: 0.7; z-index: 1; }
  .selected {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.2), rgba(217, 119, 6, 0.2));
  box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.5);
  }
  .skeleton-loader { display: flex; flex-direction: column; gap: 10px; }
  .skeleton-item {
  height: 62px;
  border-radius: 10px;
  background: linear-gradient(90deg, #fef3c7, #fde68a, #fef3c7);
  background-size: 200% 100%;
  }
  @keyframes glow-pulse {
  0%, 100% { opacity: 0.5; box-shadow: 0 0 10px rgba(245, 158, 11, 0.3); }
  50% { opacity: 1; box-shadow: 0 0 20px rgba(245, 158, 11, 0.6); }
  }
  .glow-pulse { animation: glow-pulse 2s ease-in-out infinite; }
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
  primaryColor: '#f59e0b',
  secondaryColor: '#d97706',
  backgroundColor: '#fffbeb',
  backdropFilter: 'blur(10px)',
  textColor: '#78350f',
  borderColor: '#fde68a',
  hoverColor: '#fef3c7'
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
  backgroundColor: this.appliedTheme.hoverColor,
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
