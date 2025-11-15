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
      <div *ngIf="image" class="card-image" [ngStyle]="imageStyles">
        <img [src]="image" [alt]="imageAlt || 'Card image'" />
        <div *ngIf="imageOverlay" class="image-overlay" [ngStyle]="overlayStyles"></div>
      </div>

      <div *ngIf="badge" class="corner-badge" [ngStyle]="badgeStyles">{{ badge }}</div>

      <div class="card-content" [ngStyle]="contentStyles">
        <div *ngIf="label" class="card-label" [ngStyle]="labelStyles">{{ label }}</div>
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
      border-radius: 8px;
      overflow: hidden;
      transition: all 0.3s ease;
      position: relative;
      display: flex;
      flex-direction: column;
      outline: none;
    }
    .card.hoverable:hover {
      transform: scale(1.03);
      box-shadow: 0 20px 40px rgba(0,0,0,0.15) !important;
    }
    .card.clickable {
      cursor: pointer;
    }
    .card-image {
      position: relative;
      overflow: hidden;
      height: 200px;
      clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
    }
    .card-image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.4s ease;
    }
    .card.hoverable:hover .card-image img {
      transform: scale(1.08);
    }
    .image-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      transition: opacity 0.3s ease;
    }
    .corner-badge {
      position: absolute;
      top: 0;
      right: 0;
      padding: 10px 18px;
      font-size: 12px;
      font-weight: 700;
      clip-path: polygon(0 0, 100% 0, 100% 100%);
      transform: translateX(0) translateY(0);
    }
    .card-content {
      padding: 28px 22px 22px;
      flex: 1;
    }
    .card-label {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1.2px;
      margin-bottom: 14px;
    }
    .card-title {
      font-size: 21px;
      font-weight: 700;
      margin-bottom: 8px;
      line-height: 1.3;
    }
    .card-subtitle {
      font-size: 14px;
      opacity: 0.65;
      margin-bottom: 14px;
      font-weight: 400;
    }
    .card-body {
      font-size: 15px;
      line-height: 1.65;
    }
    .card-footer {
      padding: 16px 22px;
      border-top: 1px dashed rgba(0,0,0,0.1);
      display: flex;
      gap: 10px;
      align-items: center;
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
    primaryColor: '#14b8a6',
    secondaryColor: '#5eead4',
    backgroundColor: '#ffffff',
    textColor: '#134e4a',
    borderColor: '#99f6e4',
    shadowColor: 'rgba(20, 184, 166, 0.2)',
    accentColor: '#0f766e'
  };

  get appliedTheme(): CardTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get cardStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { maxWidth: '290px' },
      md: { maxWidth: '370px' },
      lg: { maxWidth: '490px' }
    };

    const variants = {
      flat: {
        backgroundColor: t.backgroundColor,
        boxShadow: 'none',
        border: `1px solid ${t.borderColor}`
      },
      elevated: {
        backgroundColor: t.backgroundColor,
        boxShadow: `0 8px 20px ${t.shadowColor}, 0 2px 8px ${t.shadowColor}`,
        border: 'none'
      },
      outlined: {
        backgroundColor: t.backgroundColor,
        border: `2px dashed ${t.primaryColor}`,
        boxShadow: 'none'
      },
      glass: {
        backgroundColor: `${t.backgroundColor}e6`,
        backdropFilter: 'blur(10px)',
        border: `1px solid ${t.borderColor}`,
        boxShadow: `0 8px 32px 0 ${t.shadowColor}`
      },
      neumorphic: {
        backgroundColor: t.backgroundColor,
        boxShadow: `6px 6px 12px ${t.shadowColor}, -6px -6px 12px rgba(255,255,255,0.8)`,
        border: 'none'
      },
      gradient: {
        background: `linear-gradient(120deg, ${t.primaryColor} 0%, ${t.secondaryColor} 100%)`,
        border: 'none',
        boxShadow: `0 8px 24px ${t.shadowColor}`
      }
    };

    return {
      ...sizeMap[this.size],
      ...variants[this.variant],
      color: this.variant === 'gradient' ? '#ffffff' : t.textColor
    };
  }

  get imageStyles() {
    return {};
  }

  get overlayStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(225deg, ${t.primaryColor}50 0%, ${t.secondaryColor}30 100%)`,
      opacity: this.imageOverlay ? 1 : 0
    };
  }

  get badgeStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.accentColor,
      color: '#ffffff'
    };
  }

  get labelStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.borderColor,
      color: t.accentColor
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
