// Toggle Button - Two-state button with visual feedback
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface ToggleButtonTheme {
  activeColor: string;
  inactiveColor: string;
  backgroundColor: string;
  textColor: string;
  activeTextColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <button
      class="toggle-btn"
      [ngStyle]="buttonStyles"
      [class.active]="isActive"
      [disabled]="disabled"
      [attr.aria-pressed]="isActive"
      [attr.aria-label]="ariaLabel"
      (click)="handleToggle($event)">

      <div class="toggle-track"></div>

      <div class="toggle-content">
        <span *ngIf="showIcons" class="toggle-icon">
          {{ isActive ? activeIcon : inactiveIcon }}
        </span>
        <span class="toggle-label">
          {{ isActive ? activeLabel : inactiveLabel }}
        </span>
      </div>
    </button>
  `,
  styles: [`
    .toggle-btn {
      position: relative;
      border: 2px solid;
      cursor: pointer;
      font-family: inherit;
      font-weight: 600;
      font-size: 15px;
      padding: 12px 24px;
      border-radius: 25px;
      overflow: hidden;
      transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
      min-width: 120px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .toggle-btn:disabled {
      cursor: not-allowed;
      opacity: 0.5;
      filter: saturate(0.5);
    }

    .toggle-btn:hover:not(:disabled) {
      transform: scale(1.05);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }

    .toggle-btn:active:not(:disabled) {
      transform: scale(0.95);
    }

    .toggle-track {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      transform-origin: left center;
      transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
      z-index: 0;
    }

    .toggle-btn.active .toggle-track {
      transform: scaleX(1);
    }

    .toggle-btn:not(.active) .toggle-track {
      transform: scaleX(0);
    }

    .toggle-content {
      position: relative;
      z-index: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: transform 0.3s;
    }

    .toggle-btn.active .toggle-content {
      animation: contentBounce 0.4s ease-out;
    }

    @keyframes contentBounce {
      0% { transform: scale(1); }
      50% { transform: scale(1.15); }
      100% { transform: scale(1); }
    }

    .toggle-icon {
      font-size: 18px;
      transition: transform 0.3s;
    }

    .toggle-btn.active .toggle-icon {
      transform: rotate(360deg);
    }

    .toggle-label {
      transition: all 0.3s;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<ToggleButtonTheme> = {};
  @Input() isActive = false;
  @Input() activeLabel = 'ON';
  @Input() inactiveLabel = 'OFF';
  @Input() activeIcon = '✓';
  @Input() inactiveIcon = '✗';
  @Input() showIcons = true;
  @Input() disabled = false;
  @Input() ariaLabel?: string;
  @Output() toggled = new EventEmitter<boolean>();

  private defaultTheme: ToggleButtonTheme = {
    activeColor: '#10b981',
    inactiveColor: '#6b7280',
    backgroundColor: '#ffffff',
    textColor: '#1f2937',
    activeTextColor: '#ffffff'
  };

  get appliedTheme(): ToggleButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const t = this.appliedTheme;
    return {
      background: t.backgroundColor,
      borderColor: this.isActive ? t.activeColor : t.inactiveColor,
      color: this.isActive ? t.activeTextColor : t.textColor
    };
  }

  handleToggle(event: MouseEvent): void {
    if (!this.disabled) {
      this.isActive = !this.isActive;
      this.toggled.emit(this.isActive);
    }
  }
}
