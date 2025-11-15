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
          <div class="icon" [ngStyle]="iconStyles">🍊</div>
          <span class="name">Citrus</span>
        </div>
        
        <div class="menu" [ngStyle]="menuStyles" [class.active]="isMobileMenuOpen">
          <a *ngFor="let item of menuItems; let i = index"
             [href]="item.route"
             [ngStyle]="getItemStyles(i)"
             [class.active]="item.route === activeRoute"
             [attr.aria-current]="item.route === activeRoute ? 'page' : null"
             (mouseenter)="hoveredIndex = i"
             (mouseleave)="hoveredIndex = null">
            <span *ngIf="item.icon">{{item.icon}}</span>
            {{item.label}}
          </a>
        </div>
        
        <div class="actions" [ngStyle]="actionsStyles">
          <div *ngIf="showSearch" class="search">
            <input type="search" placeholder="Explore fruits..." aria-label="Search" [ngStyle]="searchStyles">
          </div>
          <button *ngIf="showNotifications" [ngStyle]="notifStyles" aria-label="Notifications">
            🔔<span *ngIf="notificationCount > 0" class="badge" [ngStyle]="badgeStyles">{{notificationCount}}</span>
          </button>
          <div *ngIf="showUserProfile" [ngStyle]="profileStyles">
            <img [src]="userAvatar" alt="{{userName}}" class="avatar" [ngStyle]="avatarStyles">
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
    nav { transition: all 0.36s cubic-bezier(0.19, 1, 0.22, 1); }
    nav.scrolled { box-shadow: 0 9px 32px rgba(251, 146, 60,0.17); backdrop-filter: blur(16px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1370px; margin: 0 auto; padding: 1.22rem 2.22rem; gap: 1.96rem; }
    .brand { display: flex; align-items: center; gap: 1.02rem; cursor: pointer; font-weight: 825; }
    .icon { font-size: 1.82rem; transition: transform 0.3s cubic-bezier(0.19, 1, 0.22, 1); }
    .icon:hover { transform: scale(1.28) rotate(-15deg); }
    .name { font-size: 1.66rem; font-weight: 825; letter-spacing: -0.52px; }
    .menu { display: flex; gap: 0.66rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.92rem 1.42rem; border-radius: 0.82rem; text-decoration: none; transition: all 0.22s ease-in; font-weight: 545; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: scale(1.05); background-color: rgba(0,0,0,0.052); }
    .menu a.active { font-weight: 685; }
    .menu a.active::after { content: ''; position: absolute; bottom: 0.8px; left: 50%; transform: translateX(-50%); width: 31px; height: 3.2px; background: currentColor; border-radius: 2.1px; }
    .actions { display: flex; gap: 1.22rem; align-items: center; }
    .search input { padding: 0.72rem 1.26rem; border-radius: 1.85rem; border: 1.85px solid; outline: none; transition: all 0.24s; width: 225px; }
    .search input:focus { transform: scale(1.032); box-shadow: 0 0 10.5px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.72rem; font-size: 1.32rem; transition: transform 0.26s; border-radius: 0.72rem; }
    button:hover { transform: scale(1.108); }
    .badge { position: absolute; top: -2.2px; right: -2.2px; font-size: 0.755rem; min-width: 19.2px; height: 19.2px; border-radius: 9.6px; display: flex; align-items: center; justify-content: center; font-weight: 755; animation: pulse 1.65s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.195); } }
    .avatar { width: 38.5px; height: 38.5px; border-radius: 50%; object-fit: cover; border: 2.55px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.31rem; }
    .toggle span { width: 26.5px; height: 2.82px; background: currentColor; border-radius: 2.1px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.52rem; animation: slideDown 0.24s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-12.5px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'gradient';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Citrus';
  @Input() menuItems: MenuItem[] = [{ label: 'Orange', route: '/', icon: '🍊' }, { label: 'Lemon', route: '/lemon', icon: '🍋' }, { label: 'Lime', route: '/lime', icon: '🍈' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 56;
  @Input() userName = 'Citrus';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=29';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#fb923c',
    secondaryColor: '#f97316',
    backgroundColor: '#fff7ed',
    textColor: '#9a3412',
    borderColor: '#fed7aa',
    accentColor: '#22c55e'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 23;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `2px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 3px 6px rgba(0,0,0,0.11)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}DF`, backdropFilter: 'blur(12.5px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AC`, backdropFilter: 'blur(18.5px) saturate(182%)' },
      gradient: { background: `linear-gradient(105deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
    };
    return {
      position: this.position,
      top: '0',
      left: '0',
      right: '0',
      zIndex: '1100',
      color: this.appliedTheme.textColor,
      ...variants[this.variant]
    };
  }

  get containerStyles() { return {}; }
  get brandStyles() { return { color: this.appliedTheme.primaryColor }; }
  get iconStyles() { return { color: this.appliedTheme.secondaryColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}92` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1E` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1A`, padding: '0.575rem 1.075rem', borderRadius: '2.25rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.accentColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}2A` : isHovered ? `${this.appliedTheme.primaryColor}16` : 'transparent',
      boxShadow: isActive ? `0 4.2px 12.5px rgba(0,0,0,0.095)` : 'none'
    };
  }
}
