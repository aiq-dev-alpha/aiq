// Pulsing Glow Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `<div class="glow-wrap" [class.active]="isFocused"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" (focus)="isFocused=true" (blur)="isFocused=false" class="glow-field" /></div>`,
  styles: [`
  .glow-wrap { position: relative; border-radius: 10px; padding: 2px; background: #1a202c; }
  .glow-wrap::before { content: ''; position: absolute; inset: -3px; border-radius: 12px; background: linear-gradient(45deg, #ff006e, #8b5cf6, #0ea5e9, #ff006e); background-size: 400% 400%; opacity: 0; transition: opacity 0.3s; animation: glow-pulse 3s ease infinite; filter: blur(8px); }
  .glow-wrap.active::before { opacity: 0.8; }
  @keyframes glow-pulse { 0%, 100% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } }
  .glow-field { width: 100%; border: none; outline: none; background: #1a202c; padding: 12px 16px; font-size: 15px; color: #e2e8f0; border-radius: 10px; position: relative; z-index: 1; }
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
