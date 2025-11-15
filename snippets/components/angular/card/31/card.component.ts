import { Component, Input, Output, EventEmitter } from '@angular/core';

interface CardTheme {
  background: string;
  border: string;
  shadow: string;
  textPrimary: string;
  textSecondary: string;
  accentColor: string;
}

type CardVariant = 'elevated' | 'outlined' | 'filled' | 'glass' | 'gradient';
type CardSize = 'sm' | 'md' | 'lg' | 'xl';

@Component({
  selector: 'app-card',
  template: `
    <div [ngStyle]="cardStyles" [ngClass]="cardClasses" class="card-container">
      <div *ngIf="headerContent || title" class="card-header" [ngStyle]="headerStyles">
        <div class="header-content">
          <h3 *ngIf="title" class="card-title">{{ title }}</h3>
          <p *ngIf="subtitle" class="card-subtitle">{{ subtitle }}</p>
          <ng-content select="[header]"></ng-content>
        </div>
        <div *ngIf="headerAction" class="header-action">
          <ng-content select="[headerAction]"></ng-content>
        </div>
      </div>

      <div *ngIf="imageUrl" class="card-media">
        <img [src]="imageUrl" [alt]="imageAlt" [ngStyle]="imageStyles">
      </div>

      <div class="card-body" [ngStyle]="bodyStyles">
        <ng-content></ng-content>
      </div>

      <div *ngIf="hasFooter" class="card-footer" [ngStyle]="footerStyles">
        <ng-content select="[footer]"></ng-content>
      </div>
    </div>
  `,
  styles: [`
    .card-container {
      border-radius: inherit;
      overflow: hidden;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: flex;
      flex-direction: column;
    }
    .card-container:hover {
      transform: translateY(-4px);
    }
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 1rem;
    }
    .header-content {
      flex: 1;
    }
    .card-title {
      margin: 0;
      font-size: 1.25rem;
      font-weight: 600;
      line-height: 1.4;
    }
    .card-subtitle {
      margin: 0.25rem 0 0;
      font-size: 0.875rem;
      opacity: 0.7;
    }
    .card-media img {
      width: 100%;
      height: auto;
      display: block;
    }
    .card-body {
      flex: 1;
    }
    .card-footer {
      border-top: 1px solid rgba(0, 0, 0, 0.1);
    }
  `]
})
export class CardComponent {
  @Input() variant: CardVariant = 'elevated';
  @Input() size: CardSize = 'md';
  @Input() theme: Partial<CardTheme> = {};
  @Input() title?: string;
  @Input() subtitle?: string;
  @Input() imageUrl?: string;
  @Input() imageAlt = '';
  @Input() hoverable = true;
  @Input() clickable = false;
  @Input() headerContent = false;
  @Input() hasFooter = false;
  @Input() headerAction = false;
  @Output() cardClick = new EventEmitter<MouseEvent>();

  private defaultTheme: CardTheme = {
    background: '#ffffff',
    border: '#e5e7eb',
    shadow: 'rgba(0, 0, 0, 0.1)',
    textPrimary: '#111827',
    textSecondary: '#6b7280',
    accentColor: '#3b82f6'
  };

  get appliedTheme(): CardTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get cardClasses(): string[] {
    return [
      `variant-${this.variant}`,
      `size-${this.size}`,
      this.hoverable ? 'hoverable' : '',
      this.clickable ? 'clickable' : ''
    ].filter(Boolean);
  }

  get cardStyles(): Record<string, string> {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { padding: '12px', borderRadius: '8px' },
      md: { padding: '16px', borderRadius: '12px' },
      lg: { padding: '24px', borderRadius: '16px' },
      xl: { padding: '32px', borderRadius: '20px' }
    };

    const variantMap = {
      elevated: {
        background: t.background,
        border: 'none',
        boxShadow: `0 4px 6px -1px ${t.shadow}, 0 2px 4px -1px ${t.shadow}`
      },
      outlined: {
        background: t.background,
        border: `1px solid ${t.border}`,
        boxShadow: 'none'
      },
      filled: {
        background: `${t.accentColor}10`,
        border: 'none',
        boxShadow: 'none'
      },
      glass: {
        background: `${t.background}cc`,
        backdropFilter: 'blur(10px)',
        border: `1px solid ${t.border}80`,
        boxShadow: `0 8px 32px ${t.shadow}`
      },
      gradient: {
        background: `linear-gradient(135deg, ${t.background}, ${t.accentColor}20)`,
        border: 'none',
        boxShadow: `0 4px 12px ${t.shadow}`
      }
    };

    return {
      ...sizeMap[this.size],
      ...variantMap[this.variant],
      color: t.textPrimary,
      cursor: this.clickable ? 'pointer' : 'default'
    };
  }

  get headerStyles(): Record<string, string> {
    return {
      marginBottom: '16px',
      color: this.appliedTheme.textPrimary
    };
  }

  get bodyStyles(): Record<string, string> {
    return {
      color: this.appliedTheme.textSecondary,
      fontSize: '0.875rem',
      lineHeight: '1.6'
    };
  }

  get footerStyles(): Record<string, string> {
    return {
      marginTop: '16px',
      paddingTop: '16px'
    };
  }

  get imageStyles(): Record<string, string> {
    return {
      marginBottom: '16px',
      borderRadius: '8px'
    };
  }
}
