// Split Button - Button with dropdown menu
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface SplitButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

export interface MenuItem {
  label: string;
  icon?: string;
  action: () => void;
  divider?: boolean;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <div class="split-button-group" [ngStyle]="groupStyles">
      <button
        class="main-action"
        [disabled]="disabled"
        (click)="handleMainClick($event)"
        [ngStyle]="mainButtonStyles">
        <span class="main-label">{{ mainLabel }}</span>
      </button>

      <button
        class="dropdown-trigger"
        [disabled]="disabled"
        (click)="toggleDropdown($event)"
        [ngStyle]="triggerStyles">
        <span class="arrow" [class.open]="dropdownOpen">▼</span>
      </button>

      <div *ngIf="dropdownOpen" class="dropdown-menu" [ngStyle]="menuStyles">
        <div
          *ngFor="let item of menuItems"
          [class.divider]="item.divider"
          class="menu-item"
          (click)="handleMenuItemClick(item)">
          <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
          <span class="item-label">{{ item.label }}</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .split-button-group {
      position: relative;
      display: inline-flex;
      align-items: stretch;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .main-action, .dropdown-trigger {
      border: none;
      cursor: pointer;
      font-family: inherit;
      font-weight: 600;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }

    .main-action {
      flex: 1;
      padding: 12px 24px;
      border-right: 1px solid rgba(255, 255, 255, 0.2);
    }

    .dropdown-trigger {
      padding: 12px 16px;
      background: rgba(0, 0, 0, 0.1);
    }

    .main-action:hover:not(:disabled),
    .dropdown-trigger:hover:not(:disabled) {
      filter: brightness(1.1);
    }

    .main-action:disabled,
    .dropdown-trigger:disabled {
      cursor: not-allowed;
      opacity: 0.5;
    }

    .arrow {
      display: inline-block;
      transition: transform 0.3s;
      font-size: 10px;
    }

    .arrow.open {
      transform: rotate(180deg);
    }

    .dropdown-menu {
      position: absolute;
      top: calc(100% + 4px);
      right: 0;
      min-width: 180px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
      overflow: hidden;
      z-index: 1000;
      animation: slideDown 0.2s ease-out;
    }

    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .menu-item {
      padding: 12px 16px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 10px;
      transition: background 0.2s;
      font-size: 14px;
    }

    .menu-item:hover {
      background: rgba(0, 0, 0, 0.05);
    }

    .menu-item.divider {
      border-top: 1px solid rgba(0, 0, 0, 0.1);
      margin-top: 4px;
      padding-top: 16px;
    }

    .item-icon {
      font-size: 16px;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<SplitButtonTheme> = {};
  @Input() mainLabel = 'Action';
  @Input() menuItems: MenuItem[] = [];
  @Input() disabled = false;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Output() mainAction = new EventEmitter<MouseEvent>();

  dropdownOpen = false;

  private defaultTheme: SplitButtonTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#2563eb',
    backgroundColor: '#ffffff',
    textColor: '#ffffff',
    borderColor: '#e5e7eb'
  };

  get appliedTheme(): SplitButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get groupStyles() {
    return {
      fontSize: this.size === 'sm' ? '13px' : this.size === 'lg' ? '16px' : '14px'
    };
  }

  get mainButtonStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
      color: t.textColor
    };
  }

  get triggerStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.secondaryColor}, ${t.primaryColor})`,
      color: t.textColor
    };
  }

  get menuStyles() {
    const t = this.appliedTheme;
    return {
      color: '#1f2937',
      borderColor: t.borderColor
    };
  }

  handleMainClick(event: MouseEvent): void {
    if (!this.disabled) {
      this.mainAction.emit(event);
      this.dropdownOpen = false;
    }
  }

  toggleDropdown(event: MouseEvent): void {
    event.stopPropagation();
    if (!this.disabled) {
      this.dropdownOpen = !this.dropdownOpen;
    }
  }

  handleMenuItemClick(item: MenuItem): void {
    item.action();
    this.dropdownOpen = false;
  }
}
