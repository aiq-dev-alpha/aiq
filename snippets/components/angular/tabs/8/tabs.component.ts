import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  selector: 'app-component',
  standalone: true,
  imports: [CommonModule],
  template: \`
    <div
      class="component-wrapper"
      [style.padding]="'16px 24px'"
      [style.backgroundColor]="theme.primary || '#3b82f6'"
      [style.color]="'#ffffff'"
      [style.borderRadius]="'8px'"
      [style.cursor]="'pointer'"
      (click)="handleClick()"
    >
      <ng-content></ng-content>
    </div>
  \`
})
export class Component {
  @Input() theme: { primary?: string; background?: string; text?: string; } = {};
  @Input() className: string = '';
  @Output() interact = new EventEmitter<string>();
  handleClick() {
    this.interact.emit('click');
  }
}
