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
  
}

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule],
  template: `
    <nav [ngStyle]="navbarStyles" [class.scrolled]="isScrolled" role="navigation">
      <div class="container" [ngStyle]="containerStyles">
        <div class="brand" [ngStyle]="brandStyles">
          <div class="icon" [ngStyle]="iconStyles">☀️</div>
          <span class="name">Solar</span>
        </div>
        
        <div class="menu" [ngStyle]="menuStyles" [class.active]="isMobileMenuOpen">
          <a *ngFor="let item of menuItems; let i = index"
             [href]="item.route"
             [ngStyle]="getItemStyles(i)"
             [class.active]="item.route === activeRoute"
             [attr.aria-current]="item.route === activeRoute ? 'page' : null">
            <span *ngIf="item.icon">{{item.icon}}</span>
            {{item.label}}
          </a>
        </div>
        
        <div class="actions" [ngStyle]="actionsStyles">
          <div *ngIf="showSearch" class="search">
            <input type="search" placeholder="Search..." aria-label="Search" [ngStyle]="searchStyles">
          </div>
          <button *ngIf="showNotifications" [ngStyle]="notifStyles" aria-label="Notifications">
            🔔<span *ngIf="notificationCount > 0" class="badge">{{notificationCount}}</span>
          </button>
          <div *ngIf="showUserProfile" [ngStyle]="profileStyles">
            <img [src]="userAvatar" alt="{{userName}}" class="avatar">
            <span>{{userName}}</span>
          </div>
        </div>
        
        <button class="toggle" (click)="toggleMobileMenu()" [attr.aria-expanded]="isMobileMenuOpen" aria-label="Menu">
          <span></span><span></span><span></span>
        </button>
      </div>
    </nav>
  `,
  styles: [`
    nav { transition: all 0.3s; }
    nav.scrolled { box-shadow: 0 4px 20px rgba(0,0,0,0.15); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1300px; margin: 0 auto; padding: 1rem 2rem; }
    .brand { display: flex; align-items: center; gap: 0.75rem; cursor: pointer; }
    .icon { font-size: 1.75rem; transition: transform 0.3s; }
    .icon:hover { transform: rotate(180deg); }
    .name { font-size: 1.5rem; font-weight: 800; }
    .menu { display: flex; gap: 0.5rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.75rem 1.25rem; border-radius: 0.5rem; text-decoration: none; transition: all 0.25s; }
    .menu a:hover { transform: translateY(-2px); }
    .menu a.active { font-weight: 600; }
    .actions { display: flex; gap: 1rem; align-items: center; }
    .search input { padding: 0.5rem 1rem; border-radius: 0.5rem; border: 1px solid; }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.5rem; }
    .badge { position: absolute; top: 0; right: 0; font-size: 0.7rem; min-width: 18px; height: 18px; border-radius: 9px; display: flex; align-items: center; justify-content: center; }
    .avatar { width: 36px; height: 36px; border-radius: 50%; }
    .toggle { display: none; flex-direction: column; gap: 0.25rem; }
    .toggle span { width: 24px; height: 2px; background: currentColor; }
    @media (max-width: 768px) { .menu, .actions { display: none; } .toggle { display: flex; } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'gradient';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Solar';
  @Input() menuItems: MenuItem[] = [{ label: 'Home', route: '/', icon: '🏠' }, { label: 'Gallery', route: '/gallery', icon: '🖼️' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 8;
  @Input() userName = 'Emma';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=5';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#f59e0b',
    secondaryColor: '#ef4444',
    backgroundColor: '#fef3c7',
    textColor: '#78350f',
    borderColor: '#fcd34d',
    accentColor: '#dc2626'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 25;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    return {
      position: this.position,
      top: '0',
      left: '0',
      right: '0',
      zIndex: '1000',
      backgroundColor: this.appliedTheme.backgroundColor,
      color: this.appliedTheme.textColor,
      borderBottom: `1px solid ${this.appliedTheme.borderColor}`
    };
  }

  get containerStyles() { return {}; }
  get brandStyles() { return { color: this.appliedTheme.primaryColor }; }
  get iconStyles() { return { color: this.appliedTheme.primaryColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor }; }
  get notifStyles() { return { color: this.appliedTheme.textColor }; }
  get profileStyles() { return { color: this.appliedTheme.textColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}20` : 'transparent'
    };
  }
}
