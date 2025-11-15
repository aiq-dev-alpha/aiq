import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-component',
  standalone: true,
  template: `
  <div
  (click)="handleClick()"
  [style.padding]="'18px 32px'"
  [style.background-color]="'#ec4899'"
  [style.color]="'#ffffff'"
  [style.border-radius]="'10px'"
  [style.cursor]="'pointer'"
  [style.font-weight]="'700'"
  [style.font-size]="'16px'"
  [style.box-shadow]="'0 4px 12px rgba(0,0,0,0.15)'"
  [style.transition]="'all 200ms ease'"
  >
  {{title}} {{count}}
  </div>
  `
})
export class Component {
  @Input() theme: { primary?: string; background?: string; text?: string; } = {};
  @Output() onInteract = new EventEmitter<string>();

  title = 'List';
  count = 0;

  handleClick() {
  this.count++;
  this.onInteract.emit('click');
  }
}
