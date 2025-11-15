// Sliding Indicator Tabs
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-tabs',
  template: `<div class="sliding-tabs"><div class="tab-headers"><button class="tab-header" *ngFor="let tab of tabs; let i = index" (click)="activeIndex = i" [class.active]="activeIndex === i">{{ tab.title }}</button><div class="slider" [style.transform]="'translateX(' + (activeIndex * 100) + '%)'"></div></div><div class="tab-content"><ng-content></ng-content></div></div>`,
  styles: [`
    .sliding-tabs { border-radius: 8px; overflow: hidden; }
    .tab-headers { position: relative; display: flex; background: #f3f4f6; }
    .tab-header { flex: 1; padding: 12px 24px; border: none; background: none; cursor: pointer; transition: color 0.3s; position: relative; z-index: 1; }
    .tab-header.active { color: white; }
    .slider { position: absolute; bottom: 0; left: 0; height: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
    .tab-content { padding: 24px; background: white; }
  `]
})
export class TabsComponent {
  @Input() tabs = [{ title: 'Tab 1' }, { title: 'Tab 2' }, { title: 'Tab 3' }];
  activeIndex = 0;
}