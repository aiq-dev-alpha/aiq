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
            <span [style.transform]="collapsed ? 'rotate(0deg)' : 'rotate(180deg)'" style="display: inline-block; transition: transform 0.3s ease;">
              &#9658;
            </span>
          </button>
        </div>
      </div>
      <div class="panel-body" [@zoomSlide]="collapsed ? 'collapsed' : 'expanded'" [ngStyle]="bodyStyles">
        <div *ngIf="loading" class="loading-overlay" [ngStyle]="loadingStyles">
          <div class="spinner"></div>
        </div>
        <ng-content></ng-content>
      </div>
    </div>
  `,
  styles: [`
    .panel-container {
      border-radius: 28px;
      overflow: hidden;
      transition: all 0.3s ease;
      position: relative;
    }
    .panel-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 2.0rem 2.25rem;
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      
    }
    
    .header-content {
      flex: 1;
      
    }
    .panel-title {
      margin: 0;
      font-size: 1.625rem;
      font-weight: 700;
      color: #1f2937;
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
      background: rgba(0, 0, 0, 0.08);
      border: none;
      color: currentColor;
      width: 40px;
      height: 40px;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }
    .collapse-btn:hover {
      background: rgba(0, 0, 0, 0.12);
      transform: scale(1.05);
    }
    .panel-body {
      padding: 3.0rem;
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
      border-top-color: '#ef4444';
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    
  `],
  animations: [
    trigger('zoomSlide', [
      state('collapsed', style({
        height: '0',
        padding: '0 2rem',
        overflow: 'hidden',
        opacity: 0,
        transform: 'scale(0.9) translateY(-10px)'
      })),
      state('expanded', style({
        height: '*',
        padding: '*',
        overflow: 'visible',
        opacity: 1,
        transform: 'scale(1) translateY(0)'
      })),
      transition('collapsed <=> expanded', animate('375ms cubic-bezier(0.34, 1.56, 0.64, 1)'))
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
    primaryColor: '#ef4444',
    backgroundColor: '#fef2f2',
    borderColor: '#fecaca',
    headerColor: '#dc2626',
    shadowColor: 'rgba(239, 68, 68, 0.25)'
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
      boxShadow: `0 10px 15px -3px ${this.appliedTheme.shadowColor}`
    };
  }

  get headerStyles() {
    return {
      background: `linear-gradient(180deg, ${this.appliedTheme.headerColor} 0%, ${this.appliedTheme.backgroundColor} 100%)`,
      borderBottom: `1px solid ${this.appliedTheme.borderColor}`
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
