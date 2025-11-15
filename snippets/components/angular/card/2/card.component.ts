import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
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
  standalone: true,
  imports: [CommonModule],
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
  <div *ngIf="label" class="card-label" [ngStyle]="labelStyles">{{ label }}</div>
  <div *ngIf="image" class="card-image" [ngStyle]="imageStyles">
  <img [src]="image" [alt]="imageAlt || 'Card image'" />
  <div *ngIf="imageOverlay" class="image-overlay" [ngStyle]="overlayStyles"></div>
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
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  display: flex;
  flex-direction: column;
  outline: none;
  }
  .card.hoverable:hover {
  transform: translateY(-8px) scale(1.02);
  }
  .card.clickable {
  cursor: pointer;
  }
  .card-label {
  position: absolute;
  top: 0;
  left: 20px;
  padding: 8px 16px;
  border-radius: 0 0 12px 12px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  z-index: 10;
  }
  .card-image {
  position: relative;
  overflow: hidden;
  height: 220px;
  }
  .card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
  }
  .card.hoverable:hover .card-image img {
  transform: scale(1.1) rotate(2deg);
  }
  .image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  transition: opacity 0.3s ease;
  }
  .badge {
  position: absolute;
  top: 16px;
  right: 16px;
  padding: 8px 16px;
  border-radius: 24px;
  font-size: 13px;
  font-weight: 700;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  .card-content {
  padding: 24px;
  flex: 1;
  }
  .card-title {
  font-size: 22px;
  font-weight: 800;
  margin-bottom: 10px;
  letter-spacing: -0.5px;
  }
  .card-subtitle {
  font-size: 15px;
  opacity: 0.75;
  margin-bottom: 14px;
  font-weight: 500;
  }
  .card-body {
  font-size: 15px;
  line-height: 1.7;
  }
  .card-footer {
  padding: 18px 24px;
  border-top: 2px solid rgba(0,0,0,0.06);
  display: flex;
  gap: 12px;
  align-items: center;
  }
  .card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  }
  @keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
  }
  @keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
  }
  @keyframes scaleIn {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
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
  primaryColor: '#8b5cf6',
  secondaryColor: '#a78bfa',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#1e1b4b',
  borderColor: '#ddd6fe',
  shadowColor: 'rgba(139, 92, 246, 0.2)',
  accentColor: '#7c3aed'
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
  border: `1px solid ${t.borderColor}`
  },
  elevated: {
  backgroundColor: t.backgroundColor,
  boxShadow: `0 10px 25px -5px ${t.shadowColor}, 0 8px 10px -6px ${t.shadowColor}`,
  border: 'none'
  },
  outlined: {
  backgroundColor: t.backgroundColor,
  border: `3px solid ${t.primaryColor}`,
  boxShadow: 'none'
  },
  glass: {
  backgroundColor: `${t.backgroundColor}dd`,
  backdropFilter: 'blur(12px)',
  border: `1px solid ${t.borderColor}`,
  boxShadow: `0 8px 32px 0 ${t.shadowColor}`
  },
  neumorphic: {
  backgroundColor: t.backgroundColor,
  boxShadow: `8px 8px 16px ${t.shadowColor}, -8px -8px 16px rgba(255,255,255,0.7)`,
  border: 'none'
  },
  gradient: {
  background: `linear-gradient(135deg, ${t.primaryColor} 0%, ${t.secondaryColor} 100%)`,
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
  get labelStyles() {
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
  background: `linear-gradient(180deg, transparent 0%, ${t.primaryColor}40 100%)`,
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
