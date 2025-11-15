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
  <div class="icon" [ngStyle]="iconStyles">👑</div>
  <span class="name">Gold</span>
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
  <input type="search" placeholder="Explore..." aria-label="Search" [ngStyle]="searchStyles">
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
  nav { transition: all 0.3s cubic-bezier(0.4, 0, 0.6, 1); }
  nav.scrolled { box-shadow: 0 10px 35px rgba(251, 191, 36,0.20); backdrop-filter: blur(15px); }
  .container { display: flex; align-items: center; justify-content: space-between; max-width: 1450px; margin: 0 auto; padding: 1.25rem 2.5rem; gap: 2.25rem; }
  .brand { display: flex; align-items: center; gap: 1.1rem; cursor: pointer; font-weight: 900; }
  .icon { font-size: 1.9rem; transition: transform 0.3s ease-in-out; }
  .icon:hover { transform: scale(1.25) rotate(-10deg); }
  .name { font-size: 1.7rem; font-weight: 900; letter-spacing: -0.6px; }
  .menu { display: flex; gap: 0.7rem; flex: 1; justify-content: center; }
  .menu a { padding: 0.9rem 1.5rem; border-radius: 0.8rem; text-decoration: none; transition: all 0.26s ease; font-weight: 550; display: flex; align-items: center; gap: 0.5rem; position: relative; }
  .menu a:hover { transform: translateY(-3px) scale(1.02); background-color: rgba(0,0,0,0.06); }
  .menu a.active { font-weight: 700; }
  .menu a.active::after { content: ''; position: absolute; bottom: 0px; left: 50%; transform: translateX(-50%); width: 32px; height: 3.5px; background: currentColor; border-radius: 2.5px; }
  .actions { display: flex; gap: 1.3rem; align-items: center; }
  .search input { padding: 0.7rem 1.3rem; border-radius: 2rem; border: 2px solid; outline: none; transition: all 0.28s; width: 240px; }
  .search input:focus { transform: scale(1.04); box-shadow: 0 0 12px rgba(0,0,0,0.1); }
  button { position: relative; background: none; border: none; cursor: pointer; padding: 0.7rem; font-size: 1.3rem; transition: transform 0.25s; border-radius: 0.7rem; }
  button:hover { transform: scale(1.12); }
  .badge { position: absolute; top: 0px; right: 0px; font-size: 0.75rem; min-width: 20px; height: 20px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; animation: pulse 1.5s infinite; }
  @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.22); } }
  .avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 3px solid; }
  .toggle { display: none; flex-direction: column; gap: 0.32rem; }
  .toggle span { width: 27px; height: 3px; background: currentColor; border-radius: 2.5px; transition: all 0.3s; }
  @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.75rem; animation: slideDown 0.28s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-15px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'gradient';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Gold';
  @Input() menuItems: MenuItem[] = [{ label: 'Crown', route: '/', icon: '👑' }, { label: 'Royal', route: '/royal', icon: '💎' }, { label: 'Luxury', route: '/luxury', icon: '✨' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 88;
  @Input() userName = 'Regal';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=23';

  private defaultTheme: NavbarTheme = {
  primaryColor: '#fbbf24',
  secondaryColor: '#f59e0b',
  backgroundColor: '#fefce8',
  textColor: '#713f12',
  borderColor: '#fde68a',
  accentColor: '#8b5cf6'
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
  const variants = {
  solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `2px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 4px 6px rgba(0,0,0,0.12)' },
  transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}DD`, backdropFilter: 'blur(15px)' },
  blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AD`, backdropFilter: 'blur(20px) saturate(190%)' },
  gradient: { background: `linear-gradient(110deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get iconStyles() { return { color: this.appliedTheme.accentColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}95` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}22` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}20`, padding: '0.6rem 1.1rem', borderRadius: '2.5rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.secondaryColor }; }

  getItemStyles(index: number) {
  const isActive = this.menuItems[index].route === this.activeRoute;
  const isHovered = this.hoveredIndex === index;
  return {
  color: this.appliedTheme.textColor,
  backgroundColor: isActive ? `${this.appliedTheme.primaryColor}30` : isHovered ? `${this.appliedTheme.primaryColor}18` : 'transparent',
  boxShadow: isActive ? `0 5px 15px rgba(0,0,0,0.12)` : 'none'
  };
  }
}
