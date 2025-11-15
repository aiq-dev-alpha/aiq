// Floating Action Button (FAB) - Material Design style with speed dial
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface FABTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
}

export interface SpeedDialAction {
  icon: string;
  label: string;
  action: () => void;
  color?: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <div class="fab-container" [class.expanded]="isExpanded">
      <div *ngIf="speedDialActions.length > 0 && isExpanded" class="speed-dial-actions">
        <div
          *ngFor="let action of speedDialActions; let i = index"
          class="speed-dial-item"
          [style.animation-delay.ms]="i * 50"
          (click)="handleActionClick(action)">
          <span class="action-label">{{ action.label }}</span>
          <button
            class="action-btn"
            [ngStyle]="getActionStyles(action)"
            [attr.aria-label]="action.label">
            <span class="action-icon">{{ action.icon }}</span>
          </button>
        </div>
      </div>

      <button
        class="fab-main"
        [ngStyle]="fabStyles"
        [disabled]="disabled"
        [class.loading]="loading"
        [attr.aria-label]="ariaLabel"
        (click)="handleMainClick($event)">
        <span *ngIf="loading" class="fab-loader"></span>
        <span *ngIf="!loading" class="fab-icon" [class.rotated]="isExpanded">
          {{ isExpanded && speedDialActions.length > 0 ? '✕' : icon }}
        </span>
      </button>
    </div>
  `,
  styles: [`
    .fab-container {
      position: fixed;
      bottom: 24px;
      right: 24px;
      z-index: 1000;
    }

    .fab-main {
      width: 64px;
      height: 64px;
      border-radius: 50%;
      border: none;
      cursor: pointer;
      font-family: inherit;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .fab-main:hover:not(:disabled) {
      transform: scale(1.1);
      box-shadow: 0 8px 28px rgba(0, 0, 0, 0.25);
    }

    .fab-main:active:not(:disabled) {
      transform: scale(0.95);
    }

    .fab-main:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }

    .fab-icon {
      font-size: 24px;
      transition: transform 0.3s;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .fab-icon.rotated {
      transform: rotate(45deg);
    }

    .fab-loader {
      width: 24px;
      height: 24px;
      border: 3px solid rgba(255, 255, 255, 0.3);
      border-top-color: white;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .speed-dial-actions {
      position: absolute;
      bottom: 80px;
      right: 8px;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .speed-dial-item {
      display: flex;
      align-items: center;
      gap: 12px;
      animation: slideIn 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
      animation-fill-mode: both;
    }

    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translateY(20px) scale(0.8);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    .action-label {
      background: white;
      padding: 8px 12px;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      white-space: nowrap;
      color: #1f2937;
    }

    .action-btn {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      border: none;
      cursor: pointer;
      font-family: inherit;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      transition: all 0.2s;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .action-btn:hover {
      transform: scale(1.1);
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
    }

    .action-icon {
      font-size: 20px;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<FABTheme> = {};
  @Input() icon = '+';
  @Input() speedDialActions: SpeedDialAction[] = [];
  @Input() disabled = false;
  @Input() loading = false;
  @Input() ariaLabel = 'Floating action button';
  @Output() clicked = new EventEmitter<MouseEvent>();

  isExpanded = false;

  private defaultTheme: FABTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#2563eb',
    backgroundColor: '#ffffff',
    textColor: '#ffffff'
  };

  get appliedTheme(): FABTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get fabStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
      color: t.textColor
    };
  }

  getActionStyles(action: SpeedDialAction) {
    return {
      background: action.color || this.appliedTheme.primaryColor,
      color: '#ffffff'
    };
  }

  handleMainClick(event: MouseEvent): void {
    if (!this.disabled && !this.loading) {
      if (this.speedDialActions.length > 0) {
        this.isExpanded = !this.isExpanded;
      } else {
        this.clicked.emit(event);
      }
    }
  }

  handleActionClick(action: SpeedDialAction): void {
    action.action();
    this.isExpanded = false;
  }
}
