import { Component, Input, Output, EventEmitter } from '@angular/core';

interface CardTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  shadowColor: string;
  accentColor: string;
}

@Component({
  selector: 'app-card',
  template: `
    <div
      class="card"
      [ngStyle]="cardStyles"
      [class.hoverable]="hoverable"
      [class.clickable]="clickable"
      (click)="handleClick()"
      (mouseenter)="handleHover(true)"
      (mouseleave)="handleHover(false)"
      role="article"
      [attr.aria-label]="title || 'Card'"
      tabindex="0"
    >
      <div *ngIf="badge" class="ribbon" [ngStyle]="ribbonStyles">{{ badge }}</div>

      <div *ngIf="image" class="card-image" [ngStyle]="imageStyles">
        <img [src]="image" [alt]="imageAlt || 'Card image'" />
        <div *ngIf="imageOverlay" class="image-overlay" [ngStyle]="overlayStyles">
          <div *ngIf="label" class="overlay-label">{{ label }}</div>
        </div>
      </div>

      <div class="card-content" [ngStyle]="contentStyles">
        <div *ngIf="title" class="card-title" [ngStyle]="titleStyles">{{ title }}</div>
        <div *ngIf="subtitle" class="card-subtitle" [ngStyle]="subtitleStyles">{{ subtitle }}</div>
        <div class="card-body" [ngStyle]="bodyStyles">
          <ng-content></ng-content>
        </div>
      </div>

      <div *ngIf="hasFooter" class="card-footer" [ngStyle]="footerStyles">
        <ng-content select="[footer]"></ng-content>
      </div>
    </div>
  `,
  styles: [`
    .card {
      border-radius: 20px;
      overflow: hidden;
      transition: all 0.4s ease-in-out;
      position: relative;
      display: flex;
      flex-direction: column;
      outline: none;
    }
    .card.hoverable:hover {
      transform: translateY(-6px) rotateX(5deg);
      transform-style: preserve-3d;
    }
    .card.clickable {
      cursor: pointer;
    }
    .ribbon {
      position: absolute;
      top: 15px;
      left: -8px;
      padding: 8px 20px 8px 16px;
      font-size: 12px;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      z-index: 10;
      box-shadow: 2px 2px 8px rgba(0,0,0,0.2);
    }
    .ribbon::after {
      content: '';
      position: absolute;
      left: 0;
      bottom: -8px;
      width: 0;
      height: 0;
      border-left: 8px solid transparent;
      border-top: 8px solid rgba(0,0,0,0.2);
    }
    .card-image {
      position: relative;
      overflow: hidden;
      height: 240px;
    }
    .card-image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    .card.hoverable:hover .card-image img {
      transform: scale(1.15);
    }
    .image-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      display: flex;
      align-items: flex-end;
      justify-content: center;
      padding: 20px;
      transition: opacity 0.3s ease;
    }
    .overlay-label {
      padding: 10px 20px;
      border-radius: 30px;
      font-size: 14px;
      font-weight: 700;
      background: rgba(255,255,255,0.95);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
    .card-content {
      padding: 26px;
      flex: 1;
    }
    .card-title {
      font-size: 24px;
      font-weight: 900;
      margin-bottom: 12px;
      line-height: 1.2;
    }
    .card-subtitle {
      font-size: 16px;
      opacity: 0.7;
      margin-bottom: 16px;
      font-style: italic;
    }
    .card-body {
      font-size: 15px;
      line-height: 1.8;
    }
    .card-footer {
      padding: 20px 26px;
      background: rgba(0,0,0,0.03);
      display: flex;
      gap: 14px;
      align-items: center;
      justify-content: space-between;
    }
  `]
})
export class CardComponent {
  @Input() theme: Partial<CardTheme> = {};
  @Input() variant: 'flat' | 'elevated' | 'outlined' | 'glass' | 'neumorphic' | 'gradient' = 'elevated';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() title?: string;
  @Input() subtitle?: string;
  @Input() label?: string;
  @Input() image?: string;
  @Input() imageAlt?: string;
  @Input() imageOverlay = false;
  @Input() badge?: string;
  @Input() hoverable = true;
  @Input() clickable = false;
  @Input() hasFooter = false;

  @Output() cardClick = new EventEmitter<MouseEvent>();
  @Output() cardHover = new EventEmitter<boolean>();

  private defaultTheme: CardTheme = {
    primaryColor: '#ec4899',
    secondaryColor: '#f472b6',
    backgroundColor: '#ffffff',
    textColor: '#831843',
    borderColor: '#fce7f3',
    shadowColor: 'rgba(236, 72, 153, 0.25)',
    accentColor: '#db2777'
  };

  get appliedTheme(): CardTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get cardStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { maxWidth: '300px' },
      md: { maxWidth: '380px' },
      lg: { maxWidth: '500px' }
    };

    const variants = {
      flat: {
        backgroundColor: t.backgroundColor,
        boxShadow: 'none',
        border: `2px solid ${t.borderColor}`
      },
      elevated: {
        backgroundColor: t.backgroundColor,
        boxShadow: `0 15px 35px ${t.shadowColor}, 0 5px 15px ${t.shadowColor}`,
        border: 'none'
      },
      outlined: {
        backgroundColor: t.backgroundColor,
        border: `4px solid ${t.primaryColor}`,
        boxShadow: `0 0 0 4px ${t.borderColor}`
      },
      glass: {
        backgroundColor: `${t.backgroundColor}f0`,
        backdropFilter: 'blur(16px) saturate(180%)',
        border: `2px solid ${t.borderColor}`,
        boxShadow: `0 10px 40px ${t.shadowColor}`
      },
      neumorphic: {
        backgroundColor: t.backgroundColor,
        boxShadow: `12px 12px 24px ${t.shadowColor}, -12px -12px 24px rgba(255,255,255,0.8)`,
        border: 'none'
      },
      gradient: {
        background: `linear-gradient(145deg, ${t.primaryColor} 0%, ${t.secondaryColor} 50%, ${t.accentColor} 100%)`,
        border: 'none',
        boxShadow: `0 10px 30px ${t.shadowColor}`
      }
    };

    return {
      ...sizeMap[this.size],
      ...variants[this.variant],
      color: this.variant === 'gradient' ? '#ffffff' : t.textColor
    };
  }

  get ribbonStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.primaryColor,
      color: '#ffffff'
    };
  }

  get imageStyles() {
    return {};
  }

  get overlayStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(0deg, ${t.primaryColor}60 0%, transparent 70%)`,
      opacity: this.imageOverlay ? 1 : 0
    };
  }

  get contentStyles() {
    return {};
  }

  get titleStyles() {
    const t = this.appliedTheme;
    return {
      color: this.variant === 'gradient' ? '#ffffff' : t.textColor
    };
  }

  get subtitleStyles() {
    const t = this.appliedTheme;
    return {
      color: this.variant === 'gradient' ? '#ffffff' : t.textColor
    };
  }

  get bodyStyles() {
    const t = this.appliedTheme;
    return {
      color: this.variant === 'gradient' ? '#ffffff' : t.textColor
    };
  }

  get footerStyles() {
    return {};
  }

  handleClick(event?: MouseEvent): void {
    if (this.clickable && event) {
      this.cardClick.emit(event);
    }
  }

  handleHover(isHovering: boolean): void {
    this.cardHover.emit(isHovering);
  }
}
