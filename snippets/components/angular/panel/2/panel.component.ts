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
          <h3 class="panel-title" [ngStyle]="titleStyles">{{ title }}</h3>
          <p *ngIf="subtitle" class="panel-subtitle">{{ subtitle }}</p>
        </div>
        <div class="header-actions">
          <ng-content select="[header-actions]"></ng-content>
          <button *ngIf="collapsible" class="collapse-btn" [ngStyle]="buttonStyles">
            <span [style.transform]="collapsed ? 'rotate(-90deg)' : 'rotate(0deg)'" style="display: inline-block; transition: transform 0.3s ease;">
              &#9658;
            </span>
          </button>
        </div>
      </div>
      <div class="panel-body" [@fadeSlide]="collapsed ? 'collapsed' : 'expanded'" [ngStyle]="bodyStyles">
        <div *ngIf="loading" class="loading-overlay" [ngStyle]="loadingStyles">
          <div class="spinner"></div>
        </div>
        <ng-content></ng-content>
      </div>
    </div>
  `,
  styles: [`
    .panel-container {
      border-radius: 16px;
      overflow: hidden;
      transition: all 0.3s ease;
      position: relative;
    }
    .panel-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 1.5rem 2rem;
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }
    .panel-header::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
      transition: left 0.5s;
    }
    .panel-header:hover::before {
      left: 100%;
    }
    .header-content {
      flex: 1;
      
    }
    .panel-title {
      margin: 0;
      font-size: 1.375rem;
      font-weight: 700;
      color: #1e293b;
    }
    .panel-subtitle {
      margin: 0.5rem 0 0 0;
      font-size: 0.875rem;
      color: #64748b;
    }
    .header-actions {
      display: flex;
      align-items: center;
      gap: 1rem;
      
    }
    .collapse-btn {
      background: transparent;
      border: 2px solid currentColor;
      color: inherit;
      width: 36px;
      height: 36px;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }
    .collapse-btn:hover {
      background: rgba(0, 0, 0, 0.05);
      transform: scale(1.1);
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
      border-top-color: '#8b5cf6';
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    
  `],
  animations: [
    trigger('fadeSlide', [
      state('collapsed', style({
        height: '0',
        padding: '0 2rem',
        overflow: 'hidden',
        opacity: 0,
        transform: 'translateY(-20px)'
      })),
      state('expanded', style({
        height: '*',
        padding: '*',
        overflow: 'visible',
        opacity: 1,
        transform: 'translateY(0)'
      })),
      transition('collapsed <=> expanded', animate('400ms cubic-bezier(0.4, 0, 0.2, 1)'))
    ])
  ]
})
export class PanelComponent {
  @Input() theme: Partial<PanelTheme> = {};
  @Input() title: string = 'Panel Title';
  @Input() subtitle: string = '';
  @Input() collapsible: boolean = true;
  @Input() collapsed: boolean = false;
  @Input() variant: 'default' | 'bordered' | 'elevated' | 'flat' | 'gradient' = 'bordered';
  @Input() headerActions: boolean = false;
  @Input() loading: boolean = false;
  @Output() toggled = new EventEmitter<boolean>();

  private defaultTheme: PanelTheme = {
    primaryColor: '#8b5cf6',
    backgroundColor: '#faf5ff',
        backdropFilter: 'blur(10px)',
    borderColor: '#c4b5fd',
    headerColor: '#a78bfa',
    shadowColor: 'rgba(139, 92, 246, 0.25)'
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
      border: `3px solid ${this.appliedTheme.borderColor}`,
      boxShadow: 'none'
    };
  }

  get headerStyles() {
    return {
      background: 'transparent',
      borderBottom: `2px solid ${this.appliedTheme.borderColor}`
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
      backgroundColor: 'rgba(255, 255, 255, 0.9)',
        backdropFilter: 'blur(10px)'
    };
  }
}
