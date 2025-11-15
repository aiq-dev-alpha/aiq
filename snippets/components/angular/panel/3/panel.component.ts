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
  <div class="header-accent" [ngStyle]="accentStyles"></div>
  <div class="header-content">
  <h3 class="panel-title" [ngStyle]="titleStyles">{{ title }}</h3>
  <p *ngIf="subtitle" class="panel-subtitle">{{ subtitle }}</p>
  </div>
  <div class="header-actions">
  <ng-content select="[header-actions]"></ng-content>
  <button *ngIf="collapsible" class="collapse-btn" [ngStyle]="buttonStyles">
  <span [style.transform]="collapsed ? 'rotate(0deg)' : 'rotate(180deg)'" style="display: inline-block; transition: transform 0.3s ease;">
  &#9650;
  </span>
  </button>
  </div>
  </div>
  <div class="panel-body" [@accordion]="collapsed ? 'collapsed' : 'expanded'" [ngStyle]="bodyStyles">
  <div *ngIf="loading" class="loading-overlay" [ngStyle]="loadingStyles">
  <div class="spinner"></div>
  </div>
  <ng-content></ng-content>
  </div>
  </div>
  `,
  styles: [`
  .panel-container {
  border-radius: 20px;
  overflow: hidden;
  transition: all 0.3s ease;
  position: relative;
  }
  .panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.75rem 2rem;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  }
  .header-content {
  flex: 1;
  padding-left: 1rem;
  }
  .panel-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #ec4899, #8b5cf6);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  }
  .panel-subtitle {
  margin: 0.5rem 0 0 0;
  font-size: 0.875rem;
  color: #6b7280;
  }
  .header-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
  }
  .collapse-btn {
  background: linear-gradient(135deg, #ec4899, #8b5cf6);
  border: none;
  color: #ffffff;
  width: 40px;
  height: 40px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(236, 72, 153, 0.3);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  }
  .collapse-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(236, 72, 153, 0.4);
  }
  .panel-body {
  padding: 2rem;
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
  width: 48px;
  height: 48px;
  border: 4px solid #f3f4f6;
  border-top-color: '#ec4899';
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  }
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  .header-accent {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 5px;
  height: 60%;
  border-radius: 0 10px 10px 0;
  transition: all 0.3s ease;
  }
  .panel-header:hover .header-accent {
  width: 8px;
  }
  `],
  animations: [
  trigger('accordion', [
  state('collapsed', style({
  height: '0',
  minHeight: '0',
  padding: '0 2rem',
  overflow: 'hidden',
  opacity: 0
  })),
  state('expanded', style({
  height: '*',
  padding: '*',
  overflow: 'visible',
  opacity: 1
  })),
  transition('collapsed => expanded', animate('400ms cubic-bezier(0.68, -0.55, 0.265, 1.55)')),
  transition('expanded => collapsed', animate('300ms ease-in'))
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
  primaryColor: '#ec4899',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  borderColor: '#fce7f3',
  headerColor: '#f9a8d4',
  shadowColor: 'rgba(236, 72, 153, 0.2)'
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
  boxShadow: `0 20px 25px -5px ${this.appliedTheme.shadowColor}`
  };
  }
  get headerStyles() {
  return {
  background: this.appliedTheme.backgroundColor,
  borderBottom: `1px solid ${this.appliedTheme.borderColor}`
  };
  }
  get bodyStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor
  };
  }
  get titleStyles() {
  return {
  background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}, ${this.appliedTheme.headerColor})`,
  WebkitBackgroundClip: 'text',
  WebkitTextFillColor: 'transparent',
  backgroundClip: 'text'
  };
  }
  get buttonStyles() {
  return {};
  }
  get loadingStyles() {
  return {
  backgroundColor: 'rgba(255, 255, 255, 0.9)',
  backdropFilter: 'blur(10px)'
  };
  }
}
