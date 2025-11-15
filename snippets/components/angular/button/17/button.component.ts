// Pagination Button - Numbered button for pagination controls
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface PaginationButtonTheme {
  primaryColor: string;
  backgroundColor: string;
  activeColor: string;
  textColor: string;
  activeTextColor: string;
  borderColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <div class="pagination-container">
      <button
        *ngIf="showPrev"
        class="pagination-btn nav-btn"
        [ngStyle]="getNavStyles()"
        [disabled]="currentPage === 1"
        (click)="handlePrevious()">
        ‹
      </button>

      <button
        *ngFor="let page of visiblePages"
        class="pagination-btn page-btn"
        [class.active]="page === currentPage"
        [class.ellipsis]="page === -1"
        [ngStyle]="getPageStyles(page)"
        [disabled]="page === -1"
        (click)="handlePageClick(page)">
        {{ page === -1 ? '...' : page }}
      </button>

      <button
        *ngIf="showNext"
        class="pagination-btn nav-btn"
        [ngStyle]="getNavStyles()"
        [disabled]="currentPage === totalPages"
        (click)="handleNext()">
        ›
      </button>
    </div>
  `,
  styles: [`
    .pagination-container {
      display: inline-flex;
      gap: 8px;
      align-items: center;
    }

    .pagination-btn {
      min-width: 40px;
      height: 40px;
      border: 1px solid;
      background: white;
      cursor: pointer;
      font-family: inherit;
      font-weight: 600;
      font-size: 14px;
      border-radius: 8px;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0 12px;
    }

    .pagination-btn:hover:not(:disabled):not(.active) {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .pagination-btn:active:not(:disabled) {
      transform: translateY(0);
    }

    .pagination-btn:disabled {
      cursor: not-allowed;
      opacity: 0.4;
    }

    .pagination-btn.active {
      transform: scale(1.1);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      z-index: 1;
    }

    .pagination-btn.ellipsis {
      cursor: default;
      border-color: transparent;
    }

    .nav-btn {
      font-size: 20px;
      font-weight: 700;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<PaginationButtonTheme> = {};
  @Input() currentPage = 1;
  @Input() totalPages = 10;
  @Input() maxVisible = 7;
  @Input() showPrev = true;
  @Input() showNext = true;
  @Output() pageChange = new EventEmitter<number>();

  private defaultTheme: PaginationButtonTheme = {
    primaryColor: '#3b82f6',
    backgroundColor: '#ffffff',
    activeColor: '#3b82f6',
    textColor: '#1f2937',
    activeTextColor: '#ffffff',
    borderColor: '#e5e7eb'
  };

  get appliedTheme(): PaginationButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get visiblePages(): number[] {
    const pages: number[] = [];
    const half = Math.floor(this.maxVisible / 2);

    if (this.totalPages <= this.maxVisible) {
      for (let i = 1; i <= this.totalPages; i++) {
        pages.push(i);
      }
    } else {
      let start = Math.max(1, this.currentPage - half);
      let end = Math.min(this.totalPages, start + this.maxVisible - 1);

      if (end - start < this.maxVisible - 1) {
        start = Math.max(1, end - this.maxVisible + 1);
      }

      if (start > 1) {
        pages.push(1);
        if (start > 2) pages.push(-1); // ellipsis
      }

      for (let i = start; i <= end; i++) {
        pages.push(i);
      }

      if (end < this.totalPages) {
        if (end < this.totalPages - 1) pages.push(-1); // ellipsis
        pages.push(this.totalPages);
      }
    }

    return pages;
  }

  getPageStyles(page: number) {
    const t = this.appliedTheme;
    const isActive = page === this.currentPage;
    return {
      background: isActive ? t.activeColor : t.backgroundColor,
      color: isActive ? t.activeTextColor : t.textColor,
      borderColor: isActive ? t.activeColor : t.borderColor
    };
  }

  getNavStyles() {
    const t = this.appliedTheme;
    return {
      background: t.backgroundColor,
      color: t.primaryColor,
      borderColor: t.borderColor
    };
  }

  handlePageClick(page: number): void {
    if (page !== -1 && page !== this.currentPage) {
      this.currentPage = page;
      this.pageChange.emit(page);
    }
  }

  handlePrevious(): void {
    if (this.currentPage > 1) {
      this.handlePageClick(this.currentPage - 1);
    }
  }

  handleNext(): void {
    if (this.currentPage < this.totalPages) {
      this.handlePageClick(this.currentPage + 1);
    }
  }
}
