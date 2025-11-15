// Holographic Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  selector: 'app-input',
  template: `<div class="holo"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="holo-field" /><div class="holo-shine"></div></div>`,
  styles: [`
  .holo { position: relative; background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2); border-radius: 12px; overflow: hidden; }
  .holo::before { content: ''; position: absolute; inset: 0; background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%); background-size: 200% 200%; animation: holo-shift 3s linear infinite; }
  @keyframes holo-shift { 0% { background-position: 200% 200%; } 100% { background-position: -200% -200%; } }
  .holo-field { width: 100%; border: none; outline: none; background: transparent; padding: 14px 18px; font-size: 15px; color: #e2e8f0; position: relative; z-index: 1; }
  .holo-shine { position: absolute; top: 0; right: 0; width: 40px; height: 100%; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent); animation: shine 2s ease-in-out infinite; }
  @keyframes shine { 0%, 100% { transform: translateX(-100%); } 50% { transform: translateX(300%); } }
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
