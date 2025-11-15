// Infinite Scroll Virtualized List
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-list',
  template: `<div class="virtual-list" (scroll)="onScroll($event)"><div class="list-spacer" [style.height.px]="spacerHeight"></div><div class="list-item" *ngFor="let item of visibleItems; trackBy: trackByFn" [style.height.px]="itemHeight">Item {{ item }}</div></div>`,
  styles: [`
    .virtual-list { height: 400px; overflow-y: auto; border: 1px solid #e5e7eb; border-radius: 8px; }
    .list-item { padding: 16px; border-bottom: 1px solid #e5e7eb; display: flex; align-items: center; }
  `]
})
export class ListComponent {
  @Input() items: any[] = Array.from({ length: 10000 }, (_, i) => i + 1);
  @Input() itemHeight = 60;
  visibleItems: any[] = [];
  spacerHeight = 0;
  
  ngOnInit() { this.updateVisibleItems(0); }
  
  onScroll(e: Event): void {
    const scrollTop = (e.target as HTMLElement).scrollTop;
    this.updateVisibleItems(scrollTop);
  }
  
  updateVisibleItems(scrollTop: number): void {
    const startIndex = Math.floor(scrollTop / this.itemHeight);
    const endIndex = Math.min(startIndex + 20, this.items.length);
    this.visibleItems = this.items.slice(startIndex, endIndex);
    this.spacerHeight = startIndex * this.itemHeight;
  }
  
  trackByFn(index: number, item: any): any { return item; }
}