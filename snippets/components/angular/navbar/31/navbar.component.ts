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
          <div class="icon" [ngStyle]="iconStyles">🔲</div>
          <span class="name">Charcoal</span>
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
            <input type="search" placeholder="Deep search..." aria-label="Search" [ngStyle]="searchStyles">
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
    nav { transition: all 0.34s cubic-bezier(0.17, 0.67, 0.83, 0.67); }
    nav.scrolled { box-shadow: 0 7px 23px rgba(82, 82, 91,0.135); backdrop-filter: blur(12px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1460px; margin: 0 auto; padding: 1.2rem 2.3rem; gap: 2rem; }
    .brand { display: flex; align-items: center; gap: 1rem; cursor: pointer; font-weight: 850; }
    .icon { font-size: 1.85rem; transition: transform 0.3s ease; }
    .icon:hover { transform: scale(1.18) rotate(45deg); }
    .name { font-size: 1.7rem; font-weight: 850; letter-spacing: -0.55px; }
    .menu { display: flex; gap: 0.68rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.95rem 1.45rem; border-radius: 0.85rem; text-decoration: none; transition: all 0.3s ease-out; font-weight: 540; display: flex; align-items: center; gap: 0.5rem; position: relative; }
    .menu a:hover { transform: translateY(-2.4px) scale(1.02); background-color: rgba(0,0,0,0.05); }
    .menu a.active { font-weight: 690; }
    .menu a.active::after { content: ''; position: absolute; bottom: 1rem; left: 50%; transform: translateX(-50%); width: 30px; height: 3px; background: currentColor; border-radius: 2px; }
    .actions { display: flex; gap: 1.25rem; align-items: center; }
    .search input { padding: 0.7rem 1.3rem; border-radius: 1.9rem; border: 1.9px solid; outline: none; transition: all 0.22s; width: 230px; }
    .search input:focus { transform: scale(1.035); box-shadow: 0 0 11px rgba(0,0,0,0.1); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.7rem; font-size: 1.35rem; transition: transform 0.27s; border-radius: 0.7rem; }
    button:hover { transform: scale(1.115); }
    .badge { position: absolute; top: -2.5px; right: -2.5px; font-size: 0.78rem; min-width: 19.5px; height: 19.5px; border-radius: 9.75px; display: flex; align-items: center; justify-content: center; font-weight: 780; animation: pulse 1.55s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.21); } }
    .avatar { width: 39px; height: 39px; border-radius: 50%; object-fit: cover; border: 2.65px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.33rem; }
    .toggle span { width: 27px; height: 2.9px; background: currentColor; border-radius: 2.2px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1.6rem; animation: slideDown 0.22s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-13px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'blur';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Charcoal';
  @Input() menuItems: MenuItem[] = [{ label: 'Dark', route: '/', icon: '🔲' }, { label: 'Shadow', route: '/shadow', icon: '🌑' }, { label: 'Depth', route: '/depth', icon: '⬛' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 91;
  @Input() userName = 'Charcoal';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=31';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#52525b',
    secondaryColor: '#3f3f46',
    backgroundColor: '#fafafa',
    textColor: '#18181b',
    borderColor: '#d4d4d8',
    accentColor: '#ef4444'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 26;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `2px solid ${this.appliedTheme.borderColor}`, boxShadow: '0 3.5px 7px rgba(0,0,0,0.12)' },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}DC`, backdropFilter: 'blur(13px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AA`, backdropFilter: 'blur(19px) saturate(185%)' },
      gradient: { background: `linear-gradient(95deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
  get iconStyles() { return { color: this.appliedTheme.primaryColor }; }
  get menuStyles() { return {}; }
  get actionsStyles() { return {}; }
  get searchStyles() { return { borderColor: this.appliedTheme.borderColor, color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.backgroundColor}95` }; }
  get notifStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1F` }; }
  get badgeStyles() { return { backgroundColor: this.appliedTheme.accentColor, color: '#ffffff' }; }
  get profileStyles() { return { color: this.appliedTheme.textColor, backgroundColor: `${this.appliedTheme.primaryColor}1B`, padding: '0.6rem 1.1rem', borderRadius: '2.3rem' }; }
  get avatarStyles() { return { borderColor: this.appliedTheme.secondaryColor }; }

  getItemStyles(index: number) {
    const isActive = this.menuItems[index].route === this.activeRoute;
    const isHovered = this.hoveredIndex === index;
    return {
      color: this.appliedTheme.textColor,
      backgroundColor: isActive ? `${this.appliedTheme.primaryColor}2C` : isHovered ? `${this.appliedTheme.primaryColor}17` : 'transparent',
      boxShadow: isActive ? `0 4.5px 13px rgba(0,0,0,0.1)` : 'none'
    };
  }
}
