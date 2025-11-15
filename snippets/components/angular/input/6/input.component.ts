// Minimal Line Input - Japanese minimalism style
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-input',
  template: `<div class="zen-input"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="zen-field" /><div class="zen-line"></div></div>`,
  styles: [`
    .zen-input { position: relative; padding: 8px 0; }
    .zen-field { width: 100%; border: none; outline: none; background: transparent; font-size: 16px; color: #2d3748; padding: 4px 0; font-weight: 300; letter-spacing: 0.5px; }
    .zen-line { position: absolute; bottom: 0; left: 0; width: 100%; height: 1px; background: linear-gradient(90deg, transparent 0%, #718096 50%, transparent 100%); }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; private onChange: any = () => {}; private onTouched: any = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: any): void { this.onChange = fn; }
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}