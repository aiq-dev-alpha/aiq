// 3D Depth Input - Layered shadow depth effect
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-input',
  template: `<div class="depth-input" [class.focused]="isFocused"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" (focus)="isFocused=true" (blur)="isFocused=false" class="depth-field" /></div>`,
  styles: [`
  .depth-input { position: relative; background: #fff; border-radius: 8px; transform-style: preserve-3d; transition: transform 0.3s; box-shadow: 0 1px 0 #ccc, 0 2px 0 #c9c9c9, 0 3px 0 #bbb, 0 4px 0 #b9b9b9, 0 5px 0 #aaa, 0 6px 1px rgba(0,0,0,.1), 0 0 5px rgba(0,0,0,.1), 0 1px 3px rgba(0,0,0,.3), 0 3px 5px rgba(0,0,0,.2), 0 5px 10px rgba(0,0,0,.25), 0 10px 10px rgba(0,0,0,.2), 0 20px 20px rgba(0,0,0,.15); }
  .depth-input.focused { transform: translateY(-4px); box-shadow: 0 1px 0 #4f46e5, 0 2px 0 #4338ca, 0 3px 0 #3730a3, 0 4px 0 #312e81, 0 5px 0 #1e1b4b, 0 6px 1px rgba(79,70,229,.1), 0 0 5px rgba(79,70,229,.1), 0 1px 3px rgba(79,70,229,.3), 0 3px 5px rgba(79,70,229,.2), 0 5px 10px rgba(79,70,229,.25), 0 10px 10px rgba(79,70,229,.2), 0 20px 20px rgba(79,70,229,.15); }
  .depth-field { width: 100%; border: none; outline: none; background: transparent; padding: 16px 20px; font-size: 15px; color: #1f2937; position: relative; z-index: 1; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; isFocused = false; private onChange: any = () => {}; private onTouched: any = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: any): void { this.onChange = fn; }
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}