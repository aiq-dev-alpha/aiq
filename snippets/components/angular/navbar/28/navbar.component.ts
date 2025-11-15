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
          <div class="icon" [ngStyle]="iconStyles">⚙️</div>
          <span class="name">Steel</span>
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
            <input type="search" placeholder="Find tools..." aria-label="Search" [ngStyle]="searchStyles">
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
    nav { transition: all 0.32s cubic-bezier(0.22, 1, 0.36, 1); }
    nav.scrolled { box-shadow: 0 6px 20px rgba(100, 116, 139,0.12); backdrop-filter: blur(13px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1390px; margin: 0 auto; padding: 1.14rem 2.14rem; gap: 1.86rem; }
    .brand { display: flex; align-items: center; gap: 0.94rem; cursor: pointer; font-weight: 710; }
    .icon { font-size: 1.74rem; transition: transform 0.3s ease; }
    .icon:hover { transform: rotate(90deg); }
    .name { font-size: 1.58rem; font-weight: 710; letter-spacing: -0.4px; }
    .menu { display: flex; gap: 0.58rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.84rem 1.34rem; border-radius: 0.74rem; text-decoration: none; transition: all 0.3s ease-out; font-weight: 522; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: translateY(-2.1px) scale(1.012); background-color: rgba(0,0,0,0.044); }
    .menu a.active { font-weight: 655; }
    .menu a.active::after { content: ''; position: absolute; bottom: 1.6px; left: 50%; transform: translateX(-50%); width: 27.5px; height: 2.75px; background: currentColor; border-radius: 1.7px; }
    .actions { display: flex; gap: 1.14rem; align-items: center; }
    .search input { padding: 0.64rem 1.18rem; border-radius: 1.6rem; border: 1.6px solid; outline: none; transition: all 0.3s; width: 208px; }
    .search input:focus { transform: scale(1.022); box-shadow: 0 0 8.8px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.64rem; font-size: 1.24rem; transition: transform 0.22s; border-radius: 0.64rem; }
    button:hover { transform: scale(1.088); }
    .badge { position: absolute; top: -1.4px; right: -1.4px; font-size: 0.71rem; min-width: 18.4px; height: 18.4px; border-radius: 9.2px; display: flex; align-items: center; justify-content: center; font-weight: 722; animation: pulse 1.95s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.165); } }
    .avatar { width: 36.8px; height: 36.8px; border-radius: 50%; object-fit: cover; border: 2.25px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.27rem; }
    .toggle span { width: 25.2px; height: 2.64px; background: currentColor; border-radius: 1.7px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.32rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-10.8px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'blur';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Steel';
  @Input() menuItems: MenuItem[] = [{ label: 'Gear', route: '/', icon: '⚙️' }, { label: 'Metal', route: '/metal', icon: '🔩' }, { label: 'Steel', route: '/steel', icon: '🔨' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 34;
  @Input() userName = 'Steel';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=28';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#64748b',
    secondaryColor: '#475569',
    backgroundColor: '#f8fafc',
    textColor: '#1e293b',
    borderColor: '#cbd5e1',
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
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 1.8px 4.2px rgba(0,0,0,0.092)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}E4`, backdropFilter: 'blur(10.8px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}B05`, backdropFilter: 'blur(16.8px) saturate(173%)' },
      gradient: { background: `linear-gradient(128deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}84` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1BE` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}158`, padding: '0.52rem 1.02rem', borderRadius: '2.08rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.primaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}248` : isHovered ? `${this.appliedTheme.primaryColor}128` : 'transparent',
      boxShadow: isActive ? `0 3.4px 10.8px rgba(0,0,0,0.087)` : 'none'
    };
  }
}
