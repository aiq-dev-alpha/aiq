// Animated Gradient Border Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  selector: 'app-input',
  template: `<div class="gradient-wrap"><div class="gradient-border"></div><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="gradient-field" /></div>`,
  styles: [`
  .gradient-wrap { position: relative; border-radius: 12px; padding: 2px; background: linear-gradient(45deg, #ff0080, #ff8c00, #40e0d0, #ff0080); background-size: 300% 300%; animation: gradient-rotate 4s ease infinite; }
  @keyframes gradient-rotate { 0%, 100% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } }
  .gradient-border { position: absolute; inset: 0; border-radius: 12px; background: #fff; }
  .gradient-field { position: relative; width: 100%; border: none; outline: none; background: transparent; padding: 14px 18px; font-size: 15px; color: #1a202c; border-radius: 10px; z-index: 1; }
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
