import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ModalTheme {
  primaryColor: string;
  backgroundColor: string;
  overlayColor: string;
  textColor: string;
  borderColor: string;
}

@Component({
  selector: 'app-modal',
  template: `
    <div *ngIf="isOpen" class="modal-overlay" [ngStyle]="overlayStyles" (click)="onOverlayClick()">
      <div class="modal-container" [ngStyle]="modalStyles" (click)="$event.stopPropagation()" role="dialog" [attr.aria-modal]="true" [attr.aria-labelledby]="titleId">
        <button *ngIf="showCloseButton" class="close-button" [ngStyle]="closeButtonStyles" (click)="close()" aria-label="Close modal">
          <span>&times;</span>
        </button>

        <div *ngIf="title" class="modal-header" [ngStyle]="headerStyles">
          <h2 [id]="titleId" class="modal-title">{{ title }}</h2>
        </div>

        <div class="modal-body" [ngStyle]="bodyStyles">
          <ng-content></ng-content>
        </div>

        <div *ngIf="hasFooter" class="modal-footer" [ngStyle]="footerStyles">
          <ng-content select="[footer]"></ng-content>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1000;
      animation: fadeIn 0.2s ease-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    .modal-container {
      position: relative;
      border-radius: 16px;
      max-height: 90vh;
      overflow-y: auto;
      animation: slideUp 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(20px) scale(0.95);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    .close-button {
      position: absolute;
      top: 16px;
      right: 16px;
      background: none;
      border: none;
      font-size: 28px;
      line-height: 1;
      cursor: pointer;
      opacity: 0.6;
      transition: opacity 0.2s;
      z-index: 10;
    }

    .close-button:hover {
      opacity: 1;
    }

    .modal-header {
      padding: 24px 24px 16px;
      border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .modal-title {
      margin: 0;
      font-size: 24px;
      font-weight: 700;
    }

    .modal-body {
      padding: 24px;
      overflow-y: auto;
    }

    .modal-footer {
      padding: 16px 24px 24px;
      border-top: 1px solid rgba(0, 0, 0, 0.1);
      display: flex;
      gap: 12px;
      justify-content: flex-end;
    }
  `]
})
export class ModalComponent {
  @Input() theme: Partial<ModalTheme> = {};
  @Input() isOpen = false;
  @Input() title?: string;
  @Input() size: 'sm' | 'md' | 'lg' | 'xl' = 'md';
  @Input() showCloseButton = true;
  @Input() closeOnOverlayClick = true;
  @Input() hasFooter = false;
  @Output() closed = new EventEmitter<void>();

  titleId = `modal-title-${Math.random().toString(36).substr(2, 9)}`;

  private defaultTheme: ModalTheme = {
    primaryColor: '#3b82f6',
    backgroundColor: '#ffffff',
        backdropFilter: 'blur(10px)',
    overlayColor: 'rgba(0, 0, 0, 0.5)',
    textColor: '#0f172a',
    borderColor: '#e2e8f0'
  };

  get appliedTheme(): ModalTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get overlayStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.overlayColor
    };
  }

  get modalStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { width: '400px', maxWidth: '90vw' },
      md: { width: '600px', maxWidth: '90vw' },
      lg: { width: '800px', maxWidth: '90vw' },
      xl: { width: '1000px', maxWidth: '90vw' }
    };

    return {
      ...sizeMap[this.size],
      backgroundColor: t.backgroundColor,
      color: t.textColor
    };
  }

  get closeButtonStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get headerStyles() {
    return {};
  }

  get bodyStyles() {
    return {};
  }

  get footerStyles() {
    return {};
  }

  close(): void {
    this.isOpen = false;
    this.closed.emit();
  }

  onOverlayClick(): void {
    if (this.closeOnOverlayClick) {
      this.close();
    }
  }
}
