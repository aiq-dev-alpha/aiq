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
      <div class="navbar-container" [ngStyle]="containerStyles">
        <!-- Logo/Brand -->
        <div class="navbar-brand" [ngStyle]="brandStyles">
          <img *ngIf="logoUrl" [src]="logoUrl" alt="Logo" class="logo" [ngStyle]="logoStyles">
          <span class="brand-text" [ngStyle]="brandTextStyles">{{ brandName }}</span>
        </div>

        <!-- Desktop Menu -->
        <div class="navbar-menu" [ngStyle]="menuStyles" [class.active]="isMobileMenuOpen">
          <a *ngFor="let item of menuItems; let i = index"
             [href]="item.route"
             class="menu-item"
             [ngStyle]="getMenuItemStyles(item)"
             [class.active]="item.route === activeRoute"
             [attr.aria-current]="item.route === activeRoute ? 'page' : null"
             (mouseenter)="hoveredIndex = i"
             (mouseleave)="hoveredIndex = null">
            <span *ngIf="item.icon" class="item-icon">{{ item.icon }}</span>
            {{ item.label }}
            <span *ngIf="item.children" class="dropdown-arrow" [attr.aria-expanded]="expandedDropdown === i">▼</span>
          </a>
        </div>

        <!-- Search Bar -->
        <div *ngIf="showSearch" class="navbar-search" [ngStyle]="searchStyles">
          <input type="search"
                 placeholder="Search..."
                 [ngStyle]="searchInputStyles"
                 aria-label="Search">
          <span class="search-icon">🔍</span>
        </div>

        <!-- User Section -->
        <div class="navbar-actions" [ngStyle]="actionsStyles">
          <button *ngIf="showNotifications"
                  class="notification-btn"
                  [ngStyle]="notificationBtnStyles"
                  aria-label="Notifications">
            🔔
            <span *ngIf="notificationCount > 0" class="badge" [ngStyle]="badgeStyles">
              {{ notificationCount }}
            </span>
          </button>

          <div *ngIf="showUserProfile" class="user-profile" [ngStyle]="profileStyles">
            <img [src]="userAvatar" alt="User" class="avatar" [ngStyle]="avatarStyles">
            <span class="user-name">{{ userName }}</span>
          </div>
        </div>

        <!-- Mobile Menu Toggle -->
        <button class="mobile-toggle"
                [ngStyle]="mobileToggleStyles"
                (click)="toggleMobileMenu()"
                [attr.aria-expanded]="isMobileMenuOpen"
                aria-label="Toggle menu">
          <span class="hamburger" [ngStyle]="hamburgerStyles"></span>
        </button>
      </div>
    </nav>
  `,
  styles: [`
    nav {
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    nav.scrolled {
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
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
      gap: 0.75rem;
      cursor: pointer;
      transition: transform 0.2s;
    }
    .navbar-brand:hover {
      transform: scale(1.05);
    }
    .logo {
      height: 40px;
      width: auto;
    }
    .navbar-menu {
      display: flex;
      gap: 0.5rem;
      align-items: center;
      flex: 1;
    }
    .menu-item {
      position: relative;
      text-decoration: none;
      padding: 0.75rem 1.25rem;
      border-radius: 0.5rem;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .menu-item:hover {
      transform: translateY(-2px);
    }
    .menu-item.active::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 80%;
      height: 3px;
      background: currentColor;
      border-radius: 2px;
    }
    .navbar-search {
      position: relative;
      display: flex;
      align-items: center;
    }
    .search-icon {
      position: absolute;
      left: 1rem;
      pointer-events: none;
    }
    .navbar-actions {
      display: flex;
      align-items: center;
      gap: 1rem;
    }
    .notification-btn {
      position: relative;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
      font-size: 1.5rem;
      transition: transform 0.2s;
    }
    .notification-btn:hover {
      transform: scale(1.1);
    }
    .badge {
      position: absolute;
      top: 0;
      right: 0;
      font-size: 0.75rem;
      min-width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 10px;
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.1); }
    }
    .user-profile {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      cursor: pointer;
      padding: 0.5rem 1rem;
      border-radius: 2rem;
      transition: all 0.3s;
    }
    .avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      object-fit: cover;
    }
    .mobile-toggle {
      display: none;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
    }
    @media (max-width: 768px) {
      .navbar-menu {
        position: fixed;
        top: 70px;
        left: 0;
        right: 0;
        flex-direction: column;
        padding: 1rem;
        transform: translateY(-100%);
        opacity: 0;
        transition: all 0.3s;
      }
      .navbar-menu.active {
        transform: translateY(0);
        opacity: 1;
      }
      .mobile-toggle {
        display: block;
      }
      .navbar-search {
        display: none;
      }
    }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'solid';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Brand';
  @Input() logoUrl = '';
  @Input() menuItems: MenuItem[] = [
    { label: 'Home', route: '/' },
    { label: 'About', route: '/about' },
    { label: 'Services', route: '/services' },
    { label: 'Contact', route: '/contact' }
  ];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 3;
  @Input() userName = 'User';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=1';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#8b5cf6',
    backgroundColor: '#ffffff',
    textColor: '#111827',
    borderColor: '#e5e7eb',
    accentColor: '#f59e0b'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  expandedDropdown: number | null = null;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 20;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variantStyles = {
      solid: {
        backgroundColor: this.appliedTheme.backgroundColor,
        borderBottom: `1px solid ${this.appliedTheme.borderColor}`,
        boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)'
      },
      transparent: {
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        backdropFilter: 'blur(10px)',
        borderBottom: `1px solid rgba(0, 0, 0, 0.1)`
      },
      blur: {
        backgroundColor: 'rgba(255, 255, 255, 0.6)',
        backdropFilter: 'blur(20px) saturate(180%)',
        borderBottom: 'none'
      },
      gradient: {
        background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
        borderBottom: 'none',
        color: '#ffffff'
      }
    };

    return {
      position: this.position,
      top: this.position !== 'static' ? '0' : 'auto',
      left: '0',
      right: '0',
      zIndex: '1000',
      ...variantStyles[this.variant]
    };
  }

  get containerStyles() {
    return {
      maxWidth: '1280px',
      margin: '0 auto',
      padding: '1rem 2rem'
    };
  }

  get brandStyles() {
    return {
      fontWeight: '700',
      fontSize: '1.5rem',
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.primaryColor
    };
  }

  get logoStyles() {
    return {
      filter: this.variant === 'gradient' ? 'brightness(0) invert(1)' : 'none'
    };
  }

  get brandTextStyles() {
    return {
      background: this.variant === 'gradient' ? '#ffffff' : `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})`,
      WebkitBackgroundClip: 'text',
      WebkitTextFillColor: this.variant === 'gradient' ? '#ffffff' : 'transparent',
      backgroundClip: 'text'
    };
  }

  get menuStyles() {
    return {
      backgroundColor: this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.1)' : 'transparent'
    };
  }

  getMenuItemStyles(item: MenuItem) {
    const isActive = item.route === this.activeRoute;
    const baseColor = this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor;

    return {
      color: isActive ? this.appliedTheme.primaryColor : baseColor,
      backgroundColor: isActive ? (this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.2)' : `${this.appliedTheme.primaryColor}15`) : 'transparent',
      fontWeight: isActive ? '600' : '500'
    };
  }

  get searchStyles() {
    return {
      flex: '0 0 300px'
    };
  }

  get searchInputStyles() {
    return {
      width: '100%',
      padding: '0.625rem 1rem 0.625rem 3rem',
      border: `1px solid ${this.appliedTheme.borderColor}`,
      borderRadius: '2rem',
      backgroundColor: this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.2)' : this.appliedTheme.backgroundColor,
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor,
      outline: 'none',
      transition: 'all 0.3s'
    };
  }

  get actionsStyles() {
    return {};
  }

  get notificationBtnStyles() {
    return {
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get badgeStyles() {
    return {
      backgroundColor: this.appliedTheme.accentColor,
      color: '#ffffff',
      fontWeight: '600'
    };
  }

  get profileStyles() {
    return {
      backgroundColor: this.variant === 'gradient' ? 'rgba(255, 255, 255, 0.2)' : `${this.appliedTheme.primaryColor}10`,
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get avatarStyles() {
    return {
      border: `2px solid ${this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.primaryColor}`
    };
  }

  get mobileToggleStyles() {
    return {
      color: this.variant === 'gradient' ? '#ffffff' : this.appliedTheme.textColor
    };
  }

  get hamburgerStyles() {
    return {
      display: 'block',
      width: '24px',
      height: '2px',
      backgroundColor: 'currentColor',
      position: 'relative',
      transition: 'all 0.3s'
    };
  }
}
