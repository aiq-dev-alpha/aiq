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

    <div class="sidebar variant-20"
         [class.open]="isOpen"
         [class.position-right]="position === 'right'"
         [ngStyle]="sidebarStyles"
         [@slideAnimation]="isOpen ? 'open' : 'closed'">

      <div class="sidebar-header">
        <div class="brand">
          <span class="brand-icon">💚</span>
          <h2 [ngStyle]="{ color: appliedTheme.textColor }">Emerald</h2>
        </div>
        <button class="toggle-btn" (click)="toggle()">
          <span>{{ isOpen ? '×' : '☰' }}</span>
        </button>
      </div>

      <nav class="sidebar-nav">
        <div *ngFor="let item of items" class="nav-item-wrapper">
          <div class="nav-item"
               [class.active]="item.id === activeItemId"
               [class.has-children]="item.children && item.children.length > 0"
               (click)="onItemClick(item)"
               [ngStyle]="getItemStyles(item)">
            <span class="icon">{{ item.icon }}</span>
            <span class="label">{{ item.label }}</span>
            <span *ngIf="item.children && item.children.length > 0" class="arrow">
              {{ expandedItems[item.id] ? '▽' : '▷' }}
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
      background: rgba(0, 0, 0, 0.6);
      z-index: 998;
    }

    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      height: 100vh;
      overflow-y: auto;
      z-index: 999;
      box-shadow: 4px 0 20px rgba(0, 0, 0, 0.2);
      transition: transform 0.3s ease;
    }

    .variant-20 {
      background: linear-gradient(180deg, #064e3b 0%, #065f46 100%);
    }

    .sidebar.position-right {
      left: auto;
      right: 0;
      box-shadow: -4px 0 20px rgba(0, 0, 0, 0.2);
    }

    .sidebar-header {
      padding: 2rem 1.5rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .brand-icon {
      font-size: 2rem;
    }

    .sidebar-header h2 {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 700;
    }

    .toggle-btn {
      background: rgba(255, 255, 255, 0.1);
      border: none;
      font-size: 1.25rem;
      cursor: pointer;
      padding: 0.5rem 0.75rem;
      border-radius: 0.5rem;
      transition: all 0.2s;
      color: inherit;
    }

    .toggle-btn:hover {
      background: rgba(255, 255, 255, 0.2);
    }

    .sidebar-nav {
      padding: 1.5rem 0;
    }

    .nav-item-wrapper {
      margin-bottom: 0.25rem;
    }

    .nav-item {
      display: flex;
      align-items: center;
      padding: 1rem 1.5rem;
      cursor: pointer;
      transition: all 0.2s;
      position: relative;
    }

    .nav-item.child {
      padding-left: 3.5rem;
      font-size: 0.9rem;
    }

    .nav-item:hover {
      background: rgba(255, 255, 255, 0.1);
    }

    .nav-item.active {
      background: rgba(255, 255, 255, 0.2);
      font-weight: 600;
    }

    .nav-item .icon {
      margin-right: 1rem;
      font-size: 1.25rem;
      width: 1.5rem;
      text-align: center;
    }

    .nav-item .label {
      flex: 1;
      font-weight: 500;
    }

    .nav-item .arrow {
      font-size: 1rem;
      margin-left: auto;
    }

    .submenu {
      overflow: hidden;
    }

    @media (max-width: 768px) {
      .sidebar {
        width: 100% !important;
        max-width: 320px;
      }
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
    primaryColor: '#10b981',
    backgroundColor: '#064e3b',
    textColor: '#d1fae5',
    activeColor: 'rgba(16, 185, 129, 0.25)',
    hoverColor: 'rgba(16, 185, 129, 0.15)',
    borderColor: 'rgba(16, 185, 129, 0.3)'
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
