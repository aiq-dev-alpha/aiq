import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

interface InputTheme {
  primaryColor: string;
  gradientStart: string;
  gradientEnd: string;
  textColor: string;
}

@Component({
  selector: 'app-input',
  template: `
    <div class="input-wrapper">
      <label *ngIf="label" class="label" [ngStyle]="labelStyles">{{ label }}</label>
      <div class="input-container" [ngStyle]="containerStyles">
        <div class="gradient-border" [ngStyle]="borderStyles"></div>
        <input
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
    .label { display: block; margin-bottom: 8px; font-weight: 700; font-size: 13px; letter-spacing: 1px; text-transform: uppercase; }
    .input-container { position: relative; }
    .gradient-border { position: absolute; inset: 0; border-radius: 10px; padding: 2px; -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0); mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0); -webkit-mask-composite: xor; mask-composite: exclude; transition: opacity 0.3s; }
    .input-field { width: 100%; border: none; outline: none; font-family: inherit; border-radius: 10px; }
    .input-field:disabled { opacity: 0.5; cursor: not-allowed; }
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

  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};

  private defaultTheme: InputTheme = {
    primaryColor: '#8b5cf6',
    gradientStart: '#6366f1',
    gradientEnd: '#ec4899',
    textColor: '#1e1b4b'
  };

  get appliedTheme(): InputTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get labelStyles() {
    return { color: this.appliedTheme.primaryColor };
  }

  get containerStyles() {
    return { position: 'relative' };
  }

  get borderStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.gradientStart}, ${t.gradientEnd})`,
      opacity: this.isFocused ? 1 : 0.5
    };
  }

  get inputStyles() {
    const t = this.appliedTheme;
    const sizes = {
      sm: { padding: '8px 12px', fontSize: '13px' },
      md: { padding: '11px 15px', fontSize: '15px' },
      lg: { padding: '14px 18px', fontSize: '17px' }
    };
    return {
      ...sizes[this.size],
      color: t.textColor,
      backgroundColor: '#ffffff'
    };
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
