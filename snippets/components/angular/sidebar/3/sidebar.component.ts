import { Component, Input, Output, EventEmitter } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { CommonModule } from '@angular/common';

export interface SidebarItem {
  id: string;
  label: string;
  icon: string;
  route: string;
  children?: SidebarItem[];
}

export interface SidebarTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  activeColor: string;
  hoverColor: string;
  borderColor: string;
}

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule],
  template: `
  <div class="sidebar-overlay"
  *ngIf="isOpen && variant === 'overlay'"
  (click)="toggle()"
  [@fadeAnimation]></div>

  <div class="sidebar modern-sidebar"
  [class.open]="isOpen"
  [class.position-right]="position === 'right'"
  [ngStyle]="sidebarStyles"
  [@slideAnimation]="isOpen ? 'open' : 'closed'">

  <div class="sidebar-header">
  <div class="logo-section">
  <div class="logo">⚡</div>
  <div class="company-name">TechCorp</div>
  </div>
  </div>

  <div class="search-box">
  <span class="search-icon">🔍</span>
  <input type="text" placeholder="Search..." />
  </div>

  <nav class="sidebar-nav">
  <div *ngFor="let item of items" class="nav-item-wrapper">
  <div class="nav-item"
  [class.active]="item.id === activeItemId"
  [class.has-children]="item.children && item.children.length > 0"
  (click)="onItemClick(item)"
  [ngStyle]="getItemStyles(item)">
  <span class="icon">{{ item.icon }}</span>
  <div class="item-content">
  <span class="label">{{ item.label }}</span>
  <span *ngIf="item.children && item.children.length > 0" class="arrow">
  {{ expandedItems[item.id] ? '−' : '+' }}
  </span>
  </div>
  </div>

  <div *ngIf="item.children && expandedItems[item.id]"
  class="submenu"
  [@expandAnimation]>
  <div *ngFor="let child of item.children"
  class="nav-item child"
  [class.active]="child.id === activeItemId"
  (click)="onItemClick(child); $event.stopPropagation()"
  [ngStyle]="getItemStyles(child)">
  <span class="icon">{{ child.icon }}</span>
  <span class="label">{{ child.label }}</span>
  </div>
  </div>
  </div>
  </nav>

  <div class="sidebar-footer">
  <button class="upgrade-btn">
  ✨ Upgrade to Pro
  </button>
  </div>
  </div>
  `,
  styles: [`
  .sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  z-index: 998;
  }

  .sidebar {
  position: fixed;
  top: 0;
  left: 0;
  height: 100vh;
  overflow-y: auto;
  z-index: 999;
  box-shadow: 2px 0 12px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  display: flex;
  flex-direction: column;
  }

  .modern-sidebar {
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  }

  .sidebar.position-right {
  left: auto;
  right: 0;
  box-shadow: -2px 0 12px rgba(0, 0, 0, 0.1);
  }

  .sidebar-header {
  padding: 2rem 1.5rem;
  border-bottom: 1px solid rgba(148, 163, 184, 0.1);
  }

  .logo-section {
  display: flex;
  align-items: center;
  gap: 1rem;
  }

  .logo {
  width: 3rem;
  height: 3rem;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.75rem;
  }

  .company-name {
  font-size: 1.25rem;
  font-weight: 700;
  color: #f1f5f9;
  letter-spacing: 0.5px;
  }

  .search-box {
  margin: 1rem 1.5rem;
  position: relative;
  display: flex;
  align-items: center;
  background: rgba(148, 163, 184, 0.1);
  border-radius: 0.5rem;
  padding: 0.75rem 1rem;
  }

  .search-icon {
  margin-right: 0.5rem;
  opacity: 0.6;
  }

  .search-box input {
  background: none;
  border: none;
  outline: none;
  color: #f1f5f9;
  flex: 1;
  font-size: 0.95rem;
  }

  .search-box input::placeholder {
  color: rgba(241, 245, 249, 0.5);
  }

  .sidebar-nav {
  padding: 1rem 0;
  flex: 1;
  overflow-y: auto;
  }

  .nav-item-wrapper {
  margin-bottom: 0.25rem;
  }

  .nav-item {
  display: flex;
  align-items: center;
  padding: 0.875rem 1.5rem;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  }

  .nav-item.child {
  padding-left: 3.5rem;
  font-size: 0.9rem;
  }

  .nav-item:hover {
  background: rgba(148, 163, 184, 0.1);
  }

  .nav-item.active {
  background: rgba(59, 130, 246, 0.2);
  border-left: 3px solid #3b82f6;
  font-weight: 600;
  }

  .nav-item .icon {
  margin-right: 1rem;
  font-size: 1.25rem;
  width: 1.5rem;
  text-align: center;
  }

  .item-content {
  display: flex;
  align-items: center;
  flex: 1;
  justify-content: space-between;
  }

  .nav-item .label {
  flex: 1;
  font-weight: 500;
  }

  .nav-item .arrow {
  font-size: 1.25rem;
  margin-left: auto;
  font-weight: 300;
  }

  .submenu {
  overflow: hidden;
  }

  .sidebar-footer {
  padding: 1.5rem;
  border-top: 1px solid rgba(148, 163, 184, 0.1);
  }

  .upgrade-btn {
  width: 100%;
  padding: 0.875rem;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  border: none;
  border-radius: 0.5rem;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.2s;
  }

  .upgrade-btn:hover {
  transform: translateY(-2px);
  }

  @media (max-width: 768px) {
  .sidebar {
  width: 100% !important;
  max-width: 320px;
  }
  }
  
  
  @keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
  }
  
  @keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
  }
  
  @keyframes scaleIn {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
  }
  `],
  animations: [
  trigger('slideAnimation', [
  state('open', style({ transform: 'translateX(0)' })),
  state('closed', style({ transform: 'translateX(-100%)' })),
  transition('open <=> closed', animate('300ms ease-in-out'))
  ]),
  trigger('fadeAnimation', [
  transition(':enter', [
  style({ opacity: 0 }),
  animate('300ms', style({ opacity: 1 }))
  ]),
  transition(':leave', [
  animate('300ms', style({ opacity: 0 }))
  ])
  ]),
  trigger('expandAnimation', [
  transition(':enter', [
  style({ height: 0, opacity: 0 }),
  animate('200ms ease-out', style({ height: '*', opacity: 1 }))
  ]),
  transition(':leave', [
  animate('200ms ease-in', style({ height: 0, opacity: 0 }))
  ])
  ])
  ]
})
export class SidebarComponent {
  @Input() items: SidebarItem[] = [];
  @Input() theme: Partial<SidebarTheme> = {};
  @Input() variant: 'overlay' | 'push' | 'mini' | 'responsive' | 'drawer' = 'overlay';
  @Input() isOpen: boolean = true;
  @Input() position: 'left' | 'right' = 'left';
  @Input() width: string = '280px';

