import { Component, Input, Output, EventEmitter } from '@angular/core';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

@Component({
  selector: 'app-panel',
  template: `
    <div
      [ngStyle]="styles"
      (click)="handleClick()"
      (mouseenter)="hovered = true"
      (mouseleave)="hovered = false"
      class="panel-container">
      <ng-content></ng-content>
      <span *ngIf="active" class="indicator">✓</span>
    </div>
  `,
  styles: [`
    .panel-container {
      cursor: pointer;
      transition: all 340ms cubic-bezier(0.4, 0, 0.2, 1);
      user-select: none;
      position: relative;
    }
    .indicator {
      margin-left: 8px;
      opacity: 0.8;
      font-size: 14px;
    }
  `]
})
export class PanelComponent {
  @Input() theme: Partial<Theme> = {};
  @Input() variant = 'default';
  @Output() interact = new EventEmitter<string>();

  active = false;
  hovered = false;

  private defaultTheme: Theme = {
    primaryColor: '#a855f7',
    backgroundColor: '#ffffff',
    textColor: '#1f2937',
    borderColor: '#e5e7eb'
  };

  get appliedTheme(): Theme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get styles() {
    const t = this.appliedTheme;
    return {
      padding: '13px 29px',
      background: this.active ? t.primaryColor : t.backgroundColor,
      color: this.active ? '#ffffff' : t.textColor,
      border: `3px solid ${this.hovered ? t.primaryColor : t.borderColor}`,
      borderRadius: '11px',
      fontSize: '15px',
      fontWeight: 500,
      boxShadow: this.hovered ? `0 9px 25px ${t.primaryColor}40` : '0 2px 8px rgba(0,0,0,0.08)',
      transform: this.hovered ? 'translateY(-3px)' : 'translateY(0)',
      display: 'inline-flex',
      alignItems: 'center',
      gap: '8px'
    };
  }

  handleClick(): void {
    this.active = !this.active;
    this.interact.emit('panel_v9');
  }
}