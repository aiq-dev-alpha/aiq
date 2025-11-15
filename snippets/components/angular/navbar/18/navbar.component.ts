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
          <div class="icon" [ngStyle]="iconStyles">🌀</div>
          <span class="name">Indigo</span>
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
            <input type="search" placeholder="Search..." aria-label="Search" [ngStyle]="searchStyles">
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
    nav { transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
    nav.scrolled { box-shadow: 0 8px 28px rgba(99, 102, 241,0.15); backdrop-filter: blur(18px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1360px; margin: 0 auto; padding: 1.2rem 2.2rem; gap: 2rem; }
    .brand { display: flex; align-items: center; gap: 1rem; cursor: pointer; font-weight: 800; }
    .icon { font-size: 1.8rem; transition: transform 0.3s ease-out; }
    .icon:hover { transform: rotate(360deg); }
    .name { font-size: 1.6rem; font-weight: 800; letter-spacing: -0.5px; }
    .menu { display: flex; gap: 0.65rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.85rem 1.4rem; border-radius: 0.75rem; text-decoration: none; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); font-weight: 530; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: scale(1.03) translateY(-2px); background-color: rgba(0,0,0,0.05); }
    .menu a.active { font-weight: 680; }
    .menu a.active::after { content: ''; position: absolute; bottom: 1px; left: 50%; transform: translateX(-50%); width: 30px; height: 3px; background: currentColor; border-radius: 2px; }
    .actions { display: flex; gap: 1.2rem; align-items: center; }
    .search input { padding: 0.65rem 1.2rem; border-radius: 1.75rem; border: 1.75px solid; outline: none; transition: all 0.32s; width: 220px; }
    .search input:focus { transform: scale(1.03); box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.65rem; font-size: 1.25rem; transition: transform 0.22s; border-radius: 0.65rem; }
    button:hover { transform: scale(1.1); }
    .badge { position: absolute; top: -2px; right: -2px; font-size: 0.72rem; min-width: 19px; height: 19px; border-radius: 9.5px; display: flex; align-items: center; justify-content: center; font-weight: 750; animation: pulse 1.7s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.2); } }
    .avatar { width: 38px; height: 38px; border-radius: 50%; object-fit: cover; border: 2.5px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.3rem; }
    .toggle span { width: 26px; height: 2.8px; background: currentColor; border-radius: 2px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.5rem; animation: slideDown 0.32s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-12px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'blur';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Indigo';
  @Input() menuItems: MenuItem[] = [{ label: 'Spiral', route: '/', icon: '🌀' }, { label: 'Vortex', route: '/vortex', icon: '🌊' }, { label: 'Flow', route: '/flow', icon: '💫' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 29;
  @Input() userName = 'Indigo';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=22';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#6366f1',
    secondaryColor: '#818cf8',
    backgroundColor: '#eef2ff',
    textColor: '#3730a3',
    borderColor: '#c7d2fe',
    accentColor: '#ec4899'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
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
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 2px 4px rgba(0,0,0,0.08)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E0`, backdropFilter: 'blur(12px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B0`, backdropFilter: 'blur(18px) saturate(180%)' },
      gradient: { background: `linear-gradient(120deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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

  get containerStyles() { return {}; }
  get brandStyles() { return { color: this.appliedTheme.primaryColor }; }
  get iconStyles() { return { color: this.appliedTheme.primaryColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}90` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}20` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}18`, padding: '0.55rem 1.05rem', borderRadius: '2.25rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}28` : isHovered ? `${this.appliedTheme.primaryColor}15` : 'transparent',
      boxShadow: isActive ? `0 4px 12px rgba(0,0,0,0.1)` : 'none'
    };
  }
}
