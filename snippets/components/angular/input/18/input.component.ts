// Glitch Effect Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-input',
  template: `<div class="glitch-input"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="glitch-field" /><div class="glitch-effect" data-text="{{ value }}">{{ value }}</div></div>`,
  styles: [`
    .glitch-input { position: relative; background: #0f0f23; border: 1px solid #10aded; padding: 12px 16px; font-family: 'Courier New', monospace; }
    .glitch-field { width: 100%; border: none; outline: none; background: transparent; font-size: 15px; color: #10aded; font-family: inherit; position: relative; z-index: 2; }
    .glitch-effect { position: absolute; top: 12px; left: 16px; color: #10aded; pointer-events: none; opacity: 0.8; }
    .glitch-input:hover .glitch-effect { animation: glitch 0.3s cubic-bezier(.25, .46, .45, .94) both infinite; }
    @keyframes glitch { 0%, 100% { transform: translate(0); } 20% { transform: translate(-2px, 2px); } 40% { transform: translate(-2px, -2px); } 60% { transform: translate(2px, 2px); } 80% { transform: translate(2px, -2px); } }
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