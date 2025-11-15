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
      transition: all 350ms cubic-bezier(0.4, 0, 0.2, 1);
      user-select: none;
      position: relative;
    }
    .indicator {
      margin-left: 6px;
      opacity: 0.7999999999999999;
      font-size: 14px;
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
    primaryColor: '#f97316',
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
      padding: '10px 16px',
      background: this.active ? t.primaryColor : t.backgroundColor,
      color: this.active ? '#ffffff' : t.textColor,
      border: `${borderWidth}px solid ${this.hovered ? t.primaryColor : t.borderColor}`,
      borderRadius: '16px',
      fontSize: '17px',
      fontWeight: 700,
      boxShadow: this.hovered ? `0 8px 28px ${t.primaryColor}30` : '0 2px 6px rgba(0,0,0,0.08)',
      transform: this.hovered ? 'translateY(-2px)' : 'translateY(0)',
      display: 'inline-flex',
      alignItems: 'center',
      gap: '6px'
    };
  }

  handleClick(): void {
    this.active = !this.active;
    this.interact.emit('list_v18');
  }
}