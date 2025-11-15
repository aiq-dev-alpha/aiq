import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-sidebar',
  template: `
  <div
  [ngStyle]="styles"
  (click)="handleClick()"
  (mouseenter)="hovered = true"
  (mouseleave)="hovered = false"
  class="sidebar-container">
  <ng-content></ng-content>
  <span *ngIf="active" class="indicator">✓</span>
  </div>
  `,
  styles: [`
  .sidebar-container {
  cursor: pointer;
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
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
export class SidebarComponent {
  @Input() theme: Partial<Theme> = {};
  @Input() variant = 'default';
  @Output() interact = new EventEmitter<string>();
  active = false;
  hovered = false;
  private defaultTheme: Theme = {
  primaryColor: '#14b8a6',
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
  padding: '17px 25px',
  background: this.active ? t.primaryColor : t.backgroundColor,
  color: this.active ? '#ffffff' : t.textColor,
  border: `3px solid ${this.hovered ? t.primaryColor : t.borderColor}`,
  borderRadius: '13px',
  fontSize: '15px',
  fontWeight: 700,
  boxShadow: this.hovered ? `0 13px 21px ${t.primaryColor}40` : '0 2px 8px rgba(0,0,0,0.08)',
  transform: this.hovered ? 'translateY(-3px)' : 'translateY(0)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '8px'
  };
  }
  handleClick(): void {
  this.active = !this.active;
  this.interact.emit('sidebar_v5');
  }
}
