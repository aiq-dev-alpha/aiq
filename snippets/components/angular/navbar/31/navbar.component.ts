import { Component, Input, Output, EventEmitter } from '@angular/core';

interface NavbarTheme {
  background: string;
  text: string;
  accent: string;
  border: string;
  hover: string;
}

interface NavItem {
  label: string;
  path?: string;
  icon?: string;
  active?: boolean;
  badge?: string | number;
  children?: NavItem[];
}

type NavbarPosition = 'fixed' | 'sticky' | 'static';
type NavbarVariant = 'solid' | 'transparent' | 'blur' | 'bordered';

@Component({
  selector: 'app-navbar',
  template: `
    <nav [ngStyle]="navbarStyles" [ngClass]="navbarClasses" class="navbar">
      <div class="navbar-container" [ngStyle]="containerStyles">
        <div class="navbar-brand" (click)="onBrandClick()">
          <img *ngIf="logo" [src]="logo" [alt]="brandName" class="brand-logo" />
          <span *ngIf="brandName" class="brand-name">{{ brandName }}</span>
        </div>

        <button *ngIf="showMobileMenu" class="mobile-toggle" (click)="toggleMobile()" [ngStyle]="toggleStyles">
          <span class="toggle-icon">{{ mobileMenuOpen ? '✕' : '☰' }}</span>
        </button>

        <div class="navbar-menu" [ngClass]="{'mobile-open': mobileMenuOpen}">
          <div class="navbar-start">
            <div *ngFor="let item of startItems" class="nav-item" [ngStyle]="navItemStyles(item)" (click)="onItemClick(item)">
              <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
              <span class="item-label">{{ item.label }}</span>
              <span *ngIf="item.badge" class="item-badge" [ngStyle]="badgeStyles">{{ item.badge }}</span>
            </div>
          </div>

          <div class="navbar-end">
            <div *ngFor="let item of endItems" class="nav-item" [ngStyle]="navItemStyles(item)" (click)="onItemClick(item)">
              <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
              <span class="item-label">{{ item.label }}</span>
              <span *ngIf="item.badge" class="item-badge" [ngStyle]="badgeStyles">{{ item.badge }}</span>
            </div>
          </div>
        </div>

        <div *ngIf="showSearch" class="navbar-search">
          <input type="search" placeholder="Search..." [ngStyle]="searchStyles" />
        </div>

        <div *ngIf="showActions" class="navbar-actions">
          <ng-content select="[navbarActions]"></ng-content>
        </div>
      </div>
    </nav>
  `,
  styles: [`
    .navbar {
      width: 100%;
      z-index: 100;
      font-family: system-ui, -apple-system, sans-serif;
    }
    .navbar.fixed {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
    }
    .navbar.sticky {
      position: sticky;
      top: 0;
    }
    .navbar.static {
      position: static;
    }
    .navbar-container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
      padding: 0 1rem;
      max-width: 1280px;
      margin: 0 auto;
    }
    .navbar-brand {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      cursor: pointer;
      font-weight: 700;
      font-size: 1.25rem;
    }
    .brand-logo {
      height: 40px;
      width: auto;
    }
    .mobile-toggle {
      display: none;
      background: none;
      border: none;
      font-size: 1.5rem;
      cursor: pointer;
      padding: 0.5rem;
      border-radius: 6px;
    }
    .navbar-menu {
      display: flex;
      align-items: center;
      flex: 1;
      gap: 2rem;
    }
    .navbar-start,
    .navbar-end {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .navbar-start {
      flex: 1;
    }
    .nav-item {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1rem;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s ease;
      position: relative;
      font-size: 0.875rem;
      font-weight: 500;
    }
    .item-icon {
      font-size: 1.125rem;
    }
    .item-badge {
      position: absolute;
      top: 4px;
      right: 4px;
      padding: 2px 6px;
      border-radius: 10px;
      font-size: 10px;
      font-weight: 700;
      min-width: 18px;
      text-align: center;
    }
    .navbar-search input {
      border: none;
      outline: none;
      padding: 0.5rem 1rem;
      border-radius: 20px;
      font-size: 0.875rem;
      width: 200px;
      transition: all 0.2s ease;
    }
    .navbar-search input:focus {
      width: 300px;
    }
    .navbar-actions {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }
    @media (max-width: 768px) {
      .mobile-toggle {
        display: block;
      }
      .navbar-menu {
        position: fixed;
        top: 60px;
        left: 0;
        right: 0;
        flex-direction: column;
        align-items: stretch;
        padding: 1rem;
        display: none;
      }
      .navbar-menu.mobile-open {
        display: flex;
      }
      .navbar-start,
      .navbar-end {
        flex-direction: column;
        width: 100%;
      }
    }
  `]
})
export class NavbarComponent {
  @Input() variant: NavbarVariant = 'solid';
  @Input() position: NavbarPosition = 'static';
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() logo?: string;
  @Input() brandName?: string;
  @Input() startItems: NavItem[] = [];
  @Input() endItems: NavItem[] = [];
  @Input() showSearch = false;
  @Input() showActions = false;
  @Input() showMobileMenu = true;
  @Output() brandClick = new EventEmitter<void>();
  @Output() itemClick = new EventEmitter<NavItem>();

  mobileMenuOpen = false;

  private defaultTheme: NavbarTheme = {
    background: '#ffffff',
    text: '#111827',
    accent: '#3b82f6',
    border: '#e5e7eb',
    hover: '#f3f4f6'
  };

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get navbarClasses(): string[] {
    return [this.position, `variant-${this.variant}`];
  }

  get navbarStyles(): Record<string, string> {
    const t = this.appliedTheme;
    const variantMap = {
      solid: {
        background: t.background,
        borderBottom: `1px solid ${t.border}`,
        backdropFilter: 'none'
      },
      transparent: {
        background: 'transparent',
        borderBottom: 'none',
        backdropFilter: 'none'
      },
      blur: {
        background: `${t.background}dd`,
        borderBottom: `1px solid ${t.border}80`,
        backdropFilter: 'blur(12px)'
      },
      bordered: {
        background: t.background,
        borderBottom: `2px solid ${t.accent}`,
        backdropFilter: 'none'
      }
    };

    return {
      ...variantMap[this.variant],
      color: t.text
    };
  }

  get containerStyles(): Record<string, string> {
    return {
      minHeight: '60px'
    };
  }

  get toggleStyles(): Record<string, string> {
    return {
      color: this.appliedTheme.text
    };
  }

  navItemStyles(item: NavItem): Record<string, string> {
    const t = this.appliedTheme;
    return {
      color: item.active ? t.accent : t.text,
      background: item.active ? `${t.accent}15` : 'transparent',
      fontWeight: item.active ? '600' : '500'
    };
  }

  get badgeStyles(): Record<string, string> {
    return {
      background: this.appliedTheme.accent,
      color: '#ffffff'
    };
  }

  get searchStyles(): Record<string, string> {
    const t = this.appliedTheme;
    return {
      background: `${t.border}40`,
      color: t.text
    };
  }

  onBrandClick(): void {
    this.brandClick.emit();
  }

  onItemClick(item: NavItem): void {
    this.itemClick.emit(item);
    if (this.mobileMenuOpen) {
      this.mobileMenuOpen = false;
    }
  }

  toggleMobile(): void {
    this.mobileMenuOpen = !this.mobileMenuOpen;
  }
}
