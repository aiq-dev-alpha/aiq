// Accordion Panel with Smooth Expand
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-panel',
  template: `<div class="accordion-panel"><div class="panel-header" (click)="expanded = !expanded"><ng-content select="[header]"></ng-content><span class="chevron" [class.up]="expanded">›</span></div><div class="panel-body" [class.expanded]="expanded"><ng-content></ng-content></div></div>`,
  styles: [`
  .accordion-panel { border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; }
  .panel-header { padding: 16px; background: #f9fafb; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: background 0.2s; }
  .panel-header:hover { background: #f3f4f6; }
  .chevron { font-size: 24px; transform: rotate(90deg); transition: transform 0.3s; }
  .chevron.up { transform: rotate(-90deg); }
  .panel-body { max-height: 0; overflow: hidden; transition: max-height 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  .panel-body.expanded { max-height: 1000px; padding: 16px; }
  `]
})
export class PanelComponent {
  expanded = false;
}
