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
          <div class="icon" [ngStyle]="iconStyles">🐬</div>
          <span class="name">Teal</span>
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
            <input type="search" placeholder="Find..." aria-label="Search" [ngStyle]="searchStyles">
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
    nav { transition: all 0.32s cubic-bezier(0.4, 0, 0.2, 1); }
    nav.scrolled { box-shadow: 0 6px 20px rgba(0, 0, 0,0.12); backdrop-filter: blur(10px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1410px; margin: 0 auto; padding: 1.1rem 2.1rem; gap: 1.75rem; }
    .brand { display: flex; align-items: center; gap: 0.9rem; cursor: pointer; font-weight: 700; }
    .icon { font-size: 1.7rem; transition: transform 0.3s ease; }
    .icon:hover { transform: scale(1.15) rotate(5deg); }
    .name { font-size: 1.55rem; font-weight: 700; letter-spacing: -0.4px; }
    .menu { display: flex; gap: 0.6rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.8rem 1.3rem; border-radius: 0.7rem; text-decoration: none; transition: all 0.28s ease-in-out; font-weight: 520; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: translateY(-2.25px); background-color: rgba(0,0,0,0.04); }
    .menu a.active { font-weight: 650; }
    .menu a.active::after { content: ''; position: absolute; bottom: 2px; left: 50%; transform: translateX(-50%); width: 27px; height: 2.7px; background: currentColor; border-radius: 1.5px; }
    .actions { display: flex; gap: 1.1rem; align-items: center; }
    .search input { padding: 0.6rem 1.15rem; border-radius: 1.5rem; border: 1.5px solid; outline: none; transition: all 0.3s; width: 200px; }
    .search input:focus { transform: scale(1.02); box-shadow: 0 0 8px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.6rem; font-size: 1.2rem; transition: transform 0.2s; border-radius: 0.6rem; }
    button:hover { transform: scale(1.08); }
    .badge { position: absolute; top: -1px; right: -1px; font-size: 0.7rem; min-width: 18px; height: 18px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-weight: 700; animation: pulse 1.9s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.16); } }
    .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2.2px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.27rem; }
    .toggle span { width: 25px; height: 2.6px; background: currentColor; border-radius: 1.5px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.25rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'transparent';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Teal';
  @Input() menuItems: MenuItem[] = [{ label: 'Swim', route: '/', icon: '🏊' }, { label: 'Dive', route: '/dive', icon: '🤿' }, { label: 'Ocean', route: '/ocean', icon: '🌊' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 13;
  @Input() userName = 'Aqua';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=21';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#14b8a6',
    secondaryColor: '#06b6d4',
    backgroundColor: '#f0fdfa',
    textColor: '#115e59',
    borderColor: '#99f6e4',
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
    this.isScrolled = window.scrollY > 18;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 1px 3px rgba(0,0,0,0.1)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E6`, backdropFilter: 'blur(10px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B3`, backdropFilter: 'blur(16px) saturate(170%)' },
      gradient: { background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get iconStyles() { return { color: this.appliedTheme.secondaryColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}80` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1A` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}15`, padding: '0.5rem 1rem', borderRadius: '2rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}25` : isHovered ? `${this.appliedTheme.primaryColor}12` : 'transparent',
      boxShadow: isActive ? `0 3px 10px rgba(0,0,0,0.08)` : 'none'
    };
  }
}
