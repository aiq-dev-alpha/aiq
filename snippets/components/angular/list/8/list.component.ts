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
  <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item spin-fade"></div>
  </div>
  <div *ngIf="!loading" class="list-items">
  <div *ngFor="let item of items"
  class="list-item pink-pulse"
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
  padding: 16px 22px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 12px;
  border-radius: 10px;
  background: linear-gradient(135deg, rgba(236, 72, 153, 0.05), rgba(236, 72, 153, 0.03));
  border: 1px solid #f9a8d4;
  }
  .pink-pulse:hover {
  background: linear-gradient(135deg, rgba(236, 72, 153, 0.15), rgba(236, 72, 153, 0.1));
  box-shadow: 0 16px 28px rgba(236, 72, 153, 0.3);
  transform: translateY(-4px) scale(1.02);
  border-color: #ec4899;
  }
  .item-icon { font-size: 1.4rem; flex-shrink: 0; color: #ec4899; }
  .item-content { flex: 1; font-weight: 700; }
  .item-metadata { font-size: 0.875rem; opacity: 0.75; }
  .selected {
  background: linear-gradient(135deg, rgba(236, 72, 153, 0.2), rgba(236, 72, 153, 0.15));
  border-color: #ec4899;
  box-shadow: 0 0 0 3px rgba(236, 72, 153, 0.4);
  }
  .skeleton-loader { display: flex; flex-direction: column; gap: 12px; }
  .skeleton-item {
  height: 68px;
  border-radius: 10px;
  background: linear-gradient(90deg, #fce7f3, #f9a8d4, #fce7f3);
  background-size: 200% 100%;
  }
  @keyframes spin-fade {
  0% { background-position: -200% 0; opacity: 0.6; }
  50% { opacity: 1; }
  100% { background-position: 200% 0; opacity: 0.6; }
  }
  .spin-fade { animation: spin-fade 1.8s ease-in-out infinite; }
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
  primaryColor: '#ec4899',
  secondaryColor: '#db2777',
  backgroundColor: '#fdf2f8',
  backdropFilter: 'blur(10px)',
  textColor: '#831843',
  borderColor: '#f9a8d4',
  hoverColor: '#fce7f3'
  };
  get appliedTheme(): ListTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get containerStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor,
  color: this.appliedTheme.textColor,
  padding: '19px',
  borderRadius: '22px'
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
