import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
interface InputTheme {
  glassBg: string;
  glassBlur: string;
  textColor: string;
  accentGlow: string;
}
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `
  <div class="glass-input" [ngStyle]="wrapperStyles">
  <div class="wave-bg"></div>
  <input
  [type]="type"
  [placeholder]="placeholder"
  [value]="value"
  (input)="onInput($event)"
  (focus)="onFocus()"
  (blur)="onBlur()"
  [ngStyle]="inputStyles"
  class="input"
  />
  <div class="glow" *ngIf="isFocused"></div>
  </div>
  `,
  styles: [`
  .glass-input {
  position: relative;
  overflow: hidden;
  border-radius: 16px;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.18);
  }
  .wave-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(45deg, #667eea20, #764ba240, #f093fb20);
  animation: wave 8s ease-in-out infinite;
  }
  @keyframes wave {
  0%, 100% { transform: translateX(-25%) scale(1.1); }
  50% { transform: translateX(25%) scale(1.2); }
  }
  .input {
  position: relative;
  z-index: 1;
  width: 100%;
  padding: 16px 20px;
  border: none;
  outline: none;
  background: transparent;
  font-size: 15px;
  font-family: inherit;
  color: inherit;
  }
  .glow {
  position: absolute;
  inset: -2px;
  border-radius: 16px;
  background: linear-gradient(45deg, #667eea, #764ba2, #f093fb, #667eea);
  background-size: 300% 300%;
  animation: gradient-shift 3s ease infinite;
  opacity: 0.6;
  filter: blur(8px);
  z-index: 0;
  }
  @keyframes gradient-shift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  }
  `],
  providers: [{
  provide: NG_VALUE_ACCESSOR,
  useExisting: forwardRef(() => InputComponent),
  multi: true
  }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() theme: Partial<InputTheme> = {};
  @Input() type = 'text';
  @Input() placeholder = '';
  @Output() valueChange = new EventEmitter<string>();
  value = '';
  isFocused = false;
  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};
  private defaultTheme: InputTheme = {
  glassBg: 'rgba(255, 255, 255, 0.1)',
  glassBlur: '20px',
  textColor: '#1f2937',
  accentGlow: '#667eea'
  };
  get appliedTheme(): InputTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get wrapperStyles() {
  const t = this.appliedTheme;
  return {
  background: t.glassBg,
  backdropFilter: `blur(${t.glassBlur})`
  };
  }
  get inputStyles() {
  return {
  color: this.appliedTheme.textColor
  };
  }
  onInput(event: Event): void {
  const value = (event.target as HTMLInputElement).value;
  this.value = value;
  this.onChange(value);
  this.valueChange.emit(value);
  }
  onFocus(): void { this.isFocused = true; }
  onBlur(): void { this.isFocused = false; this.onTouched(); }
  writeValue(value: string): void { this.value = value || ''; }
  registerOnChange(fn: (value: string) => void): void { this.onChange = fn; }
  registerOnTouched(fn: () => void): void { this.onTouched = fn; }
  setDisabledState(isDisabled: boolean): void {}
}
