import { Component, Input } from '@angular/core';

interface CardTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  shadowColor: string;
}

@Component({
  selector: 'app-card',
  template: `
    <div class="card" [ngStyle]="cardStyles" [class.hoverable]="hoverable" [class.clickable]="clickable" (click)="handleClick()">
      <div *ngIf="image" class="card-image" [ngStyle]="imageStyles">
        <img [src]="image" [alt]="imageAlt || 'Card image'" />
        <div *ngIf="badge" class="badge" [ngStyle]="badgeStyles">{{ badge }}</div>
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
      border-radius: 16px;
      overflow: hidden;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      display: flex;
      flex-direction: column;
    }
    .card.hoverable:hover {
      transform: translateY(-4px);
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
      transition: transform 0.3s ease;
    }
    .card.hoverable:hover .card-image img {
      transform: scale(1.05);
    }
    .badge {
      position: absolute;
      top: 12px;
      right: 12px;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
    }
    .card-content {
      padding: 20px;
      flex: 1;
    }
    .card-title {
      font-size: 20px;
      font-weight: 700;
      margin-bottom: 8px;
    }
    .card-subtitle {
      font-size: 14px;
      opacity: 0.7;
      margin-bottom: 12px;
    }
    .card-body {
      font-size: 15px;
      line-height: 1.6;
    }
    .card-footer {
      padding: 16px 20px;
      border-top: 1px solid rgba(0,0,0,0.1);
    }
  `]
})
export class CardComponent {
  @Input() theme: Partial<CardTheme> = {};
  @Input() variant: 'elevated' | 'outlined' | 'filled' = 'elevated';
  @Input() title?: string;
  @Input() subtitle?: string;
  @Input() image?: string;
  @Input() imageAlt?: string;
  @Input() badge?: string;
  @Input() hoverable = true;
  @Input() clickable = false;
  @Input() hasFooter = false;

  private defaultTheme: CardTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#8b5cf6',
    backgroundColor: '#ffffff',
    textColor: '#0f172a',
    borderColor: '#e2e8f0',
    shadowColor: 'rgba(0, 0, 0, 0.1)'
  };

  get appliedTheme(): CardTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get cardStyles() {
    const t = this.appliedTheme;
    const variants = {
      elevated: {
        backgroundColor: t.backgroundColor,
        boxShadow: `0 4px 6px -1px ${t.shadowColor}, 0 2px 4px -1px ${t.shadowColor}`,
        border: 'none'
      },
      outlined: {
        backgroundColor: t.backgroundColor,
        border: `2px solid ${t.borderColor}`,
        boxShadow: 'none'
      },
      filled: {
        backgroundColor: `${t.primaryColor}15`,
        border: `1px solid ${t.primaryColor}30`,
        boxShadow: 'none'
      }
    };

    return {
      ...variants[this.variant],
      color: t.textColor
    };
  }

  get imageStyles() {
    return {};
  }

  get badgeStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.primaryColor,
      color: '#ffffff'
    };
  }

  get contentStyles() {
    return {};
  }

  get titleStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get subtitleStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get bodyStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get footerStyles() {
    return {};
  }

  handleClick(): void {
    if (this.clickable) {
      // Emit click event or handle navigation
    }
  }
}
