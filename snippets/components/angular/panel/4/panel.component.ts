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
  <div class="glow-effect"></div>
  <div class="panel-header" [ngStyle]="headerStyles" (click)="toggle()">
  
  <div class="header-content">
  <h3 class="panel-title" [ngStyle]="titleStyles">{{ title }}</h3>
  <p *ngIf="subtitle" class="panel-subtitle">{{ subtitle }}</p>
  </div>
  <div class="header-actions">
  <ng-content select="[header-actions]"></ng-content>
  <button *ngIf="collapsible" class="collapse-btn" [ngStyle]="buttonStyles">
  <span [style.transform]="collapsed ? 'scaleY(1)' : 'scaleY(-1)'" style="display: inline-block; transition: transform 0.3s ease;">
  &#x25BC;
  </span>
  </button>
  </div>
  </div>
  <div class="panel-body" [@smoothExpand]="collapsed ? 'collapsed' : 'expanded'" [ngStyle]="bodyStyles">
  <div *ngIf="loading" class="loading-overlay" [ngStyle]="loadingStyles">
  <div class="spinner"></div>
  </div>
  <ng-content></ng-content>
  </div>
  </div>
  `,
  styles: [`
  .panel-container {
  border-radius: 24px;
  overflow: hidden;
  transition: all 0.3s ease;
  position: relative;
  }
  .panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 2rem 2.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  
  }
  
  .header-content {
  flex: 1;
  z-index: 1;
  }
  .panel-title {
  margin: 0;
  font-size: 1.625rem;
  font-weight: 800;
  color: #ffffff; text-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  .panel-subtitle {
  margin: 0.5rem 0 0 0;
  font-size: 0.875rem;
  color: rgba(255,255,255,0.9);
  }
  .header-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
  z-index: 1;
  }
  .collapse-btn {
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.3);
  color: #ffffff;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  }
  .collapse-btn:hover {
  background: rgba(255, 255, 255, 0.35);
  transform: scale(1.05);
  }
  .panel-body {
  padding: 2.5rem;
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
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.95), rgba(59, 130, 246, 0.95));
  backdrop-filter: blur(10px);
  z-index: 10;
  }
  .spinner {
  width: 48px;
  height: 48px;
  border: 4px solid #f3f4f6;
  border-top-color: '#0ea5e9';
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  }
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  .glow-effect {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.3) 0%, transparent 70%);
  opacity: 0;
  transition: opacity 0.5s ease;
  pointer-events: none;
  }
  .panel-header:hover .glow-effect {
  opacity: 1;
  }
  `],
  animations: [
  trigger('smoothExpand', [
  state('collapsed', style({
  height: '0',
  padding: '0 2.5rem',
  overflow: 'hidden',
  opacity: 0,
  transform: 'scaleY(0)'
  })),
  state('expanded', style({
  height: '*',
  padding: '*',
  overflow: 'visible',
  opacity: 1,
  transform: 'scaleY(1)'
  })),
  transition('collapsed <=> expanded', animate('350ms cubic-bezier(0.35, 0, 0.25, 1)'))
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
  primaryColor: '#0ea5e9',
  backgroundColor: '#f0f9ff',
  borderColor: '#bae6fd',
  headerColor: '#0284c7',
  shadowColor: 'rgba(14, 165, 233, 0.3)'
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
  return {
  background: this.appliedTheme.backgroundColor,
  border: 'none',
  boxShadow: `0 10px 20px ${this.appliedTheme.shadowColor}`
  };
  }

  get headerStyles() {
  return {
  background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.headerColor})`,
  borderBottom: 'none'
  };
  }

  get bodyStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor
  };
  }

  get titleStyles() {
  return {};
  }

  get buttonStyles() {
  return {};
  }

  get loadingStyles() {
  return {
  backgroundColor: 'rgba(255, 255, 255, 0.9)'
  };
  }
}
