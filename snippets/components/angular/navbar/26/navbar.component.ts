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
          <div class="icon" [ngStyle]="iconStyles">🦄</div>
          <span class="name">Fuchsia</span>
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
            <input type="search" placeholder="Dream search..." aria-label="Search" [ngStyle]="searchStyles">
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
    nav { transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
    nav.scrolled { box-shadow: 0 8px 26px rgba(217, 70, 239,0.16); backdrop-filter: blur(14px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1430px; margin: 0 auto; padding: 1.16rem 2.16rem; gap: 1.9rem; }
    .brand { display: flex; align-items: center; gap: 0.96rem; cursor: pointer; font-weight: 790; }
    .icon { font-size: 1.76rem; transition: transform 0.3s ease-in-out; }
    .icon:hover { transform: scale(1.24) rotate(8deg); }
    .name { font-size: 1.6rem; font-weight: 790; letter-spacing: -0.44px; }
    .menu { display: flex; gap: 0.6rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.86rem 1.36rem; border-radius: 0.76rem; text-decoration: none; transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1); font-weight: 528; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: translateY(-2.3px) scale(1.018); background-color: rgba(0,0,0,0.046); }
    .menu a.active { font-weight: 662; }
    .menu a.active::after { content: ''; position: absolute; bottom: 1.4px; left: 50%; transform: translateX(-50%); width: 28.5px; height: 2.85px; background: currentColor; border-radius: 1.8px; }
    .actions { display: flex; gap: 1.16rem; align-items: center; }
    .search input { padding: 0.66rem 1.2rem; border-radius: 1.7rem; border: 1.7px solid; outline: none; transition: all 0.3s; width: 212px; }
    .search input:focus { transform: scale(1.024); box-shadow: 0 0 9.2px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.66rem; font-size: 1.26rem; transition: transform 0.23s; border-radius: 0.66rem; }
    button:hover { transform: scale(1.092); }
    .badge { position: absolute; top: -1.6px; right: -1.6px; font-size: 0.725rem; min-width: 18.6px; height: 18.6px; border-radius: 9.3px; display: flex; align-items: center; justify-content: center; font-weight: 728; animation: pulse 1.8s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.175); } }
    .avatar { width: 37.2px; height: 37.2px; border-radius: 50%; object-fit: cover; border: 2.4px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.28rem; }
    .toggle span { width: 25.4px; height: 2.68px; background: currentColor; border-radius: 1.8px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.38rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-11.2px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'solid';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Fuchsia';
  @Input() menuItems: MenuItem[] = [{ label: 'Magic', route: '/', icon: '🦄' }, { label: 'Fantasy', route: '/fantasy', icon: '🌟' }, { label: 'Dream', route: '/dream', icon: '✨' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 72;
  @Input() userName = 'Fuchsia';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=30';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#d946ef',
    secondaryColor: '#c026d3',
    backgroundColor: '#fdf4ff',
    textColor: '#86198f',
    borderColor: '#f0abfc',
    accentColor: '#0ea5e9'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 19;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 2.2px 4.8px rgba(0,0,0,0.098)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E3`, backdropFilter: 'blur(11.2px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B08`, backdropFilter: 'blur(17.2px) saturate(176%)' },
      gradient: { background: `linear-gradient(122deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}86` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1BC` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}168`, padding: '0.53rem 1.03rem', borderRadius: '2.12rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}268` : isHovered ? `${this.appliedTheme.primaryColor}138` : 'transparent',
      boxShadow: isActive ? `0 3.6px 11.2px rgba(0,0,0,0.089)` : 'none'
    };
  }
}
