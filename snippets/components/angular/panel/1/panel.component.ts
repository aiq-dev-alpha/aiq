import { Component, Input, Output, EventEmitter } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';

interface PanelTheme {
  primaryColor: string;
  backgroundColor: string;
  borderColor: string;
  headerColor: string;
  shadowColor: string;
}

@Component({
  selector: 'app-panel',
  template: `
  <div class="panel-container" [ngStyle]="panelStyles">
  <div class="panel-header" [ngStyle]="headerStyles" (click)="toggle()">
  <div class="header-content">
  <h3 class="panel-title">{{ title }}</h3>
  <p *ngIf="subtitle" class="panel-subtitle">{{ subtitle }}</p>
  </div>
  <div class="header-actions">
  <ng-content select="[header-actions]"></ng-content>
  <button *ngIf="collapsible" class="collapse-btn" [ngStyle]="buttonStyles">
  <span [style.transform]="collapsed ? 'rotate(0deg)' : 'rotate(180deg)'" style="display: inline-block; transition: transform 0.3s ease;">
  &#9660;
  </span>
  </button>
  </div>
  </div>
  <div class="panel-body" [@slideDown]="collapsed ? 'collapsed' : 'expanded'" [ngStyle]="bodyStyles">
  <div *ngIf="loading" class="loading-overlay" [ngStyle]="loadingStyles">
  <div class="spinner"></div>
  </div>
  <ng-content></ng-content>
  </div>
  </div>
  `,
  styles: [`
  .panel-container {
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.25rem 1.5rem;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .panel-header:hover {
  opacity: 0.9;
  }
  .header-content {
  flex: 1;
  }
  .panel-title {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
  color: #ffffff;
  }
  .panel-subtitle {
  margin: 0.25rem 0 0 0;
  font-size: 0.875rem;
  opacity: 0.9;
  color: #ffffff;
  }
  .header-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  }
  .collapse-btn {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  color: #ffffff;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .collapse-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  }
  .panel-body {
  padding: 1.5rem;
  position: relative;
  }
  .loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.9);
  z-index: 10;
  }
  .spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f4f6;
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  }
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  `],
  animations: [
  trigger('slideDown', [
  state('collapsed', style({
  height: '0',
  padding: '0 1.5rem',
  overflow: 'hidden',
  opacity: 0
  })),
  state('expanded', style({
  height: '*',
  padding: '1.5rem',
  overflow: 'visible',
  opacity: 1
  })),
  transition('collapsed <=> expanded', animate('300ms ease-in-out'))
  ])
  ]
})
export class PanelComponent {
  @Input() theme: Partial<PanelTheme> = {};
  @Input() title: string = 'Panel Title';
  @Input() subtitle: string = '';
  @Input() collapsible: boolean = true;
  @Input() collapsed: boolean = false;
  @Input() variant: 'default' | 'bordered' | 'elevated' | 'flat' | 'gradient' = 'gradient';
  @Input() headerActions: boolean = false;
  @Input() loading: boolean = false;
  @Output() toggled = new EventEmitter<boolean>();

  private defaultTheme: PanelTheme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  borderColor: '#e5e7eb',
  headerColor: '#1e40af',
  shadowColor: 'rgba(59, 130, 246, 0.3)'
  };

  get appliedTheme(): PanelTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  toggle() {
  if (this.collapsible) {
  this.collapsed = !this.collapsed;
  this.toggled.emit(this.collapsed);
  }
  }

  get panelStyles() {
  const base = {
  background: this.appliedTheme.backgroundColor,
  border: `1px solid ${this.appliedTheme.borderColor}`,
  boxShadow: `0 4px 6px -1px ${this.appliedTheme.shadowColor}, 0 2px 4px -1px ${this.appliedTheme.shadowColor}`
  };

  if (this.variant === 'elevated') {
  return { ...base, boxShadow: `0 10px 15px -3px ${this.appliedTheme.shadowColor}, 0 4px 6px -2px ${this.appliedTheme.shadowColor}` };
  } else if (this.variant === 'flat') {
  return { ...base, boxShadow: 'none', border: 'none' };
  } else if (this.variant === 'bordered') {
  return { ...base, boxShadow: 'none', border: `2px solid ${this.appliedTheme.borderColor}` };
  }

  return base;
  }

  get headerStyles() {
  return {
  background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.headerColor})`,
  borderBottom: `1px solid ${this.appliedTheme.borderColor}`
  };
  }

  get bodyStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor
  };
  }

  get buttonStyles() {
  return {
  background: 'rgba(255, 255, 255, 0.2)',
  color: '#ffffff'
  };
  }

  get loadingStyles() {
  return {
  backgroundColor: 'rgba(255, 255, 255, 0.9)',
  backdropFilter: 'blur(10px)'
  };
  }
}
