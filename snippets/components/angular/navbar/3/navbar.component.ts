import { Component, Input, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';

interface NavbarTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  accentColor: string;
}

interface MenuItem {
  label: string;
  route: string;
  icon?: string;
  children?: MenuItem[];
}

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule],
  template: `
    <nav [ngStyle]="navbarStyles" [class.scrolled]="isScrolled" role="navigation">
      <div class="navbar-inner" [ngStyle]="innerStyles">
        <!-- Brand -->
        <a href="/" class="brand" [ngStyle]="brandStyles">
          <div class="brand-logo" [ngStyle]="brandLogoStyles">
            <span>🚀</span>
          </div>
          <div class="brand-info">
            <span class="brand-name" [ngStyle]="brandNameStyles">{{ brandName }}</span>
            <span class="brand-tagline" [ngStyle]="brandTaglineStyles">{{ tagline }}</span>
          </div>
        </a>

        <!-- Main Navigation -->
        <div class="nav-links" [ngStyle]="navLinksStyles" [class.active]="isMobileMenuOpen">
          <div *ngFor="let item of menuItems; let i = index" class="nav-item">
            <a [href]="item.route"
               class="nav-link"
               [ngStyle]="getNavLinkStyles(i)"
               [class.active]="item.route === activeRoute"
               [attr.aria-current]="item.route === activeRoute ? 'page' : null"
               (mouseenter)="hoveredIndex = i"
               (mouseleave)="hoveredIndex = null">
              <span *ngIf="item.icon" class="nav-icon">{{ item.icon }}</span>
              <span class="nav-text">{{ item.label }}</span>
              <span *ngIf="item.children"
                    class="nav-arrow"
                    [attr.aria-expanded]="expandedItem === i"
                    (click)="toggleDropdown(i, $event)">
                ▼
              </span>
            </a>

            <div *ngIf="item.children && expandedItem === i"
                 class="dropdown-menu"
                 [ngStyle]="dropdownStyles">
              <a *ngFor="let child of item.children"
                 [href]="child.route"
                 class="dropdown-item"
                 [ngStyle]="dropdownItemStyles">
                {{ child.label }}
              </a>
            </div>
          </div>
        </div>

        <!-- Right Section -->
        <div class="nav-actions" [ngStyle]="actionsStyles">
          <!-- Search -->
          <div *ngIf="showSearch" class="search-box" [ngStyle]="searchBoxStyles">
            <button class="search-btn" [ngStyle]="searchBtnStyles" aria-label="Search">
              🔍
            </button>
            <input type="search"
                   placeholder="Search..."
                   [ngStyle]="searchInputStyles"
                   aria-label="Search input">
          </div>

          <!-- Notifications -->
          <div *ngIf="showNotifications" class="notification-wrapper">
            <button class="icon-btn" [ngStyle]="iconBtnStyles" aria-label="Notifications">
              <span class="icon">🔔</span>
              <span *ngIf="notificationCount > 0"
                    class="count-badge"
                    [ngStyle]="countBadgeStyles">
                {{ notificationCount }}
              </span>
            </button>
          </div>

          <!-- User Profile -->
          <div *ngIf="showUserProfile" class="user-menu" [ngStyle]="userMenuStyles">
            <button class="user-btn" [ngStyle]="userBtnStyles" aria-label="User menu">
              <img [src]="userAvatar" alt="{{ userName }}" class="user-avatar" [ngStyle]="userAvatarStyles">
              <div class="user-info">
                <span class="user-name-text">{{ userName }}</span>
                <span class="user-role">{{ userRole }}</span>
              </div>
              <span class="chevron">▼</span>
            </button>
          </div>
        </div>

        <!-- Mobile Toggle -->
        <button class="menu-toggle"
                [ngStyle]="menuToggleStyles"
                (click)="toggleMobileMenu()"
                [attr.aria-expanded]="isMobileMenuOpen"
                aria-label="Toggle navigation">
          <span [ngStyle]="hamburgerLineStyles"></span>
          <span [ngStyle]="hamburgerLineStyles"></span>
          <span [ngStyle]="hamburgerLineStyles"></span>
        </button>
      </div>
    </nav>
  `,
  styles: [`
    nav {
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    nav.scrolled {
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
    }
    .navbar-inner {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 2rem;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 1rem;
      text-decoration: none;
      transition: transform 0.3s;
    }
    .brand:hover {
      transform: translateX(4px);
    }
    .brand-logo {
      width: 52px;
      height: 52px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 14px;
      font-size: 1.75rem;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .brand-logo:hover {
      transform: scale(1.1) rotate(-5deg);
    }
    .brand-info {
      display: flex;
      flex-direction: column;
      gap: 0.125rem;
    }
    .brand-name {
      font-size: 1.25rem;
      font-weight: 800;
      line-height: 1.2;
    }
    .brand-tagline {
      font-size: 0.75rem;
      opacity: 0.7;
    }
    .nav-links {
      display: flex;
      gap: 0.5rem;
      align-items: center;
      flex: 1;
      justify-content: center;
    }
    .nav-item {
      position: relative;
    }
    .nav-link {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1.25rem;
      border-radius: 0.625rem;
      text-decoration: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
    }
    .nav-link::before {
      content: '';
      position: absolute;
      inset: 0;
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.3s ease;
    }
    .nav-link:hover::before {
      transform: scaleX(1);
    }
    .nav-link.active {
      font-weight: 600;
    }
    .dropdown-menu {
      position: absolute;
      top: 100%;
      left: 0;
      margin-top: 0.5rem;
      min-width: 200px;
      border-radius: 0.75rem;
      padding: 0.5rem;
      animation: fadeIn 0.2s;
      z-index: 100;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-8px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .dropdown-item {
      display: block;
      padding: 0.625rem 1rem;
      border-radius: 0.5rem;
      text-decoration: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .dropdown-item:hover {
      transform: translateX(4px);
    }
    .nav-actions {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }
    .search-box {
      position: relative;
      display: flex;
      align-items: center;
      border-radius: 2rem;
      overflow: hidden;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .search-btn {
      position: absolute;
      left: 0.75rem;
      background: none;
      border: none;
      cursor: pointer;
      font-size: 1rem;
      z-index: 1;
    }
    .icon-btn {
      position: relative;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.625rem;
      border-radius: 0.75rem;
      font-size: 1.25rem;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .icon-btn:hover {
      transform: scale(1.1);
    }
    .notification-wrapper {
      position: relative;
    }
    .count-badge {
      position: absolute;
      top: -4px;
      right: -4px;
      min-width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 10px;
      font-size: 0.7rem;
      font-weight: 700;
      animation: pulse 2s ease-in-out infinite;
    }
    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.15); }
    }
    .user-menu {
      position: relative;
    }
    .user-btn {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem 1rem;
      border-radius: 3rem;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .user-btn:hover {
      transform: translateY(-2px);
    }
    .user-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
    }
    .user-info {
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      gap: 0.125rem;
    }
    .user-name-text {
      font-size: 0.875rem;
      font-weight: 600;
      line-height: 1;
    }
    .user-role {
      font-size: 0.7rem;
      opacity: 0.7;
      line-height: 1;
    }
    .menu-toggle {
      display: none;
      flex-direction: column;
      gap: 0.375rem;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
    }
    @media (max-width: 768px) {
      .nav-links, .nav-actions {
        display: none;
      }
      .nav-links.active {
        display: flex;
        position: fixed;
        top: 80px;
        left: 0;
        right: 0;
        flex-direction: column;
        padding: 1.5rem;
      }
      .menu-toggle {
        display: flex;
      }
    }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'blur';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Quantum';
  @Input() tagline = 'Next Generation';
  @Input() menuItems: MenuItem[] = [
    { label: 'Home', route: '/', icon: '🏠' },
    { label: 'Products', route: '/products', icon: '📦', children: [
      { label: 'All Products', route: '/products/all' },
      { label: 'Featured', route: '/products/featured' }
    ]},
    { label: 'Services', route: '/services', icon: '⚙️' },
    { label: 'About', route: '/about', icon: 'ℹ️' }
  ];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 12;
  @Input() userName = 'Jordan';
  @Input() userRole = 'Admin';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=3';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#10b981',
    secondaryColor: '#06b6d4',
    backgroundColor: '#ffffff',
        backdropFilter: 'blur(10px)',
    textColor: '#111827',
    borderColor: '#e5e7eb',
    accentColor: '#ef4444'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;
  expandedItem: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 30;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  toggleDropdown(index: number, event: Event) {
    event.preventDefault();
    event.stopPropagation();
    this.expandedItem = this.expandedItem === index ? null : index;
  }

  get navbarStyles() {
    const variants = {
      solid: {
        backgroundColor: this.appliedTheme.backgroundColor,
        borderBottom: `1px solid ${this.appliedTheme.borderColor}`,
        boxShadow: '0 1px 3px rgba(0, 0, 0, 0.05)'
      },
      transparent: {
        backgroundColor: 'rgba(255, 255, 255, 0.85)',
        backdropFilter: 'blur(10px)',
        backdropFilter: 'blur(8px)',
        borderBottom: '1px solid rgba(0, 0, 0, 0.08)'
      },
      blur: {
        backgroundColor: 'rgba(255, 255, 255, 0.7)',
        backdropFilter: 'blur(10px)',
        backdropFilter: 'blur(16px) saturate(180%)',
        borderBottom: 'none',
        boxShadow: '0 4px 16px rgba(0, 0, 0, 0.08)'
      },
      gradient: {
        background: `linear-gradient(90deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
        borderBottom: 'none',
        color: '#ffffff'
      }
    };

    return {
      position: this.position,
      top: '0',
      left: '0',
      right: '0',
      zIndex: '1000',
      ...variants[this.variant]
    };
  }

  get innerStyles() {
    return {
      maxWidth: '1440px',
      margin: '0 auto',
      padding: '1rem 2rem'
    };
  }

  get brandStyles() {
    return {
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get brandLogoStyles() {
    return {
      background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
      boxShadow: `0 6px 20px ${this.appliedTheme.primaryColor}30`
    };
  }

  get brandNameStyles() {
    return {
      color: 'inherit'
    };
  }

  get brandTaglineStyles() {
    return {
      color: 'inherit'
    };
  }

  get navLinksStyles() {
    return {};
  }

  getNavLinkStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    const baseColor = this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor;

    return {
      color: baseColor,
      backgroundColor: isActive
        ? (this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.2)' : `${this.appliedTheme.primaryColor}15`)
        : isHovered
          ? (this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.1)' : `${this.appliedTheme.primaryColor}08`)
          : 'transparent'
    };
  }

  get dropdownStyles() {
    return {
      backgroundColor: this.appliedTheme.backgroundColor,
      boxShadow: '0 8px 24px rgba(0, 0, 0, 0.12)',
      border: `1px solid ${this.appliedTheme.borderColor}`
    };
  }

  get dropdownItemStyles() {
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: 'transparent',
        backdropFilter: 'blur(10px)'
    };
  }

  get actionsStyles() {
    return {};
  }

  get searchBoxStyles() {
    return {
      backgroundColor: this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.2)' : `${this.appliedTheme.primaryColor}08`,
      border: `1px solid ${this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.3)' : this.appliedTheme.borderColor}`
    };
  }

  get searchBtnStyles() {
    return {
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get searchInputStyles() {
    return {
      width: '200px',
      padding: '0.625rem 1rem 0.625rem 2.5rem',
      border: 'none',
      backgroundColor: 'transparent',
        backdropFilter: 'blur(10px)',
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor,
      outline: 'none'
    };
  }

  get iconBtnStyles() {
    return {
      backgroundColor: this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.15)' : `${this.appliedTheme.primaryColor}10`,
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get countBadgeStyles() {
    return {
      backgroundColor: this.appliedTheme.accentColor,
      color: '#ffffff'
    };
  }

  get userMenuStyles() {
    return {};
  }

  get userBtnStyles() {
    return {
      backgroundColor: this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.15)' : `${this.appliedTheme.primaryColor}10`,
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get userAvatarStyles() {
    return {
      border: `3px solid ${this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.primaryColor}`
    };
  }

  get menuToggleStyles() {
    return {
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get hamburgerLineStyles() {
    return {
      width: '28px',
      height: '3px',
      backgroundColor: 'currentColor',
        backdropFilter: 'blur(10px)',
      borderRadius: '2px',
      transition: 'all 0.3s'
    };
  }
}
