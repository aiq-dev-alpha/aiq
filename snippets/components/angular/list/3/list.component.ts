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
  <div *ngFor="let item of [1,2,3,4,5]" class="skeleton-item wave-animation"></div>
  </div>
  <div *ngIf="!loading" class="list-items">
  <div *ngFor="let item of items; let i = index"
  class="list-item purple-ripple"
  [class.selected]="isSelected(item)"
  [class.striped]="i % 2 === 0"
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
  .list-items { display: flex; flex-direction: column; }
  .list-item {
  padding: 18px 24px;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  display: flex;
  align-items: center;
  gap: 14px;
  border-bottom: 2px solid rgba(139, 92, 246, 0.1);
  position: relative;
  }
  .list-item.striped {
  background: linear-gradient(90deg, rgba(139, 92, 246, 0.03), transparent);
  }
  .purple-ripple:hover {
  background: linear-gradient(90deg, rgba(139, 92, 246, 0.15), rgba(124, 58, 237, 0.1));
  transform: translateY(-3px);
  box-shadow: 0 15px 35px rgba(139, 92, 246, 0.25);
  border-bottom-color: #8b5cf6;
  }
  .purple-ripple:hover::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at center, rgba(139, 92, 246, 0.3), transparent);
  opacity: 0;
  animation: ripple 0.6s ease-out;
  }
  @keyframes ripple {
  to { opacity: 1; transform: scale(1.5); }
  }
  .item-icon { font-size: 1.6rem; flex-shrink: 0; color: #8b5cf6; }
  .item-content { flex: 1; font-weight: 600; }
  .item-metadata { font-size: 0.85rem; opacity: 0.75; }
  .selected {
  background: linear-gradient(90deg, rgba(139, 92, 246, 0.2), rgba(124, 58, 237, 0.15));
  border-bottom-color: #8b5cf6;
  box-shadow: inset 5px 0 0 #8b5cf6;
  }
  .skeleton-loader { display: flex; flex-direction: column; }
  .skeleton-item {
  height: 65px;
  background: linear-gradient(110deg, #f3e8ff 8%, #e9d5ff 18%, #f3e8ff 33%);
  border-bottom: 2px solid rgba(139, 92, 246, 0.1);
  }
  @keyframes wave-animation {
  0% { background-position: -468px 0; }
  100% { background-position: 468px 0; }
  }
  .wave-animation {
  animation: wave-animation 1.5s linear infinite;
  background-size: 800px 104px;
  }
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
  primaryColor: '#8b5cf6',
  secondaryColor: '#7c3aed',
  backgroundColor: '#faf5ff',
  backdropFilter: 'blur(10px)',
  textColor: '#581c87',
  borderColor: '#e9d5ff',
  hoverColor: '#f3e8ff'
  };
  get appliedTheme(): ListTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get containerStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor,
  color: this.appliedTheme.textColor,
  padding: '0',
  borderRadius: '12px',
  overflow: 'hidden'
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
