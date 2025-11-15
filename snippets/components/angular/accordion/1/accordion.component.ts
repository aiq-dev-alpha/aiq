// Modern Smooth Accordion with Icons
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-accordion',
  template: `
  <div class="modern-accordion">
  <div class="accordion-item" *ngFor="let item of items; let i = index">
  <div class="accordion-header" (click)="toggle(i)" [class.active]="activeIndex === i">
  <span class="title">{{ item.title }}</span>
  <span class="icon" [class.rotated]="activeIndex === i">▼</span>
  </div>
  <div class="accordion-content" [class.open]="activeIndex === i">
  <div class="content-inner">{{ item.content }}</div>
  </div>
  </div>
  </div>
  `,
  styles: [`
  .modern-accordion { border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); }
  .accordion-item { border-bottom: 1px solid #e5e7eb; }
  .accordion-item:last-child { border-bottom: none; }
  .accordion-header { padding: 18px 24px; background: white; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; }
  .accordion-header:hover { background: #f9fafb; }
  .accordion-header.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
  .title { font-weight: 600; font-size: 15px; }
  .icon { transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  .icon.rotated { transform: rotate(180deg); }
  .accordion-content { max-height: 0; overflow: hidden; transition: max-height 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  .accordion-content.open { max-height: 500px; }
  .content-inner { padding: 20px 24px; background: #f9fafb; }
  `]
})
export class AccordionComponent {
  @Input() items = [
  { title: 'Section 1', content: 'Content 1' },
  { title: 'Section 2', content: 'Content 2' },
  { title: 'Section 3', content: 'Content 3' }
  ];
  activeIndex: number | null = null;
  
  toggle(index: number): void {
  this.activeIndex = this.activeIndex === index ? null : index;
  }
}