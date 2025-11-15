import { Component, Input, Output, EventEmitter } from '@angular/core';
interface TableColumn {
  key: string;
  label: string;
  sortable?: boolean;
  width?: string;
}
interface TableTheme {
  primaryColor: string;
  backgroundColor: string;
  headerColor: string;
  textColor: string;
  borderColor: string;
  hoverColor: string;
}
@Component({
  selector: 'app-table',
  template: `
  <div class="table-container" [ngStyle]="containerStyles">
  <table class="table" [ngStyle]="tableStyles">
  <thead class="table-header" [ngStyle]="headerStyles">
  <tr>
  <th *ngFor="let column of columns"
  [ngStyle]="getColumnStyles(column)"
  [class.sortable]="column.sortable"
  (click)="handleSort(column)">
  <div class="header-content">
  <span>{{ column.label }}</span>
  <span *ngIf="column.sortable && sortColumn === column.key" class="sort-icon">
  {{ sortDirection === 'asc' ? '↑' : '↓' }}
  </span>
  </div>
  </th>
  </tr>
  </thead>
  <tbody class="table-body">
  <tr *ngFor="let row of data; let i = index"
  [ngStyle]="rowStyles"
  [class.striped]="striped && i % 2 === 1"
  (click)="handleRowClick(row)">
  <td *ngFor="let column of columns" [ngStyle]="cellStyles">
  {{ row[column.key] }}
  </td>
  </tr>
  <tr *ngIf="!data || data.length === 0">
  <td [attr.colspan]="columns.length" [ngStyle]="emptyCellStyles">
  {{ emptyMessage }}
  </td>
  </tr>
  </tbody>
  </table>
  </div>
  `,
  styles: [`
  .table-container {
  overflow-x: auto;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  .table {
  width: 100%;
  border-collapse: collapse;
  }
  .table-header th {
  text-align: left;
  font-weight: 700;
  font-size: 14px;
  padding: 16px;
  border-bottom: 2px solid;
  }
  .table-header th.sortable {
  cursor: pointer;
  user-select: none;
  transition: background-color 0.2s;
  }
  .table-header th.sortable:hover {
  opacity: 0.8;
  }
  .header-content {
  display: flex;
  align-items: center;
  gap: 8px;
  }
  .sort-icon {
  font-size: 12px;
  }
  .table-body tr {
  transition: background-color 0.2s;
  cursor: pointer;
  }
  .table-body tr.striped {
  background-color: rgba(0, 0, 0, 0.02);
  }
  .table-body td {
  padding: 14px 16px;
  border-bottom: 1px solid;
  font-size: 14px;
  }
  @keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
  }
  @keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
  }
  @keyframes scaleIn {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
  }
  `]
})
export class TableComponent {
  @Input() theme: Partial<TableTheme> = {};
  @Input() columns: TableColumn[] = [];
  @Input() data: any[] = [];
  @Input() striped = true;
  @Input() hoverable = true;
  @Input() emptyMessage = 'No data available';
  @Output() rowClicked = new EventEmitter<any>();
  @Output() sorted = new EventEmitter<{column: string, direction: 'asc' | 'desc'}>();
  sortColumn: string | null = null;
  sortDirection: 'asc' | 'desc' = 'asc';
  private defaultTheme: TableTheme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  headerColor: '#f8fafc',
  textColor: '#0f172a',
  borderColor: '#e2e8f0',
  hoverColor: '#f1f5f9'
  };
  get appliedTheme(): TableTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get containerStyles() {
  const t = this.appliedTheme;
  return {
  border: `1px solid ${t.borderColor}`
  };
  }
  get tableStyles() {
  const t = this.appliedTheme;
  return {
  backgroundColor: t.backgroundColor,
  color: t.textColor
  };
  }
  get headerStyles() {
  const t = this.appliedTheme;
  return {
  backgroundColor: t.headerColor,
  borderColor: t.primaryColor
  };
  }
  getColumnStyles(column: TableColumn) {
  return {
  width: column.width || 'auto'
  };
  }
  get rowStyles() {
  const t = this.appliedTheme;
  return this.hoverable ? {
  ':hover': {
  backgroundColor: t.hoverColor
  }
  } : {};
  }
  get cellStyles() {
  const t = this.appliedTheme;
  return {
  borderColor: t.borderColor
  };
  }
  get emptyCellStyles() {
  return {
  textAlign: 'center',
  padding: '32px',
  opacity: 0.6,
  fontStyle: 'italic'
  };
  }
  handleSort(column: TableColumn): void {
  if (!column.sortable) return;
  if (this.sortColumn === column.key) {
  this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
  } else {
  this.sortColumn = column.key;
  this.sortDirection = 'asc';
  }
  this.sorted.emit({ column: column.key, direction: this.sortDirection });
  }
  handleRowClick(row: any): void {
  this.rowClicked.emit(row);
  }
}
