// Brutalist Bold Input - Bold typography, stark contrasts
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `<div class="brutal"><div class="brutal-label">{{ label }}</div><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="brutal-field" /></div>`,
  styles: [`
  .brutal { background: #000; border: 4px solid #fff; padding: 0; }
  .brutal-label { background: #fff; color: #000; padding: 8px 16px; font-weight: 900; font-size: 11px; text-transform: uppercase; letter-spacing: 2px; border-bottom: 4px solid #000; }
  .brutal-field { width: 100%; border: none; outline: none; background: #000; color: #fff; font-size: 18px; padding: 16px; font-weight: 700; font-family: 'Arial Black', sans-serif; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() label = 'INPUT'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; private onChange: unknown = () => {}; private onTouched: unknown = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: unknown): void { this.onChange = fn; }
  registerOnTouched(fn: unknown): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}
