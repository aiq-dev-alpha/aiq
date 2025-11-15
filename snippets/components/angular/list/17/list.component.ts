// Kanban Board Style List
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-list',
  template: `<div class="kanban-list"><div class="kanban-column" *ngFor="let column of columns"><div class="column-header">{{ column.title }}</div><div class="column-items"><div class="kanban-item" *ngFor="let item of column.items"><ng-content></ng-content></div></div></div></div>`,
  styles: [`
  .kanban-list { display: flex; gap: 16px; overflow-x: auto; padding: 16px; }
  .kanban-column { flex: 0 0 300px; background: #f3f4f6; border-radius: 8px; padding: 12px; }
  .column-header { font-weight: 600; padding: 8px 12px; margin-bottom: 12px; background: white; border-radius: 6px; }
  .column-items { display: flex; flex-direction: column; gap: 8px; }
  .kanban-item { background: white; border-radius: 6px; padding: 12px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); cursor: move; transition: transform 0.2s; }
  .kanban-item:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15); }
  `]
})
export class ListComponent {
  columns = [
  { title: 'To Do', items: [1, 2, 3] },
  { title: 'In Progress', items: [4, 5] },
  { title: 'Done', items: [6] }
  ];
}