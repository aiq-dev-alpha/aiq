import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-panel',
  template: `
    <div class="panel" [ngClass]="variant">
      <div *ngIf="title" class="panel-header">
        <h3 class="panel-title">{{ title }}</h3>
        <button *ngIf="collapsible"
                (click)="toggleCollapse()"
                class="collapse-btn">
          {{ collapsed ? '+' : '−' }}
        </button>
      </div>
      <div *ngIf="!collapsed" class="panel-body">
        <ng-content></ng-content>
      </div>
      <div *ngIf="footer" class="panel-footer">
        {{ footer }}
      </div>
    </div>
  `,
  styles: [`
    .panel {
      border-radius: 12px;
      overflow: hidden;
      max-width: 600px;
    }
    .panel.default {
      background: white;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .panel.bordered {
      background: white;
      border: 2px solid #e5e7eb;
    }
    .panel.accent {
      background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
      border-left: 4px solid #3b82f6;
    }
    .panel-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px 20px;
      background-color: #f9fafb;
      border-bottom: 1px solid #e5e7eb;
    }
    .panel-title {
      margin: 0;
      font-size: 18px;
      font-weight: 700;
      color: #1f2937;
    }
    .collapse-btn {
      background: none;
      border: none;
      font-size: 24px;
      color: #6b7280;
      cursor: pointer;
      padding: 0;
      width: 28px;
      height: 28px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 4px;
      transition: background-color 150ms;
    }
    .collapse-btn:hover {
      background-color: #e5e7eb;
    }
    .panel-body {
      padding: 20px;
      color: #1f2937;
      line-height: 1.6;
    }
    .panel-footer {
      padding: 12px 20px;
      background-color: #f9fafb;
      border-top: 1px solid #e5e7eb;
      font-size: 14px;
      color: #6b7280;
    }
  `]
})
export class PanelComponent {
  @Input() title = '';
  @Input() footer = '';
  @Input() variant: 'default' | 'bordered' | 'accent' = 'default';
  @Input() collapsible = false;
  @Output() toggle = new EventEmitter<boolean>();

  collapsed = false;

  toggleCollapse(): void {
    this.collapsed = !this.collapsed;
    this.toggle.emit(this.collapsed);
  }
}