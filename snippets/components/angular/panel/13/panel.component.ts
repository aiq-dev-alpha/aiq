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
              &#9650;
            </span>
          </button>
        </div>
      </div>
      <div class="panel-body" [@flipExpand]="collapsed ? 'collapsed' : 'expanded'" [ngStyle]="bodyStyles">
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
      padding: 1.25rem 1.5rem;
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      
    }
    
    .header-content {
      flex: 1;
      
    }
    .panel-title {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 800;
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
      width: 44px;
      height: 44px;
      border-radius: 50%;
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
      width: 48px;
      height: 48px;
      border: 4px solid #f3f4f6;
      border-top-color: '#6366f1';
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }
    @keyframes spin {
      to { transform: rotate(360deg); }
    }
    
  `],
  animations: [
    trigger('flipExpand', [
      state('collapsed', style({
        height: '0',
        padding: '0 2rem',
        overflow: 'hidden',
        opacity: 0,
        transform: 'perspective(500px) rotateX(-15deg)'
      })),
      state('expanded', style({
        height: '*',
        padding: '*',
        overflow: 'visible',
        opacity: 1,
        transform: 'perspective(500px) rotateX(0deg)'
      })),
      transition('collapsed <=> expanded', animate('450ms cubic-bezier(0.4, 0, 0.2, 1)'))
    ])
  ]
})
export class PanelComponent {
  @Input() theme: Partial<PanelTheme> = {};
  @Input() title: string = 'Panel Title';
  @Input() subtitle: string = '';
  @Input() collapsible: boolean = true;
  @Input() collapsed: boolean = false;
  @Input() variant: 'default' | 'bordered' | 'elevated' | 'flat' | 'gradient' = 'flat';
  @Input() headerActions: boolean = false;
  @Input() loading: boolean = false;
  @Output() toggled = new EventEmitter<boolean>();

  private defaultTheme: PanelTheme = {
    primaryColor: '#6366f1',
    backgroundColor: '#eef2ff',
        backdropFilter: 'blur(10px)',
    borderColor: '#c7d2fe',
    headerColor: '#4f46e5',
    shadowColor: 'rgba(99, 102, 241, 0.25)'
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
      background: `linear-gradient(135deg, ${this.appliedTheme.backgroundColor} 0%, ${this.appliedTheme.headerColor}15 100%)`,
      border: 'none',
      boxShadow: `0 8px 32px ${this.appliedTheme.shadowColor}`
    };
  }

  get headerStyles() {
    return {
      background: 'rgba(255, 255, 255, 0.1)',
      borderBottom: `1px solid rgba(255, 255, 255, 0.2)`
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
