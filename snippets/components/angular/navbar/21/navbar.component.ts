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
  <div class="icon" [ngStyle]="iconStyles">💠</div>
  <span class="name">Sapphire</span>
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
  <input type="search" placeholder="Find gems..." aria-label="Search" [ngStyle]="searchStyles">
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
  nav { transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94); }
  nav.scrolled { box-shadow: 0 6px 22px rgba(59, 130, 246,0.13); backdrop-filter: blur(14px); }
  .container { display: flex; align-items: center; justify-content: space-between; max-width: 1400px; margin: 0 auto; padding: 1.12rem 2.12rem; gap: 1.88rem; }
  .brand { display: flex; align-items: center; gap: 0.92rem; cursor: pointer; font-weight: 725; }
  .icon { font-size: 1.72rem; transition: transform 0.3s ease; }
  .icon:hover { transform: rotate(20deg) scale(1.18); }
  .name { font-size: 1.56rem; font-weight: 725; letter-spacing: -0.38px; }
  .menu { display: flex; gap: 0.56rem; flex: 1; justify-content: center; }
  .menu a { padding: 0.8rem 1.28rem; border-radius: 0.68rem; text-decoration: none; transition: all 0.27s ease-in; font-weight: 515; display: flex; align-items: center; gap: 0.5rem; position: relative; }
  .menu a:hover { transform: translateY(-2.2px) scale(1.015); background-color: rgba(0,0,0,0.042); }
  .menu a.active { font-weight: 640; }
  .menu a.active::after { content: ''; position: absolute; bottom: 1.8px; left: 50%; transform: translateX(-50%); width: 26px; height: 2.65px; background: currentColor; border-radius: 1.6px; }
  .actions { display: flex; gap: 1.08rem; align-items: center; }
  .search input { padding: 0.58rem 1.12rem; border-radius: 1.55rem; border: 1.55px solid; outline: none; transition: all 0.3s; width: 205px; }
  .search input:focus { transform: scale(1.018); box-shadow: 0 0 8.5px rgba(0,0,0,0.1); }
  button { position: relative; background: none; border: none; cursor: pointer; padding: 0.58rem; font-size: 1.18rem; transition: transform 0.21s; border-radius: 0.58rem; }
  button:hover { transform: scale(1.075); }
  .badge { position: absolute; top: -1.2px; right: -1.2px; font-size: 0.695rem; min-width: 18.2px; height: 18.2px; border-radius: 9.1px; display: flex; align-items: center; justify-content: center; font-weight: 715; animation: pulse 2.05s infinite; }
  @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.155); } }
  .avatar { width: 36.5px; height: 36.5px; border-radius: 50%; object-fit: cover; border: 2.15px solid; }
  .toggle { display: none; flex-direction: column; gap: 0.26rem; }
  .toggle span { width: 24.8px; height: 2.62px; background: currentColor; border-radius: 1.6px; transition: all 0.3s; }
  @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.28rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-10.5px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'blur';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Sapphire';
  @Input() menuItems: MenuItem[] = [{ label: 'Crystal', route: '/', icon: '💠' }, { label: 'Gem', route: '/gem', icon: '💎' }, { label: 'Jewel', route: '/jewel', icon: '💍' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 17;
  @Input() userName = 'Sapphire';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=25';
  private defaultTheme: NavbarTheme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#2563eb',
  backgroundColor: '#eff6ff',
  textColor: '#1e40af',
  borderColor: '#93c5fd',
  accentColor: '#f472b6'
  };
  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;
  get appliedTheme(): NavbarTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  @HostListener('window:scroll', [])
  onWindowScroll() {
  this.isScrolled = window.scrollY > 17;
  }
  toggleMobileMenu() {
  this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }
  get navbarStyles() {
  const variants = {
  solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 1.5px 3.5px rgba(0,0,0,0.095)' },
  transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E5`, backdropFilter: 'blur(10.5px)' },
  blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B1`, backdropFilter: 'blur(16.5px) saturate(172%)' },
  gradient: { background: `linear-gradient(132deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}82` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1B` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}155`, padding: '0.515rem 1.015rem', borderRadius: '2.05rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }
  getItemStyles(index: number) {
  const isActive = this.menuItems[index].route === this.activeRoute;
  const isHovered = this.hoveredIndex === index;
  return {
  color: this.appliedTheme.textColor,
  backgroundColor: isActive ? `${this.appliedTheme.primaryColor}245` : isHovered ? `${this.appliedTheme.primaryColor}125` : 'transparent',
  boxShadow: isActive ? `0 3.2px 10.5px rgba(0,0,0,0.085)` : 'none'
  };
  }
}
