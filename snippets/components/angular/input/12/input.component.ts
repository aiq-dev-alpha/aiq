// Retro Terminal Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  selector: 'app-input',
  template: `<div class="terminal"><span class="prompt">$</span><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="term-field" /><span class="cursor"></span></div>`,
  styles: [`
  .terminal { display: flex; align-items: center; background: #0c0c0c; border: 1px solid #00ff00; padding: 10px 14px; font-family: 'Courier New', monospace; gap: 8px; }
  .prompt { color: #00ff00; font-weight: bold; }
  .term-field { flex: 1; border: none; outline: none; background: transparent; color: #00ff00; font-family: inherit; font-size: 14px; }
  .cursor { width: 8px; height: 18px; background: #00ff00; animation: blink 1s step-end infinite; }
  @keyframes blink { 0%, 50% { opacity: 1; } 51%, 100% { opacity: 0; } }
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
