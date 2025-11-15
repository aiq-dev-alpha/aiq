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
  badge?: string;
}

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule],
  template: `
    <nav [ngStyle]="navbarStyles" [class.scrolled]="isScrolled" role="navigation">
      <div class="nav-content" [ngStyle]="contentStyles">
        <!-- Left Section: Brand + Menu -->
        <div class="nav-left" [ngStyle]="leftStyles">
          <a href="/" class="brand-link" [ngStyle]="brandLinkStyles">
            <div class="brand-icon" [ngStyle]="brandIconStyles">
              <span>💎</span>
            </div>
            <span class="brand-title" [ngStyle]="brandTitleStyles">{{ brandName }}</span>
          </a>

          <div class="menu-items" [ngStyle]="menuItemsStyles" [class.active]="isMobileMenuOpen">
            <a *ngFor="let item of menuItems; let i = index"
               [href]="item.route"
               class="menu-link"
               [ngStyle]="getMenuLinkStyles(i)"
               [class.active]="item.route === activeRoute"
               [attr.aria-current]="item.route === activeRoute ? 'page' : null"
               (mouseenter)="onHoverItem(i)"
               (mouseleave)="onLeaveItem()">
              <span *ngIf="item.icon" class="link-icon">{{ item.icon }}</span>
              <span class="link-label">{{ item.label }}</span>
              <span *ngIf="item.badge" class="link-badge" [ngStyle]="linkBadgeStyles">{{ item.badge }}</span>
            </a>
          </div>
        </div>

        <!-- Right Section: Actions -->
        <div class="nav-right" [ngStyle]="rightStyles">
          <!-- Search Input -->
          <div *ngIf="showSearch" class="search-wrapper" [ngStyle]="searchWrapperStyles">
            <div class="search-input-group" [ngStyle]="searchGroupStyles">
              <span class="search-icon-left">🔍</span>
              <input type="search"
                     placeholder="Type to search..."
                     [ngStyle]="searchFieldStyles"
                     aria-label="Search">
              <button class="search-clear" [ngStyle]="searchClearStyles" aria-label="Clear">✕</button>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="action-group" [ngStyle]="actionGroupStyles">
            <button *ngIf="showNotifications"
                    class="action-button"
                    [ngStyle]="actionButtonStyles"
                    aria-label="View notifications">
              <span class="action-icon">🔔</span>
              <span *ngIf="notificationCount > 0"
                    class="action-badge"
                    [ngStyle]="actionBadgeStyles">
                {{ notificationCount > 99 ? '99+' : notificationCount }}
              </span>
            </button>

            <button class="action-button" [ngStyle]="actionButtonStyles" aria-label="Settings">
              <span class="action-icon">⚙️</span>
            </button>

            <div *ngIf="showUserProfile" class="profile-section" [ngStyle]="profileSectionStyles">
              <button class="profile-button" [ngStyle]="profileButtonStyles" aria-label="User profile">
                <img [src]="userAvatar" alt="{{ userName }}" class="profile-pic" [ngStyle]="profilePicStyles">
                <div class="profile-text">
                  <span class="profile-name">{{ userName }}</span>
                  <span class="profile-status">Online</span>
                </div>
                <span class="profile-chevron">▾</span>
              </button>
            </div>
          </div>
        </div>

        <!-- Mobile Menu Button -->
        <button class="mobile-menu-btn"
                [ngStyle]="mobileBtnStyles"
                (click)="toggleMobileMenu()"
                [attr.aria-expanded]="isMobileMenuOpen"
                aria-label="Toggle menu">
          <span class="menu-line" [class.open]="isMobileMenuOpen"></span>
          <span class="menu-line" [class.open]="isMobileMenuOpen"></span>
          <span class="menu-line" [class.open]="isMobileMenuOpen"></span>
        </button>
      </div>
    </nav>
  `,
  styles: [`
    nav {
      transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
    }
    nav.scrolled {
      box-shadow: 0 6px 24px rgba(0, 0, 0, 0.12);
    }
    .nav-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1.5rem;
    }
    .nav-left {
      display: flex;
      align-items: center;
      gap: 2rem;
      flex: 1;
    }
    .brand-link {
      display: flex;
      align-items: center;
      gap: 0.875rem;
      text-decoration: none;
      transition: all 0.3s;
    }
    .brand-link:hover .brand-icon {
      transform: scale(1.1) rotate(10deg);
    }
    .brand-icon {
      width: 44px;
      height: 44px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 12px;
      font-size: 1.5rem;
      transition: transform 0.3s;
    }
    .brand-title {
      font-size: 1.375rem;
      font-weight: 800;
      letter-spacing: -0.5px;
    }
    .menu-items {
      display: flex;
      gap: 0.375rem;
      align-items: center;
    }
    .menu-link {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1.125rem;
      border-radius: 0.625rem;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.25s ease;
      position: relative;
    }
    .menu-link:hover {
      transform: translateY(-1px);
    }
    .menu-link.active::after {
      content: '';
      position: absolute;
      bottom: 2px;
      left: 50%;
      transform: translateX(-50%);
      width: 24px;
      height: 3px;
      border-radius: 2px;
      background: currentColor;
    }
    .link-badge {
      padding: 0.125rem 0.5rem;
      border-radius: 1rem;
      font-size: 0.7rem;
      font-weight: 700;
    }
    .nav-right {
      display: flex;
      align-items: center;
      gap: 1rem;
    }
    .search-wrapper {
      position: relative;
    }
    .search-input-group {
      position: relative;
      display: flex;
      align-items: center;
    }
    .search-icon-left {
      position: absolute;
      left: 1rem;
      font-size: 0.9rem;
      pointer-events: none;
    }
    .search-clear {
      position: absolute;
      right: 0.75rem;
      background: none;
      border: none;
      cursor: pointer;
      opacity: 0.5;
      transition: opacity 0.2s;
    }
    .search-clear:hover {
      opacity: 1;
    }
    .action-group {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .action-button {
      position: relative;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.625rem;
      border-radius: 0.625rem;
      transition: all 0.25s;
      font-size: 1.25rem;
    }
    .action-button:hover {
      transform: scale(1.05);
    }
    .action-badge {
      position: absolute;
      top: -2px;
      right: -2px;
      min-width: 18px;
      height: 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 9px;
      font-size: 0.65rem;
      font-weight: 800;
      animation: pop 0.3s ease;
    }
    @keyframes pop {
      0% { transform: scale(0); }
      50% { transform: scale(1.2); }
      100% { transform: scale(1); }
    }
    .profile-section {
      margin-left: 0.5rem;
    }
    .profile-button {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem 0.875rem;
      border-radius: 3rem;
      transition: all 0.3s;
    }
    .profile-button:hover {
      transform: translateY(-1px);
    }
    .profile-pic {
      width: 38px;
      height: 38px;
      border-radius: 50%;
      object-fit: cover;
    }
    .profile-text {
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      gap: 0.125rem;
    }
    .profile-name {
      font-size: 0.875rem;
      font-weight: 600;
      line-height: 1;
    }
    .profile-status {
      font-size: 0.7rem;
      opacity: 0.7;
      line-height: 1;
    }
    .profile-chevron {
      font-size: 0.75rem;
      opacity: 0.6;
    }
    .mobile-menu-btn {
      display: none;
      flex-direction: column;
      gap: 0.35rem;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
    }
    .menu-line {
      width: 26px;
      height: 2.5px;
      background: currentColor;
      border-radius: 2px;
      transition: all 0.3s;
    }
    .menu-line.open:nth-child(1) {
      transform: rotate(45deg) translate(6px, 6px);
    }
    .menu-line.open:nth-child(2) {
      opacity: 0;
    }
    .menu-line.open:nth-child(3) {
      transform: rotate(-45deg) translate(6px, -6px);
    }
    @media (max-width: 968px) {
      .menu-items, .search-wrapper {
        display: none;
      }
      .menu-items.active {
        display: flex;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        flex-direction: column;
        padding: 1rem;
        animation: slideIn 0.3s;
      }
      @keyframes slideIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      .mobile-menu-btn {
        display: flex;
      }
    }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'solid';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Nebula';
  @Input() menuItems: MenuItem[] = [
    { label: 'Dashboard', route: '/', icon: '📊' },
    { label: 'Projects', route: '/projects', icon: '📁', badge: 'New' },
    { label: 'Tasks', route: '/tasks', icon: '✓' },
    { label: 'Reports', route: '/reports', icon: '📈' }
  ];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 24;
  @Input() userName = 'Taylor';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=5';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#8b5cf6',
    secondaryColor: '#ec4899',
    backgroundColor: '#1f2937',
    textColor: '#f9fafb',
    borderColor: '#374151',
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
    this.isScrolled = window.scrollY > 15;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  onHoverItem(index: number) {
    this.hoveredIndex = index;
  }

  onLeaveItem() {
    this.hoveredIndex = null;
  }

  get navbarStyles() {
    const variants = {
      solid: {
        backgroundColor: this.appliedTheme.backgroundColor,
        borderBottom: `1px solid ${this.appliedTheme.borderColor}`
      },
      transparent: {
        backgroundColor: 'rgba(31, 41, 55, 0.75)',
        backdropFilter: 'blur(10px)',
        borderBottom: `1px solid ${this.appliedTheme.borderColor}40`
      },
      blur: {
        backgroundColor: 'rgba(31, 41, 55, 0.6)',
        backdropFilter: 'blur(20px) saturate(180%)',
        borderBottom: 'none'
      },
      gradient: {
        background: `linear-gradient(120deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
        borderBottom: 'none'
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

  get contentStyles() {
    return {
      maxWidth: '1600px',
      margin: '0 auto',
      padding: '1.125rem 2rem'
    };
  }

  get leftStyles() {
    return {};
  }

  get brandLinkStyles() {
    return {
      color: this.appliedTheme.textColor
    };
  }

  get brandIconStyles() {
    return {
      background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
      boxShadow: `0 4px 16px ${this.appliedTheme.primaryColor}40`
    };
  }

  get brandTitleStyles() {
    return {
      color: 'inherit'
    };
  }

  get menuItemsStyles() {
    return {};
  }

  getMenuLinkStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;

    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive
        ? `${this.appliedTheme.primaryColor}35`
        : isHovered
          ? `${this.appliedTheme.primaryColor}20`
          : 'transparent',
      boxShadow: isActive ? `0 4px 12px ${this.appliedTheme.primaryColor}25` : 'none'
    };
  }

  get linkBadgeStyles() {
    return {
      backgroundColor: this.appliedTheme.accentColor,
      color: '#ffffff'
    };
  }

  get rightStyles() {
    return {};
  }

  get searchWrapperStyles() {
    return {};
  }

  get searchGroupStyles() {
    return {};
  }

  get searchFieldStyles() {
    return {
      width: '280px',
      padding: '0.625rem 2.5rem 0.625rem 2.75rem',
      border: `1px solid ${this.appliedTheme.borderColor}`,
      borderRadius: '0.75rem',
      backgroundColor: `${this.appliedTheme.backgroundColor}80`,
      color: this.appliedTheme.textColor,
      outline: 'none',
      transition: 'all 0.3s'
    };
  }

  get searchClearStyles() {
    return {
      color: this.appliedTheme.textColor,
      fontSize: '0.875rem'
    };
  }

  get actionGroupStyles() {
    return {};
  }

  get actionButtonStyles() {
    return {
      backgroundColor: `${this.appliedTheme.primaryColor}15`,
      color: this.appliedTheme.textColor,
      border: `1px solid ${this.appliedTheme.primaryColor}25`
    };
  }

  get actionBadgeStyles() {
    return {
      backgroundColor: this.appliedTheme.accentColor,
      color: '#ffffff'
    };
  }

  get profileSectionStyles() {
    return {};
  }

  get profileButtonStyles() {
    return {
      backgroundColor: `${this.appliedTheme.primaryColor}15`,
      color: this.appliedTheme.textColor,
      border: `1px solid ${this.appliedTheme.primaryColor}25`
    };
  }

  get profilePicStyles() {
    return {
      border: `2px solid ${this.appliedTheme.primaryColor}`
    };
  }

  get mobileBtnStyles() {
    return {
      color: this.appliedTheme.textColor
    };
  }
}
