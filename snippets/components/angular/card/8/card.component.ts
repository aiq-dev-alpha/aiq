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
        <div *ngIf="badge" class="badge" [ngStyle]="badgeStyles">{{ badge }}</div>
      </div>

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
      border-radius: 14px;
      overflow: hidden;
      transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
      position: relative;
      display: flex;
      flex-direction: column;
      outline: none;
    }
    .card.hoverable:hover {
      transform: translateY(-5px) scale(1.05);
    }
    .card.clickable {
      cursor: pointer;
    }
    .card-image {
      position: relative;
      overflow: hidden;
      height: 200px;
    }
    .card-image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
    }
    .card.hoverable:hover .card-image img {
      transform: scale(1.13);
    }
    .image-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      transition: opacity 0.35s ease;
    }
    .badge {
      position: absolute;
      padding: 8px 14px;
      font-size: 12px;
      font-weight: 700;
      border-radius: 20px
4px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.15);
      z-index: 5;
    }
    .badge {
      bottom: 14px; right: 14px;
    }
    .card-content {
      padding: 24px;
      flex: 1;
    }
    .card-label {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 8px;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 12px;
    }
    .card-title {
      font-size: 28px;
      font-weight: 800;
      margin-bottom: 10px;
      line-height: 1.3;
    }
    .card-subtitle {
      font-size: 24px;
      opacity: 0.7;
      margin-bottom: 14px;
      font-weight: 500;
    }
    .card-body {
      font-size: 16px;
      line-height: 1.7;
    }
    .card-footer {
      padding: 18px 24px;
      border-top: 2px solid rgba(0,0,0,0.08);
      display: flex;
      gap: 12px;
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
    primaryColor: '#ef4444',
    secondaryColor: '#f87171',
    backgroundColor: '#ffffff',
    textColor: '#7f1d1d',
    borderColor: '#fee2e2',
    shadowColor: 'rgba(239, 68, 68, 0.2)',
    accentColor: '#dc2626'
  };

  get appliedTheme(): CardTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get cardStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { maxWidth: '280px' },
      md: { maxWidth: '360px' },
      lg: { maxWidth: '480px' }
    };

    const variants = {
      flat: {
        backgroundColor: t.backgroundColor,
        boxShadow: 'none',
        border: `2px solid ${t.borderColor}`
      },
      elevated: {
        backgroundColor: t.backgroundColor,
        boxShadow: `0 12px 28px ${t.shadowColor}, 0 4px 12px ${t.shadowColor}`,
        border: 'none'
      },
      outlined: {
        backgroundColor: t.backgroundColor,
        border: `3px solid ${t.primaryColor}`,
        boxShadow: 'none'
      },
      glass: {
        backgroundColor: `${t.backgroundColor}e8`,
        backdropFilter: 'blur(14px) saturate(160%)',
        border: `1px solid ${t.borderColor}`,
        boxShadow: `0 8px 32px 0 ${t.shadowColor}`
      },
      neumorphic: {
        backgroundColor: t.backgroundColor,
        boxShadow: `10px 10px 20px ${t.shadowColor}, -10px -10px 20px rgba(255,255,255,0.75)`,
        border: 'none'
      },
      gradient: {
        background: `linear-gradient(135deg, ${t.primaryColor} 0%, ${t.secondaryColor} 100%)`,
        border: 'none',
        boxShadow: `0 10px 28px ${t.shadowColor}`
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
      background: `linear-gradient(180deg, transparent 0%, ${t.primaryColor}50 100%)`,
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
      color: t.primaryColor
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
