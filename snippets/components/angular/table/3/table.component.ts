import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
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
  [key: string]: unknown;
  id: string | number;
}
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-table',
  template: `
  <div [ngStyle]="containerStyles" class="table-container">
  <div *ngIf="searchable" [ngStyle]="searchBarStyles">
  <input
  type="text"
  [ngStyle]="searchInputStyles"
  [(ngModel)]="searchTerm"
  (input)="onSearch()"
  placeholder="Filter records..."
  aria-label="Search table">
  </div>
  <div *ngIf="loading" [ngStyle]="loadingStyles">
  <div [ngStyle]="spinnerStyles"></div>
  <p>Loading...</p>
  </div>
  <div *ngIf="!loading" [ngStyle]="tableWrapperStyles">
  <table [ngStyle]="tableStyles">
  <thead [ngStyle]="theadStyles">
  <tr>
  <th *ngIf="selectable" [ngStyle]="thStyles">
  <input type="checkbox" [checked]="allSelected" (change)="toggleSelectAll()" aria-label="Select all">
  </th>
  <th *ngFor="let col of columns" [ngStyle]="thStyles" [style.width]="col.width" scope="col" [attr.aria-sort]="getSortDirection(col.key)">
  <div [ngStyle]="thContentStyles">
  <span>{{ col.label }}</span>
  <button *ngIf="col.sortable" (click)="onSort(col.key)" [ngStyle]="sortButtonStyles" [attr.aria-label]="'Sort by ' + col.label">
  {{ getSortIcon(col.key) }}
  </button>
  </div>
  </th>
  <th *ngIf="hasActions" [ngStyle]="thStyles" scope="col">Actions</th>
  </tr>
  </thead>
  <tbody>
  <tr *ngIf="filteredData.length === 0">
  <td [attr.colspan]="totalColumns" [ngStyle]="emptyStateStyles">
  <p>No records found</p>
  </td>
  </tr>
  <ng-container *ngFor="let row of paginatedData; let i = index; let even = even">
  <tr [ngStyle]="getTrStyles(row, even)" (click)="onRowClick(row)" [attr.aria-selected]="isSelected(row.id)">
  <td *ngIf="selectable" [ngStyle]="tdStyles">
  <input type="checkbox" [checked]="isSelected(row.id)" (change)="toggleSelect(row.id)" (click)="$event.stopPropagation()" [attr.aria-label]="'Select row ' + (i + 1)">
  </td>
  <td *ngFor="let col of columns" [ngStyle]="tdStyles">{{ row[col.key] }}</td>
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
  <div *ngIf="paginate && filteredData.length > 0" [ngStyle]="paginationStyles">
  <div [ngStyle]="paginationInfoStyles">
  {{ startIndex + 1 }}-{{ endIndex }} of {{ filteredData.length }} items
  </div>
  <div [ngStyle]="paginationButtonGroupStyles">
  <button [ngStyle]="paginationButtonStyles" (click)="previousPage()" [disabled]="currentPage === 1">Prev</button>
  <span [ngStyle]="pageNumberStyles">{{ currentPage }}/{{ totalPages }}</span>
  <button [ngStyle]="paginationButtonStyles" (click)="nextPage()" [disabled]="currentPage === totalPages">Next</button>
  </div>
  </div>
  </div>
  `
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
  @Input() bordered: boolean = false;
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
  primaryColor: '#10b981',
  secondaryColor: '#059669',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#111827',
  borderColor: '#d1d5db',
  headerBgColor: '#10b981',
  hoverColor: '#d1fae5'
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
  return this.paginatedData.length > 0 && this.paginatedData.every(row => this.selectedRows.has(row.id));
  }
  get totalColumns(): number {
  return this.columns.length + (this.selectable ? 1 : 0) + (this.hasActions ? 1 : 0);
  }
  get containerStyles() {
  return {
  width: '100%',
  backgroundColor: this.appliedTheme.backgroundColor,
  borderRadius: '12px',
  boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
  overflow: 'hidden',
  border: `2px solid ${this.appliedTheme.borderColor}`
  };
  }
  get searchBarStyles() {
  return {
  padding: '20px',
  backgroundColor: '#f9fafb',
  backdropFilter: 'blur(10px)',
  borderBottom: `2px solid ${this.appliedTheme.borderColor}`
  };
  }
  get searchInputStyles() {
  return {
  width: '100%',
  padding: '10px 16px',
  border: `2px solid ${this.appliedTheme.primaryColor}`,
  borderRadius: '8px',
  fontSize: '14px',
  outline: 'none'
  };
  }
  get tableWrapperStyles() {
  return {
  overflowX: 'auto',
  maxHeight: this.stickyHeader ? '500px' : 'none',
  overflowY: this.stickyHeader ? 'auto' : 'visible'
  };
  }
  get tableStyles() {
  return {
  width: '100%',
  borderCollapse: 'separate' as const,
  borderSpacing: '0',
  fontSize: this.size === 'compact' ? '12px' : this.size === 'comfortable' ? '14px' : '16px'
  };
  }
  get theadStyles() {
  return {
  backgroundColor: this.appliedTheme.headerBgColor,
  color: '#ffffff',
  position: this.stickyHeader ? 'sticky' as const : 'static' as const,
  top: '0',
  zIndex: '10'
  };
  }
  get thStyles() {
  const padding = this.size === 'compact' ? '10px 14px' : this.size === 'comfortable' ? '14px 18px' : '18px 22px';
  return {
  padding,
  textAlign: 'left' as const,
  fontWeight: '700',
  color: '#ffffff',
  borderBottom: 'none'
  };
  }
  get thContentStyles() {
  return {
  display: 'flex',
  alignItems: 'center',
  gap: '10px'
  };
  }
  get sortButtonStyles() {
  return {
  background: 'rgba(255,255,255,0.2)',
  border: 'none',
  cursor: 'pointer',
  fontSize: '14px',
  color: '#ffffff',
  padding: '4px 8px',
  borderRadius: '4px'
  };
  }
  getTrStyles(row: TableRow, even: boolean) {
  const isRowSelected = this.selectedRows.has(row.id);
  return {
  backgroundColor: isRowSelected ? this.appliedTheme.hoverColor : (this.striped && even ? '#f9fafb' : this.appliedTheme.backgroundColor),
  cursor: 'pointer',
  transition: 'all 0.2s ease',
  borderBottom: `1px solid ${this.appliedTheme.borderColor}`
  };
  }
  get tdStyles() {
  const padding = this.size === 'compact' ? '10px 14px' : this.size === 'comfortable' ? '14px 18px' : '18px 22px';
  return {
  padding,
  color: this.appliedTheme.textColor
  };
  }
  get emptyStateStyles() {
  return {
  padding: '60px 20px',
  textAlign: 'center' as const,
  color: '#6b7280',
  fontSize: '16px'
  };
  }
  get loadingStyles() {
  return {
  display: 'flex',
  flexDirection: 'column' as const,
  alignItems: 'center',
  justifyContent: 'center',
  padding: '60px',
  gap: '20px'
  };
  }
  get spinnerStyles() {
  return {
  width: '48px',
  height: '48px',
  border: `5px solid ${this.appliedTheme.borderColor}`,
  borderTop: `5px solid ${this.appliedTheme.primaryColor}`,
  borderRadius: '50%',
  animation: 'spin 0.8s linear infinite'
  };
  }
  get paginationStyles() {
  return {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  padding: '20px',
  backgroundColor: '#f9fafb',
  backdropFilter: 'blur(10px)',
  borderTop: `2px solid ${this.appliedTheme.borderColor}`
  };
  }
  get paginationInfoStyles() {
  return {
  color: this.appliedTheme.textColor,
  fontWeight: '600'
  };
  }
  get paginationButtonGroupStyles() {
  return {
  display: 'flex',
  gap: '16px',
  alignItems: 'center'
  };
  }
  get paginationButtonStyles() {
  return {
  padding: '8px 16px',
  border: 'none',
  borderRadius: '8px',
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff',
  cursor: 'pointer',
  fontSize: '14px',
  fontWeight: '600'
  };
  }
  get pageNumberStyles() {
  return {
  color: this.appliedTheme.textColor,
  fontSize: '14px',
  fontWeight: '600'
  };
  }
  get actionButtonGroupStyles() {
  return {
  display: 'flex',
  gap: '10px'
  };
  }
  get actionButtonStyles() {
  return {
  padding: '6px 12px',
  border: 'none',
  borderRadius: '6px',
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff',
  cursor: 'pointer',
  fontSize: '13px',
  fontWeight: '500'
  };
  }
  get deleteButtonStyles() {
  return {
  padding: '6px 12px',
  border: 'none',
  borderRadius: '6px',
  backgroundColor: '#dc2626',
  backdropFilter: 'blur(10px)',
  color: '#ffffff',
  cursor: 'pointer',
  fontSize: '13px',
  fontWeight: '500'
  };
  }
  get expandedRowStyles() {
  return {
  backgroundColor: '#f3f4f6',
  backdropFilter: 'blur(10px)'
  };
  }
  get expandedContentStyles() {
  return {
  padding: '20px'
  };
  }
  onSearch() { this.currentPage = 1; }
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
  if (this.sortKey !== key) return '⇅';
  return this.sortDirection === 'asc' ? '▲' : '▼';
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
  onEdit(row: TableRow) { this.edit.emit(row); }
  onDelete(row: TableRow) { this.delete.emit(row); }
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
