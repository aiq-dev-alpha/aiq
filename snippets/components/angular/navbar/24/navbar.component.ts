import { Component, Input, Output, EventEmitter } from '@angular/core';
interface NavItem {
  label: string;
  href: string;
  active?: boolean;
}
@Component({
  selector: 'app-navbar',
  template: `
  <nav class="navbar">
  <div class="nav-brand">{{ brand }}</div>
  <ul class="nav-menu">
  <li *ngFor="let item of items"
  [class.active]="item.active"
  (click)="onNavClick(item)"
  class="nav-item">
  {{ item.label }}
  </li>
  </ul>
  <div class="nav-actions">
  <ng-content></ng-content>
  </div>
  </nav>
  `,
  styles: [`
  .navbar {
  display: flex;
  align-items: center;
  gap: 32px;
  padding: 16px 32px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  }
  .nav-brand {
  font-size: 24px;
  font-weight: 800;
  letter-spacing: -0.5px;
  }
  .nav-menu {
  display: flex;
  gap: 24px;
  list-style: none;
  margin: 0;
  padding: 0;
  flex: 1;
  }
  .nav-item {
  padding: 8px 16px;
  cursor: pointer;
  border-radius: 8px;
  transition: all 200ms;
  font-weight: 500;
  }
  .nav-item:hover {
  background-color: rgba(255,255,255,0.2);
  }
  .nav-item.active {
  background-color: rgba(255,255,255,0.3);
  font-weight: 700;
  }
  .nav-actions {
  display: flex;
  gap: 12px;
  }
  `]
})
export class NavbarComponent {
  @Input() brand = 'Brand';
  @Input() items: NavItem[] = [];
  @Output() navClick = new EventEmitter<NavItem>();
  onNavClick(item: NavItem): void {
  this.navClick.emit(item);
  }
}
