// Link Button - Styled like a hyperlink with underline animation
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface LinkButtonTheme {
  linkColor: string;
  hoverColor: string;
  visitedColor: string;
  underlineColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <button
      class="link-btn"
      [ngStyle]="linkStyles"
      [class.underlined]="underline !== 'none'"
      [class.external]="external"
      [class.visited]="visited"
      [disabled]="disabled"
      (click)="handleClick($event)">
      <ng-content></ng-content>
      <span *ngIf="external" class="external-icon">↗</span>
    </button>
  `,
  styles: [`
    .link-btn {
      background: none;
      border: none;
      cursor: pointer;
      font-family: inherit;
      font-size: inherit;
      font-weight: 500;
      padding: 0;
      position: relative;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      transition: all 0.2s;
    }

    .link-btn:disabled {
      cursor: not-allowed;
      opacity: 0.5;
    }

    .link-btn.underlined::after {
      content: '';
      position: absolute;
      left: 0;
      right: 0;
      bottom: -2px;
      height: 1px;
      background: currentColor;
      transform: scaleX(0);
      transform-origin: right;
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .link-btn.underlined:hover:not(:disabled)::after {
      transform: scaleX(1);
      transform-origin: left;
    }

    .link-btn:hover:not(:disabled) {
      filter: brightness(1.2);
    }

    .link-btn:active:not(:disabled) {
      transform: translateY(1px);
    }

    .external-icon {
      font-size: 0.85em;
      opacity: 0.7;
    }

    .link-btn.visited {
      opacity: 0.7;
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<LinkButtonTheme> = {};
  @Input() underline: 'none' | 'hover' | 'always' = 'hover';
  @Input() external = false;
  @Input() visited = false;
  @Input() disabled = false;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private defaultTheme: LinkButtonTheme = {
    linkColor: '#3b82f6',
    hoverColor: '#2563eb',
    visitedColor: '#7c3aed',
    underlineColor: '#3b82f6'
  };

  get appliedTheme(): LinkButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get linkStyles() {
    const t = this.appliedTheme;
    return {
      color: this.visited ? t.visitedColor : t.linkColor,
      textDecoration: this.underline === 'always' ? 'underline' : 'none'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled) {
      this.visited = true;
      this.clicked.emit(event);
    }
  }
}
