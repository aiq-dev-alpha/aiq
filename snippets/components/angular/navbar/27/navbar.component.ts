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
          <div class="icon" [ngStyle]="iconStyles">🌺</div>
          <span class="name">Orchid</span>
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
            <input type="search" placeholder="Search garden..." aria-label="Search" [ngStyle]="searchStyles">
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
    nav { transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
    nav.scrolled { box-shadow: 0 7px 24px rgba(192, 38, 211,0.145); backdrop-filter: blur(11px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1420px; margin: 0 auto; padding: 1.18rem 2.18rem; gap: 1.92rem; }
    .brand { display: flex; align-items: center; gap: 0.98rem; cursor: pointer; font-weight: 775; }
    .icon { font-size: 1.78rem; transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
    .icon:hover { transform: scale(1.22) rotate(12deg); }
    .name { font-size: 1.62rem; font-weight: 775; letter-spacing: -0.48px; }
    .menu { display: flex; gap: 0.62rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.88rem 1.38rem; border-radius: 0.78rem; text-decoration: none; transition: all 0.24s ease-in-out; font-weight: 535; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: scale(1.045) translateY(-2.5px); background-color: rgba(0,0,0,0.048); }
    .menu a.active { font-weight: 670; }
    .menu a.active::after { content: ''; position: absolute; bottom: 1.2px; left: 50%; transform: translateX(-50%); width: 29px; height: 2.9px; background: currentColor; border-radius: 1.85px; }
    .actions { display: flex; gap: 1.18rem; align-items: center; }
    .search input { padding: 0.68rem 1.22rem; border-radius: 1.65rem; border: 1.65px solid; outline: none; transition: all 0.26s; width: 215px; }
    .search input:focus { transform: scale(1.028); box-shadow: 0 0 9.5px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.68rem; font-size: 1.28rem; transition: transform 0.24s; border-radius: 0.68rem; }
    button:hover { transform: scale(1.098); }
    .badge { position: absolute; top: -1.8px; right: -1.8px; font-size: 0.735rem; min-width: 18.8px; height: 18.8px; border-radius: 9.4px; display: flex; align-items: center; justify-content: center; font-weight: 735; animation: pulse 1.75s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.185); } }
    .avatar { width: 37.5px; height: 37.5px; border-radius: 50%; object-fit: cover; border: 2.35px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.29rem; }
    .toggle span { width: 25.8px; height: 2.72px; background: currentColor; border-radius: 1.85px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.42rem; animation: slideDown 0.26s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-11.5px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'solid';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Orchid';
  @Input() menuItems: MenuItem[] = [{ label: 'Bloom', route: '/', icon: '🌺' }, { label: 'Petal', route: '/petal', icon: '🌸' }, { label: 'Garden', route: '/garden', icon: '🌷' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 47;
  @Input() userName = 'Orchid';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=27';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#c026d3',
    secondaryColor: '#a855f7',
    backgroundColor: '#fae8ff',
    textColor: '#701a75',
    borderColor: '#f0abfc',
    accentColor: '#10b981'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 21;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 2.5px 5.5px rgba(0,0,0,0.105)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E2`, backdropFilter: 'blur(11.5px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AF`, backdropFilter: 'blur(17.5px) saturate(178%)' },
      gradient: { background: `linear-gradient(115deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get iconStyles() { return { color: this.appliedTheme.accentColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}88` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1D` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}17`, padding: '0.545rem 1.045rem', borderRadius: '2.15rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}27` : isHovered ? `${this.appliedTheme.primaryColor}14` : 'transparent',
      boxShadow: isActive ? `0 3.8px 11.5px rgba(0,0,0,0.092)` : 'none'
    };
  }
}
