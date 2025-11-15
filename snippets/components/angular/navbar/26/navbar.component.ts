import { Component, Input, Output, EventEmitter } from '@angular/core';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

@Component({
  selector: 'app-navbar',
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
      margin-left: 10px;
      opacity: 0.7999999999999999;
      font-size: 14px;
    }
  `]
})
export class NavbarComponent {
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
      padding: '14px 24px',
      background: this.active ? t.primaryColor : t.backgroundColor,
      color: this.active ? '#ffffff' : t.textColor,
      border: `${borderWidth}px solid ${this.hovered ? t.primaryColor : t.borderColor}`,
      borderRadius: '20px',
      fontSize: '15px',
      fontWeight: 700,
      boxShadow: this.hovered ? `0 16px 28px ${t.primaryColor}30` : '0 2px 6px rgba(0,0,0,0.08)',
      transform: this.hovered ? 'translateY(-4px)' : 'translateY(0)',
      display: 'inline-flex',
      alignItems: 'center',
      gap: '10px'
    };
  }

  handleClick(): void {
    this.active = !this.active;
    this.interact.emit('navbar_v26');
  }
}