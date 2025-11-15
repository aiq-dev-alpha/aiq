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
  badge?: number;
}

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule],
  template: `
    <nav [ngStyle]="navbarStyles" [class.scrolled]="isScrolled" role="navigation">
      <div class="navbar-container" [ngStyle]="containerStyles">
        <!-- Logo Section -->
        <div class="navbar-brand" [ngStyle]="brandStyles">
          <div class="logo-wrapper" [ngStyle]="logoWrapperStyles">
            <span class="logo-icon">⚡</span>
          </div>
          <span class="brand-text" [ngStyle]="brandTextStyles">{{ brandName }}</span>
        </div>

        <!-- Navigation Links -->
        <div class="navbar-menu" [ngStyle]="menuStyles" [class.active]="isMobileMenuOpen">
          <a *ngFor="let item of menuItems; let i = index"
             [href]="item.route"
             class="menu-item"
             [ngStyle]="getMenuItemStyles(i)"
             [class.active]="item.route === activeRoute"
             [attr.aria-current]="item.route === activeRoute ? 'page' : null"
             (mouseenter)="hoveredIndex = i"
             (mouseleave)="hoveredIndex = null">
            <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
            <span>{{ item.label }}</span>
            <span *ngIf="item.badge" class="item-badge" [ngStyle]="itemBadgeStyles">{{ item.badge }}</span>
          </a>
        </div>

        <!-- Search & Actions -->
        <div class="navbar-end" [ngStyle]="endStyles">
          <div *ngIf="showSearch" class="search-container" [ngStyle]="searchContainerStyles">
            <span class="search-icon">🔍</span>
            <input type="search"
                   placeholder="Search..."
                   [ngStyle]="searchInputStyles"
                   aria-label="Search">
          </div>

          <div class="action-buttons" [ngStyle]="actionButtonsStyles">
            <button *ngIf="showNotifications"
                    class="action-btn notification-btn"
                    [ngStyle]="actionBtnStyles"
                    aria-label="Notifications">
              <span class="btn-icon">🔔</span>
              <span *ngIf="notificationCount > 0" class="notification-badge" [ngStyle]="notificationBadgeStyles">
                {{ notificationCount }}
              </span>
            </button>

            <button *ngIf="showUserProfile"
                    class="action-btn profile-btn"
                    [ngStyle]="profileBtnStyles"
                    aria-label="User profile">
              <img [src]="userAvatar" alt="User" class="avatar" [ngStyle]="avatarStyles">
              <span class="user-name">{{ userName }}</span>
              <span class="dropdown-icon">▼</span>
            </button>
          </div>
        </div>

        <!-- Mobile Toggle -->
        <button class="mobile-toggle"
                [ngStyle]="mobileToggleStyles"
                (click)="toggleMobileMenu()"
                [attr.aria-expanded]="isMobileMenuOpen"
                aria-label="Toggle menu">
          <span class="bar" [class.open]="isMobileMenuOpen"></span>
          <span class="bar" [class.open]="isMobileMenuOpen"></span>
          <span class="bar" [class.open]="isMobileMenuOpen"></span>
        </button>
      </div>
    </nav>
  `,
  styles: [`
    nav {
      transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }
    nav.scrolled {
      transform: translateY(0);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    }
    .navbar-container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 2rem;
    }
    .navbar-brand {
      display: flex;
      align-items: center;
      gap: 1rem;
      cursor: pointer;
    }
    .logo-wrapper {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 48px;
      height: 48px;
      border-radius: 12px;
      font-size: 1.5rem;
      transition: all 0.3s ease;
    }
    .logo-wrapper:hover {
      transform: rotate(10deg) scale(1.1);
    }
    .navbar-menu {
      display: flex;
      gap: 0.25rem;
      align-items: center;
      flex: 1;
      justify-content: center;
    }
    .menu-item {
      position: relative;
      text-decoration: none;
      padding: 0.875rem 1.5rem;
      border-radius: 0.75rem;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-weight: 500;
    }
    .menu-item::before {
      content: '';
      position: absolute;
      inset: 0;
      border-radius: inherit;
      opacity: 0;
      transition: opacity 0.3s;
    }
    .menu-item:hover::before {
      opacity: 1;
    }
    .menu-item.active {
      font-weight: 600;
    }
    .item-badge {
      font-size: 0.75rem;
      padding: 0.125rem 0.5rem;
      border-radius: 1rem;
      font-weight: 600;
    }
    .navbar-end {
      display: flex;
      align-items: center;
      gap: 1rem;
    }
    .search-container {
      position: relative;
      display: flex;
      align-items: center;
    }
    .search-icon {
      position: absolute;
      left: 1rem;
      font-size: 1rem;
    }
    .action-buttons {
      display: flex;
      gap: 0.5rem;
    }
    .action-btn {
      position: relative;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.625rem 1rem;
      border-radius: 0.75rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      transition: all 0.3s;
      font-weight: 500;
    }
    .action-btn:hover {
      transform: translateY(-2px);
    }
    .notification-badge {
      position: absolute;
      top: 0;
      right: 0;
      font-size: 0.7rem;
      min-width: 18px;
      height: 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 9px;
      font-weight: 700;
      animation: bounce 1s infinite;
    }
    @keyframes bounce {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-3px); }
    }
    .avatar {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      object-fit: cover;
    }
    .mobile-toggle {
      display: none;
      flex-direction: column;
      gap: 0.25rem;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
    }
    .bar {
      width: 24px;
      height: 3px;
      background: currentColor;
      border-radius: 2px;
      transition: all 0.3s;
    }
    .bar.open:nth-child(1) {
      transform: rotate(45deg) translateY(9px);
    }
    .bar.open:nth-child(2) {
      opacity: 0;
    }
    .bar.open:nth-child(3) {
      transform: rotate(-45deg) translateY(-9px);
    }
    @media (max-width: 768px) {
      .navbar-menu, .navbar-end {
        display: none;
      }
      .navbar-menu.active {
        display: flex;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        flex-direction: column;
        padding: 1rem;
        animation: slideDown 0.3s;
      }
      @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      .mobile-toggle {
        display: flex;
      }
    }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'solid';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Velocity';
  @Input() menuItems: MenuItem[] = [
    { label: 'Dashboard', route: '/', icon: '📊' },
    { label: 'Projects', route: '/projects', icon: '📁', badge: 5 },
    { label: 'Team', route: '/team', icon: '👥' },
    { label: 'Analytics', route: '/analytics', icon: '📈' }
  ];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 7;
  @Input() userName = 'Alex';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=2';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#6366f1',
    secondaryColor: '#ec4899',
    backgroundColor: '#0f172a',
    textColor: '#f1f5f9',
    borderColor: '#1e293b',
    accentColor: '#f59e0b'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 10;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: {
        backgroundColor: this.appliedTheme.backgroundColor,
        borderBottom: `1px solid ${this.appliedTheme.borderColor}`
      },
      transparent: {
        backgroundColor: 'rgba(15, 23, 42, 0.7)',
        backdropFilter: 'blur(12px)'
      },
      blur: {
        backgroundColor: 'rgba(15, 23, 42, 0.5)',
        backdropFilter: 'blur(24px) saturate(150%)'
      },
      gradient: {
        background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`
      }
    };

    return {
      position: this.position,
      top: '0',
      left: '0',
      right: '0',
      zIndex: '1000',
      color: this.appliedTheme.textColor,
      ...variants[this.variant]
    };
  }

  get containerStyles() {
    return {
      maxWidth: '1400px',
      margin: '0 auto',
      padding: '1.25rem 2rem'
    };
  }

  get brandStyles() {
    return {};
  }

  get logoWrapperStyles() {
    return {
      background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
      boxShadow: `0 4px 12px ${this.appliedTheme.primaryColor}40`
    };
  }

  get brandTextStyles() {
    return {
      fontSize: '1.5rem',
      fontWeight: '800',
      background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
      WebkitBackgroundClip: 'text',
      WebkitTextFillColor: 'transparent'
    };
  }

  get menuStyles() {
    return {};
  }

  getMenuItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;

    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive
        ? `${this.appliedTheme.primaryColor}30`
        : isHovered
          ? `${this.appliedTheme.primaryColor}20`
          : 'transparent',
      boxShadow: isActive ? `0 4px 12px ${this.appliedTheme.primaryColor}30` : 'none'
    };
  }

  get itemBadgeStyles() {
    return {
      backgroundColor: this.appliedTheme.accentColor,
      color: '#ffffff'
    };
  }

  get endStyles() {
    return {};
  }

  get searchContainerStyles() {
    return {};
  }

  get searchInputStyles() {
    return {
      width: '240px',
      padding: '0.625rem 1rem 0.625rem 2.5rem',
      border: `1px solid ${this.appliedTheme.borderColor}`,
      borderRadius: '0.75rem',
      backgroundColor: `${this.appliedTheme.backgroundColor}80`,
      color: this.appliedTheme.textColor,
      outline: 'none',
      transition: 'all 0.3s'
    };
  }

  get actionButtonsStyles() {
    return {};
  }

  get actionBtnStyles() {
    return {
      backgroundColor: `${this.appliedTheme.primaryColor}20`,
      color: this.appliedTheme.textColor,
      border: `1px solid ${this.appliedTheme.primaryColor}30`
    };
  }

  get notificationBadgeStyles() {
    return {
      backgroundColor: this.appliedTheme.accentColor,
      color: '#ffffff'
    };
  }

  get profileBtnStyles() {
    return {
      backgroundColor: `${this.appliedTheme.primaryColor}20`,
      color: this.appliedTheme.textColor,
      border: `1px solid ${this.appliedTheme.primaryColor}30`
    };
  }

  get avatarStyles() {
    return {
      border: `2px solid ${this.appliedTheme.primaryColor}`
    };
  }

  get mobileToggleStyles() {
    return {
      color: this.appliedTheme.textColor
    };
  }
}
