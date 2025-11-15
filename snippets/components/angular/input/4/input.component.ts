import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

interface InputTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  shadowColor: string;
}

@Component({
  selector: 'app-input',
  template: `
    <div class="input-wrapper">
      <label *ngIf="label" [for]="inputId" class="label" [ngStyle]="labelStyles">{{ label }}</label>
      <div class="input-box" [ngStyle]="boxStyles">
        <input
          [id]="inputId"
          [type]="type"
          [placeholder]="placeholder"
          [disabled]="disabled"
          [value]="value"
          [ngStyle]="inputStyles"
          (input)="onInput($event)"
          (focus)="isFocused = true"
          (blur)="isFocused = false; onTouched()"
          [attr.aria-label]="ariaLabel || label"
          class="input-field"
        />
      </div>
    </div>
  `,
  styles: [`
    .input-wrapper { width: 100%; }
    .label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; }
    .input-box { position: relative; border-radius: 16px; overflow: hidden; transition: all 0.3s ease; }
    .input-box:hover { transform: translateY(-2px); }
    .input-field { width: 100%; border: none; outline: none; font-family: inherit; background: transparent; }
    .input-field:disabled { opacity: 0.6; cursor: not-allowed; }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() theme: Partial<InputTheme> = {};
  @Input() type = 'text';
  @Input() label?: string;
  @Input() placeholder = '';
  @Input() disabled = false;
  @Input() ariaLabel?: string;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Output() valueChange = new EventEmitter<string>();

  value = '';
  isFocused = false;
  inputId = `input-${Math.random().toString(36).substr(2, 9)}`;

  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};

  private defaultTheme: InputTheme = {
    primaryColor: '#f59e0b',
    backgroundColor: '#fffbeb',
    textColor: '#78350f',
    shadowColor: 'rgba(245, 158, 11, 0.3)'
  };

  get appliedTheme(): InputTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get labelStyles() {
    return { color: this.appliedTheme.primaryColor };
  }

  get boxStyles() {
    const t = this.appliedTheme;
    const sizes = {
      sm: { padding: '8px 14px', height: '36px' },
      md: { padding: '12px 16px', height: '44px' },
      lg: { padding: '16px 20px', height: '52px' }
    };
    return {
      ...sizes[this.size],
      backgroundColor: t.backgroundColor,
      boxShadow: this.isFocused ? `0 8px 24px ${t.shadowColor}` : `0 2px 8px ${t.shadowColor}`,
      border: `2px solid ${t.primaryColor}${this.isFocused ? '' : '50'}`
    };
  }

  get inputStyles() {
    const sizes = { sm: { fontSize: '13px' }, md: { fontSize: '15px' }, lg: { fontSize: '17px' } };
    return { ...sizes[this.size], color: this.appliedTheme.textColor };
  }

  onInput(e: Event): void {
    this.value = (e.target as HTMLInputElement).value;
    this.onChange(this.value);
    this.valueChange.emit(this.value);
  }

  writeValue(value: string): void { this.value = value || ''; }
  registerOnChange(fn: any): void { this.onChange = fn; }
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState(isDisabled: boolean): void { this.disabled = isDisabled; }
}
