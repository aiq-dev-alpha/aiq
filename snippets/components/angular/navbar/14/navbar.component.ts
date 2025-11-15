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
          <div class="icon" [ngStyle]="iconStyles">💜</div>
          <span class="name">Violet</span>
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
    nav { transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); }
    nav.scrolled { box-shadow: 0 9px 36px rgba(0,0,0,0.18); backdrop-filter: blur(15px); }
    .container { display: flex; align-items: center; justify-content: space-between; max-width: 1350px; margin: 0 auto; padding: 1.175rem 2.175rem; gap: 2rem; }
    .brand { display: flex; align-items: center; gap: 1.05rem; cursor: pointer; font-weight: 825; }
    .icon { font-size: 1.85rem; transition: transform 0.3s ease; }
    .icon:hover { transform: scale(1.25) rotate(-15deg); }
    .name { font-size: 1.675rem; font-weight: 825; letter-spacing: -0.6px; }
    .menu { display: flex; gap: 0.7rem; flex: 1; justify-content: center; }
    .menu a { padding: 0.95rem 1.55rem; border-radius: 0.85rem; text-decoration: none; transition: all 0.26s; font-weight: 550; display: flex; align-items: center; gap: 0.5rem; }
    .menu a:hover { transform: translateY(-3.5px); background-color: rgba(0,0,0,0.05); }
    .menu a.active { font-weight: 725; }
    .menu a.active::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 33px; height: 3.5px; background: currentColor; border-radius: 2px; }
    .actions { display: flex; gap: 1.35rem; align-items: center; }
    .search input { padding: 0.7rem 1.35rem; border-radius: 0.85rem; border: 1px solid; outline: none; transition: all 0.3s; }
    .search input:focus { transform: scale(1.02); }
    button { position: relative; background: none; border: none; cursor: pointer; padding: 0.7rem; font-size: 1.325rem; transition: transform 0.2s; }
    button:hover { transform: scale(1.13); }
    .badge { position: absolute; top: -2px; right: -2px; font-size: 0.7rem; min-width: 18px; height: 18px; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-weight: 700; animation: pulse 1.7s infinite; }
    @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.22); } }
    .avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2.75px solid; }
    .toggle { display: none; flex-direction: column; gap: 0.325rem; }
    .toggle span { width: 27px; height: 3.25px; background: currentColor; border-radius: 2px; transition: all 0.3s; }
    @media (max-width: 768px) { .menu, .search { display: none; } .toggle { display: flex; } .menu.active { display: flex; position: absolute; top: 100%; left: 0; right: 0; flex-direction: column; padding: 1rem; animation: slideDown 0.3s; } @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } } }
  `]
})
export class NavbarComponent {
  @Input() theme: Partial<NavbarTheme> = {};
  @Input() variant: 'solid' | 'transparent' | 'blur' | 'gradient' = 'gradient';
  @Input() position: 'static' | 'sticky' | 'fixed' = 'fixed';
  @Input() brandName = 'Violet';
  @Input() menuItems: MenuItem[] = [{ label: 'Magic', route: '/', icon: '✨' }, { label: 'Dream', route: '/dream', icon: '💭' }, { label: 'Wonder', route: '/wonder', icon: '🌈' }];
  @Input() activeRoute = '/';
  @Input() showSearch = true;
  @Input() showNotifications = true;
  @Input() showUserProfile = true;
  @Input() notificationCount = 37;
  @Input() userName = 'Violet';
  @Input() userAvatar = 'https://i.pravatar.cc/150?img=18';

  private defaultTheme: NavbarTheme = {
    primaryColor: '#a78bfa',
    secondaryColor: '#8b5cf6',
    backgroundColor: '#f5f3ff',
    textColor: '#5b21b6',
    borderColor: '#c4b5fd',
    accentColor: '#ec4899'
  };

  isMobileMenuOpen = false;
  isScrolled = false;
  hoveredIndex: number | null = null;

  get appliedTheme(): NavbarTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  @HostListener('window:scroll', [])
  onWindowScroll() {
    this.isScrolled = window.scrollY > 27;
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

  get navbarStyles() {
    const variants = {
      solid: { backgroundColor: this.appliedTheme.backgroundColor, borderBottom: `1px solid ${this.appliedTheme.borderColor}` },
      transparent: { backgroundColor: `${this.appliedTheme.backgroundColor}CC`, backdropFilter: 'blur(10px)' },
      blur: { backgroundColor: `${this.appliedTheme.backgroundColor}AA`, backdropFilter: 'blur(20px) saturate(180%)' },
      gradient: { background: `linear-gradient(110deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.secondaryColor})` }
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
