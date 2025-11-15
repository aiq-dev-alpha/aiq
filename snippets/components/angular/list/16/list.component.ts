import { Component, Input, Output, EventEmitter } from '@angular/core';
@Component({
  selector: 'app-component',
  standalone: true,
  template: `
  <div
  (click)="handleClick()"
  [style.padding]="'16px 24px'"
  [style.background-color]="'#3b82f6'"
  [style.color]="'#ffffff'"
  [style.border-radius]="'16px'"
  [style.cursor]="'pointer'"
  [style.font-weight]="'600'"
  [style.font-size]="'15px'"
  [style.box-shadow]="'0 4px 12px rgba(0,0,0,0.15)'"
  [style.transition]="'all 200ms ease'"
  >
  {{label}}
  </div>
  `
})
export class Component {
  @Input() theme: { primary?: string; background?: string; text?: string; } = {};
  @Output() onInteract = new EventEmitter<string>();
  label = 'List 15';
  handleClick() {
  this.onInteract.emit('click');
  }
}
