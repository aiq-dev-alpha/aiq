// Vertical Accordion Tabs
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-tabs',
  template: `<div class="vertical-tabs"><div class="tab-item" *ngFor="let tab of tabs; let i = index" [class.expanded]="activeIndex === i"><div class="tab-trigger" (click)="activeIndex = activeIndex === i ? -1 : i"><span>{{ tab.title }}</span><span class="chevron">›</span></div><div class="tab-panel" [class.open]="activeIndex === i"><ng-content></ng-content></div></div></div>`,
  styles: [`
    .vertical-tabs { border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; }
    .tab-item { border-bottom: 1px solid #e5e7eb; }
    .tab-item:last-child { border-bottom: none; }
    .tab-trigger { padding: 16px; background: white; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: background 0.2s; }
    .tab-trigger:hover { background: #f9fafb; }
    .tab-item.expanded .tab-trigger { background: #f3f4f6; }
    .chevron { transform: rotate(90deg); transition: transform 0.3s; }
    .tab-item.expanded .chevron { transform: rotate(-90deg); }
    .tab-panel { max-height: 0; overflow: hidden; transition: max-height 0.3s; }
    .tab-panel.open { max-height: 500px; padding: 16px; }
  `]
})
export class TabsComponent {
  @Input() tabs = [{ title: 'Section 1' }, { title: 'Section 2' }, { title: 'Section 3' }];
  activeIndex = 0;
}