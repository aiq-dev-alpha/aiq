import { Component, Input, Output, EventEmitter } from '@angular/core';

interface TableTheme {
  background: string;
  headerBackground: string;
  headerText: string;
  rowText: string;
  border: string;
  hoverBackground: string;
  selectedBackground: string;
}

interface TableColumn {
  key: string;
  label: string;
  sortable?: boolean;
  width?: string;
  align?: 'left' | 'center' | 'right';
  format?: (value: any) => string;
}

interface SortConfig {
  column: string;
  direction: 'asc' | 'desc' | null;
}

type TableVariant = 'default' | 'striped' | 'bordered' | 'borderless' | 'compact';
type TableDensity = 'compact' | 'normal' | 'comfortable';

@Component({
  selector: 'app-table',
  template: `
    <div class="table-wrapper" [ngStyle]="wrapperStyles">
      <table [ngStyle]="tableStyles" [ngClass]="tableClasses" class="data-table">
        <thead [ngStyle]="headerStyles">
          <tr>
            <th *ngIf="selectable" class="select-column">
              <input type="checkbox" [checked]="allSelected" (change)="toggleSelectAll()" />
            </th>
            <th *ngFor="let column of columns"
                [ngStyle]="columnHeaderStyles(column)"
                [class.sortable]="column.sortable"
                (click)="column.sortable ? onSort(column.key) : null">
              <div class="header-content">
                <span>{{ column.label }}</span>
                <span *ngIf="column.sortable && sortConfig.column === column.key" class="sort-icon">
                  {{ sortConfig.direction === 'asc' ? '↑' : '↓' }}
                </span>
              </div>
            </th>
            <th *ngIf="hasActions" class="actions-column">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr *ngFor="let row of sortedData; let i = index"
              [ngStyle]="rowStyles(row, i)"
              [class.selected]="isSelected(row)"
              (click)="onRowClick(row)">
            <td *ngIf="selectable" class="select-column">
              <input type="checkbox" [checked]="isSelected(row)" (change)="toggleSelect(row)" (click)="$event.stopPropagation()" />
            </td>
            <td *ngFor="let column of columns" [ngStyle]="cellStyles(column)">
              {{ column.format ? column.format(row[column.key]) : row[column.key] }}
            </td>
            <td *ngIf="hasActions" class="actions-column">
              <ng-content select="[tableActions]" [ngTemplateOutlet]="actionsTemplate" [ngTemplateOutletContext]="{$implicit: row}"></ng-content>
            </td>
          </tr>
        </tbody>
      </table>

      <div *ngIf="!data || data.length === 0" class="empty-state" [ngStyle]="emptyStyles">
        <ng-content select="[emptyState]"></ng-content>
        <p *ngIf="!hasEmptyState">No data available</p>
      </div>
    </div>
  `,
  styles: [`
    .table-wrapper {
      width: 100%;
      overflow-x: auto;
      border-radius: 8px;
    }
    .data-table {
      width: 100%;
      border-collapse: collapse;
      font-family: system-ui, -apple-system, sans-serif;
    }
    .data-table thead {
      position: sticky;
      top: 0;
      z-index: 10;
    }
    .header-content {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      justify-content: space-between;
    }
    .sortable {
      cursor: pointer;
      user-select: none;
    }
    .sortable:hover {
      opacity: 0.8;
    }
    .sort-icon {
      font-size: 0.875rem;
    }
    .select-column {
      width: 40px;
      text-align: center;
    }
    .actions-column {
      width: 100px;
      text-align: center;
    }
    .empty-state {
      padding: 3rem;
      text-align: center;
      color: #6b7280;
    }
    .striped tbody tr:nth-child(even) {
      background: rgba(0, 0, 0, 0.02);
    }
    .bordered {
      border: 1px solid;
    }
    .bordered th,
    .bordered td {
      border: 1px solid;
    }
    .compact th,
    .compact td {
      padding: 0.5rem !important;
    }
  `]
})
export class TableComponent {
  @Input() variant: TableVariant = 'default';
  @Input() density: TableDensity = 'normal';
  @Input() theme: Partial<TableTheme> = {};
  @Input() columns: TableColumn[] = [];
  @Input() data: any[] = [];
  @Input() selectable = false;
  @Input() hoverable = true;
  @Input() hasActions = false;
  @Input() hasEmptyState = false;
  @Output() rowClick = new EventEmitter<any>();
  @Output() sort = new EventEmitter<SortConfig>();
  @Output() selectionChange = new EventEmitter<any[]>();

