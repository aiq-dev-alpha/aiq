import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
interface ListItem {
  id: string;
  text: string;
  icon?: string;
  badge?: string;
}
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-list',
  template: `
  <div class="compact-list">
  <div *ngFor="let item of items; let i = index"
  class="list-row"
  [class.striped]="striped && i % 2 === 1">
  <span *ngIf="item.icon" class="icon">{{ item.icon }}</span>
  <span class="text">{{ item.text }}</span>
  <span *ngIf="item.badge" class="badge">{{ item.badge }}</span>
  </div>
  </div>
  `,
  styles: [`
  .compact-list {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  overflow: hidden;
  max-width: 500px;
  }
  .list-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  border-bottom: 1px solid #f3f4f6;
  }
  .list-row:last-child {
  border-bottom: none;
  }
  .list-row.striped {
  background-color: #f9fafb;
  }
  .icon {
  width: 24px;
  text-align: center;
  font-size: 18px;
  }
  .text {
  flex: 1;
  color: #1f2937;
  font-size: 14px;
  }
  .badge {
  padding: 2px 8px;
  background-color: #3b82f6;
  color: white;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  }
  `]
})
export class ListComponent {
  @Input() items: ListItem[] = [];
  @Input() striped = false;
}
