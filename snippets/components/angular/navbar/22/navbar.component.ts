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
  <div class="icon" [ngStyle]="iconStyles">🍑</div>
  <span class="name">Peach</span>
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
  <input type="search" placeholder="Discover..." aria-label="Search" [ngStyle]="searchStyles">
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
  nav { transition: all 0.34s cubic-bezier(0.25, 1, 0.5, 1); }
  nav.scrolled { box-shadow: 0 5px 18px rgba(253, 164, 175,0.11); backdrop-filter: blur(9px); }
  .container { display: flex; align-items: center; justify-content: space-between; max-width: 1380px; margin: 0 auto; padding: 1.08rem 2.08rem; gap: 1.82rem; }
  .brand { display: flex; align-items: center; gap: 0.88rem; cursor: pointer; font-weight: 680; }
  .icon { font-size: 1.68rem; transition: transform 0.3s ease-out; }
  .icon:hover { transform: scale(1.12) rotate(-8deg); }
  .name { font-size: 1.52rem; font-weight: 680; letter-spacing: -0.32px; }
  .menu { display: flex; gap: 0.52rem; flex: 1; justify-content: center; }
  .menu a { padding: 0.78rem 1.24rem; border-radius: 0.64rem; text-decoration: none; transition: all 0.29s cubic-bezier(0.25, 1, 0.5, 1); font-weight: 510; display: flex; align-items: center; gap: 0.5rem; position: relative; }
  .menu a:hover { transform: translateY(-1.8px); background-color: rgba(0,0,0,0.038); }
  .menu a.active { font-weight: 630; }
  .menu a.active::after { content: ''; position: absolute; bottom: 2.2px; left: 50%; transform: translateX(-50%); width: 24px; height: 2.5px; background: currentColor; border-radius: 1.45px; }
  .actions { display: flex; gap: 1.04rem; align-items: center; }
  .search input { padding: 0.54rem 1.08rem; border-radius: 1.45rem; border: 1.45px solid; outline: none; transition: all 0.32s; width: 198px; }
  .search input:focus { transform: scale(1.015); box-shadow: 0 0 7.5px rgba(0,0,0,0.1); }
  button { position: relative; background: none; border: none; cursor: pointer; padding: 0.54rem; font-size: 1.14rem; transition: transform 0.2s; border-radius: 0.54rem; }
  button:hover { transform: scale(1.065); }
  .badge { position: absolute; top: -0.8px; right: -0.8px; font-size: 0.68rem; min-width: 17.8px; height: 17.8px; border-radius: 8.9px; display: flex; align-items: center; justify-content: center; font-weight: 705; animation: pulse 2.15s infinite; }
  @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.145); } }
  .avatar { width: 35.5px; height: 35.5px; border-radius: 50%; object-fit: cover; border: 2.05px solid; }
  .toggle { display: none; flex-direction: column; gap: 0.24rem; }
  .toggle span { width: 24.2px; height: 2.52px; background: currentColor; border-radius: 1.45px; transition: all 0.3s; }
  @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.22rem; animation: slideDown 0.32s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-9.5px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'transparent';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Peach';
  @Input() menuItems: MenuItem[] = [{ label: 'Sweet', route: '/', icon: '🍑' }, { label: 'Soft', route: '/soft', icon: '🌸' }, { label: 'Gentle', route: '/gentle', icon: '🌺' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 23;
  @Input() userName = 'Peach';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=26';

  private defaultTheme: NavbarTheme = {
  primaryColor: '#fda4af',
  secondaryColor: '#fb7185',
  backgroundColor: '#fff1f2',
  textColor: '#881337',
  borderColor: '#fecdd3',
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
  solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 1.2px 3.2px rgba(0,0,0,0.088)' },
  transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E8`, backdropFilter: 'blur(9.5px)' },
  blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B4`, backdropFilter: 'blur(15.5px) saturate(168%)' },
  gradient: { background: `linear-gradient(140deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}78` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}19` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}14`, padding: '0.485rem 0.985rem', borderRadius: '1.95rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.secondaryColor }; }

  getItemStyles(index: number) {
  const isActive = this.menuItems[index].route === this.activeRoute;
  const isHovered = this.hoveredIndex === index;
  return {
  color: this.appliedTheme.textColor,
  backgroundColor: isActive ? `${this.appliedTheme.primaryColor}23` : isHovered ? `${this.appliedTheme.primaryColor}115` : 'transparent',
  boxShadow: isActive ? `0 2.8px 9.5px rgba(0,0,0,0.078)` : 'none'
  };
  }
}
