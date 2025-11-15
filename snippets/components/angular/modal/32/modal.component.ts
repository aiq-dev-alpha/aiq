import { Component, Input, Output, EventEmitter, HostListener } from '@angular/core';

interface DialogConfig {
  backdrop: {
    color: string;
    blur: string;
    opacity: number;
  };
  content: {
    background: string;
    textColor: string;
    borderRadius: string;
    shadow: string;
  };
}

type DialogPosition = 'center' | 'top' | 'bottom' | 'left' | 'right';
type DialogVariant = 'standard' | 'fullscreen' | 'drawer' | 'popup';

@Component({
  selector: 'app-modal',
  template: `
    <div *ngIf="visible" class="dialog-backdrop" [ngStyle]="backdropStyles" (click)="handleBackdropClick()">
      <div class="dialog-wrapper" [ngClass]="positionClass">
        <div class="dialog-content" [ngStyle]="contentStyles" [ngClass]="variantClass" (click)="$event.stopPropagation()">
          <header *ngIf="hasHeader || headerTitle" class="dialog-header">
            <div class="header-text">
              <h3 *ngIf="headerTitle" class="header-title">{{ headerTitle }}</h3>
              <p *ngIf="headerDescription" class="header-desc">{{ headerDescription }}</p>
              <ng-content select="[dialogHeader]"></ng-content>
            </div>
            <button *ngIf="dismissible" class="dismiss-btn" (click)="dismiss()" aria-label="Dismiss">
              <span class="dismiss-icon">✕</span>
            </button>
          </header>

          <main class="dialog-main">
            <ng-content></ng-content>
          </main>

          <footer *ngIf="hasFooter" class="dialog-footer">
            <ng-content select="[dialogFooter]"></ng-content>
          </footer>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .dialog-backdrop {
      position: fixed;
      inset: 0;
      z-index: 9999;
      animation: backdropFadeIn 0.25s ease;
    }
    @keyframes backdropFadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .dialog-wrapper {
      position: absolute;
      display: flex;
      padding: 1rem;
    }
    .dialog-wrapper.center {
      inset: 0;
      align-items: center;
      justify-content: center;
    }
    .dialog-wrapper.top {
      top: 0;
      left: 0;
      right: 0;
      justify-content: center;
    }
    .dialog-wrapper.bottom {
      bottom: 0;
      left: 0;
      right: 0;
      justify-content: center;
    }
    .dialog-wrapper.left {
      top: 0;
      bottom: 0;
      left: 0;
    }
    .dialog-wrapper.right {
      top: 0;
      bottom: 0;
      right: 0;
    }
    .dialog-content {
      display: flex;
      flex-direction: column;
      max-height: 90vh;
      animation: contentSlideIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    @keyframes contentSlideIn {
      from { transform: translateY(20px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .dialog-content.standard {
      width: 100%;
      max-width: 500px;
    }
    .dialog-content.fullscreen {
      width: 100%;
      height: 100%;
      max-height: 100vh;
      border-radius: 0 !important;
    }
    .dialog-content.drawer {
      width: 100%;
      max-width: 400px;
      height: 100vh;
      max-height: 100vh;
    }
    .dialog-content.popup {
      width: 100%;
      max-width: 350px;
    }
    .dialog-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 1rem;
      padding: 1.5rem;
      border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    }
    .header-text {
      flex: 1;
    }
    .header-title {
      margin: 0;
      font-size: 1.25rem;
      font-weight: 700;
    }
    .header-desc {
      margin: 0.5rem 0 0;
      font-size: 0.875rem;
      opacity: 0.7;
    }
    .dismiss-btn {
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
      border-radius: 6px;
      transition: background 0.2s;
      line-height: 1;
    }
    .dismiss-btn:hover {
      background: rgba(0, 0, 0, 0.05);
    }
    .dismiss-icon {
      font-size: 1.25rem;
      font-weight: 400;
    }
    .dialog-main {
      flex: 1;
      overflow-y: auto;
      padding: 1.5rem;
    }
    .dialog-footer {
      padding: 1.5rem;
      border-top: 1px solid rgba(0, 0, 0, 0.08);
      display: flex;
      gap: 0.75rem;
      justify-content: flex-end;
    }
  `]
})
export class ModalComponent {
  @Input() visible = false;
  @Input() position: DialogPosition = 'center';
  @Input() variant: DialogVariant = 'standard';
  @Input() config: Partial<DialogConfig> = {};
  @Input() headerTitle?: string;
  @Input() headerDescription?: string;
  @Input() dismissible = true;
  @Input() closeOnBackdrop = true;
  @Input() closeOnEscape = true;
  @Input() hasHeader = false;
  @Input() hasFooter = false;
  @Output() visibleChange = new EventEmitter<boolean>();
  @Output() dismissed = new EventEmitter<void>();

  private defaultConfig: DialogConfig = {
    backdrop: {
      color: 'rgba(0, 0, 0, 0.65)',
      blur: '10px',
      opacity: 1
    },
    content: {
      background: '#ffffff',
      textColor: '#0f172a',
      borderRadius: '16px',
      shadow: '0 25px 50px rgba(0, 0, 0, 0.3)'
    }
  };

  get dialogConfig(): DialogConfig {
    return {
      backdrop: { ...this.defaultConfig.backdrop, ...this.config.backdrop },
      content: { ...this.defaultConfig.content, ...this.config.content }
    };
  }

  get positionClass(): string {
    return this.position;
  }

  get variantClass(): string {
    return this.variant;
  }

  get backdropStyles(): Record<string, string> {
    const b = this.dialogConfig.backdrop;
    return {
      backgroundColor: b.color,
      backdropFilter: `blur(${b.blur})`,
      opacity: b.opacity.toString()
    };
  }

  get contentStyles(): Record<string, string> {
    const c = this.dialogConfig.content;
    return {
      background: c.background,
      color: c.textColor,
      borderRadius: c.borderRadius,
      boxShadow: c.shadow
    };
  }

  @HostListener('document:keydown.escape', ['$event'])
  handleEscape(event: KeyboardEvent): void {
    if (this.visible && this.closeOnEscape && this.dismissible) {
      event.preventDefault();
      this.dismiss();
    }
  }

  handleBackdropClick(): void {
    if (this.closeOnBackdrop && this.dismissible) {
      this.dismiss();
    }
  }

  dismiss(): void {
    this.visible = false;
    this.visibleChange.emit(false);
    this.dismissed.emit();
  }
}
