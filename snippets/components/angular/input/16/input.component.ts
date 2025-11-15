// Skeuomorphic Realistic Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-input',
  template: `<div class="skeu"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="skeu-field" /></div>`,
  styles: [`
    .skeu { background: linear-gradient(180deg, #f9fafb 0%, #f3f4f6 100%); border: 1px solid #d1d5db; border-bottom-color: #9ca3af; border-radius: 6px; box-shadow: inset 0 1px 2px rgba(0,0,0,0.1), 0 1px 0 rgba(255,255,255,0.8); }
    .skeu-field { width: 100%; border: none; outline: none; background: transparent; padding: 10px 14px; font-size: 14px; color: #374151; text-shadow: 0 1px 0 rgba(255,255,255,0.8); }
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