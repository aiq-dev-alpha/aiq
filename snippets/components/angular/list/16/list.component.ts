import { Component, Input, Output, EventEmitter } from '@angular/core';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

@Component({
  selector: 'app-list',
  template: `
    <div
      [ngStyle]="styles"
      (click)="handleClick()"
      (mouseenter)="hovered = true"
      (mouseleave)="hovered = false"
      class="container">
      <ng-content></ng-content>
      <span *ngIf="active" class="indicator">✓</span>
    </div>
  `,
  styles: [`
    .container {
      cursor: pointer;
      transition: all 250ms cubic-bezier(0.4, 0, 0.2, 1);
      user-select: none;
      position: relative;
    }
    .indicator {
      margin-left: 8px;
      opacity: 0.7;
      font-size: 12px;
    }
  `]
})
export class ListComponent {
  @Input() theme: Partial<Theme> = {};
  @Input() variant = 'default';
  @Output() interact = new EventEmitter<string>();

  active = false;
  hovered = false;

  private defaultTheme: Theme = {
    primaryColor: '#06b6d4',
    backgroundColor: '#ffffff',
    textColor: '#1f2937',
    borderColor: '#e5e7eb'
  };

  get appliedTheme(): Theme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get styles() {
    const t = this.appliedTheme;
    const borderWidth = this.hovered ? 3 : 1;
    return {
      padding: '18px 32px',
      background: this.active ? t.primaryColor : t.backgroundColor,
      color: this.active ? '#ffffff' : t.textColor,
      border: `${borderWidth}px solid ${this.hovered ? t.primaryColor : t.borderColor}`,
      borderRadius: '10px',
      fontSize: '15px',
      fontWeight: 500,
      boxShadow: this.hovered ? `0 12px 16px ${t.primaryColor}30` : '0 2px 6px rgba(0,0,0,0.08)',
      transform: this.hovered ? 'translateY(-3px)' : 'translateY(0)',
      display: 'inline-flex',
      alignItems: 'center',
      gap: '8px'
    };
  }

  handleClick(): void {
    this.active = !this.active;
    this.interact.emit('list_v16');
  }
}