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

    <div class="sidebar minimal-sidebar"
         [class.open]="isOpen"
         [class.position-right]="position === 'right'"
         [ngStyle]="sidebarStyles"
         [@scaleAnimation]="isOpen ? 'open' : 'closed'">

      <div class="sidebar-header">
        <button class="close-btn" (click)="toggle()">×</button>
      </div>

      <nav class="sidebar-nav">
        <div class="category-label">Main Menu</div>
        <div *ngFor="let item of items" class="nav-item-wrapper">
          <div class="nav-item"
               [class.active]="item.id === activeItemId"
               [class.has-children]="item.children && item.children.length > 0"
               (click)="onItemClick(item)"
               [ngStyle]="getItemStyles(item)">
            <div class="item-left">
              <span class="icon">{{ item.icon }}</span>
              <span class="label">{{ item.label }}</span>
            </div>
            <span *ngIf="item.children && item.children.length > 0" class="arrow">
              {{ expandedItems[item.id] ? '⌄' : '›' }}
            </span>
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
    </div>
  `,
  styles: [`
    .sidebar-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.4);
      z-index: 998;
    }

    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      height: 100vh;
      overflow-y: auto;
      z-index: 999;
      box-shadow: 4px 0 24px rgba(0, 0, 0, 0.12);
      transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    }

    .minimal-sidebar {
      background: #ffffff;
    }

    .sidebar.position-right {
      left: auto;
      right: 0;
      box-shadow: -4px 0 24px rgba(0, 0, 0, 0.12);
    }

    .sidebar-header {
      padding: 1.5rem;
      display: flex;
      justify-content: flex-end;
      border-bottom: 2px solid #f3f4f6;
    }

    .close-btn {
      background: none;
      border: none;
      font-size: 2.5rem;
      cursor: pointer;
      color: #6b7280;
      line-height: 1;
      padding: 0;
      width: 2rem;
      height: 2rem;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 0.25rem;
      transition: all 0.2s;
    }

    .close-btn:hover {
      background: #f3f4f6;
      color: #111827;
    }

    .sidebar-nav {
      padding: 1.5rem 0;
    }

    .category-label {
      padding: 0.5rem 1.5rem;
      font-size: 0.75rem;
      font-weight: 700;
      color: #9ca3af;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 0.5rem;
    }

    .nav-item-wrapper {
      margin-bottom: 0.125rem;
    }

    .nav-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1rem 1.5rem;
      cursor: pointer;
      transition: all 0.2s;
      position: relative;
      border-left: 3px solid transparent;
    }

    .item-left {
      display: flex;
      align-items: center;
    }

    .nav-item.child {
      padding-left: 3.5rem;
      font-size: 0.9rem;
    }

    .nav-item:hover {
      background: #f9fafb;
      border-left-color: #e5e7eb;
    }

    .nav-item.active {
      background: #eff6ff;
      border-left-color: #3b82f6;
      font-weight: 600;
      color: #1e40af;
    }

    .nav-item .icon {
      margin-right: 0.875rem;
      font-size: 1.25rem;
      width: 1.5rem;
      text-align: center;
    }

    .nav-item .label {
      font-weight: 500;
      font-size: 0.95rem;
    }

    .nav-item .arrow {
      font-size: 1.25rem;
      color: #9ca3af;
    }

    .submenu {
      overflow: hidden;
      background: #fafbfc;
    }

    @media (max-width: 768px) {
      .sidebar {
        width: 100% !important;
        max-width: 320px;
      }
    }
  `],
  animations: [
    trigger('scaleAnimation', [
      state('open', style({ transform: 'translateX(0) scale(1)', opacity: 1 })),
      state('closed', style({ transform: 'translateX(-100%) scale(0.95)', opacity: 0 })),
      transition('open <=> closed', animate('300ms cubic-bezier(0.68, -0.55, 0.265, 1.55)'))
    ]),
    trigger('fadeAnimation', [
      transition(':enter', [
        style({ opacity: 0 }),
        animate('250ms', style({ opacity: 1 }))
      ]),
      transition(':leave', [
        animate('250ms', style({ opacity: 0 }))
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
    backgroundColor: '#ffffff',
    textColor: '#111827',
    activeColor: '#eff6ff',
    hoverColor: '#f9fafb',
    borderColor: '#f3f4f6'
  };

  get appliedTheme(): SidebarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get sidebarStyles() {
    return {
      width: this.width,
      backgroundColor: this.appliedTheme.backgroundColor,
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
      color: isActive ? '#1e40af' : this.appliedTheme.textColor
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
