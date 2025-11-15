import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
// Neumorphism Design - Soft UI with depth
@Component({
  selector: 'app-input',
  template: `
  <div class="neomorphic-input" [class.focused]="isFocused">
  <input
  [type]="type"
  [placeholder]="placeholder"
  [value]="value"
  (input)="onInput($event)"
  (focus)="onFocus()"
  (blur)="onBlur()"
  class="neu-field"
  />
  </div>
  `,
  styles: [`
  .neomorphic-input {
  background: #e0e5ec;
  border-radius: 20px;
  padding: 16px 24px;
  box-shadow: -6px -6px 12px rgba(255, 255, 255, 0.8),
  6px 6px 12px rgba(163, 177, 198, 0.6);
  transition: all 0.3s ease;
  }
  .neomorphic-input.focused {
  box-shadow: inset -3px -3px 8px rgba(255, 255, 255, 0.8),
  inset 3px 3px 8px rgba(163, 177, 198, 0.4);
  }
  .neu-field {
  width: 100%;
  border: none;
  outline: none;
  background: transparent;
  font-size: 15px;
  color: #4a5568;
  font-family: inherit;
  }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text';
  @Input() placeholder = '';
  @Output() valueChange = new EventEmitter<string>();
  value = '';
  isFocused = false;
  private onChange: any = () => {};
  private onTouched: any = () => {};
  onInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  onFocus(): void { this.isFocused = true; }
  onBlur(): void { this.isFocused = false; this.onTouched(); }
  writeValue(value: string): void { this.value = value || ''; }
  registerOnChange(fn: any): void { this.onChange = fn; }
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState(isDisabled: boolean): void {}
}
