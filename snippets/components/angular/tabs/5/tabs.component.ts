import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-component',
  standalone: true,
  imports: [CommonModule],
  template: \`
    <div class="container" [style.border]="'2px solid ' + (theme.primary || '#8b5cf6')" [style.borderRadius]="'12px'" [style.padding]="'20px'">
      <ng-content></ng-content>
    </div>
  \`
})
export class Component {
  @Input() theme: { primary?: string; background?: string; text?: string; } = {};
  @Output() interact = new EventEmitter<string>();
}