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
          <div class="icon" [ngStyle]="iconStyles">🔥</div>
          <span class="name">Ember</span>
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
    nav { transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
    nav.scrolled { box-shadow: 0 10px 40px rgba(0,0,0,0.20); backdrop-filter: blur(12px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1380px; margin: 0 auto; padding: 1.125rem 2.25rem; gap: 2rem; }
    .brand { display: flex; align-items: center; gap: 1.125rem; cursor: pointer; font-weight: 900; }
    .icon { font-size: 1.875rem; transition: transform 0.3s ease; }
    .icon:hover { transform: scale(1.3) rotate(-10deg); }
    .name { font-size: 1.75rem; font-weight: 900; letter-spacing: -0.75px; }
    .menu { display: flex; gap: 0.75rem; flex: 1; justify-content: flex-start; }
    .menu a { padding: 1rem 1.75rem; border-radius: 0.875rem; text-decoration: none; transition: all 0.2s; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; }
    .menu a:hover { transform: scale(1.05); background-color: rgba(0,0,0,0.05); }
    .menu a.active { font-weight: 700; }
    .menu a.active::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 35px; height: 4px; background: currentColor; border-radius: 2px; }
    .actions { display: flex; gap: 1.5rem; align-items: center; }
    .search input { padding: 0.75rem 1.5rem; border-radius: 0.875rem; border: 1px solid; outline: none; transition: all 0.3s; }
    .search input:focus { transform: scale(1.02); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.75rem; font-size: 1.375rem; transition: transform 0.2s; }
    button:hover { transform: scale(1.15); }
    .badge { position: absolute; top: -2px; right: -2px; font-size: 0.7rem; min-width: 18px; height: 18px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-weight: 700; animation: pulse 1s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.25); } }
    .avatar { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 3px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.35rem; }
    .toggle span { width: 28px; height: 3.5px; background: currentColor; border-radius: 2px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'gradient';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'sticky';
  @Input() brandName = 'Ember';
  @Input() menuItems: MenuItem[] = [{ label: 'Flame', route: '/', icon: '🔥' }, { label: 'Heat', route: '/heat', icon: '🌡️' }, { label: 'Burn', route: '/burn', icon: '💥' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 27;
  @Input() userName = 'Blaze';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=13';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#f97316',
    secondaryColor: '#dc2626',
    backgroundColor: '#fff7ed',
    textColor: '#7c2d12',
    borderColor: '#fdba74',
    accentColor: '#ea580c'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 35;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}` },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}CC`, backdropFilter: 'blur(10px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AA`, backdropFilter: 'blur(20px) saturate(180%)' },
      gradient: { background: `linear-gradient(120deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
