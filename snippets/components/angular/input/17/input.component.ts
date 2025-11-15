// Split Flip Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `<div class="split-container" [class.focused]="isFocused"><div class="split-half left"></div><div class="split-half right"></div><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" (focus)="isFocused=true" (blur)="isFocused=false" class="split-field" /></div>`,
  styles: [`
  .split-container { position: relative; border-radius: 10px; overflow: hidden; }
  .split-half { position: absolute; top: 0; bottom: 0; width: 50%; background: #3b82f6; transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  .split-half.left { left: 0; transform-origin: left; }
  .split-half.right { right: 0; transform-origin: right; }
  .split-container.focused .split-half.left { transform: translateX(-100%); }
  .split-container.focused .split-half.right { transform: translateX(100%); }
  .split-field { width: 100%; border: 2px solid #3b82f6; outline: none; background: #fff; padding: 12px 16px; font-size: 15px; color: #1f2937; border-radius: 10px; position: relative; z-index: 1; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; isFocused = false; private onChange: unknown = () => {}; private onTouched: unknown = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: unknown): void { this.onChange = fn; }
  registerOnTouched(fn: unknown): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}
