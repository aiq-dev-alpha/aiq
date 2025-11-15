import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
interface InputTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  focusColor: string;
  errorColor: string;
}
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `
  <div class="input-wrapper" [ngStyle]="wrapperStyles">
  <label *ngIf="label" [for]="inputId" class="label" [ngStyle]="labelStyles">
  {{ label }}
  <span *ngIf="required" class="required">*</span>
  </label>
  <div class="input-container" [class.focused]="isFocused" [class.error]="error">
  <span *ngIf="prefixIcon" class="prefix-icon" [ngStyle]="iconStyles">{{ prefixIcon }}</span>
  <input
  [id]="inputId"
  [type]="type"
  [placeholder]="placeholder"
  [disabled]="disabled"
  [readonly]="readonly"
  [value]="value"
  [required]="required"
  [ngStyle]="inputStyles"
  (input)="onInput($event)"
  (focus)="onFocus()"
  (blur)="onBlur()"
  [attr.aria-label]="ariaLabel || label"
  [attr.aria-invalid]="error ? 'true' : 'false'"
  class="input-field"
  />
  <span *ngIf="suffixIcon" class="suffix-icon" [ngStyle]="iconStyles">{{ suffixIcon }}</span>
  <span *ngIf="loading" class="spinner"></span>
  </div>
  <div *ngIf="helperText && !error" class="helper-text" [ngStyle]="helperStyles">
  {{ helperText }}
  </div>
  <div *ngIf="error" class="error-text" [ngStyle]="errorStyles">
  {{ errorMessage }}
  </div>
  </div>
  `,
  styles: [`
  .input-wrapper {
  display: flex;
  flex-direction: column;
  gap: 6px;
  width: 100%;
  }
  .label {
  font-weight: 600;
  font-size: 14px;
  margin-bottom: 4px;
  display: block;
  }
  .required {
  color: #ef4444;
  margin-left: 2px;
  }
  .input-container {
  position: relative;
  display: flex;
  align-items: center;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .input-field {
  flex: 1;
  border: none;
  outline: none;
  font-family: inherit;
  background: transparent;
  transition: all 0.2s ease;
  }
  .input-field:disabled {
  cursor: not-allowed;
  opacity: 0.6;
  }
  .prefix-icon, .suffix-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.6;
  }
  .spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(0,0,0,0.1);
  border-top-color: currentColor;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  }
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  .helper-text, .error-text {
  font-size: 12px;
  margin-top: 4px;
  }
  .error-text {
  color: #ef4444;
  }
  `],
  providers: [
  {
  provide: NG_VALUE_ACCESSOR,
  useExisting: forwardRef(() => InputComponent),
  multi: true
  }
  ]
})
export class InputComponent implements ControlValueAccessor {
  @Input() theme: Partial<InputTheme> = {};
  @Input() type: string = 'text';
  @Input() label?: string;
  @Input() placeholder: string = '';
  @Input() helperText?: string;
  @Input() errorMessage?: string;
  @Input() disabled = false;
  @Input() readonly = false;
  @Input() required = false;
  @Input() loading = false;
  @Input() error = false;
  @Input() prefixIcon?: string;
  @Input() suffixIcon?: string;
  @Input() ariaLabel?: string;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Output() valueChange = new EventEmitter<string>();
  value: string = '';
  isFocused = false;
  inputId = `input-${Math.random().toString(36).substr(2, 9)}`;
  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};
  private defaultTheme: InputTheme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#8b5cf6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#0f172a',
  borderColor: '#e2e8f0',
  focusColor: '#3b82f6',
  errorColor: '#ef4444'
  };
  get appliedTheme(): InputTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get wrapperStyles() {
  return {
  fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
  };
  }
  get labelStyles() {
  const t = this.appliedTheme;
  return {
  color: t.textColor
  };
  }
  get inputStyles() {
  const t = this.appliedTheme;
  const sizeMap = {
  sm: { padding: '8px 12px', fontSize: '13px', height: '36px' },
  md: { padding: '10px 14px', fontSize: '14px', height: '40px' },
  lg: { padding: '12px 16px', fontSize: '16px', height: '48px' }
  };
  return {
  ...sizeMap[this.size],
  color: t.textColor,
  width: '100%',
  backgroundColor: t.backgroundColor,
  border: `2px solid ${this.error ? t.errorColor : t.borderColor}`,
  borderRadius: '8px',
  boxShadow: this.isFocused ? `0 0 0 3px ${t.focusColor}20` : 'none'
  };
  }
  get iconStyles() {
  const t = this.appliedTheme;
  const sizeMap = {
  sm: { fontSize: '16px', padding: '0 8px' },
  md: { fontSize: '18px', padding: '0 10px' },
  lg: { fontSize: '20px', padding: '0 12px' }
  };
  return {
  ...sizeMap[this.size],
  color: t.textColor
  };
  }
  get helperStyles() {
  const t = this.appliedTheme;
  return {
  color: `${t.textColor}99`
  };
  }
  get errorStyles() {
  const t = this.appliedTheme;
  return {
  color: t.errorColor
  };
  }
  onInput(event: Event): void {
  const value = (event.target as HTMLInputElement).value;
  this.value = value;
  this.onChange(value);
  this.valueChange.emit(value);
  }
  onFocus(): void {
  this.isFocused = true;
  }
  onBlur(): void {
  this.isFocused = false;
  this.onTouched();
  }
  writeValue(value: string): void {
  this.value = value || '';
  }
  registerOnChange(fn: (value: string) => void): void {
  this.onChange = fn;
  }
  registerOnTouched(fn: () => void): void {
  this.onTouched = fn;
  }
  setDisabledState(isDisabled: boolean): void {
  this.disabled = isDisabled;
  }
}
