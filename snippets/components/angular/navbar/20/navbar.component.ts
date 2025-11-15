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
  <div class="icon" [ngStyle]="iconStyles">🍇</div>
  <span class="name">Plum</span>
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
  <input type="search" placeholder="Seek..." aria-label="Search" [ngStyle]="searchStyles">
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
  nav { transition: all 0.38s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  nav.scrolled { box-shadow: 0 7px 25px rgba(147, 51, 234,0.14); backdrop-filter: blur(12px); }
  .container { display: flex; align-items: center; justify-content: space-between; max-width: 1340px; margin: 0 auto; padding: 1.15rem 2.15rem; gap: 1.85rem; }
  .brand { display: flex; align-items: center; gap: 0.95rem; cursor: pointer; font-weight: 750; }
  .icon { font-size: 1.75rem; transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  .icon:hover { transform: scale(1.2) translateY(-2px); }
  .name { font-size: 1.58rem; font-weight: 750; letter-spacing: -0.42px; }
  .menu { display: flex; gap: 0.58rem; flex: 1; justify-content: center; }
  .menu a { padding: 0.82rem 1.32rem; border-radius: 0.72rem; text-decoration: none; transition: all 0.3s ease-out; font-weight: 525; display: flex; align-items: center; gap: 0.5rem; position: relative; }
  .menu a:hover { transform: translateX(3px) scale(1.01); background-color: rgba(0,0,0,0.045); }
  .menu a.active { font-weight: 660; }
  .menu a.active::after { content: ''; position: absolute; bottom: 1.5px; left: 50%; transform: translateX(-50%); width: 28px; height: 2.8px; background: currentColor; border-radius: 1.75px; }
  .actions { display: flex; gap: 1.12rem; align-items: center; }
  .search input { padding: 0.62rem 1.18rem; border-radius: 1.6rem; border: 1.6px solid; outline: none; transition: all 0.3s; width: 210px; }
  .search input:focus { transform: scale(1.025); box-shadow: 0 0 9px rgba(0,0,0,0.1); }
  button { position: relative; background: none; border: none; cursor: pointer; padding: 0.62rem; font-size: 1.22rem; transition: transform 0.23s; border-radius: 0.62rem; }
  button:hover { transform: scale(1.09); }
  .badge { position: absolute; top: -1.5px; right: -1.5px; font-size: 0.71rem; min-width: 18.5px; height: 18.5px; border-radius: 9.25px; display: flex; align-items: center; justify-content: center; font-weight: 725; animation: pulse 1.85s infinite; }
  @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.17); } }
  .avatar { width: 37px; height: 37px; border-radius: 50%; object-fit: cover; border: 2.3px solid; }
  .toggle { display: none; flex-direction: column; gap: 0.28rem; }
  .toggle span { width: 25.5px; height: 2.7px; background: currentColor; border-radius: 1.75px; transition: all 0.3s; }
  @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.35rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-11px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'solid';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Plum';
  @Input() menuItems: MenuItem[] = [{ label: 'Grape', route: '/', icon: '🍇' }, { label: 'Berry', route: '/berry', icon: '🫐' }, { label: 'Wine', route: '/wine', icon: '🍷' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 61;
  @Input() userName = 'Violet';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=24';
  private defaultTheme: NavbarTheme = {
  primaryColor: '#9333ea',
  secondaryColor: '#a855f7',
  backgroundColor: '#faf5ff',
  textColor: '#581c87',
  borderColor: '#d8b4fe',
  accentColor: '#14b8a6'
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
  solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 2px 5px rgba(0,0,0,0.09)' },
  transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E3`, backdropFilter: 'blur(11px)' },
  blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B2`, backdropFilter: 'blur(17px) saturate(175%)' },
  gradient: { background: `linear-gradient(125deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}85` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1C` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}16`, padding: '0.52rem 1.02rem', borderRadius: '2.1rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }
  getItemStyles(index: number) {
  const isActive = this.menuItems[index].route === this.activeRoute;
  const isHovered = this.hoveredIndex === index;
  return {
  color: this.appliedTheme.textColor,
  backgroundColor: isActive ? `${this.appliedTheme.primaryColor}26` : isHovered ? `${this.appliedTheme.primaryColor}13` : 'transparent',
  boxShadow: isActive ? `0 3.5px 11px rgba(0,0,0,0.09)` : 'none'
  };
  }
}