  selectedRows: any[] = [];
  sortConfig: SortConfig = { column: '', direction: null };

  private defaultTheme: TableTheme = {
    background: '#ffffff',
    headerBackground: '#f9fafb',
    headerText: '#111827',
    rowText: '#374151',
    border: '#e5e7eb',
    hoverBackground: '#f3f4f6',
    selectedBackground: '#dbeafe'
  };

  get appliedTheme(): TableTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get allSelected(): boolean {
    return this.data.length > 0 && this.selectedRows.length === this.data.length;
  }

  get tableClasses(): string[] {
    return [
      this.variant,
      `density-${this.density}`,
      this.hoverable ? 'hoverable' : ''
    ].filter(Boolean);
  }

  get sortedData(): any[] {
    if (!this.sortConfig.column || !this.sortConfig.direction) {
      return this.data;
    }

    return [...this.data].sort((a, b) => {
      const aVal = a[this.sortConfig.column];
      const bVal = b[this.sortConfig.column];
      const modifier = this.sortConfig.direction === 'asc' ? 1 : -1;

      if (aVal < bVal) return -1 * modifier;
      if (aVal > bVal) return 1 * modifier;
      return 0;
    });
  }

  get wrapperStyles(): Record<string, string> {
    const t = this.appliedTheme;
    return {
      background: t.background,
      borderColor: this.variant === 'bordered' ? t.border : 'transparent'
    };
  }

  get tableStyles(): Record<string, string> {
    return {
      fontSize: '0.875rem'
    };
  }

  get headerStyles(): Record<string, string> {
    const t = this.appliedTheme;
    return {
      background: t.headerBackground,
      color: t.headerText,
      borderBottom: `2px solid ${t.border}`
    };
  }

  columnHeaderStyles(column: TableColumn): Record<string, string> {
    const densityMap = {
      compact: '0.5rem',
      normal: '0.75rem',
      comfortable: '1rem'
    };

    return {
      padding: densityMap[this.density],
      textAlign: column.align || 'left',
      fontWeight: '600',
      fontSize: '0.8125rem',
      textTransform: 'uppercase',
      letterSpacing: '0.05em',
      width: column.width || 'auto'
    };
  }

  rowStyles(row: any, index: number): Record<string, string> {
    const t = this.appliedTheme;
    const densityMap = {
      compact: '0.5rem',
      normal: '0.75rem',
      comfortable: '1rem'
    };

    return {
      background: this.isSelected(row) ? t.selectedBackground : 'transparent',
      color: t.rowText,
      borderBottom: `1px solid ${t.border}`,
      cursor: this.hoverable ? 'pointer' : 'default',
      transition: 'background 0.15s ease'
    };
  }

  cellStyles(column: TableColumn): Record<string, string> {
    const densityMap = {
      compact: '0.5rem',
      normal: '0.75rem',
      comfortable: '1rem'
    };

    return {
      padding: densityMap[this.density],
      textAlign: column.align || 'left'
    };
  }

  get emptyStyles(): Record<string, string> {
    return {
      padding: '3rem',
      textAlign: 'center'
    };
  }

  isSelected(row: any): boolean {
    return this.selectedRows.includes(row);
  }

  toggleSelect(row: any): void {
    const index = this.selectedRows.indexOf(row);
    if (index > -1) {
      this.selectedRows.splice(index, 1);
    } else {
      this.selectedRows.push(row);
    }
    this.selectionChange.emit(this.selectedRows);
  }

  toggleSelectAll(): void {
    if (this.allSelected) {
      this.selectedRows = [];
    } else {
      this.selectedRows = [...this.data];
    }
    this.selectionChange.emit(this.selectedRows);
  }

  onSort(column: string): void {
    if (this.sortConfig.column === column) {
      this.sortConfig.direction = this.sortConfig.direction === 'asc' ? 'desc' : this.sortConfig.direction === 'desc' ? null : 'asc';
    } else {
      this.sortConfig = { column, direction: 'asc' };
    }
    this.sort.emit(this.sortConfig);
  }

  onRowClick(row: any): void {
    this.rowClick.emit(row);
  }
}
