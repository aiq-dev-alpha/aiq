import { Component, Input, Output, EventEmitter } from '@angular/core';

interface TableTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  headerBgColor: string;
  hoverColor: string;
}

interface TableColumn {
  key: string;
  label: string;
  sortable?: boolean;
  width?: string;
}

interface TableRow {
  [key: string]: any;
  id: string | number;
}

@Component({
  selector: 'app-table',
  template: `
    <div [ngStyle]="containerStyles" class="table-container">
      <!-- Search Bar -->
      <div *ngIf="searchable" [ngStyle]="searchBarStyles">
        <input
          type="text"
          [ngStyle]="searchInputStyles"
          [(ngModel)]="searchTerm"
          (input)="onSearch()"
          placeholder="Search..."
          aria-label="Search table">
      </div>

      <!-- Loading State -->
      <div *ngIf="loading" [ngStyle]="loadingStyles">
        <div [ngStyle]="spinnerStyles"></div>
        <p>Loading data...</p>
      </div>

      <!-- Table -->
      <div *ngIf="!loading" [ngStyle]="tableWrapperStyles">
        <table [ngStyle]="tableStyles">
          <thead [ngStyle]="theadStyles">
            <tr>
              <th *ngIf="selectable" [ngStyle]="thStyles">
                <input
                  type="checkbox"
                  [checked]="allSelected"
                  (change)="toggleSelectAll()"
                  aria-label="Select all rows">
              </th>
              <th *ngFor="let col of columns"
                  [ngStyle]="thStyles"
                  [style.width]="col.width"
                  scope="col"
                  [attr.aria-sort]="getSortDirection(col.key)">
                <div [ngStyle]="thContentStyles">
                  <span>{{ col.label }}</span>
                  <button *ngIf="col.sortable"
                          (click)="onSort(col.key)"
                          [ngStyle]="sortButtonStyles"
                          [attr.aria-label]="'Sort by ' + col.label">
                    {{ getSortIcon(col.key) }}
                  </button>
                </div>
              </th>
              <th *ngIf="hasActions" [ngStyle]="thStyles" scope="col">Actions</th>
            </tr>
          </thead>
          <tbody>
            <!-- Empty State -->
            <tr *ngIf="filteredData.length === 0">
              <td [attr.colspan]="totalColumns" [ngStyle]="emptyStateStyles">
                <div [ngStyle]="emptyStateContentStyles">
                  <p>No data available</p>
                </div>
              </td>
            </tr>

            <!-- Data Rows -->
            <ng-container *ngFor="let row of paginatedData; let i = index">
              <tr [ngStyle]="getTrStyles(row)"
                  (click)="onRowClick(row)"
                  [attr.aria-selected]="isSelected(row.id)">
                <td *ngIf="selectable" [ngStyle]="tdStyles">
                  <input
                    type="checkbox"
                    [checked]="isSelected(row.id)"
                    (change)="toggleSelect(row.id)"
                    (click)="$event.stopPropagation()"
                    [attr.aria-label]="'Select row ' + (i + 1)">
                </td>
                <td *ngFor="let col of columns" [ngStyle]="tdStyles">
                  {{ row[col.key] }}
                </td>
                <td *ngIf="hasActions" [ngStyle]="tdStyles">
                  <div [ngStyle]="actionButtonGroupStyles">
                    <button [ngStyle]="actionButtonStyles" (click)="onEdit(row); $event.stopPropagation()">Edit</button>
                    <button [ngStyle]="deleteButtonStyles" (click)="onDelete(row); $event.stopPropagation()">Delete</button>
                  </div>
                </td>
              </tr>
              <tr *ngIf="expandable && expandedRows.has(row.id)" [ngStyle]="expandedRowStyles">
                <td [attr.colspan]="totalColumns" [ngStyle]="expandedContentStyles">
                  <ng-content></ng-content>
                </td>
              </tr>
            </ng-container>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div *ngIf="paginate && filteredData.length > 0" [ngStyle]="paginationStyles">
        <div [ngStyle]="paginationInfoStyles">
          Showing {{ startIndex + 1 }}-{{ endIndex }} of {{ filteredData.length }}
        </div>
        <div [ngStyle]="paginationButtonGroupStyles">
          <button [ngStyle]="paginationButtonStyles"
                  (click)="previousPage()"
                  [disabled]="currentPage === 1">
            Previous
          </button>
          <span [ngStyle]="pageNumberStyles">Page {{ currentPage }} of {{ totalPages }}</span>
          <button [ngStyle]="paginationButtonStyles"
                  (click)="nextPage()"
                  [disabled]="currentPage === totalPages">
            Next
          </button>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .table-container { width: 100%; }
  
    
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
  @Input() data: TableRow[] = [];
  @Input() selectable: boolean = false;
  @Input() searchable: boolean = true;
  @Input() paginate: boolean = true;
  @Input() pageSize: number = 10;
  @Input() striped: boolean = true;
  @Input() bordered: boolean = true;
  @Input() size: 'compact' | 'comfortable' | 'spacious' = 'comfortable';
  @Input() stickyHeader: boolean = true;
  @Input() expandable: boolean = false;
  @Input() hasActions: boolean = true;
  @Input() loading: boolean = false;

  @Output() rowClick = new EventEmitter<TableRow>();
  @Output() edit = new EventEmitter<TableRow>();
  @Output() delete = new EventEmitter<TableRow>();
  @Output() selectionChange = new EventEmitter<(string | number)[]>();

  searchTerm: string = '';
  sortKey: string = '';
  sortDirection: 'asc' | 'desc' | null = null;
  currentPage: number = 1;
  selectedRows: Set<string | number> = new Set();
  expandedRows: Set<string | number> = new Set();

  private defaultTheme: TableTheme = {
    primaryColor: '#2563eb',
    secondaryColor: '#3b82f6',
    backgroundColor: '#ffffff',
        backdropFilter: 'blur(10px)',
    textColor: '#1f2937',
    borderColor: '#e5e7eb',
    headerBgColor: '#f3f4f6',
    hoverColor: '#eff6ff'
  };

  get appliedTheme(): TableTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get filteredData(): TableRow[] {
    let result = [...this.data];

    if (this.searchTerm) {
      result = result.filter(row =>
        Object.values(row).some(val =>
          String(val).toLowerCase().includes(this.searchTerm.toLowerCase())
        )
      );
    }

    if (this.sortKey && this.sortDirection) {
      result.sort((a, b) => {
        const aVal = a[this.sortKey];
        const bVal = b[this.sortKey];
        const modifier = this.sortDirection === 'asc' ? 1 : -1;
        return aVal > bVal ? modifier : aVal < bVal ? -modifier : 0;
      });
    }

    return result;
  }

  get paginatedData(): TableRow[] {
    if (!this.paginate) return this.filteredData;
    const start = (this.currentPage - 1) * this.pageSize;
    return this.filteredData.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    return Math.ceil(this.filteredData.length / this.pageSize);
  }

  get startIndex(): number {
    return (this.currentPage - 1) * this.pageSize;
  }

  get endIndex(): number {
    return Math.min(this.startIndex + this.pageSize, this.filteredData.length);
  }

  get allSelected(): boolean {
    return this.paginatedData.length > 0 &&
           this.paginatedData.every(row => this.selectedRows.has(row.id));
  }

  get totalColumns(): number {
    return this.columns.length + (this.selectable ? 1 : 0) + (this.hasActions ? 1 : 0);
  }

  get containerStyles() {
    return {
      width: '100%',
      backgroundColor: this.appliedTheme.backgroundColor,
      borderRadius: '8px',
      boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
      overflow: 'hidden'
    };
  }

  get searchBarStyles() {
    return {
      padding: '16px',
      borderBottom: `1px solid ${this.appliedTheme.borderColor}`
    };
  }

  get searchInputStyles() {
    return {
      width: '100%',
      padding: '8px 12px',
      border: `1px solid ${this.appliedTheme.borderColor}`,
      borderRadius: '6px',
      fontSize: '14px',
      outline: 'none'
    };
  }

  get tableWrapperStyles() {
    return {
      overflowX: 'auto',
      maxHeight: this.stickyHeader ? '600px' : 'none',
      overflowY: this.stickyHeader ? 'auto' : 'visible'
    };
  }

  get tableStyles() {
    return {
      width: '100%',
      borderCollapse: 'collapse' as const,
      fontSize: this.size === 'compact' ? '13px' : this.size === 'comfortable' ? '14px' : '16px'
    };
  }

  get theadStyles() {
    return {
      backgroundColor: this.appliedTheme.headerBgColor,
      position: this.stickyHeader ? 'sticky' as const : 'static' as const,
      top: '0',
      zIndex: '10'
    };
  }

  get thStyles() {
    const padding = this.size === 'compact' ? '8px 12px' :
                   this.size === 'comfortable' ? '12px 16px' : '16px 20px';
    return {
      padding,
      textAlign: 'left' as const,
      fontWeight: '600',
      color: this.appliedTheme.textColor,
      borderBottom: `2px solid ${this.appliedTheme.borderColor}`,
      borderRight: this.bordered ? `1px solid ${this.appliedTheme.borderColor}` : 'none'
    };
  }

  get thContentStyles() {
    return {
      display: 'flex',
      alignItems: 'center',
      gap: '8px'
    };
  }

  get sortButtonStyles() {
    return {
      background: 'none',
      border: 'none',
      cursor: 'pointer',
      fontSize: '12px',
      color: this.appliedTheme.primaryColor,
      padding: '2px 4px'
    };
  }

  getTrStyles(row: TableRow) {
    const isRowSelected = this.selectedRows.has(row.id);
    const padding = this.size === 'compact' ? '8px 12px' :
                   this.size === 'comfortable' ? '12px 16px' : '16px 20px';

    return {
      backgroundColor: isRowSelected ? this.appliedTheme.hoverColor : 'transparent',
      cursor: 'pointer',
      transition: 'background-color 0.2s',
      ':hover': {
        backgroundColor: this.appliedTheme.hoverColor
      }
    };
  }

  get tdStyles() {
    const padding = this.size === 'compact' ? '8px 12px' :
                   this.size === 'comfortable' ? '12px 16px' : '16px 20px';
    return {
      padding,
      borderBottom: `1px solid ${this.appliedTheme.borderColor}`,
      borderRight: this.bordered ? `1px solid ${this.appliedTheme.borderColor}` : 'none',
      color: this.appliedTheme.textColor
    };
  }

  get emptyStateStyles() {
    return {
      padding: '48px 16px',
      textAlign: 'center' as const,
      color: '#9ca3af'
    };
  }

  get emptyStateContentStyles() {
    return {
      fontSize: '14px'
    };
  }

  get loadingStyles() {
    return {
      display: 'flex',
      flexDirection: 'column' as const,
      alignItems: 'center',
      justifyContent: 'center',
      padding: '48px',
      gap: '16px'
    };
  }

  get spinnerStyles() {
    return {
      width: '40px',
      height: '40px',
      border: `4px solid ${this.appliedTheme.borderColor}`,
      borderTop: `4px solid ${this.appliedTheme.primaryColor}`,
      borderRadius: '50%',
      animation: 'spin 1s linear infinite'
    };
  }

  get paginationStyles() {
    return {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      padding: '16px',
      borderTop: `1px solid ${this.appliedTheme.borderColor}`,
      fontSize: '14px'
    };
  }

  get paginationInfoStyles() {
    return {
      color: this.appliedTheme.textColor
    };
  }

  get paginationButtonGroupStyles() {
    return {
      display: 'flex',
      gap: '12px',
      alignItems: 'center'
    };
  }

  get paginationButtonStyles() {
    return {
      padding: '6px 12px',
      border: `1px solid ${this.appliedTheme.borderColor}`,
      borderRadius: '6px',
      backgroundColor: this.appliedTheme.backgroundColor,
      color: this.appliedTheme.primaryColor,
      cursor: 'pointer',
      fontSize: '14px'
    };
  }

  get pageNumberStyles() {
    return {
      color: this.appliedTheme.textColor,
      fontSize: '14px'
    };
  }

  get actionButtonGroupStyles() {
    return {
      display: 'flex',
      gap: '8px'
    };
  }

  get actionButtonStyles() {
    return {
      padding: '4px 8px',
      border: 'none',
      borderRadius: '4px',
      backgroundColor: this.appliedTheme.primaryColor,
      color: '#ffffff',
      cursor: 'pointer',
      fontSize: '12px'
    };
  }

  get deleteButtonStyles() {
    return {
      padding: '4px 8px',
      border: 'none',
      borderRadius: '4px',
      backgroundColor: '#ef4444',
        backdropFilter: 'blur(10px)',
      color: '#ffffff',
      cursor: 'pointer',
      fontSize: '12px'
    };
  }

  get expandedRowStyles() {
    return {
      backgroundColor: '#f9fafb',
        backdropFilter: 'blur(10px)'
    };
  }

  get expandedContentStyles() {
    return {
      padding: '16px'
    };
  }

  onSearch() {
    this.currentPage = 1;
  }

  onSort(key: string) {
    if (this.sortKey === key) {
      this.sortDirection = this.sortDirection === 'asc' ? 'desc' : this.sortDirection === 'desc' ? null : 'asc';
      if (this.sortDirection === null) this.sortKey = '';
    } else {
      this.sortKey = key;
      this.sortDirection = 'asc';
    }
  }

  getSortIcon(key: string): string {
    if (this.sortKey !== key) return '↕';
    return this.sortDirection === 'asc' ? '↑' : '↓';
  }

  getSortDirection(key: string): string | null {
    if (this.sortKey !== key) return null;
    return this.sortDirection === 'asc' ? 'ascending' : 'descending';
  }

  toggleSelect(id: string | number) {
    if (this.selectedRows.has(id)) {
      this.selectedRows.delete(id);
    } else {
      this.selectedRows.add(id);
    }
    this.selectionChange.emit(Array.from(this.selectedRows));
  }

  toggleSelectAll() {
    if (this.allSelected) {
      this.paginatedData.forEach(row => this.selectedRows.delete(row.id));
    } else {
      this.paginatedData.forEach(row => this.selectedRows.add(row.id));
    }
    this.selectionChange.emit(Array.from(this.selectedRows));
  }

  isSelected(id: string | number): boolean {
    return this.selectedRows.has(id);
  }

  onRowClick(row: TableRow) {
    if (this.expandable) {
      if (this.expandedRows.has(row.id)) {
        this.expandedRows.delete(row.id);
      } else {
        this.expandedRows.add(row.id);
      }
    }
    this.rowClick.emit(row);
  }

  onEdit(row: TableRow) {
    this.edit.emit(row);
  }

  onDelete(row: TableRow) {
    this.delete.emit(row);
  }

  nextPage() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
    }
  }

  previousPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
    }
  }
}
