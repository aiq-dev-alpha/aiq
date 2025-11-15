import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
// Cyberpunk Neon Style
@Component({
  selector: 'app-input',
  template: `
  <div class="cyber-input">
  <div class="scanline"></div>
  <input
  [type]="type"
  [placeholder]="placeholder"
  [value]="value"
  (input)="onInput($event)"
  class="cyber-field"
  />
  <div class="corner tl"></div>
  <div class="corner tr"></div>
  <div class="corner bl"></div>
  <div class="corner br"></div>
  </div>
  `,
  styles: [`
  .cyber-input {
  position: relative;
  background: linear-gradient(90deg, #0a0e1a 0%, #151b2d 100%);
  border: 2px solid #00ff9f;
  clip-path: polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 12px 100%, 0 calc(100% - 12px));
  padding: 14px 20px;
  overflow: hidden;
  }
  .cyber-field {
  width: 100%;
  border: none;
  outline: none;
  background: transparent;
  color: #00ff9f;
  font-family: 'Courier New', monospace;
  font-size: 14px;
  text-shadow: 0 0 10px rgba(0, 255, 159, 0.5);
  }
  .scanline {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 45%, rgba(0, 255, 159, 0.03) 50%, transparent 55%);
  animation: scan 4s linear infinite;
  pointer-events: none;
  }
  @keyframes scan {
  0%, 100% { transform: translateY(-100%); }
  50% { transform: translateY(100%); }
  }
  .corner {
  position: absolute;
  width: 8px;
  height: 8px;
  border: 2px solid #ff006e;
  box-shadow: 0 0 8px rgba(255, 0, 110, 0.8);
  }
  .corner.tl { top: -2px; left: -2px; border-right: none; border-bottom: none; }
  .corner.tr { top: -2px; right: -2px; border-left: none; border-bottom: none; }
  .corner.bl { bottom: -2px; left: -2px; border-right: none; border-top: none; }
  .corner.br { bottom: -2px; right: -2px; border-left: none; border-top: none; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text';
  @Input() placeholder = 'ENTER DATA...';
  @Output() valueChange = new EventEmitter<string>();
  value = '';
  private onChange: any = () => {};
  private onTouched: any = () => {};
  onInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  writeValue(value: string): void { this.value = value || ''; }
  registerOnChange(fn: any): void { this.onChange = fn; }
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState(isDisabled: boolean): void {}
}
