// Liquid Morphing Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `<div class="liquid"><svg class="liquid-svg"><defs><filter id="goo"><feGaussianBlur in="SourceGraphic" stdDeviation="10" result="blur"/><feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="goo"/></feGaussianBlur></filter></defs></svg><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="liquid-field" /></div>`,
  styles: [`
  .liquid { position: relative; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50px; padding: 3px; overflow: hidden; }
  .liquid::before { content: ''; position: absolute; inset: -100%; background: radial-gradient(circle, rgba(255,255,255,0.3) 20%, transparent 20%), radial-gradient(circle, rgba(255,255,255,0.3) 20%, transparent 20%); background-size: 40px 40px; background-position: 0 0, 20px 20px; animation: liquid-flow 20s linear infinite; }
  @keyframes liquid-flow { 0% { transform: translate(0, 0); } 100% { transform: translate(40px, 40px); } }
  .liquid-field { width: 100%; border: none; outline: none; background: rgba(255,255,255,0.95); padding: 14px 24px; font-size: 15px; color: #4a5568; border-radius: 50px; position: relative; z-index: 1; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; private onChange: unknown = () => {}; private onTouched: unknown = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: unknown): void { this.onChange = fn; }
  registerOnTouched(fn: unknown): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}
