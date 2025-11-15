// Particle Effect Input - Animated particles on focus
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  selector: 'app-input',
  template: `<div class="particle-input" [class.active]="isFocused"><div class="particles"><span class="particle" *ngFor="let p of [1,2,3,4,5,6]"></span></div><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" (focus)="isFocused=true" (blur)="isFocused=false" class="particle-field" /></div>`,
  styles: [`
  .particle-input { position: relative; background: rgba(139, 92, 246, 0.05); border: 2px solid #8b5cf6; border-radius: 14px; padding: 14px 20px; overflow: hidden; }
  .particles { position: absolute; inset: 0; pointer-events: none; opacity: 0; transition: opacity 0.3s; }
  .particle-input.active .particles { opacity: 1; }
  .particle { position: absolute; width: 4px; height: 4px; background: #8b5cf6; border-radius: 50%; animation: float 3s infinite; }
  .particle:nth-child(1) { left: 10%; animation-delay: 0s; animation-duration: 2.5s; }
  .particle:nth-child(2) { left: 30%; animation-delay: 0.5s; animation-duration: 3s; }
  .particle:nth-child(3) { left: 50%; animation-delay: 1s; animation-duration: 2.8s; }
  .particle:nth-child(4) { left: 70%; animation-delay: 0.3s; animation-duration: 3.2s; }
  .particle:nth-child(5) { left: 90%; animation-delay: 0.8s; animation-duration: 2.6s; }
  .particle:nth-child(6) { left: 45%; animation-delay: 1.2s; animation-duration: 3.5s; }
  @keyframes float { 0%, 100% { transform: translateY(40px); opacity: 0; } 50% { transform: translateY(-10px); opacity: 1; } }
  .particle-field { width: 100%; border: none; outline: none; background: transparent; font-size: 15px; color: #1f2937; position: relative; z-index: 1; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; isFocused = false; private onChange: any = () => {}; private onTouched: any = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: any): void { this.onChange = fn; }
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}