  @Output() itemClicked = new EventEmitter<SidebarItem>();
  @Output() toggleSidebar = new EventEmitter<boolean>();

  activeItemId: string = '';
  expandedItems: { [key: string]: boolean } = {};

  private defaultTheme: SidebarTheme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#0f172a',
  backdropFilter: 'blur(10px)',
  textColor: '#f1f5f9',
  activeColor: 'rgba(59, 130, 246, 0.2)',
  hoverColor: 'rgba(148, 163, 184, 0.1)',
  borderColor: 'rgba(148, 163, 184, 0.1)'
  };

  get appliedTheme(): SidebarTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  get sidebarStyles() {
  return {
  width: this.width,
  color: this.appliedTheme.textColor
  };
  }

  get buttonStyles() {
  return {
  color: this.appliedTheme.textColor
  };
  }

  getItemStyles(item: SidebarItem) {
  const isActive = item.id === this.activeItemId;
  return {
  backgroundColor: isActive ? this.appliedTheme.activeColor : 'transparent',
  color: this.appliedTheme.textColor
  };
  }

  onItemClick(item: SidebarItem) {
  if (item.children && item.children.length > 0) {
  this.expandedItems[item.id] = !this.expandedItems[item.id];
  } else {
  this.activeItemId = item.id;
  this.itemClicked.emit(item);
  }
  }

  toggle() {
  this.isOpen = !this.isOpen;
  this.toggleSidebar.emit(this.isOpen);
  }
}
