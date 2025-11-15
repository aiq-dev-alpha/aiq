import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
interface CardAppearance {
  backgroundColor: string;
  borderColor: string;
  textColor: string;
  accentColor: string;
  shadowIntensity: 'none' | 'light' | 'medium' | 'heavy';
}
type CardPattern = 'default' | 'image-top' | 'image-left' | 'overlay' | 'minimal';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-card',
  template: `
  <div [ngStyle]="containerStyles" [ngClass]="patternClass" class="card-root" (click)="onCardClick($event)">
  <div *ngIf="coverImage && (pattern === 'image-top' || pattern === 'overlay')" class="cover-image-container">
  <img [src]="coverImage" [alt]="coverImageAlt" class="cover-image">
  <div *ngIf="pattern === 'overlay'" class="overlay-gradient"></div>
  </div>
  <div class="card-content-wrapper" [ngClass]="{'overlay-content': pattern === 'overlay'}">
  <div *ngIf="coverImage && pattern === 'image-left'" class="side-image">
  <img [src]="coverImage" [alt]="coverImageAlt">
  </div>
  <div class="text-content">
  <div *ngIf="label" class="label-tag">{{ label }}</div>
  <div *ngIf="cardTitle" class="title-section">
  <h3 class="title">{{ cardTitle }}</h3>
  <p *ngIf="tagline" class="tagline">{{ tagline }}</p>
  </div>
  <div class="body-section">
  <ng-content></ng-content>
  </div>
  <div *ngIf="showFooter" class="footer-section">
  <ng-content select="[cardFooter]"></ng-content>
  </div>
  </div>
  </div>
  </div>
  `,
  styles: [`
  .card-root {
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  }
  .card-root:hover {
  transform: scale(1.02);
  }
  .cover-image-container {
  position: relative;
  width: 100%;
  overflow: hidden;
  }
  .cover-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  display: block;
  }
  .overlay-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, transparent, rgba(0,0,0,0.7));
  }
  .card-content-wrapper {
  position: relative;
  }
  .card-content-wrapper.overlay-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  color: white;
  padding: 1.5rem;
  }
  .image-left .card-content-wrapper {
  display: flex;
  gap: 1rem;
  }
  .side-image {
  flex-shrink: 0;
  width: 120px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  }
  .side-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  }
  .text-content {
  flex: 1;
  }
  .label-tag {
  display: inline-block;
  padding: 4px 10px;
  background: currentColor;
  opacity: 0.15;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.75rem;
  }
  .title-section {
  margin-bottom: 1rem;
  }
  .title {
  margin: 0;
  font-size: 1.375rem;
  font-weight: 700;
  line-height: 1.3;
  }
  .tagline {
  margin: 0.5rem 0 0;
  font-size: 0.875rem;
  opacity: 0.7;
  }
  .body-section {
  margin: 1rem 0;
  line-height: 1.6;
  }
  .footer-section {
  margin-top: 1.5rem;
  padding-top: 1rem;
  border-top: 1px solid currentColor;
  opacity: 0.1;
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
  @Input() pattern: CardPattern = 'default';
  @Input() appearance: Partial<CardAppearance> = {};
  @Input() cardTitle?: string;
  @Input() tagline?: string;
  @Input() label?: string;
  @Input() coverImage?: string;
  @Input() coverImageAlt = '';
  @Input() showFooter = false;
  @Input() selectable = false;
  @Output() cardClicked = new EventEmitter<MouseEvent>();
  private defaultAppearance: CardAppearance = {
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  borderColor: '#e5e7eb',
  textColor: '#0f172a',
  accentColor: '#3b82f6',
  shadowIntensity: 'medium'
  };
  get cardAppearance(): CardAppearance {
  return { ...this.defaultAppearance, ...this.appearance };
  }
  get patternClass(): string {
  return `pattern-${this.pattern}`;
  }
  get containerStyles(): Record<string, string> {
  const a = this.cardAppearance;
  const shadowMap = {
  none: 'none',
  light: '0 1px 3px rgba(0, 0, 0, 0.05)',
  medium: '0 4px 6px rgba(0, 0, 0, 0.1)',
  heavy: '0 20px 25px rgba(0, 0, 0, 0.15)'
  };
  const baseStyles = {
  backgroundColor: a.backgroundColor,
  color: a.textColor,
  borderRadius: '14px',
  boxShadow: shadowMap[a.shadowIntensity],
  cursor: this.selectable ? 'pointer' : 'default'
  };
  if (this.pattern === 'overlay') {
  return { ...baseStyles, padding: '0' };
  } else if (this.pattern === 'minimal') {
  return { ...baseStyles, padding: '1rem', border: `1px solid ${a.borderColor}` };
  }
  return { ...baseStyles, padding: '1.5rem' };
  }
  onCardClick(event: MouseEvent): void {
  if (this.selectable) {
  this.cardClicked.emit(event);
  }
  }
}
