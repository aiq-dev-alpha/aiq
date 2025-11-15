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
          <div class="icon" [ngStyle]="iconStyles">❄️</div>
          <span class="name">Frost</span>
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
    nav { transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1); }
    nav.scrolled { box-shadow: 0 8px 32px rgba(0,0,0,0.08); backdrop-filter: blur(16px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1500px; margin: 0 auto; padding: 1rem 2rem; gap: 2rem; }
    .brand { display: flex; align-items: center; gap: 0.875rem; cursor: pointer; font-weight: 800; }
    .icon { font-size: 1.75rem; transition: transform 0.3s ease; }
    .icon:hover { transform: rotate(360deg); }
    .name { font-size: 1.5rem; font-weight: 800; letter-spacing: -0.25px; }
    .menu { display: flex; gap: 0.5rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.75rem 1.25rem; border-radius: 0.625rem; text-decoration: none; transition: all 0.3s; font-weight: 500; display: flex; align-items: center; gap: 0.5rem; }
    .menu a:hover { transform: translateY(-2px) scale(1.02); background-color: rgba(0,0,0,0.05); }
    .menu a.active { font-weight: 600; }
    .menu a.active::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 25px; height: 2.5px; background: currentColor; border-radius: 2px; }
    .actions { display: flex; gap: 1rem; align-items: center; }
    .search input { padding: 0.5rem 1rem; border-radius: 0.625rem; border: 1px solid; outline: none; transition: all 0.3s; }
    .search input:focus { transform: scale(1.02); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.5rem; font-size: 1.125rem; transition: transform 0.2s; }
    button:hover { transform: scale(1.08); }
    .badge { position: absolute; top: -2px; right: -2px; font-size: 0.7rem; min-width: 18px; height: 18px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-weight: 700; animation: pulse 1.5s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.2); } }
    .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2.5px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.25rem; }
    .toggle span { width: 24px; height: 2.5px; background: currentColor; border-radius: 2px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'blur';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Frost';
  @Input() menuItems: MenuItem[] = [{ label: 'Winter', route: '/', icon: '❄️' }, { label: 'Ice', route: '/ice', icon: '🧊' }, { label: 'Snow', route: '/snow', icon: '⛄' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 5;
  @Input() userName = 'Frozen';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=12';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#38bdf8',
    secondaryColor: '#0ea5e9',
    backgroundColor: '#f0f9ff',
    textColor: '#075985',
    borderColor: '#7dd3fc',
    accentColor: '#06b6d4'
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

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}` },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}CC`, backdropFilter: 'blur(10px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AA`, backdropFilter: 'blur(20px) saturate(180%)' },
      gradient: { background: `linear-gradient(90deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}80` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}20` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}15`, padding: '0.5rem 1rem', borderRadius: '2rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}25` : isHovered ? `${this.appliedTheme.primaryColor}15` : 'transparent',
      position: 'relative'
    };
  }
}
