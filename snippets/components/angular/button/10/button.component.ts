// Button Group - Multiple buttons in a connected group
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface ButtonGroupTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  selectedColor: string;
}

export interface GroupButton {
  label: string;
  value: any;
  icon?: string;
  disabled?: boolean;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <div
      class="button-group"
      [ngStyle]="groupStyles"
      [class.vertical]="vertical"
      role="group"
      [attr.aria-label]="ariaLabel">
      <button
        *ngFor="let btn of buttons; let i = index"
        class="group-btn"
        [class.selected]="isSelected(btn.value)"
        [class.first]="i === 0"
        [class.last]="i === buttons.length - 1"
        [ngStyle]="getButtonStyles(btn)"
        [disabled]="btn.disabled"
        (click)="handleClick(btn)">
        <span *ngIf="btn.icon" class="btn-icon">{{ btn.icon }}</span>
        <span class="btn-label">{{ btn.label }}</span>
        <span *ngIf="showCheck && isSelected(btn.value)" class="check-mark">✓</span>
      </button>
    </div>
  `,
  styles: [`
    .button-group {
      display: inline-flex;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .button-group.vertical {
      flex-direction: column;
    }

    .group-btn {
      flex: 1;
      border: none;
      cursor: pointer;
      font-family: inherit;
      font-weight: 600;
      padding: 12px 20px;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      position: relative;
      background: transparent;
      border-right: 1px solid rgba(0, 0, 0, 0.1);
    }

    .button-group.vertical .group-btn {
      border-right: none;
      border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .group-btn.last {
      border-right: none;
      border-bottom: none;
    }

    .group-btn:hover:not(:disabled):not(.selected) {
      background: rgba(0, 0, 0, 0.05);
    }

    .group-btn.selected {
      position: relative;
      z-index: 1;
    }

    .group-btn.selected::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: currentColor;
      animation: slideIn 0.3s ease-out;
    }

    .button-group.vertical .group-btn.selected::after {
      top: 0;
      bottom: 0;
      left: auto;
      right: 0;
      width: 3px;
      height: auto;
    }

    @keyframes slideIn {
      from {
        transform: scaleX(0);
      }
      to {
        transform: scaleX(1);
      }
    }

    .group-btn:disabled {
      cursor: not-allowed;
      opacity: 0.4;
    }

    .btn-icon {
      font-size: 18px;
    }

    .check-mark {
      font-size: 12px;
      margin-left: 4px;
      animation: checkPop 0.2s ease-out;
    }

    @keyframes checkPop {
      0% { transform: scale(0); }
      50% { transform: scale(1.3); }
      100% { transform: scale(1); }
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ButtonGroupTheme> = {};
  @Input() buttons: GroupButton[] = [];
  @Input() selectedValue: any;
  @Input() multiSelect = false;
  @Input() vertical = false;
  @Input() showCheck = false;
  @Input() ariaLabel?: string;
  @Output() selectionChange = new EventEmitter<any>();

  private selectedValues = new Set<any>();

  private defaultTheme: ButtonGroupTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#2563eb',
    backgroundColor: '#ffffff',
    textColor: '#1f2937',
    selectedColor: '#3b82f6'
  };

  ngOnInit() {
    if (this.selectedValue !== undefined) {
      if (Array.isArray(this.selectedValue)) {
        this.selectedValues = new Set(this.selectedValue);
      } else {
        this.selectedValues.add(this.selectedValue);
      }
    }
  }

  get appliedTheme(): ButtonGroupTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get groupStyles() {
    const t = this.appliedTheme;
    return {
      background: t.backgroundColor
    };
  }

  getButtonStyles(btn: GroupButton) {
    const t = this.appliedTheme;
    const isSelected = this.isSelected(btn.value);
    return {
      color: isSelected ? t.selectedColor : t.textColor,
      background: isSelected ? `${t.selectedColor}15` : 'transparent',
      fontWeight: isSelected ? '700' : '600'
    };
  }

  isSelected(value: any): boolean {
    return this.selectedValues.has(value);
  }

  handleClick(btn: GroupButton): void {
    if (btn.disabled) return;

    if (this.multiSelect) {
      if (this.selectedValues.has(btn.value)) {
        this.selectedValues.delete(btn.value);
      } else {
        this.selectedValues.add(btn.value);
      }
      this.selectionChange.emit(Array.from(this.selectedValues));
    } else {
      this.selectedValues.clear();
      this.selectedValues.add(btn.value);
      this.selectionChange.emit(btn.value);
    }
  }
}
