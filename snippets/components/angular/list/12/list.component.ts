import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ListItem {
  id: string;
  label: string;
  selected?: boolean;
}

@Component({
  selector: 'app-list',
  template: `
    <ul class="list-container">
      <li *ngFor="let item of items"
          [class.selected]="item.selected"
          (click)="onItemClick(item)"
          class="list-item">
        <span class="item-icon">{{ item.selected ? '✓' : '○' }}</span>
        <span class="item-label">{{ item.label }}</span>
      </li>
    </ul>
  `,
  styles: [`
    .list-container {
      list-style: none;
      padding: 0;
      margin: 0;
      max-width: 400px;
    }
    .list-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      cursor: pointer;
      border-bottom: 1px solid #e5e7eb;
      transition: background-color 200ms;
    }
    .list-item:hover {
      background-color: #f3f4f6;
    }
    .list-item.selected {
      background-color: #dbeafe;
    }
    .item-icon {
      color: #3b82f6;
      font-size: 18px;
      font-weight: bold;
    }
    .item-label {
      flex: 1;
      color: #1f2937;
      font-size: 16px;
    }
  `]
})
export class ListComponent {
  @Input() items: ListItem[] = [];
  @Output() itemClick = new EventEmitter<ListItem>();

  onItemClick(item: ListItem): void {
    this.itemClick.emit(item);
  }
}