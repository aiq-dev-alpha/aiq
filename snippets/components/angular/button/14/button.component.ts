// Chip Button - Compact tag/filter style button with dismiss
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface ChipButtonTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <div
      class="chip-btn"
      [ngStyle]="chipStyles"
      [class.selected]="isSelected"
      [class.disabled]="disabled"
      [class.with-avatar]="avatar !== undefined"
      [class.with-dismiss]="dismissible"
      (click)="handleClick($event)">

      <span *ngIf="avatar" class="chip-avatar">{{ avatar }}</span>

      <span *ngIf="leadingIcon" class="chip-icon chip-leading">{{ leadingIcon }}</span>

      <span class="chip-label">{{ label }}</span>

      <span *ngIf="count !== undefined" class="chip-count">{{ count }}</span>

      <button
        *ngIf="dismissible"
        class="chip-dismiss"
        [attr.aria-label]="'Remove ' + label"
        (click)="handleDismiss($event)">
        ✕
      </button>

      <span *ngIf="trailingIcon && !dismissible" class="chip-icon chip-trailing">
        {{ trailingIcon }}
      </span>
    </div>
  `,
  styles: [`
    .chip-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 600;
      border: 1px solid;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      user-select: none;
      position: relative;
      overflow: hidden;
    }

    .chip-btn::before {
      content: '';
      position: absolute;
      inset: 0;
      background: currentColor;
      opacity: 0;
      transition: opacity 0.2s;
    }

    .chip-btn:hover:not(.disabled)::before {
      opacity: 0.08;
    }

    .chip-btn.selected::before {
      opacity: 0.12;
    }

    .chip-btn:active:not(.disabled) {
      transform: scale(0.95);
    }

    .chip-btn.disabled {
      cursor: not-allowed;
      opacity: 0.5;
    }

    .chip-avatar {
      width: 24px;
      height: 24px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 700;
      background: currentColor;
      color: white;
      flex-shrink: 0;
      margin-left: -4px;
    }

    .chip-with-avatar {
      padding-left: 4px;
    }

    .chip-icon {
      font-size: 16px;
      display: flex;
      align-items: center;
      position: relative;
      z-index: 1;
    }

    .chip-label {
      position: relative;
      z-index: 1;
      white-space: nowrap;
    }

    .chip-count {
      background: currentColor;
      color: white;
      padding: 2px 6px;
      border-radius: 10px;
      font-size: 11px;
      font-weight: 700;
      min-width: 20px;
      text-align: center;
      position: relative;
      z-index: 1;
    }

    .chip-dismiss {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 14px;
      padding: 0;
      width: 18px;
      height: 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      transition: all 0.2s;
      color: inherit;
      position: relative;
      z-index: 2;
      margin-right: -4px;
    }

    .chip-dismiss:hover {
      background: rgba(0, 0, 0, 0.1);
      transform: scale(1.2);
    }

    .chip-with-dismiss {
      padding-right: 8px;
    }

    .chip-btn.selected {
      transform: scale(1.05);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ChipButtonTheme> = {};
  @Input() label = 'Chip';
  @Input() avatar?: string;
  @Input() leadingIcon?: string;
  @Input() trailingIcon?: string;
  @Input() count?: number;
  @Input() dismissible = false;
  @Input() isSelected = false;
  @Input() disabled = false;
  @Input() variant: 'filled' | 'outlined' = 'outlined';
  @Output() clicked = new EventEmitter<MouseEvent>();
  @Output() dismissed = new EventEmitter<void>();

  private defaultTheme: ChipButtonTheme = {
    primaryColor: '#3b82f6',
    backgroundColor: '#eff6ff',
    textColor: '#1e40af',
    borderColor: '#93c5fd'
  };

  get appliedTheme(): ChipButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get chipStyles() {
    const t = this.appliedTheme;
    if (this.variant === 'filled') {
      return {
        background: t.backgroundColor,
        color: t.textColor,
        borderColor: t.backgroundColor
      };
    } else {
      return {
        background: 'transparent',
        color: t.primaryColor,
        borderColor: t.borderColor
      };
    }
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled) {
      this.clicked.emit(event);
    }
  }

  handleDismiss(event: MouseEvent): void {
    event.stopPropagation();
    if (!this.disabled) {
      this.dismissed.emit();
    }
  }
}
