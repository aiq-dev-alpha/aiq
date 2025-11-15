import { Component, Input, Output, EventEmitter } from '@angular/core';

interface ModalTheme {
  overlayColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  shadowColor: string;
}

type ModalSize = 'sm' | 'md' | 'lg' | 'xl' | 'full';
type ModalAnimation = 'fade' | 'slide-up' | 'slide-down' | 'zoom' | 'flip';

@Component({
  selector: 'app-modal',
  template: `
    <div *ngIf="isOpen" class="modal-overlay" [ngStyle]="overlayStyles" (click)="onOverlayClick()">
      <div class="modal-container" [ngStyle]="containerStyles" [ngClass]="animationClass" (click)="$event.stopPropagation()">
        <div *ngIf="showHeader" class="modal-header" [ngStyle]="headerStyles">
          <div class="header-content">
            <h2 *ngIf="title" class="modal-title">{{ title }}</h2>
            <p *ngIf="subtitle" class="modal-subtitle">{{ subtitle }}</p>
          </div>
          <button *ngIf="closable" class="close-button" (click)="close()" aria-label="Close">
            <span class="close-icon">&times;</span>
          </button>
        </div>

        <div class="modal-body" [ngStyle]="bodyStyles">
          <ng-content></ng-content>
        </div>

        <div *ngIf="showFooter" class="modal-footer" [ngStyle]="footerStyles">
          <ng-content select="[modalFooter]"></ng-content>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .modal-overlay {
      position: fixed;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1000;
      padding: 1rem;
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .modal-container {
      position: relative;
      width: 100%;
      max-height: 90vh;
      overflow: hidden;
      display: flex;
      flex-direction: column;
    }
    .fade {
      animation: modalFade 0.3s ease;
    }
    @keyframes modalFade {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .slide-up {
      animation: slideUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    @keyframes slideUp {
      from { transform: translateY(100px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .slide-down {
      animation: slideDown 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    @keyframes slideDown {
      from { transform: translateY(-100px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .zoom {
      animation: zoomIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    @keyframes zoomIn {
      from { transform: scale(0.8); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }
    .flip {
      animation: flipIn 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    @keyframes flipIn {
      from { transform: rotateX(-90deg); opacity: 0; }
      to { transform: rotateX(0); opacity: 1; }
    }
    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 1rem;
      flex-shrink: 0;
    }
    .header-content {
      flex: 1;
    }
    .modal-title {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 700;
      line-height: 1.3;
    }
    .modal-subtitle {
      margin: 0.5rem 0 0;
      font-size: 0.875rem;
      opacity: 0.7;
    }
    .close-button {
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
      border-radius: 50%;
      transition: all 0.2s;
      line-height: 1;
    }
    .close-button:hover {
      background: rgba(0, 0, 0, 0.1);
    }
    .close-icon {
      font-size: 1.5rem;
      font-weight: 300;
    }
    .modal-body {
      flex: 1;
      overflow-y: auto;
    }
    .modal-footer {
      flex-shrink: 0;
      display: flex;
      gap: 0.75rem;
      justify-content: flex-end;
      align-items: center;
      flex-wrap: wrap;
    }
  `]
})
export class ModalComponent {
  @Input() isOpen = false;
  @Input() size: ModalSize = 'md';
  @Input() animation: ModalAnimation = 'slide-up';
  @Input() theme: Partial<ModalTheme> = {};
  @Input() title?: string;
  @Input() subtitle?: string;
  @Input() closable = true;
  @Input() closeOnOverlay = true;
  @Input() showHeader = true;
  @Input() showFooter = false;
  @Output() closeModal = new EventEmitter<void>();

  private defaultTheme: ModalTheme = {
    overlayColor: 'rgba(0, 0, 0, 0.5)',
    backgroundColor: '#ffffff',
    textColor: '#111827',
    borderColor: '#e5e7eb',
    shadowColor: 'rgba(0, 0, 0, 0.25)'
  };

  get appliedTheme(): ModalTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get animationClass(): string {
    return this.animation;
  }

  get overlayStyles(): Record<string, string> {
    return {
      backgroundColor: this.appliedTheme.overlayColor,
      backdropFilter: 'blur(4px)'
    };
  }

  get containerStyles(): Record<string, string> {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { maxWidth: '400px' },
      md: { maxWidth: '600px' },
      lg: { maxWidth: '800px' },
      xl: { maxWidth: '1200px' },
      full: { maxWidth: 'calc(100% - 2rem)' }
    };

    return {
      ...sizeMap[this.size],
      backgroundColor: t.backgroundColor,
      color: t.textColor,
      borderRadius: '16px',
      boxShadow: `0 20px 25px ${t.shadowColor}`
    };
  }

  get headerStyles(): Record<string, string> {
    return {
      padding: '1.5rem',
      borderBottom: `1px solid ${this.appliedTheme.borderColor}`
    };
  }

  get bodyStyles(): Record<string, string> {
    return {
      padding: '1.5rem',
      color: this.appliedTheme.textColor
    };
  }

  get footerStyles(): Record<string, string> {
    return {
      padding: '1.5rem',
      borderTop: `1px solid ${this.appliedTheme.borderColor}`
    };
  }

  close(): void {
    this.closeModal.emit();
  }

  onOverlayClick(): void {
    if (this.closeOnOverlay && this.closable) {
      this.close();
    }
  }
}
